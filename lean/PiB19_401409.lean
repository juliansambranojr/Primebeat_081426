import PiChunks

namespace PiChunks

theorem b19_401409 : Nat.count Nat.Prime 405505 = Nat.count Nat.Prime 401409 + 301 := by
  have h := count_add_chunk 401409 4096
  have hc : cntR 401409 4096 = 301 := by decide +kernel
  rw [hc, show (401409 : ℕ) + 4096 = 405505 from rfl] at h
  exact h

end PiChunks
