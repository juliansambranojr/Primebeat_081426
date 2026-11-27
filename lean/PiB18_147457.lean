import PiChunks

namespace PiChunks

theorem b18_147457 : Nat.count Nat.Prime 151553 = Nat.count Nat.Prime 147457 + 351 := by
  have h := count_add_chunk 147457 4096
  have hc : cntR 147457 4096 = 351 := by decide +kernel
  rw [hc, show (147457 : ℕ) + 4096 = 151553 from rfl] at h
  exact h

end PiChunks
