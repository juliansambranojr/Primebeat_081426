import PiChunks

namespace PiChunks

theorem b20_577537 : Nat.count Nat.Prime 581633 = Nat.count Nat.Prime 577537 + 310 := by
  have h := count_add_chunk 577537 4096
  have hc : cntR 577537 4096 = 310 := by decide +kernel
  rw [hc, show (577537 : ℕ) + 4096 = 581633 from rfl] at h
  exact h

end PiChunks
