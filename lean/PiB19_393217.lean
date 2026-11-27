import PiChunks

namespace PiChunks

theorem b19_393217 : Nat.count Nat.Prime 397313 = Nat.count Nat.Prime 393217 + 312 := by
  have h := count_add_chunk 393217 4096
  have hc : cntR 393217 4096 = 312 := by decide +kernel
  rw [hc, show (393217 : ℕ) + 4096 = 397313 from rfl] at h
  exact h

end PiChunks
