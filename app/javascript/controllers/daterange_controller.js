import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["trigger", "display", "dropdown", "monthLabel", "weekGrid", "clear"]

  connect() {
    this.open = false
    this.startDate = null
    this.endDate = null
    this.hoverDate = null
    this.picking = "start"

    const now = new Date()
    this.year = now.getFullYear()
    this.month = now.getMonth()

    // Native event delegation on weekGrid
    this._boundGridClick = this._onGridClick.bind(this)
    this._boundGridHover = this._onGridHover.bind(this)
    this._boundGridHoverOut = this._onGridHoverOut.bind(this)
    this.weekGridTarget.addEventListener("click", this._boundGridClick)
    this.weekGridTarget.addEventListener("mouseover", this._boundGridHover)
    this.weekGridTarget.addEventListener("mouseout", this._boundGridHoverOut)

    // Outside click detection via mousedown (fires before click, so DOM is intact)
    this._boundOutside = this._onOutsideMousedown.bind(this)
    document.addEventListener("mousedown", this._boundOutside)
  }

  disconnect() {
    document.removeEventListener("mousedown", this._boundOutside)
  }

  toggle(event) {
    event.stopPropagation()
    this.open ? this._doClose() : this.show()
  }

  show() {
    this.open = true
    this.dropdownTarget.classList.remove("hidden")
    this._render()
  }

  _doClose() {
    this.open = false
    this.dropdownTarget.classList.add("hidden")
    this.hoverDate = null
  }

  prevMonth(event) {
    event.stopPropagation()
    if (this.month === 0) { this.month = 11; this.year-- }
    else { this.month-- }
    this._render()
  }

  nextMonth(event) {
    event.stopPropagation()
    if (this.month === 11) { this.month = 0; this.year++ }
    else { this.month++ }
    this._render()
  }

  clear(event) {
    event.stopPropagation()
    this.startDate = null
    this.endDate = null
    this.picking = "start"
    this._updateDisplay()
    if (this.open) this._render()
  }

  // -- Grid event handlers (native delegation) --

  _onGridClick(event) {
    event.stopPropagation()
    const cell = event.target.closest("[data-day]")
    if (!cell || cell.dataset.cur !== "true") return

    const d = parseInt(cell.dataset.day)
    const n = this._toNum(d)
    let shouldClose = false

    if (this.picking === "start") {
      this.startDate = n
      this.endDate = null
      this.picking = "end"
    } else {
      if (n <= this.startDate) {
        this.startDate = n
        this.endDate = null
      } else {
        this.endDate = n
        this.picking = "start"
        shouldClose = true
      }
    }

    this._updateDisplay()

    // Defer DOM rebuild so event.target stays in DOM during event propagation
    setTimeout(() => {
      this._render()
      if (shouldClose) this._doClose()
    }, 0)
  }

  _onGridHover(event) {
    const cell = event.target.closest("[data-day]")
    if (!cell || cell.dataset.cur !== "true") return
    const d = parseInt(cell.dataset.day)
    const newHover = this._toNum(d)
    if (this.hoverDate !== newHover) {
      this.hoverDate = newHover
      this._render()
    }
  }

  _onGridHoverOut() {
    if (this.hoverDate !== null) {
      this.hoverDate = null
      this._render()
    }
  }

  // -- Outside click via mousedown (fires before click, DOM intact) --

  _onOutsideMousedown(event) {
    if (!this.open) return
    if (this.element.contains(event.target)) return
    this._doClose()
  }

  // -- Private helpers --

  _toNum(d) {
    return this.year * 10000 + (this.month + 1) * 100 + d
  }

  _formatDate(n) {
    if (!n) return ""
    const y = Math.floor(n / 10000)
    const m = Math.floor((n % 10000) / 100)
    const d = n % 100
    return y + "/" + String(m).padStart(2, "0") + "/" + String(d).padStart(2, "0")
  }

  _updateDisplay() {
    let text = ""
    if (this.startDate && this.endDate) {
      text = this._formatDate(this.startDate) + " - " + this._formatDate(this.endDate)
    } else if (this.startDate) {
      text = this._formatDate(this.startDate) + " - yyyy/mm/dd"
    }

    this.displayTarget.textContent = text || "yyyy/mm/dd - yyyy/mm/dd"
    this.displayTarget.classList.toggle("text-gray-400", !text)
    this.displayTarget.classList.toggle("text-gray-900", !!text)

    if (this.hasClearTarget) {
      this.clearTarget.classList.toggle("hidden", !this.startDate)
    }
  }

  _getDays() {
    const first = new Date(this.year, this.month, 1)
    let dow = first.getDay()
    dow = dow === 0 ? 6 : dow - 1
    const last = new Date(this.year, this.month + 1, 0).getDate()
    const prevLast = new Date(this.year, this.month, 0).getDate()
    const cells = []
    for (let i = dow - 1; i >= 0; i--) cells.push({ d: prevLast - i, cur: false })
    for (let i = 1; i <= last; i++) cells.push({ d: i, cur: true })
    const rem = 42 - cells.length
    for (let i = 1; i <= rem; i++) cells.push({ d: i, cur: false })
    return cells
  }

  _render() {
    this.monthLabelTarget.textContent = this.year + "\u5E74 " + (this.month + 1) + "\u6708"

    const days = this._getDays()
    const grid = this.weekGridTarget
    grid.innerHTML = ""

    days.forEach(cell => {
      const el = document.createElement("div")
      el.textContent = cell.d
      el.dataset.day = cell.d
      el.dataset.cur = cell.cur
      el.className = "h-9 flex items-center justify-center text-xs transition-colors select-none"

      if (!cell.cur) {
        el.classList.add("text-gray-400", "cursor-default")
      } else {
        const n = this._toNum(cell.d)
        const isStart = this.startDate && n === this.startDate
        const isEnd = this.endDate && n === this.endDate
        const end = this.endDate || (this.hoverDate && this.picking === "end" ? this.hoverDate : null)
        const lo = end && this.startDate ? Math.min(this.startDate, end) : null
        const hi = end && this.startDate ? Math.max(this.startDate, end) : null
        const inRange = lo !== null && hi !== null && n > lo && n < hi

        if (isStart || isEnd) {
          el.classList.add("text-white", "rounded-full", "cursor-pointer")
          el.style.background = "#3D62D3"
        } else if (inRange) {
          el.classList.add("text-gray-500", "cursor-pointer")
          el.style.background = "#ECEFF9"
        } else {
          el.classList.add("text-gray-900", "rounded-full", "hover:bg-gray-100", "cursor-pointer")
        }
      }

      grid.appendChild(el)
    })
  }
}
