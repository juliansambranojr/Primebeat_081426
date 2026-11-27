import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_180_185 : ∀ i ∈ Finset.Ico 185 186, F25 i = W25 i := by
  decide +kernel

end Legendre
