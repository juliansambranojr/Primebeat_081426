import PiChunks

namespace PiChunks

theorem b19_385025 : Nat.count Nat.Prime 389121 = Nat.count Nat.Prime 385025 + 312 := by
  have h := count_add_chunk 385025 4096
  have hc : cntR 385025 4096 = 312 := by decide +kernel
  rw [hc, show (385025 : ℕ) + 4096 = 389121 from rfl] at h
  exact h

end PiChunks
