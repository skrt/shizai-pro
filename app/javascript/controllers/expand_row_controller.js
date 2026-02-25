import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="expand-row"
export default class extends Controller {
  static targets = ["expandArea", "icon"]

  toggle() {
    this.expandAreaTarget.classList.toggle("hidden")
    const isExpanded = !this.expandAreaTarget.classList.contains("hidden")
    this.iconTarget.style.transform = isExpanded ? "rotate(90deg)" : ""
  }
}
