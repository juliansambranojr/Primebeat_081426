import PiChunks

namespace PiChunks

theorem b20_548865 : Nat.count Nat.Prime 552961 = Nat.count Nat.Prime 548865 + 309 := by
  have h := count_add_chunk 548865 4096
  have hc : cntR 548865 4096 = 309 := by decide +kernel
  rw [hc, show (548865 : ℕ) + 4096 = 552961 from rfl] at h
  exact h

end PiChunks
