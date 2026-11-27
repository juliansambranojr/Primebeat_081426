import PiChunks

namespace PiChunks

theorem b20_614401 : Nat.count Nat.Prime 618497 = Nat.count Nat.Prime 614401 + 320 := by
  have h := count_add_chunk 614401 4096
  have hc : cntR 614401 4096 = 320 := by decide +kernel
  rw [hc, show (614401 : ℕ) + 4096 = 618497 from rfl] at h
  exact h

end PiChunks
