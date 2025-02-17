#!/usr/bin/env node
import { Dom } from './js/dom.mjs';
import { Type } from './js/type.mjs';
import { Container, Col, Row } from './js/layout.mjs';
import { Navbar } from './js/components/navbars.mjs';
document.addEventListener('DOMContentLoaded', function()
{
	Dom.boilerplate({
		'title': 'website',
		'theme': 'dark',
		'icon': 'static/img/icon.png',
		'description': 'A brief description of the document',
		'keywords': 'HTML, CSS, JavaScript',
		'author': 'John Doe',
		'doctype': 'xs',
		'scripts': [
			{
				'paths': {
					'static/js': [
						'script.mjs'
					]
				},
				'script': {}
			},
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
	myContainer.addRows(1);
	myContainer.children[0].addCols(1)
	const myNavbar = new Navbar({
		'to': myContainer.children[0].children[0].element,
		'true': [ 'sticky' ],
		'brand': 'navbar',
		'toggle': 'offcanvas',
		'location': 'end',
		'title': 'hello'
	});

	//console.log(
		//console.log(Arr.shortStart('dan', [ 'primary', 'secondary', 'success', 'danger', 'warning', 'info', 'light', 'dark', 'black' ], ',', 'dark'))

	//console.log(Arr.shortStart('dan', 
//	for (let num of Int.range(1, 5)) {
//		console.log(num);
//	}
//	console.log(Int.odd(2))
/*
		let arr = [1, 2, 3, 4, 5];
	arr = Arr.rotate(arr, 1);
	console.log(arr);
	arr = Arr.rotate(arr, 1);
	console.log(arr);
	arr = Arr.rotate(arr, 1);
	console.log(arr);
	arr = Arr.rotate(arr, 1);
	console.log(arr);
	arr = Arr.rotate(arr, 1);
	console.log(arr);
	const myContainer = new Container({
		'id': 'myContainer'
	});
	let valu = Arr.query(list, Arr.range('1>', '12', 2))
	console.log(valu.next())
	console.log(valu.next())
	console.log(valu.next())
	console.log(valu.next())
//	console.log('638>'.slice(0, -1))
//	
mylist = new List({
		'to': myContainer.children[4].children[2].element,
		'variant': 'danger',
		'size': 'sm',
		'true': [ 'group' ],
		'clsSet': 'm-5 p-5'
	});

	mylist.addButton({
		'text': 'hello',
		'variant': 'danger',
		'true': [ 'group' ]
	});
	mylist.addLink({
		'text': 'hello',
		'variant': 'prim',
		'true': [ 'group' ]
	});
	mylist.addItem({
		'text': 'hello',
		'size': 'sm',
		'variant': 'warn',
		'true': [ 'group' ]
	});


	//myNavbar.list.addButton({
	//	'text': 'hello',
	//	'variant': 'warning'
	//})
	//console.log(Arr.expandBoolean({
//		'hello': 'world',
//		'true': [ 'a', 'b', 'c', 'd' ]
//	}))
//	let tmpa = myContainer.alterChildren([1,4]);
//	console.log(tmpa.next())
//	console.log(tmpa.next())
//	console.log(tmpa.next())
			{
				'paths': {
					'static/js/js': [
						'arr.mjs',
						'components.mjs',
						'dom.mjs',
						'int.mjs',
						'layout.mjs',
						'obj.js',
						'str.mjs',
						'type.mjs'
					]
				},
				'script': {}
			},
			{
				'paths': {
					'static/js/js/components': [
						'lists.mjs',
						'navbars.mjs',
						'tables.mjs'
					]
				},
				'script': {}
			},
	//new Row({
	//	'container': 
	//});
/*
	new Row({
		'layout': myLayout,
	});
	new Row({
		'layout': myLayout,
	});
	new Row({
		'layout': myLayout,
	});

	const myCol1 = new Col({
		'row': myRow1,
		'textIn': 'hello world',
	});

	myLayout.alterRows({
		'clsAdd': 'bg-primary',
		'textIn': 'hello'
	})
//	Layout.methods()
//	myLayout.alterJustifies('start')
//	myLayout.alterAligns('start')

	/*
	Dom.apply({
		'tag': 'div',
		'id': 'myDiv',
		'to': Dom.body()
	});
	Dom.apply({
		'tag': 'div',
		'id': 'myInnerDiv',
		'to': Dom.byId('myDiv')
	});
	Dom.apply({
		'textIn': 'hello world',
		'css': {
			'background-color': 'white',
			'color': 'black'
		}
	}, Dom.byId('myDiv'));
	/*
	//console.log(Object.getOwnPropertyNames(HTMLElement.prototype));
	//Dom()
	//console.log(Object.getOwnPropertyNames(Object.getPrototypeOf(Dom)))
	//console.log(Obj.reflect(Document))
	//console.log(Obj.reflect(Dom))
	//console.log(Arr.difference(['a','b','c'],['a', 'd', 'c','e']))
     //   prototypeProperties: Object.getOwnPropertyNames(Object.getPrototypeOf(val))

//	Obj.methods(Document)
		//.prop(
	//console.log(Str.random('hello world this is the camel'));
	//console.log(Str.random(5, 'digit'))
	//console.log(Arr.explode('hello world'))
	//	.methods(Misc)
		//	console.log(Arr.shortest(['hii','by'])) //random('hello world this is the camel'));
	//	return parseFloat(val) === val;
//	console.log(Object.getOwnPropertyNames(Math))
//	console.log(Type.isFloat('3.12e+1'));
/*
	_let myDiv = new Layout({
		'id': 'baseDiv',
		'to': 'body'
	})

	myRow = new Row(myDiv, {})
	myRow1 = new Row(myDiv, {})

	myCol = new Col(myRow, {})
	console.log
	addTo(getObj(myCol.id), addTag({
		'tag': 'p',
		'txtAdd': 'hello world!',
	}));
*/
//	console.log(document.body.attributes)
//	console.log(DOMUtils.docMethods());
//	console.log(myDiv.getRow(1))
	//rowCss(2, {
//			'background-color': 'red'
//	})
//	myCol2 = new Col(myRow, {})
	/*
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

	addFormTemplateOne({
		'id': 'exampleForm',
		'to': 'contentContainerContact'
	});

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

	addFooter({
		'id': 'contentContainer',
		'cprgt': 'Jane Doe & John Doe'
	});

	document.getElementById('contentContainerHome').click();
	*/
});

