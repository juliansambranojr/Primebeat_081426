import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_120_121 : ∀ i ∈ Finset.Ico 121 122, F24 i = W24 i := by
  decide +kernel

end Legendre
