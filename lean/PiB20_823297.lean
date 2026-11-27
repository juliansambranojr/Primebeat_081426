import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_823297 : Nat.count Nat.Prime 827393 = Nat.count Nat.Prime 823297 + 310 := by
  have h := count_add_chunk 823297 4096
  have hc : cntR 823297 4096 = 310 := by decide +kernel
  rw [hc, show (823297 : ℕ) + 4096 = 827393 from rfl] at h
  exact h

end PiChunks
