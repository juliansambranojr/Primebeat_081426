import PiChunks

namespace PiChunks

theorem b20_540673 : Nat.count Nat.Prime 544769 = Nat.count Nat.Prime 540673 + 308 := by
  have h := count_add_chunk 540673 4096
  have hc : cntR 540673 4096 = 308 := by decide +kernel
  rw [hc, show (540673 : ℕ) + 4096 = 544769 from rfl] at h
  exact h

end PiChunks
