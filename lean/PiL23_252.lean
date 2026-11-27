import PiW23

namespace Legendre

set_option maxHeartbeats 0 in
theorem g23_252 : ∀ i ∈ Finset.Ico 252 258, F23 i = W23 i := by
  decide +kernel

end Legendre
