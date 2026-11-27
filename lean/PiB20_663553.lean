import PiChunks

namespace PiChunks

theorem b20_663553 : Nat.count Nat.Prime 667649 = Nat.count Nat.Prime 663553 + 313 := by
  have h := count_add_chunk 663553 4096
  have hc : cntR 663553 4096 = 313 := by decide +kernel
  rw [hc, show (663553 : ℕ) + 4096 = 667649 from rfl] at h
  exact h

end PiChunks
