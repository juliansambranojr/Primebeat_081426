import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_60_60 : ∀ i ∈ Finset.Ico 60 61, F25 i = W25 i := by
  decide +kernel

end Legendre
