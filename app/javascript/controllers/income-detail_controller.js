import { Controller } from "@hotwired/stimulus";
import { validMandatory } from "services/field-validation_services";

export default class extends Controller {
  static targets = ["grossIncomeError"];

  connect() {
  }

  validateGrossIncome(event) {
    const message = validMandatory(event.target.value) ? "" : "Mandatory field";
    this.grossIncomeErrorTarget.textContent = message;
  }
}
