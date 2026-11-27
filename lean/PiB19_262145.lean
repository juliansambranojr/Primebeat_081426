import PiChunks

namespace PiChunks

theorem b19_262145 : Nat.count Nat.Prime 266241 = Nat.count Nat.Prime 262145 + 332 := by
  have h := count_add_chunk 262145 4096
  have hc : cntR 262145 4096 = 332 := by decide +kernel
  rw [hc, show (262145 : ℕ) + 4096 = 266241 from rfl] at h
  exact h

end PiChunks
