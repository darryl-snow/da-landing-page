# Show modals

Modal = require "./modules/modal.coffee"

for trigger in document.getElementsByClassName "js-toggle-form-modal"

	trigger.addEventListener "click", (e) ->

		Modal.showModal document.getElementById e.target.getAttribute("href").substr 1


# Run the carousel

Carousel = require "./modules/carousel.coffee"

for carousel in document.getElementsByClassName "carousel"
	new Carousel carousel


# Process the form

Form = require "./modules/form.coffee"

for form in document.getElementsByClassName "banner-module-form"
	new Form form

for dropdown in $("select")
	label = $(dropdown).data "label"
	$(dropdown).dropdown
		label: label