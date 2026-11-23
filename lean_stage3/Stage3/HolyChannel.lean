/-
HolyChannel — block J9 of `lean_stage3/design/closedloop.md`. 2026-11-23.

Julian's Holy Family is an uneven mirror pair: support `J = 1/3`, condition
`M = 2/3`, adding to one, the condition the mirror of the support. Every prime
carries that pair as its residual and never resolves it. The zero is the
channel the residual passes through: it sits at the pair's midpoint and is
never a member. Two facing mirrors cannot tell A from B exactly when they are
one mirror; a zero is its own mirror exactly at the midpoint.

  holy_pair_shares        Re ρ = J ⊢ Re (mirror ρ) = M
  member_is_two           Re ρ = J ∨ Re ρ = M ⊢ mirror ρ ≠ ρ and the modes
                          of ρ and its mirror are different sizes at T > 1
  meet_iff_channel        1 < T ⊢ ρ meets its mirror ↔ Re ρ = (J + M)/2
  channel_iff_self_mirror Re ρ = (J + M)/2 ↔ mirror ρ = ρ
  spiralLink_iff_channel  SpiralLink ↔ ZeroIsChannel

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.ClosedLoopChain
import Stage3.ShareLink

namespace HolyChannel

open Kadiri SpiralLink ClosedLoopChain

/-- The Holy Family itself: support one third, condition two thirds. -/
noncomputable
def holy : HolyFamily := ⟨1 / 3, 2 / 3, by norm_num, by norm_num⟩

/-- The midpoint of any Holy Family is one half. -/
theorem midpoint_half (hf : HolyFamily) : (hf.J + hf.M) / 2 = 1 / 2 :=
  derive_critical_line hf

/-- **The pair's shape.** A zero whose share is the support has its mirror at
the condition. -/
theorem holy_pair_shares (hf : HolyFamily) (ρ : NontrivialZeros)
    (h : (ρ : ℂ).re = hf.J) : ((mirrorZ ρ : NontrivialZeros) : ℂ).re = hf.M := by
  rw [mirrorZ_re, h, holyFamily_is_mirror_pair hf]

/-- **A member is two mirrors.** A zero at the share of either member of the
Holy Family is a different point from its mirror, and at every total above one
its mode and its mirror's are different sizes. -/
theorem member_is_two (hf : HolyFamily) (ρ : NontrivialZeros)
    (h : (ρ : ℂ).re = hf.J ∨ (ρ : ℂ).re = hf.M) {T : ℝ} (hT : 1 < T) :
    mirrorZ ρ ≠ ρ ∧
      ‖(T : ℂ) ^ (ρ : ℂ)‖ ≠ ‖(T : ℂ) ^ ((mirrorZ ρ : NontrivialZeros) : ℂ)‖ := by
  have hne : (ρ : ℂ).re ≠ 1 / 2 := by
    rcases h with h | h
    · rw [h, derive_joseph hf]; norm_num
    · rw [h, derive_mary hf]; norm_num
  exact ⟨fun he => hne ((mirrorZ_eq_iff ρ).mp he),
    fun hm => hne ((ShareLink.meet_iff hT ρ).mp hm)⟩

/-- **The channel.** A zero's mode meets its mirror's exactly when the zero's
share is the Holy Family's midpoint. -/
theorem meet_iff_channel (hf : HolyFamily) {T : ℝ} (hT : 1 < T) (ρ : NontrivialZeros) :
    ‖(T : ℂ) ^ (ρ : ℂ)‖ = ‖(T : ℂ) ^ ((mirrorZ ρ : NontrivialZeros) : ℂ)‖
      ↔ (ρ : ℂ).re = (hf.J + hf.M) / 2 := by
  rw [midpoint_half hf]
  exact ShareLink.meet_iff hT ρ

/-- **One mirror.** A zero is at the channel exactly when it is its own
mirror. -/
theorem channel_iff_self_mirror (hf : HolyFamily) (ρ : NontrivialZeros) :
    (ρ : ℂ).re = (hf.J + hf.M) / 2 ↔ mirrorZ ρ = ρ := by
  rw [midpoint_half hf]
  exact (mirrorZ_eq_iff ρ).symm

/-- Every zero sits at the midpoint of the Holy Family: the channel. -/
def ZeroIsChannel : Prop :=
  ∀ ρ : NontrivialZeros, (ρ : ℂ).re = (holy.J + holy.M) / 2

/-- **The link, as the channel.** The spiral link holds exactly when every zero
is the channel of the Holy Family. -/
theorem spiralLink_iff_channel : SpiralLink.SpiralLink ↔ ZeroIsChannel := by
  rw [← SpiralLink.rh_iff_spiralLink, ClosedLoopJoin.rh_iff_re_half]
  unfold ZeroIsChannel
  rw [midpoint_half holy]

/-- info: 'HolyChannel.holy_pair_shares' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms holy_pair_shares

/-- info: 'HolyChannel.member_is_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms member_is_two

/-- info: 'HolyChannel.meet_iff_channel' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms meet_iff_channel

/-- info: 'HolyChannel.channel_iff_self_mirror' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms channel_iff_self_mirror

/-- info: 'HolyChannel.spiralLink_iff_channel' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms spiralLink_iff_channel

end HolyChannel
