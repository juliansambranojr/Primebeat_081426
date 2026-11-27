import PiChunks

namespace PiChunks

theorem b20_626689 : Nat.count Nat.Prime 630785 = Nat.count Nat.Prime 626689 + 291 := by
  have h := count_add_chunk 626689 4096
  have hc : cntR 626689 4096 = 291 := by decide +kernel
  rw [hc, show (626689 : ℕ) + 4096 = 630785 from rfl] at h
  exact h

end PiChunks
