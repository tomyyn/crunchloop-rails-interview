import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.focusInputField();
    document.addEventListener("turbo:frame-load", this.focusInputField.bind(this));
  }

  focusInputField() {
      const inputField = this.element.querySelector("#new_item_name");
      if (inputField) {
        inputField.focus();
      }
  }

  disconnect() {
    document.removeEventListener("turbo:frame-load", this.focusInputField);
  }
}