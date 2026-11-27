import PiChunks

namespace PiChunks

theorem b19_294913 : Nat.count Nat.Prime 299009 = Nat.count Nat.Prime 294913 + 312 := by
  have h := count_add_chunk 294913 4096
  have hc : cntR 294913 4096 = 312 := by decide +kernel
  rw [hc, show (294913 : ℕ) + 4096 = 299009 from rfl] at h
  exact h

end PiChunks
