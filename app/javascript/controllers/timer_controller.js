import { Controller } from "@hotwired/stimulus"

// Animates a progress bar from full to empty, ending at a fixed point in
// time so the countdown stays in sync even if the page loads mid-timer.
export default class extends Controller {
  static targets = ["bar"]
  static values = { endsAt: Number }

  connect() {
    const remainingMs = Math.max(this.endsAtValue - Date.now(), 0)

    this.barTarget.style.transitionDuration = "0s"
    this.barTarget.style.width = "100%"

    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        this.barTarget.style.transitionDuration = `${remainingMs / 1000}s`
        this.barTarget.style.width = "0%"
      })
    })
  }
}
