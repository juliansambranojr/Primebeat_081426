import PiChunks

namespace PiChunks

theorem b19_286721 : Nat.count Nat.Prime 290817 = Nat.count Nat.Prime 286721 + 320 := by
  have h := count_add_chunk 286721 4096
  have hc : cntR 286721 4096 = 320 := by decide +kernel
  rw [hc, show (286721 : ℕ) + 4096 = 290817 from rfl] at h
  exact h

end PiChunks
