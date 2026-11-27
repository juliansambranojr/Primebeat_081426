import PiChunks

namespace PiChunks

theorem b20_688129 : Nat.count Nat.Prime 692225 = Nat.count Nat.Prime 688129 + 297 := by
  have h := count_add_chunk 688129 4096
  have hc : cntR 688129 4096 = 297 := by decide +kernel
  rw [hc, show (688129 : ℕ) + 4096 = 692225 from rfl] at h
  exact h

end PiChunks
