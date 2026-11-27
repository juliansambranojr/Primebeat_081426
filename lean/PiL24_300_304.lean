import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_300_304 : ∀ i ∈ Finset.Ico 304 305, F24 i = W24 i := by
  decide +kernel

end Legendre
