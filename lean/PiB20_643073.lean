import PiChunks

namespace PiChunks

theorem b20_643073 : Nat.count Nat.Prime 647169 = Nat.count Nat.Prime 643073 + 312 := by
  have h := count_add_chunk 643073 4096
  have hc : cntR 643073 4096 = 312 := by decide +kernel
  rw [hc, show (643073 : ℕ) + 4096 = 647169 from rfl] at h
  exact h

end PiChunks
