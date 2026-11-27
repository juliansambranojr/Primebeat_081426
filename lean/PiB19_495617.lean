import PiChunks

namespace PiChunks

theorem b19_495617 : Nat.count Nat.Prime 499713 = Nat.count Nat.Prime 495617 + 317 := by
  have h := count_add_chunk 495617 4096
  have hc : cntR 495617 4096 = 317 := by decide +kernel
  rw [hc, show (495617 : ℕ) + 4096 = 499713 from rfl] at h
  exact h

end PiChunks
