#!/usr/bin/env node
import { Dom } from './js/dom.mjs';
import { Type } from './js/type.mjs';
import { Str } from './js/str.mjs';
import { Anime } from './js/anime.mjs';
import { Int } from './js/int.mjs';
import { Container, Col, Row } from './js/layout.mjs';
import { Navbar } from './js/components/navbars.mjs';
import { Component } from './js/components.mjs';
document.addEventListener('DOMContentLoaded', function()
{
	Dom.boilerplate({
		'title': 'website',
		'theme': 'dark',
		'icon': 'static/img/icon.png',
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
					'static/css': [
						'style.css'
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
	const myContainer = new Container({
		'id': 'myContainer',
	});
	myContainer.addRows(1);
	myContainer.children[0].addCols(1);
	const myNavbar = new Navbar({
		'to': myContainer.children[0].children[0].element,
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
	myNavbar.addLink({
		'text': 'Contact Me',
		'fa': 'fa-solid fa-address-book',
		'id': 'contact'
	});
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
	Anime.fa();
});

