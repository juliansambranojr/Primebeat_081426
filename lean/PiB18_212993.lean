import PiChunks

namespace PiChunks

theorem b18_212993 : Nat.count Nat.Prime 217089 = Nat.count Nat.Prime 212993 + 325 := by
  have h := count_add_chunk 212993 4096
  have hc : cntR 212993 4096 = 325 := by decide +kernel
  rw [hc, show (212993 : ℕ) + 4096 = 217089 from rfl] at h
  exact h

end PiChunks
