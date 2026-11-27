import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_144_145 : ∀ i ∈ Finset.Ico 145 146, F24 i = W24 i := by
  decide +kernel

end Legendre
