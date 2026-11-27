import PiChunks

namespace PiChunks

theorem b18_131073 : Nat.count Nat.Prime 135169 = Nat.count Nat.Prime 131073 + 338 := by
  have h := count_add_chunk 131073 4096
  have hc : cntR 131073 4096 = 338 := by decide +kernel
  rw [hc, show (131073 : ℕ) + 4096 = 135169 from rfl] at h
  exact h

end PiChunks
