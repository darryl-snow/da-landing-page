class Modals

	constructor: ->

		@el =
			body: document.body

	showModal: (modal) ->

		@el.body.className += " banner-module-modal-open"

		backdrop = document.createElement "div"
		backdrop.className = "banner-module-modal-backdrop fade"

		modal.insertBefore backdrop, modal.firstChild

		backdrop.className += " in"

		dialog = modal.getElementsByClassName("banner-module-modal-dialog")[0]

		modal.style.display = "block"

		setTimeout ->
			modal.className += " show"
		, 500

		modal.setAttribute "aria-hidden", "false"

		backdrop.addEventListener "click", =>
			@closeModal modal

		if backdrop.clientHeight < dialog.clientHeight
			backdrop.style.height = dialog.clientHeight + 100 + "px"

	closeModal: (modal) ->

		modal.className = modal.className.replace /show/, ""

		setTimeout ->
			modal.style.display = "none"
		, 300

		@el.body.className = @el.body.className.replace /banner-module-modal-open/, ""

		modal.setAttribute "aria-hidden", "true"

		backdrop = document.getElementsByClassName("banner-module-modal-backdrop")[0]
		modal.removeChild backdrop

module.exports = new Modals