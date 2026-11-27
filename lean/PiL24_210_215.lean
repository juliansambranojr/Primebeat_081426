import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_210_215 : ∀ i ∈ Finset.Ico 215 216, F24 i = W24 i := by
  decide +kernel

end Legendre
