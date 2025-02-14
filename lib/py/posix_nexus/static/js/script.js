#!/usr/bin/env node
document.addEventListener('DOMContentLoaded', function()
{
	//console.log(Arr.shortStart('dan', [ 'primary', 'secondary', 'success', 'danger', 'warning', 'info', 'light', 'dark', 'black' ], ',', 'dark'))
	const myLayout = new Layout({
		'text': 'center',
	});

	var myRow1 = new Row({
		'layout': myLayout,
	});

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

