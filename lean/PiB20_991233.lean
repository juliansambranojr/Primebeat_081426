import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_991233 : Nat.count Nat.Prime 995329 = Nat.count Nat.Prime 991233 + 286 := by
  have h := count_add_chunk 991233 4096
  have hc : cntR 991233 4096 = 286 := by decide +kernel
  rw [hc, show (991233 : ℕ) + 4096 = 995329 from rfl] at h
  exact h

end PiChunks
