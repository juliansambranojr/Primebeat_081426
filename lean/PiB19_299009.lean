import PiChunks

namespace PiChunks

theorem b19_299009 : Nat.count Nat.Prime 303105 = Nat.count Nat.Prime 299009 + 329 := by
  have h := count_add_chunk 299009 4096
  have hc : cntR 299009 4096 = 329 := by decide +kernel
  rw [hc, show (299009 : ℕ) + 4096 = 303105 from rfl] at h
  exact h

end PiChunks
