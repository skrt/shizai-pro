import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "dropdown", "option", "count", "clear"]

  connect() {
    this.open = false
    document.addEventListener("click", this._onClickOutside)
  }

  disconnect() {
    document.removeEventListener("click", this._onClickOutside)
  }

  toggle() {
    this.open ? this.close() : this.show()
  }

  show() {
    this.open = true
    this.dropdownTarget.classList.remove("hidden")
    this.filter()
  }

  close() {
    this.open = false
    this.dropdownTarget.classList.add("hidden")
  }

  filter() {
    const query = this.inputTarget.value.toLowerCase()
    let visibleCount = 0

    this.optionTargets.forEach(option => {
      const text = option.textContent.toLowerCase()
      const matches = !query || text.includes(query)
      option.classList.toggle("hidden", !matches)
      if (matches) visibleCount++
    })

    if (this.hasCountTarget) {
      this.countTarget.textContent = `検索結果：${visibleCount}件`
    }
  }

  select(event) {
    const value = event.currentTarget.dataset.value
    const label = event.currentTarget.dataset.label
    this.inputTarget.value = label
    if (this.hasClearTarget) {
      this.clearTarget.classList.remove("hidden")
    }
    this.close()
  }

  clear() {
    this.inputTarget.value = ""
    if (this.hasClearTarget) {
      this.clearTarget.classList.add("hidden")
    }
    this.inputTarget.focus()
  }

  _onClickOutside = (event) => {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }
}
