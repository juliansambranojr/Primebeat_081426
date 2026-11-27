import PiChunks

namespace PiChunks

theorem b20_675841 : Nat.count Nat.Prime 679937 = Nat.count Nat.Prime 675841 + 308 := by
  have h := count_add_chunk 675841 4096
  have hc : cntR 675841 4096 = 308 := by decide +kernel
  rw [hc, show (675841 : ℕ) + 4096 = 679937 from rfl] at h
  exact h

end PiChunks
