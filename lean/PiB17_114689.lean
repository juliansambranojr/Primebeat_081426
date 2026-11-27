import PiChunks

namespace PiChunks

theorem b17_114689 : Nat.count Nat.Prime 118785 = Nat.count Nat.Prime 114689 + 350 := by
  have h := count_add_chunk 114689 4096
  have hc : cntR 114689 4096 = 350 := by decide +kernel
  rw [hc, show (114689 : ℕ) + 4096 = 118785 from rfl] at h
  exact h

end PiChunks
