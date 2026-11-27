import PiChunks

namespace PiChunks

theorem b17_69633 : Nat.count Nat.Prime 73729 = Nat.count Nat.Prime 69633 + 375 := by
  have h := count_add_chunk 69633 4096
  have hc : cntR 69633 4096 = 375 := by decide +kernel
  rw [hc, show (69633 : ℕ) + 4096 = 73729 from rfl] at h
  exact h

end PiChunks
