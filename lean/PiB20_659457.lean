import PiChunks

namespace PiChunks

theorem b20_659457 : Nat.count Nat.Prime 663553 = Nat.count Nat.Prime 659457 + 308 := by
  have h := count_add_chunk 659457 4096
  have hc : cntR 659457 4096 = 308 := by decide +kernel
  rw [hc, show (659457 : ℕ) + 4096 = 663553 from rfl] at h
  exact h

end PiChunks
