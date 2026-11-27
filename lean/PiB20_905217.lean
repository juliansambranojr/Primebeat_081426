import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_905217 : Nat.count Nat.Prime 909313 = Nat.count Nat.Prime 905217 + 317 := by
  have h := count_add_chunk 905217 4096
  have hc : cntR 905217 4096 = 317 := by decide +kernel
  rw [hc, show (905217 : ℕ) + 4096 = 909313 from rfl] at h
  exact h

end PiChunks
