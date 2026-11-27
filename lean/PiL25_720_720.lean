import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_720_720 : ∀ i ∈ Finset.Ico 720 721, F25 i = W25 i := by
  decide +kernel

end Legendre
