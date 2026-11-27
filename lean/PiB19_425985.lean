import PiChunks

namespace PiChunks

theorem b19_425985 : Nat.count Nat.Prime 430081 = Nat.count Nat.Prime 425985 + 317 := by
  have h := count_add_chunk 425985 4096
  have hc : cntR 425985 4096 = 317 := by decide +kernel
  rw [hc, show (425985 : ℕ) + 4096 = 430081 from rfl] at h
  exact h

end PiChunks
