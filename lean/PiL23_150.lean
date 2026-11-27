import PiW23

namespace Legendre

set_option maxHeartbeats 0 in
theorem g23_150 : ∀ i ∈ Finset.Ico 150 156, F23 i = W23 i := by
  decide +kernel

end Legendre
