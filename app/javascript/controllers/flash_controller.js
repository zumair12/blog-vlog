import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Auto-dismiss after 5 seconds
    this.timeout = setTimeout(() => this.dismiss(), 5000)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  dismiss() {
    this.element.style.opacity = "0"
    this.element.style.transform = "translateX(100%)"
    this.element.style.transition = "opacity 0.3s ease, transform 0.3s ease"
    setTimeout(() => this.element.remove(), 350)
  }
}
