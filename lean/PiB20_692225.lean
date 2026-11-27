import PiChunks

namespace PiChunks

theorem b20_692225 : Nat.count Nat.Prime 696321 = Nat.count Nat.Prime 692225 + 308 := by
  have h := count_add_chunk 692225 4096
  have hc : cntR 692225 4096 = 308 := by decide +kernel
  rw [hc, show (692225 : ℕ) + 4096 = 696321 from rfl] at h
  exact h

end PiChunks
