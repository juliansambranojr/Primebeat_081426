import PiChunks

namespace PiChunks

theorem b17_118785 : Nat.count Nat.Prime 122881 = Nat.count Nat.Prime 118785 + 358 := by
  have h := count_add_chunk 118785 4096
  have hc : cntR 118785 4096 = 358 := by decide +kernel
  rw [hc, show (118785 : ℕ) + 4096 = 122881 from rfl] at h
  exact h

end PiChunks
