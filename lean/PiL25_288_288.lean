import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_288_288 : ∀ i ∈ Finset.Ico 288 289, F25 i = W25 i := by
  decide +kernel

end Legendre
