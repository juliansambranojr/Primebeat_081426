import PiChunks

namespace PiChunks

theorem b18_188417 : Nat.count Nat.Prime 192513 = Nat.count Nat.Prime 188417 + 337 := by
  have h := count_add_chunk 188417 4096
  have hc : cntR 188417 4096 = 337 := by decide +kernel
  rw [hc, show (188417 : ℕ) + 4096 = 192513 from rfl] at h
  exact h

end PiChunks
