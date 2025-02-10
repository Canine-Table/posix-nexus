#!/usr/bin/env node
document.addEventListener('DOMContentLoaded', function()
{
	addOffCanvasNavBar({
		'id': 'Top',
		'clsTog': 'offcanvas-end',
		'txtHdr': 'Welcome to your bootstap template!'
	});

	// Home Page
	addNavBarItem({
		'to': 'Top',
		'id': 'Home',
		'fa': 'fa-solid fa-house',
		'txtAdd': 'Home',
		'lnk': '#Home',
	});
	addCarousel({
		'id': 'HomePage',
		'to': 'contentContainerHome',
		'btn': true,
		'clsOut': 'carousel-fade'
	});
	addCarouselItem({
		'id': 'ImageOne',
		'to': 'HomePage',
		'hdr': 'Number 3',
		'hdrnum': 5,
		'par': 'Hello World!'
	});
	addCarouselItem({
		'id': 'ImageTwo',
		'to': 'HomePage',
	});
	addCarouselItem({
		'id': 'ImageThree',
		'to': 'HomePage',
	})

	// Clients
	addNavBarItem({
		'to': 'Top',
		'id': 'Testimonials',
		'fa': 'fa-solid fa-star',
		'txtAdd': 'Client Testimonials',
		'lnk': '#Testimonials'
	});


	// Contact Page
	addNavBarItem({
		'to': 'Top',
		'id': 'Contact',
		'fa': 'fa-solid fa-address-book',
		'txtAdd': 'Contact Me',
		'lnk': '#Contact'
	});

	addFileForm({
		'lbl': 'Password',
		'id': 'exampleForm',
		'to': 'contentContainerContact',
	})

	// Services
	addNavBarItem({
		'to': 'Top',
		'id': 'Services',
		'fa': 'fa-solid fa-pen-nib',
		'txtAdd': 'My Services',
		'lnk': '#Services'
	});

	// About
	addNavBarItem({
		'fa': 'fa-solid fa-circle-info',
		'txtAdd': 'About Me'
	});

	document.getElementById('contentContainerHome').click();
});

