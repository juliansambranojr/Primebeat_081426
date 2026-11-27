import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_198_200 : ∀ i ∈ Finset.Ico 200 201, F25 i = W25 i := by
  decide +kernel

end Legendre
