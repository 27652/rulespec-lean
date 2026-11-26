import Lean

namespace RuleSpecLean.VersionSelection

/-- Dates are ordered day numbers. The adapter must establish their encoding. -/
structure Version (α : Type) where
  firstDay : Int
  lastDay : Option Int
  body : α
  deriving DecidableEq

def active (day : Int) (v : Version α) : Bool :=
  decide (v.firstDay ≤ day) && (v.lastDay.map (fun last => decide (day ≤ last))).getD true

/-- Latest active start wins; on equal starts, the later source row wins. -/
def select (day : Int) : List (Version α) → Option (Version α)
  | [] => none
  | v :: rest =>
      if active day v then
        match select day rest with
        | none => some v
        | some w => if v.firstDay ≤ w.firstDay then some w else some v
      else select day rest

def mapBody (f : α → β) (v : Version α) : Version β :=
  ⟨v.firstDay, v.lastDay, f v.body⟩

/-- Lowering formula bodies does not change which version is selected. -/
theorem select_mapBody (day : Int) (f : α → β) (versions : List (Version α)) :
    select day (versions.map (mapBody f)) = (select day versions).map (mapBody f) := by
  induction versions with
  | nil => rfl
  | cons v rest ih =>
    simp only [List.map_cons, select, show active day (mapBody f v) = active day v from rfl, ih]
    cases active day v with
    | false => simp
    | true =>
      cases select day rest with
      | none => simp
      | some w => by_cases h : v.firstDay ≤ w.firstDay <;> simp [mapBody, h]

theorem select_none_iff (versions : List (Version α)) (day : Int) :
    select day versions = none ↔ ∀ v ∈ versions, active day v = false := by
  induction versions with
  | nil => simp [select]
  | cons v rest ih =>
    cases hv : active day v with
    | false => simpa [select, hv] using ih
    | true =>
      have impossible : ¬ (∀ w ∈ v :: rest, active day w = false) := by
        intro hall
        simpa [hv] using hall v (by simp)
      simp only [iff_false_intro impossible, iff_false]
      cases hs : select day rest with
      | none => simp [select, hv, hs]
      | some w => by_cases hle : v.firstDay ≤ w.firstDay <;> simp [select, hv, hs, hle]

theorem select_sound (versions : List (Version α)) (day : Int) (chosen : Version α)
    (h : select day versions = some chosen) :
    chosen ∈ versions ∧ active day chosen = true ∧
      ∀ v ∈ versions, active day v = true → v.firstDay ≤ chosen.firstDay := by
  induction versions generalizing chosen with
  | nil => simp [select] at h
  | cons head rest ih =>
    cases hh : active day head with
    | false =>
      have ⟨hm, ha, hg⟩ := ih chosen (by simpa [select, hh] using h)
      exact ⟨List.mem_cons_of_mem _ hm, ha, by simpa [hh] using hg⟩
    | true =>
      cases hr : select day rest with
      | none =>
        have he := (select_none_iff rest day).mp hr
        simp [select, hh, hr] at h
        subst chosen
        exact ⟨by simp, hh, by
          intro v hv ha
          rcases List.mem_cons.mp hv with rfl | hm
          · exact Int.le_refl _
          · simp [he v hm] at ha⟩
      | some tail =>
        have ⟨hm, ha, hg⟩ := ih tail hr
        by_cases ht : head.firstDay ≤ tail.firstDay
        · simp [select, hh, hr, ht] at h
          subst chosen
          exact ⟨List.mem_cons_of_mem _ hm, ha, by
            intro v hv hvActive
            rcases List.mem_cons.mp hv with rfl | hvRest
            · exact ht
            · exact hg v hvRest hvActive⟩
        · simp [select, hh, hr, ht] at h
          subst chosen
          exact ⟨by simp, hh, by
            intro v hv hvActive
            rcases List.mem_cons.mp hv with rfl | hvRest
            · exact Int.le_refl _
            · exact Int.le_trans (hg v hvRest hvActive) (Int.le_of_lt (Int.lt_of_not_ge ht))⟩

/-- Appending an active row with a maximal start makes that row the selection,
including when an earlier row has the same start. -/
theorem select_append_latest (versions : List (Version α)) (day : Int) (v : Version α)
    (hv : active day v = true)
    (latest : ∀ w ∈ versions, active day w = true → w.firstDay ≤ v.firstDay) :
    select day (versions ++ [v]) = some v := by
  induction versions with
  | nil => simp [select, hv]
  | cons head rest ih =>
    have tail := ih (fun w hm ha => latest w (List.mem_cons_of_mem _ hm) ha)
    cases hh : active day head with
    | false => simp [select, hh, tail]
    | true => simp [select, hh, tail, latest head (by simp) hh]

-- The final day is included; a later row wins a tie on the first day.
example : (select 20 ([⟨10, some 20, "first"⟩, ⟨10, some 20, "second"⟩] : List (Version String))).map
    (fun v => v.body) = some "second" := rfl

example : (select 21 ([⟨10, some 20, "expired"⟩] : List (Version String))).map
    (fun v => v.body) = none := rfl

end RuleSpecLean.VersionSelection
