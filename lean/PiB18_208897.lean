import PiChunks

namespace PiChunks

theorem b18_208897 : Nat.count Nat.Prime 212993 = Nat.count Nat.Prime 208897 + 335 := by
  have h := count_add_chunk 208897 4096
  have hc : cntR 208897 4096 = 335 := by decide +kernel
  rw [hc, show (208897 : ℕ) + 4096 = 212993 from rfl] at h
  exact h

end PiChunks
