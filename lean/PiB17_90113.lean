import PiChunks

namespace PiChunks

theorem b17_90113 : Nat.count Nat.Prime 94209 = Nat.count Nat.Prime 90113 + 360 := by
  have h := count_add_chunk 90113 4096
  have hc : cntR 90113 4096 = 360 := by decide +kernel
  rw [hc, show (90113 : ℕ) + 4096 = 94209 from rfl] at h
  exact h

end PiChunks
