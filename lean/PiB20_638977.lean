import PiChunks

namespace PiChunks

theorem b20_638977 : Nat.count Nat.Prime 643073 = Nat.count Nat.Prime 638977 + 298 := by
  have h := count_add_chunk 638977 4096
  have hc : cntR 638977 4096 = 298 := by decide +kernel
  rw [hc, show (638977 : ℕ) + 4096 = 643073 from rfl] at h
  exact h

end PiChunks
