import PiChunks

namespace PiChunks

theorem b20_557057 : Nat.count Nat.Prime 561153 = Nat.count Nat.Prime 557057 + 312 := by
  have h := count_add_chunk 557057 4096
  have hc : cntR 557057 4096 = 312 := by decide +kernel
  rw [hc, show (557057 : ℕ) + 4096 = 561153 from rfl] at h
  exact h

end PiChunks
