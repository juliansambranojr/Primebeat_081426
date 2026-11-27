import PiChunks

namespace PiChunks

theorem b19_376833 : Nat.count Nat.Prime 380929 = Nat.count Nat.Prime 376833 + 311 := by
  have h := count_add_chunk 376833 4096
  have hc : cntR 376833 4096 = 311 := by decide +kernel
  rw [hc, show (376833 : ℕ) + 4096 = 380929 from rfl] at h
  exact h

end PiChunks
