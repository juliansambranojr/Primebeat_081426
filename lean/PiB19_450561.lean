import PiChunks

namespace PiChunks

theorem b19_450561 : Nat.count Nat.Prime 454657 = Nat.count Nat.Prime 450561 + 300 := by
  have h := count_add_chunk 450561 4096
  have hc : cntR 450561 4096 = 300 := by decide +kernel
  rw [hc, show (450561 : ℕ) + 4096 = 454657 from rfl] at h
  exact h

end PiChunks
