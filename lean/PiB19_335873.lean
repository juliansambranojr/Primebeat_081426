import PiChunks

namespace PiChunks

theorem b19_335873 : Nat.count Nat.Prime 339969 = Nat.count Nat.Prime 335873 + 316 := by
  have h := count_add_chunk 335873 4096
  have hc : cntR 335873 4096 = 316 := by decide +kernel
  rw [hc, show (335873 : ℕ) + 4096 = 339969 from rfl] at h
  exact h

end PiChunks
