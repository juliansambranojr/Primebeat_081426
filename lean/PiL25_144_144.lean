import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_144_144 : ∀ i ∈ Finset.Ico 144 145, F25 i = W25 i := by
  decide +kernel

end Legendre
