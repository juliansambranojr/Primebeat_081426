import PiChunks

namespace PiChunks

theorem b18_204801 : Nat.count Nat.Prime 208897 = Nat.count Nat.Prime 204801 + 343 := by
  have h := count_add_chunk 204801 4096
  have hc : cntR 204801 4096 = 343 := by decide +kernel
  rw [hc, show (204801 : ℕ) + 4096 = 208897 from rfl] at h
  exact h

end PiChunks
