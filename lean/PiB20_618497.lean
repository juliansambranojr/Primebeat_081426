import PiChunks

namespace PiChunks

theorem b20_618497 : Nat.count Nat.Prime 622593 = Nat.count Nat.Prime 618497 + 300 := by
  have h := count_add_chunk 618497 4096
  have hc : cntR 618497 4096 = 300 := by decide +kernel
  rw [hc, show (618497 : ℕ) + 4096 = 622593 from rfl] at h
  exact h

end PiChunks
