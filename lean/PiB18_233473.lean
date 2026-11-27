import PiChunks

namespace PiChunks

theorem b18_233473 : Nat.count Nat.Prime 237569 = Nat.count Nat.Prime 233473 + 313 := by
  have h := count_add_chunk 233473 4096
  have hc : cntR 233473 4096 = 313 := by decide +kernel
  rw [hc, show (233473 : ℕ) + 4096 = 237569 from rfl] at h
  exact h

end PiChunks
