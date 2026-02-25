import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="expand-row"
export default class extends Controller {
  static targets = ["expandArea", "icon"]

  toggle() {
    this.expandAreaTarget.classList.toggle("hidden")
    this.iconTarget.classList.toggle("rotate-90")
  }
}
