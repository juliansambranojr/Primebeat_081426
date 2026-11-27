import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_384_388 : ∀ i ∈ Finset.Ico 388 389, F25 i = W25 i := by
  decide +kernel

end Legendre
