import PiChunks

namespace PiChunks

theorem b18_139265 : Nat.count Nat.Prime 143361 = Nat.count Nat.Prime 139265 + 348 := by
  have h := count_add_chunk 139265 4096
  have hc : cntR 139265 4096 = 348 := by decide +kernel
  rw [hc, show (139265 : ℕ) + 4096 = 143361 from rfl] at h
  exact h

end PiChunks
