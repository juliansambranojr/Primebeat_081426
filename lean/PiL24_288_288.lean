import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_288_288 : ∀ i ∈ Finset.Ico 288 289, F24 i = W24 i := by
  decide +kernel

end Legendre
