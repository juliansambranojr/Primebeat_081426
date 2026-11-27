import PiChunks

namespace PiChunks

theorem b20_712705 : Nat.count Nat.Prime 716801 = Nat.count Nat.Prime 712705 + 298 := by
  have h := count_add_chunk 712705 4096
  have hc : cntR 712705 4096 = 298 := by decide +kernel
  rw [hc, show (712705 : ℕ) + 4096 = 716801 from rfl] at h
  exact h

end PiChunks
