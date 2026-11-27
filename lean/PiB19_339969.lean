import PiChunks

namespace PiChunks

theorem b19_339969 : Nat.count Nat.Prime 344065 = Nat.count Nat.Prime 339969 + 323 := by
  have h := count_add_chunk 339969 4096
  have hc : cntR 339969 4096 = 323 := by decide +kernel
  rw [hc, show (339969 : ℕ) + 4096 = 344065 from rfl] at h
  exact h

end PiChunks
