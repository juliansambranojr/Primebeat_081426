import PiChunks

namespace PiChunks

theorem b20_589825 : Nat.count Nat.Prime 593921 = Nat.count Nat.Prime 589825 + 300 := by
  have h := count_add_chunk 589825 4096
  have hc : cntR 589825 4096 = 300 := by decide +kernel
  rw [hc, show (589825 : ℕ) + 4096 = 593921 from rfl] at h
  exact h

end PiChunks
