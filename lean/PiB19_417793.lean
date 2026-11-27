import PiChunks

namespace PiChunks

theorem b19_417793 : Nat.count Nat.Prime 421889 = Nat.count Nat.Prime 417793 + 318 := by
  have h := count_add_chunk 417793 4096
  have hc : cntR 417793 4096 = 318 := by decide +kernel
  rw [hc, show (417793 : ℕ) + 4096 = 421889 from rfl] at h
  exact h

end PiChunks
