import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_198_200 : ∀ i ∈ Finset.Ico 200 201, F24 i = W24 i := by
  decide +kernel

end Legendre
