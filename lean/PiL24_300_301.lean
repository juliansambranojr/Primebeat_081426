import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_300_301 : ∀ i ∈ Finset.Ico 301 302, F24 i = W24 i := by
  decide +kernel

end Legendre
