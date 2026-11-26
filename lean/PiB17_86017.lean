import PiChunks

namespace PiChunks

theorem b17_86017 : Nat.count Nat.Prime 90113 = Nat.count Nat.Prime 86017 + 364 := by
  have h := count_add_chunk 86017 4096
  have hc : cntR 86017 4096 = 364 := by decide +kernel
  rw [hc, show (86017 : ℕ) + 4096 = 90113 from rfl] at h
  exact h

end PiChunks
