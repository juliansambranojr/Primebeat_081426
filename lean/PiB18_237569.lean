import PiChunks

namespace PiChunks

theorem b18_237569 : Nat.count Nat.Prime 241665 = Nat.count Nat.Prime 237569 + 337 := by
  have h := count_add_chunk 237569 4096
  have hc : cntR 237569 4096 = 337 := by decide +kernel
  rw [hc, show (237569 : ℕ) + 4096 = 241665 from rfl] at h
  exact h

end PiChunks
