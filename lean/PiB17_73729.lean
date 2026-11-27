import PiChunks

namespace PiChunks

theorem b17_73729 : Nat.count Nat.Prime 77825 = Nat.count Nat.Prime 73729 + 368 := by
  have h := count_add_chunk 73729 4096
  have hc : cntR 73729 4096 = 368 := by decide +kernel
  rw [hc, show (73729 : ℕ) + 4096 = 77825 from rfl] at h
  exact h

end PiChunks
