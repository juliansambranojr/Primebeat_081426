import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_978945 : Nat.count Nat.Prime 983041 = Nat.count Nat.Prime 978945 + 280 := by
  have h := count_add_chunk 978945 4096
  have hc : cntR 978945 4096 = 280 := by decide +kernel
  rw [hc, show (978945 : ℕ) + 4096 = 983041 from rfl] at h
  exact h

end PiChunks
