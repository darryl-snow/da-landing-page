Modal = require "./modal.coffee"

class Form

	constructor: (el) ->

		@el =
			form: el
			name: document.getElementById "contact-details-name"
			phone: document.getElementById "contact-details-phone"
			email: document.getElementById "contact-details-email"
			expiryMonth: document.getElementById "contact-details-expiry-month"
			expiryYear: document.getElementById "contact-details-expiry-year"
			contactDays: document.getElementById "contact-details-contact-days"
			contactTime: document.getElementById "contact-details-contact-time"
			optin: document.getElementById "contact-details-optin"
			sendButton: document.getElementById "contact-details-send"

		@el.sendButton.addEventListener "click", (e) =>
			e.preventDefault()
			@sendForm()

		@data = {}

	validateForm: ->

		valid = false

		# Check name
		if @el.name.value.length is 0
			@el.name.parentElement.className += " error"
			@el.name.parentElement.getElementsByClassName("error-msg")[0].innerText =
			 "This is required information"
		else if !@el.name.value.match /^[a-zA-Z\s]*$/
			@el.name.parentElement.className += " error"
			@el.name.parentElement.getElementsByClassName("error-msg")[0].innerText =
			 "Please enter a valid name"
		else
			@el.name.parentElement.className =
			@el.name.parentElement.className.replace /error/, ""

		# Check phone number
		if @el.phone.value.length is 0
			@el.phone.parentElement.className += " error"
			@el.phone.parentElement.getElementsByClassName("error-msg")[0].innerText =
			 "This is required information"
		else if !@el.phone.value.match /^[0-9\s-]*$/
			@el.phone.parentElement.className += " error"
			@el.phone.parentElement.getElementsByClassName("error-msg")[0].innerText =
			 "Please enter a valid phone number"
		else
			@el.phone.parentElement.className =
			@el.phone.parentElement.className.replace /error/, ""

		# Check email
		if @el.email.value.length is 0
			@el.email.parentElement.className += " error"
			@el.email.parentElement.getElementsByClassName("error-msg")[0].innerText =
			 "This is required information"
		else if !@el.email.value.match /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@/
			@el.email.parentElement.className += " error"
			@el.email.parentElement.getElementsByClassName("error-msg")[0].innerText =
			 "Please enter a valid email address"
		else
			@el.email.parentElement.className =
			@el.email.parentElement.className.replace /error/, ""

		if (@el.name.value.length isnt 0) and
		(@el.name.value.match /^[a-zA-Z\s]*$/) and
		(@el.phone.value.length isnt 0) and
		(@el.phone.value.match /^[0-9\s-]*$/) and
		(@el.email.value.match /(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/) and
		(@el.email.value.length isnt 0)
			return true
		else
			return false

	sendForm: ->

		if @validateForm()

			document.getElementById("modal-thank-you-name").innerText = @el.name.value

			@data.name = @el.name.value
			@data.phone = @el.phone.value
			@data.email = @el.email.value
			@data.expiryMonth = @el.expiryMonth.value
			@data.expiryYear = @el.expiryYear.value
			@data.contactDays = @el.contactDays.value
			@data.contactTime = @el.contactTime.value
			@data.optin = @el.optin.checked

			###
			send data to server
			###

			###
			$.ajax
				type: "POST"
				url: "https://api.url/get-contact-details"
				data: @data
				success: ->
					Modal.closeModal document.getElementById "modal-form"
					setTimeout ->
						Modal.showModal document.getElementById "modal-thank-you"
					, 300
				dataType: "JSON"
			###

			console.info @data

			Modal.closeModal document.getElementById "modal-form"
			setTimeout ->
				Modal.showModal document.getElementById "modal-thank-you"
			, 300

module.exports = Form