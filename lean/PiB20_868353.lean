import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_868353 : Nat.count Nat.Prime 872449 = Nat.count Nat.Prime 868353 + 304 := by
  have h := count_add_chunk 868353 4096
  have hc : cntR 868353 4096 = 304 := by decide +kernel
  rw [hc, show (868353 : ℕ) + 4096 = 872449 from rfl] at h
  exact h

end PiChunks
