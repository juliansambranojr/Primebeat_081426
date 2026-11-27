import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_252_256 : ∀ i ∈ Finset.Ico 256 257, F25 i = W25 i := by
  decide +kernel

end Legendre
