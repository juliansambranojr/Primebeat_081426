import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_132_137 : ∀ i ∈ Finset.Ico 137 138, F24 i = W24 i := by
  decide +kernel

end Legendre
