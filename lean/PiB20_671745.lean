import PiChunks

namespace PiChunks

theorem b20_671745 : Nat.count Nat.Prime 675841 = Nat.count Nat.Prime 671745 + 309 := by
  have h := count_add_chunk 671745 4096
  have hc : cntR 671745 4096 = 309 := by decide +kernel
  rw [hc, show (671745 : ℕ) + 4096 = 675841 from rfl] at h
  exact h

end PiChunks
