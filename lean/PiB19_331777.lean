import PiChunks

namespace PiChunks

theorem b19_331777 : Nat.count Nat.Prime 335873 = Nat.count Nat.Prime 331777 + 319 := by
  have h := count_add_chunk 331777 4096
  have hc : cntR 331777 4096 = 319 := by decide +kernel
  rw [hc, show (331777 : ℕ) + 4096 = 335873 from rfl] at h
  exact h

end PiChunks
