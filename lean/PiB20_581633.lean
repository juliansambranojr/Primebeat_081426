import PiChunks

namespace PiChunks

theorem b20_581633 : Nat.count Nat.Prime 585729 = Nat.count Nat.Prime 581633 + 307 := by
  have h := count_add_chunk 581633 4096
  have hc : cntR 581633 4096 = 307 := by decide +kernel
  rw [hc, show (581633 : ℕ) + 4096 = 585729 from rfl] at h
  exact h

end PiChunks
