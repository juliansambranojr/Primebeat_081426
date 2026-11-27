import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_300_301 : ∀ i ∈ Finset.Ico 301 302, F25 i = W25 i := by
  decide +kernel

end Legendre
