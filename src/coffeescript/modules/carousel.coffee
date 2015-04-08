class Carousel

	constructor: (el) ->

		@el =
			carousel: el
			carouselSlideContainer: el.getElementsByClassName("carousel-slides")[0]
			carouselSlides: el.getElementsByClassName "carousel-slide"

		@numberOfSlides = @el.carouselSlides.length
		@currentSlide = 0

		@setupCarousel()
		@addNavigation()
		@addPagination()

		window.addEventListener "resize", =>
			console.log "resizing"
			@setupCarousel()

	setupCarousel: ->

		@el.carouselSlideContainer.style.width = (100 * @numberOfSlides) + "%"

		for slide in @el.carouselSlides
			slide.style.width = @el.carousel.clientWidth
			slide.style.height = @el.carousel.clientHeight

	addNavigation: ->

		@el.navigation = {}

		@el.navigation.previous = document.createElement "button"
		@el.navigation.previous.className = "carousel-navigation carousel-navigation-previous"
		@el.navigation.previous.type = "button"

		@el.navigation.next = document.createElement "button"
		@el.navigation.next.className = "carousel-navigation carousel-navigation-next"
		@el.navigation.next.type = "button"

		@el.carousel.appendChild @el.navigation.previous
		@el.carousel.appendChild @el.navigation.next

		@el.navigation.next.addEventListener "click", (e) =>
			e.preventDefault()
			@next()

		@el.navigation.previous.addEventListener "click", (e) =>
			e.preventDefault()
			@previous()

	addPagination: ->

		@el.pagination = document.createElement "ul"
		@el.pagination.className = "carousel-pagination"

		for slide, index in @el.carouselSlides

			image = slide.style.backgroundImage.slice 4, -1
			title = slide.getElementsByTagName("span")[0].innerText

			li = document.createElement "li"
			li.className = "carousel-pagination-item"
			li.style.backgroundImage = "url(" + image + ")"
			a = document.createElement "a"
			a.href = index
			a.title = title
			li.appendChild a

			if slide is @el.carouselSlides[@currentSlide]
				li.className += " active"

			@el.pagination.appendChild li

		@el.carousel.appendChild @el.pagination

		for link in @el.pagination.getElementsByTagName "a"

			link.addEventListener "click", (e) =>
				e.preventDefault()
				@goto e.target.getAttribute "href"

	next: ->
		if @currentSlide isnt @numberOfSlides - 1
			@currentSlide++
			@el.carouselSlideContainer.style.marginLeft = (-1 * @currentSlide * 100) + "%"
			@updatePagination()
		else
			@goto 0

	previous: ->
		if @currentSlide isnt 0
			@currentSlide--
			@el.carouselSlideContainer.style.marginLeft = (-1 * @currentSlide * 100) + "%"
			@updatePagination()
		else
			@goto @numberOfSlides - 1

	goto: (index) ->
		@currentSlide = index
		@el.carouselSlideContainer.style.marginLeft = (-1 * @currentSlide * 100) + "%"
		@updatePagination()

	updatePagination: ->

		for li, index in @el.pagination.getElementsByTagName "li"

			if index.toString() is @currentSlide.toString()
				li.className = "carousel-pagination-item active"
			else
				li.className = "carousel-pagination-item"


module.exports = Carousel