import PiChunks

namespace PiChunks

theorem b20_622593 : Nat.count Nat.Prime 626689 = Nat.count Nat.Prime 622593 + 296 := by
  have h := count_add_chunk 622593 4096
  have hc : cntR 622593 4096 = 296 := by decide +kernel
  rw [hc, show (622593 : ℕ) + 4096 = 626689 from rfl] at h
  exact h

end PiChunks
