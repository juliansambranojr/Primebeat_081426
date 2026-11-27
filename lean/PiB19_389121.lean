import PiChunks

namespace PiChunks

theorem b19_389121 : Nat.count Nat.Prime 393217 = Nat.count Nat.Prime 389121 + 340 := by
  have h := count_add_chunk 389121 4096
  have hc : cntR 389121 4096 = 340 := by decide +kernel
  rw [hc, show (389121 : ℕ) + 4096 = 393217 from rfl] at h
  exact h

end PiChunks
