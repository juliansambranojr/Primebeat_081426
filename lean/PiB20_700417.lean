import PiChunks

namespace PiChunks

theorem b20_700417 : Nat.count Nat.Prime 704513 = Nat.count Nat.Prime 700417 + 308 := by
  have h := count_add_chunk 700417 4096
  have hc : cntR 700417 4096 = 308 := by decide +kernel
  rw [hc, show (700417 : ℕ) + 4096 = 704513 from rfl] at h
  exact h

end PiChunks
