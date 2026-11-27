import PiChunks

namespace PiChunks

theorem b19_503809 : Nat.count Nat.Prime 507905 = Nat.count Nat.Prime 503809 + 315 := by
  have h := count_add_chunk 503809 4096
  have hc : cntR 503809 4096 = 315 := by decide +kernel
  rw [hc, show (503809 : ℕ) + 4096 = 507905 from rfl] at h
  exact h

end PiChunks
