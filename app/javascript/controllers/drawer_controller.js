import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="drawer"
export default class extends Controller {
  static targets = ["panel", "title"]

  open(event) {
    const orderNumber = event.currentTarget.dataset.drawerOrderNumber || ""
    if (this.hasTitleTarget) {
      this.titleTarget.textContent = `${orderNumber} メッセージ`
    }

    this.panelTarget.style.width = "512px"
    this.panelTarget.style.borderLeftWidth = "1px"
  }

  close() {
    this.panelTarget.style.width = "0"
    this.panelTarget.style.borderLeftWidth = "0"
  }
}
