import PiChunks

namespace PiChunks

theorem b20_630785 : Nat.count Nat.Prime 634881 = Nat.count Nat.Prime 630785 + 317 := by
  have h := count_add_chunk 630785 4096
  have hc : cntR 630785 4096 = 317 := by decide +kernel
  rw [hc, show (630785 : ℕ) + 4096 = 634881 from rfl] at h
  exact h

end PiChunks
