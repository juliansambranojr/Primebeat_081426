import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_300_303 : ∀ i ∈ Finset.Ico 303 304, F25 i = W25 i := by
  decide +kernel

end Legendre
