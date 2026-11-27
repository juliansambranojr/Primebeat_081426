import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_778241 : Nat.count Nat.Prime 782337 = Nat.count Nat.Prime 778241 + 312 := by
  have h := count_add_chunk 778241 4096
  have hc : cntR 778241 4096 = 312 := by decide +kernel
  rw [hc, show (778241 : ℕ) + 4096 = 782337 from rfl] at h
  exact h

end PiChunks
