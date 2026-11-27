import PiChunks

namespace PiChunks

theorem b19_462849 : Nat.count Nat.Prime 466945 = Nat.count Nat.Prime 462849 + 314 := by
  have h := count_add_chunk 462849 4096
  have hc : cntR 462849 4096 = 314 := by decide +kernel
  rw [hc, show (462849 : ℕ) + 4096 = 466945 from rfl] at h
  exact h

end PiChunks
