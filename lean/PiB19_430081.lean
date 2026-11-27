import PiChunks

namespace PiChunks

theorem b19_430081 : Nat.count Nat.Prime 434177 = Nat.count Nat.Prime 430081 + 325 := by
  have h := count_add_chunk 430081 4096
  have hc : cntR 430081 4096 = 325 := by decide +kernel
  rw [hc, show (430081 : ℕ) + 4096 = 434177 from rfl] at h
  exact h

end PiChunks
