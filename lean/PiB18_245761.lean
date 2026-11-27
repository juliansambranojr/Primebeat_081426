import PiChunks

namespace PiChunks

theorem b18_245761 : Nat.count Nat.Prime 249857 = Nat.count Nat.Prime 245761 + 336 := by
  have h := count_add_chunk 245761 4096
  have hc : cntR 245761 4096 = 336 := by decide +kernel
  rw [hc, show (245761 : ℕ) + 4096 = 249857 from rfl] at h
  exact h

end PiChunks
