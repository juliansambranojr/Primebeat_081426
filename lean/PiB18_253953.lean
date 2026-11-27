import PiChunks

namespace PiChunks

theorem b18_253953 : Nat.count Nat.Prime 258049 = Nat.count Nat.Prime 253953 + 320 := by
  have h := count_add_chunk 253953 4096
  have hc : cntR 253953 4096 = 320 := by decide +kernel
  rw [hc, show (253953 : ℕ) + 4096 = 258049 from rfl] at h
  exact h

end PiChunks
