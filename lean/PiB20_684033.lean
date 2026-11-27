import PiChunks

namespace PiChunks

theorem b20_684033 : Nat.count Nat.Prime 688129 = Nat.count Nat.Prime 684033 + 310 := by
  have h := count_add_chunk 684033 4096
  have hc : cntR 684033 4096 = 310 := by decide +kernel
  rw [hc, show (684033 : ℕ) + 4096 = 688129 from rfl] at h
  exact h

end PiChunks
