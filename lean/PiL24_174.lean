import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_174 : ∀ i ∈ Finset.Ico 174 180, F24 i = W24 i := by
  decide +kernel

end Legendre
