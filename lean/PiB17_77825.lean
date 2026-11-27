import PiChunks

namespace PiChunks

theorem b17_77825 : Nat.count Nat.Prime 81921 = Nat.count Nat.Prime 77825 + 360 := by
  have h := count_add_chunk 77825 4096
  have hc : cntR 77825 4096 = 360 := by decide +kernel
  rw [hc, show (77825 : ℕ) + 4096 = 81921 from rfl] at h
  exact h

end PiChunks
