import PiChunks

namespace PiChunks

theorem b17_65537 : Nat.count Nat.Prime 69633 = Nat.count Nat.Prime 65537 + 364 := by
  have h := count_add_chunk 65537 4096
  have hc : cntR 65537 4096 = 364 := by decide +kernel
  rw [hc, show (65537 : ℕ) + 4096 = 69633 from rfl] at h
  exact h

end PiChunks
