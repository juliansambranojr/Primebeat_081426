import PiChunks

namespace PiChunks

theorem b18_184321 : Nat.count Nat.Prime 188417 = Nat.count Nat.Prime 184321 + 342 := by
  have h := count_add_chunk 184321 4096
  have hc : cntR 184321 4096 = 342 := by decide +kernel
  rw [hc, show (184321 : ℕ) + 4096 = 188417 from rfl] at h
  exact h

end PiChunks
