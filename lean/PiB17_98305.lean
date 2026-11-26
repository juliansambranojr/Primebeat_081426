import PiChunks

namespace PiChunks

theorem b17_98305 : Nat.count Nat.Prime 102401 = Nat.count Nat.Prime 98305 + 366 := by
  have h := count_add_chunk 98305 4096
  have hc : cntR 98305 4096 = 366 := by decide +kernel
  rw [hc, show (98305 : ℕ) + 4096 = 102401 from rfl] at h
  exact h

end PiChunks
