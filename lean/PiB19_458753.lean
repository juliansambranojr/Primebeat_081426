import PiChunks

namespace PiChunks

theorem b19_458753 : Nat.count Nat.Prime 462849 = Nat.count Nat.Prime 458753 + 298 := by
  have h := count_add_chunk 458753 4096
  have hc : cntR 458753 4096 = 298 := by decide +kernel
  rw [hc, show (458753 : ℕ) + 4096 = 462849 from rfl] at h
  exact h

end PiChunks
