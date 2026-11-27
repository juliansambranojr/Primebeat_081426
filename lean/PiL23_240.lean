import PiW23

namespace Legendre

set_option maxHeartbeats 0 in
theorem g23_240 : ∀ i ∈ Finset.Ico 240 246, F23 i = W23 i := by
  decide +kernel

end Legendre
