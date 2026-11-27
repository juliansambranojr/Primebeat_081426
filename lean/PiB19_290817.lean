import PiChunks

namespace PiChunks

theorem b19_290817 : Nat.count Nat.Prime 294913 = Nat.count Nat.Prime 290817 + 314 := by
  have h := count_add_chunk 290817 4096
  have hc : cntR 290817 4096 = 314 := by decide +kernel
  rw [hc, show (290817 : ℕ) + 4096 = 294913 from rfl] at h
  exact h

end PiChunks
