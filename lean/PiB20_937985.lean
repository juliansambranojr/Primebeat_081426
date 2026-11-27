import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_937985 : Nat.count Nat.Prime 942081 = Nat.count Nat.Prime 937985 + 303 := by
  have h := count_add_chunk 937985 4096
  have hc : cntR 937985 4096 = 303 := by decide +kernel
  rw [hc, show (937985 : ℕ) + 4096 = 942081 from rfl] at h
  exact h

end PiChunks
