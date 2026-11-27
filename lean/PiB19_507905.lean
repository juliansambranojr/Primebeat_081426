import PiChunks

namespace PiChunks

theorem b19_507905 : Nat.count Nat.Prime 512001 = Nat.count Nat.Prime 507905 + 313 := by
  have h := count_add_chunk 507905 4096
  have hc : cntR 507905 4096 = 313 := by decide +kernel
  rw [hc, show (507905 : ℕ) + 4096 = 512001 from rfl] at h
  exact h

end PiChunks
