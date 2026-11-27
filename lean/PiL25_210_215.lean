import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_210_215 : ∀ i ∈ Finset.Ico 215 216, F25 i = W25 i := by
  decide +kernel

end Legendre
