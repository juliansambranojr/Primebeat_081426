import PiChunks

namespace PiChunks

theorem b20_593921 : Nat.count Nat.Prime 598017 = Nat.count Nat.Prime 593921 + 314 := by
  have h := count_add_chunk 593921 4096
  have hc : cntR 593921 4096 = 314 := by decide +kernel
  rw [hc, show (593921 : ℕ) + 4096 = 598017 from rfl] at h
  exact h

end PiChunks
