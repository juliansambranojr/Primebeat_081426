import PiChunks

namespace PiChunks

theorem b18_258049 : Nat.count Nat.Prime 262145 = Nat.count Nat.Prime 258049 + 322 := by
  have h := count_add_chunk 258049 4096
  have hc : cntR 258049 4096 = 322 := by decide +kernel
  rw [hc, show (258049 : ℕ) + 4096 = 262145 from rfl] at h
  exact h

end PiChunks
