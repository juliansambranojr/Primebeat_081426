import PiChunks

namespace PiChunks

theorem b19_512001 : Nat.count Nat.Prime 516097 = Nat.count Nat.Prime 512001 + 300 := by
  have h := count_add_chunk 512001 4096
  have hc : cntR 512001 4096 = 300 := by decide +kernel
  rw [hc, show (512001 : ℕ) + 4096 = 516097 from rfl] at h
  exact h

end PiChunks
