import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_786433 : Nat.count Nat.Prime 790529 = Nat.count Nat.Prime 786433 + 301 := by
  have h := count_add_chunk 786433 4096
  have hc : cntR 786433 4096 = 301 := by decide +kernel
  rw [hc, show (786433 : ℕ) + 4096 = 790529 from rfl] at h
  exact h

end PiChunks
