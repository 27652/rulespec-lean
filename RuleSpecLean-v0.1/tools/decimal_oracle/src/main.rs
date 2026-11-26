use rust_decimal::{Decimal, RoundingStrategy};
use serde_json::{Value, json};
use std::io::{self, Read};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let cases: Vec<Value> = serde_json::from_str(&input).unwrap();
    let rows: Vec<Value> = cases.iter().map(|case| {
        if let Some(op) = case["op"].as_str() {
            let a = Decimal::from_str_exact(case["left"].as_str().unwrap()).unwrap();
            let b = Decimal::from_str_exact(case["right"].as_str().unwrap()).unwrap();
            let output = match op {
                "add" => a.checked_add(b),
                "sub" => a.checked_sub(b),
                "mul" => a.checked_mul(b),
                "div" => a.checked_div(b),
                other => panic!("unknown arithmetic op {other}"),
            };
            return match output {
                Some(v) => json!({"case": case, "coefficient": v.mantissa().to_string(),
                                  "scale": v.scale(), "output": v.to_string()}),
                None => json!({"case": case, "fault": if op == "div" && b.is_zero() {
                    "divisionByZero" } else { "arithmeticOverflow" }}),
            };
        }
        let value = Decimal::from_str_exact(case["input"].as_str().unwrap()).unwrap();
        let places = case["places"].as_u64().unwrap() as u32;
        let strategy = match case["mode"].as_str().unwrap() {
            "half_up" => RoundingStrategy::MidpointAwayFromZero,
            "half_even" => RoundingStrategy::MidpointNearestEven,
            "floor" => RoundingStrategy::ToNegativeInfinity,
            "ceil" => RoundingStrategy::ToPositiveInfinity,
            other => panic!("unknown mode {other}"),
        };
        let output = value.round_dp_with_strategy(places, strategy);
        json!({"input": case["input"], "places": places, "mode": case["mode"],
               "coefficient": output.mantissa().to_string(), "scale": output.scale(),
               "output": output.to_string()})
    }).collect();
    println!("{}", serde_json::to_string_pretty(&rows).unwrap());
}
