import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_909313 : Nat.count Nat.Prime 913409 = Nat.count Nat.Prime 909313 + 291 := by
  have h := count_add_chunk 909313 4096
  have hc : cntR 909313 4096 = 291 := by decide +kernel
  rw [hc, show (909313 : ℕ) + 4096 = 913409 from rfl] at h
  exact h

end PiChunks
