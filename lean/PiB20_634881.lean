import PiChunks

namespace PiChunks

theorem b20_634881 : Nat.count Nat.Prime 638977 = Nat.count Nat.Prime 634881 + 290 := by
  have h := count_add_chunk 634881 4096
  have hc : cntR 634881 4096 = 290 := by decide +kernel
  rw [hc, show (634881 : ℕ) + 4096 = 638977 from rfl] at h
  exact h

end PiChunks
