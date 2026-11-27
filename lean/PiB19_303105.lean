import PiChunks

namespace PiChunks

theorem b19_303105 : Nat.count Nat.Prime 307201 = Nat.count Nat.Prime 303105 + 340 := by
  have h := count_add_chunk 303105 4096
  have hc : cntR 303105 4096 = 340 := by decide +kernel
  rw [hc, show (303105 : ℕ) + 4096 = 307201 from rfl] at h
  exact h

end PiChunks
