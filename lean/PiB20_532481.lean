import PiChunks

namespace PiChunks

theorem b20_532481 : Nat.count Nat.Prime 536577 = Nat.count Nat.Prime 532481 + 308 := by
  have h := count_add_chunk 532481 4096
  have hc : cntR 532481 4096 = 308 := by decide +kernel
  rw [hc, show (532481 : ℕ) + 4096 = 536577 from rfl] at h
  exact h

end PiChunks
