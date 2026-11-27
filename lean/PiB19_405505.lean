import PiChunks

namespace PiChunks

theorem b19_405505 : Nat.count Nat.Prime 409601 = Nat.count Nat.Prime 405505 + 317 := by
  have h := count_add_chunk 405505 4096
  have hc : cntR 405505 4096 = 317 := by decide +kernel
  rw [hc, show (405505 : ℕ) + 4096 = 409601 from rfl] at h
  exact h

end PiChunks
