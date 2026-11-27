import PiChunks

namespace PiChunks

theorem b19_413697 : Nat.count Nat.Prime 417793 = Nat.count Nat.Prime 413697 + 322 := by
  have h := count_add_chunk 413697 4096
  have hc : cntR 413697 4096 = 322 := by decide +kernel
  rw [hc, show (413697 : ℕ) + 4096 = 417793 from rfl] at h
  exact h

end PiChunks
