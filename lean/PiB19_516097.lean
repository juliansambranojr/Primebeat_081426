import PiChunks

namespace PiChunks

theorem b19_516097 : Nat.count Nat.Prime 520193 = Nat.count Nat.Prime 516097 + 328 := by
  have h := count_add_chunk 516097 4096
  have hc : cntR 516097 4096 = 328 := by decide +kernel
  rw [hc, show (516097 : ℕ) + 4096 = 520193 from rfl] at h
  exact h

end PiChunks
