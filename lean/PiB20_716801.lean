import PiChunks

namespace PiChunks

theorem b20_716801 : Nat.count Nat.Prime 720897 = Nat.count Nat.Prime 716801 + 288 := by
  have h := count_add_chunk 716801 4096
  have hc : cntR 716801 4096 = 288 := by decide +kernel
  rw [hc, show (716801 : ℕ) + 4096 = 720897 from rfl] at h
  exact h

end PiChunks
