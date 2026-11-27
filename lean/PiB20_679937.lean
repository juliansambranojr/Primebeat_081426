import PiChunks

namespace PiChunks

theorem b20_679937 : Nat.count Nat.Prime 684033 = Nat.count Nat.Prime 679937 + 306 := by
  have h := count_add_chunk 679937 4096
  have hc : cntR 679937 4096 = 306 := by decide +kernel
  rw [hc, show (679937 : ℕ) + 4096 = 684033 from rfl] at h
  exact h

end PiChunks
