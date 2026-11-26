import PiChunks

namespace PiChunks

theorem b17_122881 : Nat.count Nat.Prime 126977 = Nat.count Nat.Prime 122881 + 346 := by
  have h := count_add_chunk 122881 4096
  have hc : cntR 122881 4096 = 346 := by decide +kernel
  rw [hc, show (122881 : ℕ) + 4096 = 126977 from rfl] at h
  exact h

end PiChunks
