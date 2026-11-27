import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_120_125 : ∀ i ∈ Finset.Ico 125 126, F25 i = W25 i := by
  decide +kernel

end Legendre
