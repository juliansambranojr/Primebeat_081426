import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_12_16 : ∀ i ∈ Finset.Ico 16 17, F25 i = W25 i := by
  decide +kernel

end Legendre
