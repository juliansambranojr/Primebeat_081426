import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_6_8 : ∀ i ∈ Finset.Ico 8 9, F25 i = W25 i := by
  decide +kernel

end Legendre
