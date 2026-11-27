import PiChunks

namespace PiChunks

theorem b17_94209 : Nat.count Nat.Prime 98305 = Nat.count Nat.Prime 94209 + 352 := by
  have h := count_add_chunk 94209 4096
  have hc : cntR 94209 4096 = 352 := by decide +kernel
  rw [hc, show (94209 : ℕ) + 4096 = 98305 from rfl] at h
  exact h

end PiChunks
