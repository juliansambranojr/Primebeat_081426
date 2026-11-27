import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_300_300 : ∀ i ∈ Finset.Ico 300 301, F25 i = W25 i := by
  decide +kernel

end Legendre
