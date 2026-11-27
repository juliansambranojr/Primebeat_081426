import PiChunks

namespace PiChunks

theorem b17_126977 : Nat.count Nat.Prime 131073 = Nat.count Nat.Prime 126977 + 351 := by
  have h := count_add_chunk 126977 4096
  have hc : cntR 126977 4096 = 351 := by decide +kernel
  rw [hc, show (126977 : ℕ) + 4096 = 131073 from rfl] at h
  exact h

end PiChunks
