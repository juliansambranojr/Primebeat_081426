import PiChunks

namespace PiChunks

theorem b20_585729 : Nat.count Nat.Prime 589825 = Nat.count Nat.Prime 585729 + 322 := by
  have h := count_add_chunk 585729 4096
  have hc : cntR 585729 4096 = 322 := by decide +kernel
  rw [hc, show (585729 : ℕ) + 4096 = 589825 from rfl] at h
  exact h

end PiChunks
