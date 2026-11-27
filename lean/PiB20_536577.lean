import PiChunks

namespace PiChunks

theorem b20_536577 : Nat.count Nat.Prime 540673 = Nat.count Nat.Prime 536577 + 303 := by
  have h := count_add_chunk 536577 4096
  have hc : cntR 536577 4096 = 303 := by decide +kernel
  rw [hc, show (536577 : ℕ) + 4096 = 540673 from rfl] at h
  exact h

end PiChunks
