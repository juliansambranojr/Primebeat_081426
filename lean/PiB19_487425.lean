import PiChunks

namespace PiChunks

theorem b19_487425 : Nat.count Nat.Prime 491521 = Nat.count Nat.Prime 487425 + 325 := by
  have h := count_add_chunk 487425 4096
  have hc : cntR 487425 4096 = 325 := by decide +kernel
  rw [hc, show (487425 : ℕ) + 4096 = 491521 from rfl] at h
  exact h

end PiChunks
