"""Conservative snapshot binding for a single query interval.

The default policy requires exact intervals. The opt-in covering policy selects
the latest-starting spell that covers the query. Conflicting same-start ties,
assessment dates and pins are refused. Decimal callers may opt into aggregation
over supplied binary relations and handle defaults at read sites; the binder
never injects the interface's descriptive default metadata.
"""
from datetime import date

from tools.compile_ir import named, parse_date, parse_value, require, version_at


def interval_dates(interval):
    require(isinstance(interval, dict) and all(isinstance(interval.get(key), str) for key in ("start", "end")),
            "invalid interval")
    start, end = (parse_date(interval[key]) for key in ("start", "end"))
    require(start <= end, "invalid interval")
    return start, end


def annual_key(input_id, year):
    return f"@year:{year}:{input_id}"


def count_key(relation, current_slot, related_slot):
    return f"@count:{current_slot}:{related_slot}:{relation}"


def member_key(relation, current_slot, related_slot):
    return f"@members:{current_slot}:{related_slot}:{relation}"


def direct_members(program, records, query, entity, start, end):
    """Snapshot distinct members in supplied, typed binary relations."""
    schemas = named(program.get("relations", []))
    interface = named(program["interface"].get("relations", []))
    members = {}
    entity_types = {query: entity}
    for name, schema in schemas.items():
        slots = schema.get("slot_entities", [])
        if (schema.get("arity") != 2 or len(slots) != 2 or schema.get("derivation") is not None or
                not interface.get(name, {}).get("accepts_supplied_tuples")):
            continue
        for current in (0, 1):
            if slots[current] == entity:
                members[(name, current)] = set()
    for record in records:
        require(isinstance(record, dict) and set(record) == {"name", "tuple", "interval"},
                "unsupported relation fields")
        name, pair = record["name"], record["tuple"]
        require(isinstance(name, str) and ((name, 0) in members or (name, 1) in members),
                "unsupported supplied relation")
        require(isinstance(pair, list) and len(pair) == 2 and all(isinstance(x, str) and x for x in pair),
                "invalid binary relation tuple")
        for member, kind in zip(pair, schemas[name]["slot_entities"]):
            require(entity_types.setdefault(member, kind) == kind, "conflicting relation entity kinds")
        require(isinstance(record["interval"], dict) and set(record["interval"]) == {"start", "end"},
                "unsupported relation interval fields")
        left, right = interval_dates(record["interval"])
        if left <= start and end <= right:
            for current in (0, 1):
                if pair[current] == query and (name, current) in members:
                    members[(name, current)].add(pair[1 - current])
    return members, entity_types


def selected_year_windows(program, output, as_of):
    contracts = {item["id"]: item for item in program.get("selected_year_inputs", [])}
    if not contracts:
        return {}
    rules = named(program["derived"])
    entity = rules[output]["entity"]
    windows = {}
    seen = set()
    pending = [{"kind": "derived", "name": output}]
    while pending:
        node = pending.pop()
        if isinstance(node, list):
            pending.extend(node)
        elif isinstance(node, dict):
            if node.get("kind") == "derived":
                name = node["name"]
                if name not in seen:
                    seen.add(name)
                    rule = rules[name]
                    versions = rule.get("versions", [])
                    active = version_at(versions, as_of) if versions else rule
                    if active is not None:
                        pending.append(active["expr"])
                continue
            if node.get("kind") == "input_for_year":
                contract = contracts.get(node["input"])
                require(contract is not None, "missing selected-year contract")
                year = node["year"]
                if contract["entity"] == entity:
                    require(contract["period"] == "Year" and type(year) is int and 1 <= year <= 9999,
                            "invalid selected-year contract")
                    windows.setdefault(contract["slot"], {})[annual_key(node["input"], year)] = (
                        date(year, 1, 1), date(year, 12, 31), contract["dtype"])
            pending.extend(node.values())
    return windows


