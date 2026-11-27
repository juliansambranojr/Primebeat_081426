import PiW23

namespace Legendre

set_option maxHeartbeats 0 in
theorem g23_48 : ∀ i ∈ Finset.Ico 48 54, F23 i = W23 i := by
  decide +kernel

end Legendre
