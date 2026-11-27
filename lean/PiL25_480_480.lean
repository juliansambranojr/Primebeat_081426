import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_480_480 : ∀ i ∈ Finset.Ico 480 481, F25 i = W25 i := by
  decide +kernel

end Legendre
