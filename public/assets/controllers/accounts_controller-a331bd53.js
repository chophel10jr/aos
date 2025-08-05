import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["stepper", "stepperDiv", "stepperDetail"];
  static values = { presentStep: Number, statusClick: Number };

  connect() {
    this.presentStepValue = 1;
    this.statusClick = 0;
    this.updateStepper(this.presentStepValue);
  }

  randomStep(event) {
    const step = parseInt(event.target.dataset.step);
    this.presentStepValue = step;
    this.updateStepper(step);
  }

  updateStepper(step) {
    for (let i = 1; i <= this.stepperDetailTargets.length; i++) {
      if (i !== step) {
        this.stepperDivTargets[i - 1].classList.remove(
          "bg-bnb_blue",
          "text-white"
        );
        this.stepperDetailTargets[i - 1].classList.add("hidden");
      } else {
        this.stepperDivTargets[i - 1].classList.add(
          "bg-bnb_blue",
          "text-white"
        );
        this.stepperDetailTargets[i - 1].classList.remove("hidden");
      }
    }
  }
}
