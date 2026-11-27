import PiChunks

namespace PiChunks

theorem b19_270337 : Nat.count Nat.Prime 274433 = Nat.count Nat.Prime 270337 + 320 := by
  have h := count_add_chunk 270337 4096
  have hc : cntR 270337 4096 = 320 := by decide +kernel
  rw [hc, show (270337 : ℕ) + 4096 = 274433 from rfl] at h
  exact h

end PiChunks
