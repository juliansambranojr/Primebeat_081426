import PiChunks

namespace PiChunks

theorem b18_135169 : Nat.count Nat.Prime 139265 = Nat.count Nat.Prime 135169 + 352 := by
  have h := count_add_chunk 135169 4096
  have hc : cntR 135169 4096 = 352 := by decide +kernel
  rw [hc, show (135169 : ℕ) + 4096 = 139265 from rfl] at h
  exact h

end PiChunks
