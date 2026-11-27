import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_300_304 : ∀ i ∈ Finset.Ico 304 305, F25 i = W25 i := by
  decide +kernel

end Legendre
