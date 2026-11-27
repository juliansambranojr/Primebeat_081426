import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_462_462 : ∀ i ∈ Finset.Ico 462 463, F24 i = W24 i := by
  decide +kernel

end Legendre
