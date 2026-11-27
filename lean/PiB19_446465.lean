import PiChunks

namespace PiChunks

theorem b19_446465 : Nat.count Nat.Prime 450561 = Nat.count Nat.Prime 446465 + 307 := by
  have h := count_add_chunk 446465 4096
  have hc : cntR 446465 4096 = 307 := by decide +kernel
  rw [hc, show (446465 : ℕ) + 4096 = 450561 from rfl] at h
  exact h

end PiChunks
