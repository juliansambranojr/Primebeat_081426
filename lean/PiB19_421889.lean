import PiChunks

namespace PiChunks

theorem b19_421889 : Nat.count Nat.Prime 425985 = Nat.count Nat.Prime 421889 + 320 := by
  have h := count_add_chunk 421889 4096
  have hc : cntR 421889 4096 = 320 := by decide +kernel
  rw [hc, show (421889 : ℕ) + 4096 = 425985 from rfl] at h
  exact h

end PiChunks
