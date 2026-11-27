import PiChunks

namespace PiChunks

theorem b18_217089 : Nat.count Nat.Prime 221185 = Nat.count Nat.Prime 217089 + 339 := by
  have h := count_add_chunk 217089 4096
  have hc : cntR 217089 4096 = 339 := by decide +kernel
  rw [hc, show (217089 : ℕ) + 4096 = 221185 from rfl] at h
  exact h

end PiChunks
