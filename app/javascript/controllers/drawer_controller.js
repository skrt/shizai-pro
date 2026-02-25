import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="drawer"
export default class extends Controller {
  static targets = ["panel", "title"]

  open(event) {
    const orderNumber = event.currentTarget.dataset.drawerOrderNumber || ""
    if (this.hasTitleTarget) {
      this.titleTarget.textContent = `${orderNumber} メッセージ`
    }

    this.panelTarget.style.transform = "translateX(0)"
  }

  close() {
    this.panelTarget.style.transform = "translateX(100%)"
  }
}
