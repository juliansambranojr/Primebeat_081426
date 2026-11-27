import PiChunks

namespace PiChunks

theorem b20_544769 : Nat.count Nat.Prime 548865 = Nat.count Nat.Prime 544769 + 305 := by
  have h := count_add_chunk 544769 4096
  have hc : cntR 544769 4096 = 305 := by decide +kernel
  rw [hc, show (544769 : ℕ) + 4096 = 548865 from rfl] at h
  exact h

end PiChunks
