import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_144_144 : ∀ i ∈ Finset.Ico 144 145, F24 i = W24 i := by
  decide +kernel

end Legendre
