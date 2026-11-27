import PiChunks

namespace PiChunks

theorem b18_221185 : Nat.count Nat.Prime 225281 = Nat.count Nat.Prime 221185 + 334 := by
  have h := count_add_chunk 221185 4096
  have hc : cntR 221185 4096 = 334 := by decide +kernel
  rw [hc, show (221185 : ℕ) + 4096 = 225281 from rfl] at h
  exact h

end PiChunks
