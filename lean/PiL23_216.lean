import PiW23

namespace Legendre

set_option maxHeartbeats 0 in
theorem g23_216 : ∀ i ∈ Finset.Ico 216 222, F23 i = W23 i := by
  decide +kernel

end Legendre
