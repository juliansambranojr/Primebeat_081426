import PiChunks

namespace PiChunks

theorem b18_229377 : Nat.count Nat.Prime 233473 = Nat.count Nat.Prime 229377 + 330 := by
  have h := count_add_chunk 229377 4096
  have hc : cntR 229377 4096 = 330 := by decide +kernel
  rw [hc, show (229377 : ℕ) + 4096 = 233473 from rfl] at h
  exact h

end PiChunks
