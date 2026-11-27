import PiChunks

namespace PiChunks

theorem b18_192513 : Nat.count Nat.Prime 196609 = Nat.count Nat.Prime 192513 + 335 := by
  have h := count_add_chunk 192513 4096
  have hc : cntR 192513 4096 = 335 := by decide +kernel
  rw [hc, show (192513 : ℕ) + 4096 = 196609 from rfl] at h
  exact h

end PiChunks
