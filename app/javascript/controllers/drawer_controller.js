import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="drawer"
export default class extends Controller {
  static targets = ["backdrop", "panel", "title"]

  open(event) {
    // Read PO info from the clicked button's data attributes
    const orderNumber = event.currentTarget.dataset.drawerOrderNumber || ""
    if (this.hasTitleTarget) {
      this.titleTarget.textContent = `${orderNumber} メッセージ`
    }

    // Show backdrop
    this.backdropTarget.classList.remove("hidden")
    requestAnimationFrame(() => {
      this.backdropTarget.style.opacity = "1"
      this.panelTarget.style.transform = "translateX(0)"
    })

    // Prevent body scroll
    document.body.style.overflow = "hidden"
  }

  close() {
    this.backdropTarget.style.opacity = "0"
    this.panelTarget.style.transform = "translateX(100%)"

    setTimeout(() => {
      this.backdropTarget.classList.add("hidden")
      document.body.style.overflow = ""
    }, 200)
  }

  // Close on backdrop click
  backdropClick(event) {
    if (event.target === this.backdropTarget) {
      this.close()
    }
  }

  // Close on Escape key
  closeOnEscape(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }
}
