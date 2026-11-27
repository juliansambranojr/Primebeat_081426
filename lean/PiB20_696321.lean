import PiChunks

namespace PiChunks

theorem b20_696321 : Nat.count Nat.Prime 700417 = Nat.count Nat.Prime 696321 + 299 := by
  have h := count_add_chunk 696321 4096
  have hc : cntR 696321 4096 = 299 := by decide +kernel
  rw [hc, show (696321 : ℕ) + 4096 = 700417 from rfl] at h
  exact h

end PiChunks
