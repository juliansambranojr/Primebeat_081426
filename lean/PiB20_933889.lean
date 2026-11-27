import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_933889 : Nat.count Nat.Prime 937985 = Nat.count Nat.Prime 933889 + 299 := by
  have h := count_add_chunk 933889 4096
  have hc : cntR 933889 4096 = 299 := by decide +kernel
  rw [hc, show (933889 : ℕ) + 4096 = 937985 from rfl] at h
  exact h

end PiChunks
