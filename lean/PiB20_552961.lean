import PiChunks

namespace PiChunks

theorem b20_552961 : Nat.count Nat.Prime 557057 = Nat.count Nat.Prime 552961 + 314 := by
  have h := count_add_chunk 552961 4096
  have hc : cntR 552961 4096 = 314 := by decide +kernel
  rw [hc, show (552961 : ℕ) + 4096 = 557057 from rfl] at h
  exact h

end PiChunks
