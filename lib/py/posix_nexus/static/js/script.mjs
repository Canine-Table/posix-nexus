#!/usr/bin/env node
import { Dom } from './js/dom.mjs';
import { Obj } from './js/obj.mjs';
import { Type } from './js/type.mjs';
import { Str } from './js/str.mjs';
import { Arr } from './js/arr.mjs';
import { nexAnime } from './js/anime.mjs';
import { Int } from './js/int.mjs';
import { nexContainer, nexCol, nexRow } from './js/layout.mjs';
import { nexFooter } from './js/components/footer.mjs';
import { nexForm } from './js/components/forms.mjs';
import { nexNavbar } from './js/components/navbars.mjs';
import { nexCarousel } from './js/components/carousel.mjs';
import { nexComponent } from './js/components.mjs';
document.addEventListener('DOMContentLoaded', function()
{
	Dom.boilerplate({
		'title': 'website',
		'theme': 'dark',
		'description': 'A brief description of the document',
		'keywords': 'JavaScript, HTML through JavaScript, CSS through JavaScript',
		'author': 'John and Jane Doe',
		'doctype': 'xs',
		'scripts': [
			{
				'paths': {
					'https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js': [
						'bootstrap.bundle.min.js'
					]
				},
				'script': {
					'bootstrap.bundle.min.js': {
						'integrity': 'sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz',
						'crossorigin': 'anonymous'
					}
				},
			},
		],
		'links': [
			{
				'paths': {
					'static': [
						'css/style.css',
						'img/logo.png'
					]
				},
				'link': {}
			},
			{
				'paths': {
					'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css': [
						'brands.min.css',
						'fontawesome.min.css',
						'solid.min.css'
					],
				},
				'link': {
					'brands.min.css': {
						'crossorigin': 'anonymous'
					},
					'fontawesome.min.css': {
						'crossorigin': 'anonymous'
					},
					'solid.min.css': {
						'crossorigin': 'anonymous'
					}
				}
			},
			{
				'paths': {
					'https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css': [
						'bootstrap.min.css'
					]
				},
				'link': {
					'bootstrap.min.css' : {
						'integrity': 'sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH',
						'crossorigin': 'anonymous'
					}
				}
			}
		]
	});
	const myNavbar = new nexNavbar({
		'to': Dom.body(),
		'h': 5,
		'true': [ 'sticky' ],
		'brand': 'Home',
		'fa': 'fa-solid fa-house',
		'link': 'home',
		'toggle': 'offcanvas',
		'location': 'end',
		'size': 'md',
		'title': 'Editorial Insights',
		'justify': 'center',
		'bar': [ 'pill' ]
	});

	const myCarousel = new nexCarousel({
		'to': myNavbar.getTab('home').element,
		'true': [ 'prev', 'next', 'indicators' ]
	});
	myCarousel.addSlide({
		'caption': 'slide 1',
		'p': 'This is a for slide 1.'
	}).addSlide({	
		'caption': 'slide 1',
		'p': 'This is a for slide 1.'
	});

	myNavbar.addLink({
		'text': 'Contact Me',
		'fa': 'fa-solid fa-address-book',
		'id': 'contact'
	});
	const myForm = new nexForm({
		'to': myNavbar.getTab('contact').element,
		'text': 'send',
		'cls': 'btn-outline-primary'
	});
	myForm.addInput([
		{
			'type': 'text',
			'label': 'name',
			'float': 'first name',
			'true': [ 'group' ]
		}, {
			'type': 'text',
			'float': 'last name',
			'true': [ 'group' ]
		}
	]);
	myForm.addInput([
		{
			'type': 'text',
			'label': 'email',
			'float': 'username',
			'true': [ 'group' ]
		}, {
			'type': 'text',
			'label': '@',
			'float': 'server',
			'true': [ 'group' ]
		}
	]);

	myForm.addInput([{
		'type': 'subject',
		'label': 'subject',
		'true': [ 'group' ]
	}]);
	myForm.addInput([{
		'type': 'file',
		'true': [ 'multi' ]
	}]);
	myForm.addInput([{
		'type': 'area',
		'float': 'message'
	}]);

	for (let i of myForm.form.alterChildren()) {
		i.apply({
			'clsAdd': Str.implode(Arr.flatten([
				{
					'col': 0
				},
				{
					'col': {
						'sm': 2,
						'md': 2,
						'lg': 2,
						'xl': 2,
						'xx1': 2
					}
				}
			]), ' ')
		});
	}

	myNavbar.addLink({
		'text': 'Client Testimonials',
		'fa': 'fa-solid fa-star',
		'id': 'testimonials'
	});

	myNavbar.addLink({
		'text': 'About Me',
		'fa': 'fa-solid fa-circle-info',
		'id': 'about'
	});

	myNavbar.addLink({
		'text': 'My Services',
		'fa': 'fa-solid fa-pen-nib',
		'id': 'services'
	});

	nexAnime.fa();

	new nexFooter({
		'to': Dom.body(),
		'align': 'center',
		'true': [ 'secondary' ]
	});
});

