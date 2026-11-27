import PiChunks

namespace PiChunks

theorem b19_266241 : Nat.count Nat.Prime 270337 = Nat.count Nat.Prime 266241 + 340 := by
  have h := count_add_chunk 266241 4096
  have hc : cntR 266241 4096 = 340 := by decide +kernel
  rw [hc, show (266241 : ℕ) + 4096 = 270337 from rfl] at h
  exact h

end PiChunks
