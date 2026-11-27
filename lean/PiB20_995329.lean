import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_995329 : Nat.count Nat.Prime 999425 = Nat.count Nat.Prime 995329 + 305 := by
  have h := count_add_chunk 995329 4096
  have hc : cntR 995329 4096 = 305 := by decide +kernel
  rw [hc, show (995329 : ℕ) + 4096 = 999425 from rfl] at h
  exact h

end PiChunks
