import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {}

  confirmDelete(event) {
    const confirmed = confirm("Are you sure you want to delete this item?");

    if (!confirmed) {
      event.preventDefault();
      event.stopImmediatePropagation();
    }
  }
}
