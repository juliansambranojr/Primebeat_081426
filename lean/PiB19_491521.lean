import PiChunks

namespace PiChunks

theorem b19_491521 : Nat.count Nat.Prime 495617 = Nat.count Nat.Prime 491521 + 319 := by
  have h := count_add_chunk 491521 4096
  have hc : cntR 491521 4096 = 319 := by decide +kernel
  rw [hc, show (491521 : ℕ) + 4096 = 495617 from rfl] at h
  exact h

end PiChunks
