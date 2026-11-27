import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_876545 : Nat.count Nat.Prime 880641 = Nat.count Nat.Prime 876545 + 301 := by
  have h := count_add_chunk 876545 4096
  have hc : cntR 876545 4096 = 301 := by decide +kernel
  rw [hc, show (876545 : ℕ) + 4096 = 880641 from rfl] at h
  exact h

end PiChunks
