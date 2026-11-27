import PiChunks

namespace PiChunks

theorem b20_598017 : Nat.count Nat.Prime 602113 = Nat.count Nat.Prime 598017 + 304 := by
  have h := count_add_chunk 598017 4096
  have hc : cntR 598017 4096 = 304 := by decide +kernel
  rw [hc, show (598017 : ℕ) + 4096 = 602113 from rfl] at h
  exact h

end PiChunks
