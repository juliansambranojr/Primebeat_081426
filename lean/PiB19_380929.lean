import PiChunks

namespace PiChunks

theorem b19_380929 : Nat.count Nat.Prime 385025 = Nat.count Nat.Prime 380929 + 317 := by
  have h := count_add_chunk 380929 4096
  have hc : cntR 380929 4096 = 317 := by decide +kernel
  rw [hc, show (380929 : ℕ) + 4096 = 385025 from rfl] at h
  exact h

end PiChunks
