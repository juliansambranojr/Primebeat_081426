import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_150_150 : ∀ i ∈ Finset.Ico 150 151, F25 i = W25 i := by
  decide +kernel

end Legendre
