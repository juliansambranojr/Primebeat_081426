import PiChunks

namespace PiChunks

theorem b20_667649 : Nat.count Nat.Prime 671745 = Nat.count Nat.Prime 667649 + 298 := by
  have h := count_add_chunk 667649 4096
  have hc : cntR 667649 4096 = 298 := by decide +kernel
  rw [hc, show (667649 : ℕ) + 4096 = 671745 from rfl] at h
  exact h

end PiChunks