def bind(artifact, request, rule_name, *, validate_value=parse_value, covering=False,
         read_site_defaults=False, relation_counts=False, filtered_counts=False):
    require(isinstance(request, dict) and set(request) == {"mode", "dataset", "queries"},
            "unsupported request fields")
    require(request.get("mode") == "explain", "Explain required")
    require(isinstance(request["queries"], list) and len(request["queries"]) == 1, "one query required")
    query = request["queries"][0]
    require(isinstance(query, dict) and set(query) == {"entity_id", "period", "outputs"},
            "unsupported query fields")
    require(isinstance(query["entity_id"], str) and query["entity_id"], "query entity ID required")
    period = query["period"]
    require(isinstance(period, dict), "period object required")
    period_fields = {"period_kind", "start", "end"}
    if period.get("period_kind") == "custom":
        period_fields.add("name")
        require(isinstance(period.get("name"), str) and period["name"], "custom period name required")
    else:
        require(period.get("period_kind") in ("tax_year", "month", "benefit_week"), "unsupported period kind")
    require(set(period) == period_fields, "unsupported period fields")
    query_start, query_end = interval_dates(period)
    rule = next((r for r in artifact["program"]["derived"] if r["name"] == rule_name), None)
    require(rule is not None, "unknown binding rule")
    require(query["outputs"] == [rule["id"]], "output identity mismatch")
    require(covering or not artifact["program"].get("selected_year_inputs"),
            "selected-year requests require covering-spell binding")
    dataset = request["dataset"]
    require(isinstance(dataset, dict) and set(dataset) <= {"inputs", "relations"}, "unsupported dataset fields")
    require(all(isinstance(records, list) for records in dataset.values()), "dataset records must be lists")
    require(relation_counts or filtered_counts or not dataset.get("relations"), "relations not supported by binding adapter")
    interface = artifact["program"]["interface"]
    require(read_site_defaults or all(i.get("default") is None for i in interface["inputs"]),
            "input defaults not supported by binding adapter")
    aliases = {}
    for row in artifact["metadata"]["input_catalog"]:
        for name in row["request_names"]:
            require(name not in aliases, "ambiguous input alias")
            aliases[name] = row["slot"]
    inputs = {i["name"]: i for i in interface["inputs"]}
    annual = selected_year_windows(artifact["program"], rule_name, query_start) if covering else {}
    members, entity_types = ({}, {})
    if relation_counts or filtered_counts:
        members, entity_types = direct_members(artifact["program"], dataset.get("relations", []),
                                               query["entity_id"], rule["entity"], query_start, query_end)
    env = {}
    related_envs = {}
    selected_starts = {}
    values_by_start = {}
    for record in dataset.get("inputs", []):
        require(isinstance(record, dict) and set(record) == {"name", "entity", "entity_id", "interval", "value"},
                "unsupported input fields")
        require(isinstance(record["name"], str) and record["name"] in aliases, "unknown input alias")
        slot = aliases[record["name"]]
        entity_id = record["entity_id"]
        require(isinstance(entity_id, str) and entity_id, "input entity ID required")
        is_query = entity_id == query["entity_id"]
        require(is_query or (filtered_counts and entity_id in entity_types), "input entity is outside supplied relations")
        require(record["entity"] == (rule["entity"] if is_query else entity_types[entity_id]),
                "input entity does not match binding")
        require(record["entity"] in inputs[slot]["entities"], "input entity kind mismatch")
        interval = record["interval"]
        require(isinstance(interval, dict) and set(interval) == {"start", "end"},
                "unsupported input interval fields")
        start, end = interval_dates(interval)
        if not covering:
            require((start, end) == (query_start, query_end), "input interval must equal query interval")
        spell = (entity_id, slot, start)
        value = record["value"]
        validate_value(value)
        # Preserve the supplied wire value. Only identical records are treated
        # as redundant; equal decimals with distinct scales stay out of scope.
        require(values_by_start.setdefault(spell, value) == value, "conflicting input spell start")
        selection = (entity_id, slot)
        if start <= query_start and query_end <= end and (
                selection not in selected_starts or start > selected_starts[selection]):
            selected_starts[selection] = start
            target = env if is_query else related_envs.setdefault(entity_id, {})
            target[slot] = record["value"]
        if not is_query:
            continue
        for key, (year_start, year_end, dtype) in annual.get(slot, {}).items():
            require(key not in inputs, "selected-year key collides with input slot")
            require(dtype in {"integer", "decimal", "money"}, "unsupported numeric selected-year input")
            require(record["value"]["kind"] in ({"integer"} if dtype == "integer" else {"integer", "decimal"}),
                    "selected-year input type mismatch")
            if start <= year_start and year_end <= end and (
                    key not in selected_starts or start > selected_starts[key]):
                selected_starts[key] = start
                env[key] = record["value"]
    for (name, current), ids in members.items():
        key = count_key(name, current, 1 - current)
        require(key not in inputs, "relation count key collides with input slot")
        env[key] = {"kind": "integer", "value": len(ids)}
        if filtered_counts:
            key = member_key(name, current, 1 - current)
            require(key not in inputs, "relation member key collides with input slot")
            env[key] = [
                {key: val for key, val in (env if member == query["entity_id"] else related_envs.get(member, {})).items()
                 if key in inputs} for member in sorted(ids)
            ]
    return env


def check_env(artifact, case, *, validate_value=parse_value, covering=False,
              read_site_defaults=False, relation_counts=False, filtered_counts=False):
    bound = bind(artifact, case["request"], case["rule"], validate_value=validate_value, covering=covering,
                 read_site_defaults=read_site_defaults, relation_counts=relation_counts, filtered_counts=filtered_counts)
    require(bound == case["env"], "prebound environment differs from official request")
    return bound
