import PiChunks

namespace PiChunks

theorem b19_520193 : Nat.count Nat.Prime 524289 = Nat.count Nat.Prime 520193 + 317 := by
  have h := count_add_chunk 520193 4096
  have hc : cntR 520193 4096 = 317 := by decide +kernel
  rw [hc, show (520193 : ℕ) + 4096 = 524289 from rfl] at h
  exact h

end PiChunks
