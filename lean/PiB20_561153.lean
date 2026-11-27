import PiChunks

namespace PiChunks

theorem b20_561153 : Nat.count Nat.Prime 565249 = Nat.count Nat.Prime 561153 + 293 := by
  have h := count_add_chunk 561153 4096
  have hc : cntR 561153 4096 = 293 := by decide +kernel
  rw [hc, show (561153 : ℕ) + 4096 = 565249 from rfl] at h
  exact h

end PiChunks
