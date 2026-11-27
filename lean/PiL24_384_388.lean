import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_384_388 : ∀ i ∈ Finset.Ico 388 389, F24 i = W24 i := by
  decide +kernel

end Legendre
