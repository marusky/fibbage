import { Controller } from "@hotwired/stimulus"

const INTRO_STAGGER_MS = 120
const BOARD_FADE_MS = 400

// Plays the evaluation reveal on the TV screen: all answers fade in as a
// board, then each voted-for answer (lies first, truth last) is highlighted
// in turn with its author, voters and points. Once done, the answer board
// is swapped out for the leaderboard so everything keeps fitting on a
// single, unscrollable screen.
export default class extends Controller {
  static targets = ["board", "card", "leaderboard"]
  static values = {
    order: Array,
    stepDuration: { type: Number, default: 4200 }
  }

  connect() {
    this.playIntro().then(() => this.playReveal()).then(() => this.showLeaderboard())
  }

  playIntro() {
    this.cardTargets.forEach((card, index) => {
      setTimeout(() => card.classList.add("is-in"), index * INTRO_STAGGER_MS)
    })

    return this.wait(this.cardTargets.length * INTRO_STAGGER_MS + 500)
  }

  async playReveal() {
    const revealedIds = this.orderValue.map(String)

    this.cardTargets.forEach((card) => {
      if (!revealedIds.includes(card.dataset.answerId)) card.classList.add("is-muted")
    })

    for (const answerId of revealedIds) {
      const card = this.cardTargets.find((candidate) => candidate.dataset.answerId === answerId)
      if (!card) continue

      this.cardTargets.forEach((candidate) => candidate.classList.remove("is-active"))
      card.classList.remove("is-muted")
      card.classList.add("is-active", "is-revealed")

      await this.wait(this.stepDurationValue)
    }
  }

  async showLeaderboard() {
    if (this.hasBoardTarget) {
      this.boardTarget.classList.add("is-fading-out")
      await this.wait(BOARD_FADE_MS)
      this.boardTarget.style.display = "none"
    }

    if (this.hasLeaderboardTarget) this.leaderboardTarget.classList.add("is-in")
  }

  wait(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms))
  }
}
