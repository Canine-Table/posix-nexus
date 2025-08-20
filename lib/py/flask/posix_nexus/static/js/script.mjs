import { Obj } from './js/obj.mjs';
import { Regx } from './js/reg.mjs';
import { Type } from './js/type.mjs';
import { Str } from './js/str.mjs';
import { nxStr } from './js/nex-str.mjs';
import { Arr } from './js/arr.mjs';
import { nxArr } from './js/nex-arr.mjs';
import { nxObj } from './js/nex-obj.mjs';
import { nexAnime } from './js/anime.mjs';
import { Int } from './js/int.mjs';
import { nexLog } from './js/log.mjs';
import { nexClass } from './js/class.mjs';
import { nexForm } from './js/components/nex-form.mjs';
import { nxDom } from './js/components/nex-dom.mjs';
import { nxFrag } from './js/nex-frag.mjs';
import { nexNav } from './js/components/nex-navbar.mjs';
import { nexCarousel } from './js/components/nex-carousel.mjs';
import { nexDrop } from './js/components/nex-dropdown.mjs';
import { nexCard } from './js/components/nex-cards.mjs';
import { nexSvg } from './js/components/nex-svg.mjs';
import { nexSvgText } from './js/components/nex-svg/nex-text.mjs';
import { nexSvgDefs } from './js/components/nex-svg/nex-defs.mjs';
import { nexEvent } from './js/event.mjs';
import { nexNode } from './js/components/nex-node.mjs';
import { nexAccordion } from './js/components/nex-accordion.mjs';
import { nexTable } from './js/components/nex-table.mjs';


document.addEventListener('DOMContentLoaded', () => {
	
	console.log(nxDom.Mime('hello.js'));
	return
	//console.log(nxStr.camelCase('hello world'));
	//console.log(nxFrag([ { 'data': { 'data-nx-live': false } } ]));
	//
	console.log(nxFrag([
		'hello world',
		{
			'tag': 'span',
			'css': {
				'backgroundColor': 'black',
				'fontSize': '11pt'
			},
			'pin': {
				'set': 'h5 modal jumbo',
				'swap': { 'modal': 'money', 'jumbo': 'tron' },
				'add': 'hello world this',
				'omit': 'hello'
			},
			'data': {
				'mykey': 'value',
				'another': 'also'
			},
		},
		{
			'tag': 'div',
			'stem': {
				1: {
					'css': {
						'backgroundColor': 'red',
						'color': 'blue'
					}
				},
				2: {
					'css': {
						'backgroundColor': 'blue',
						'color': 'yellow'
					}
				},
				3: {
					'css': {
						'backgroundColor': 'yellow',
						'color': 'red'
					}
				}
			},
			'leaf': {
				'tag': 'h4',
				'leaf': {
					'tag': 'h3',
					'stem': {
						-1: {
							'css': {
								'backgroundColor': 'green',
								'color': 'orange'
							}
						}
					}
					'leaf': {
							'tag': 'div'
						}
				}
			}
		},
		{
			'tag': 'p'
		},
		{
			'tag': 'h1',
			'leaf': {
				'tag': 'h4',
				'leaf': {
					'tag': 'h3',
					'leaf': [
						{
							'tag': 'div'
						},
						{
							'tag': 'div'
						},
						{
							'tag': 'div'
						}
					]
				}
			}
		},
		{
			'tag': 'section'
		}
	]));

	/*
	const mysym = nxDom.Frame({ 'meta': 'hello world', 'class': { 'add': 'hello world this is tom' }});
	console.log(nxDom.Symbol(mysym, 'class'))
	let a;
	console.log(nxDom.Instance(a))
	//	mysym.gate[mysym.key])
	*/

	//console.log(mysym[Object.getOwnPropertySymbols(mysym)[0]]);
	//console.log(mysym[Symbol.for('class')]);


	//for (const i of nxArr.getList([ 'keys', 'class', 'css', 'meta' ])) {
	//	console.log(i);
	//}


	//console.log(nxObj.isProp({
	//	'from': nxArr,
	//	'find': 'toLists'
	//}))
	

	let tmpa = undefined;
	let tmpb = undefined;
	let tmpc = undefined;
	const root = new nexNode({
		'tag': 'html',
		'doctype': 'h',
		'prop': {
			'lang': 'en-CA',
			'dir': 'ltr',
			'data-bs-theme': 'dark'
		},
		'head': {
			'child': [
				{
					'tag': 'title',
					'text': 'Evelyn Stroobach'
				},
				{
					'tag': 'meta',
					'prop': {
						'charset': 'UTF-8'
					}
				},
				{
					'tag': 'meta',
					'prop': {
						'name': 'viewpoint',
						'content': 'width=device-width, initial-scale=1.0'
					}
				},
				{
					'tag': 'meta',
					'prop': {
						'name': 'author',
						'content': 'Evelyn Stroobach'
					}
				},
				{
					'tag': 'meta',
					'prop': {
						'name': 'description',
						'content': 'Evelyn Stroobach - Composer'

					}
				},
				{
					'tag': 'meta',
					'prop': {
						'name': 'keywords',
						'content': 'music, composer, clasical music, classical art music, Jewish music, Canadian composer, female composer, 21st century composer, 21st century female composer, modern music, PhD in music composition'
					}
				},
				{
					'tag': 'meta',
					'prop': {
						'name': 'googlebot',
						'content': 'index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1'
					}
				},
				{
					'tag': 'meta',
					'prop': {
						'name': 'robots',
						'content': 'index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1'
					}
				},
				{
					'tag': 'meta',
					'prop': {
						'name': 'author',
						'content': 'Canine-Table'
					}
				},
				{
					'tag': 'meta',
					'prop': {
						'http-equiv': 'X-UA-Compatible',
						'content': 'IE=edge'
					}
				},
				{
					'tag': 'meta',
					'prop': {
						'property': 'og:locale',
						'content': 'en_US',
					}
				},
				{
					'tag': 'meta',
					'prop': {
						'property': 'og:type',
						'content': 'article'
					}
				},
				{
					'tag': 'meta',
					'prop': {
						'property': 'og:title',
						'content': 'Evelyn Stroobach'
					}
				},
				{
					'tag': 'meta',
					'prop': {
						'property': 'og:description',
						'content': 'Evelyn Stroobach - Composer'
					}
				},
				{
					'tag': 'meta',
					'prop': {
						'property': 'og:url',
						'content': 'https://posix-nexus.onrender.com/'
					}
				},
				{
					'tag': 'meta',
					'prop': {
						'property': 'og:site_name',
						'content': 'Evelyn Stroobach'
					}
				},
				{
					'tag': 'style',
					'text': `
						.nex-scroll-container {
							overflow-y: scroll;
							overflow-x: hidden;
							-ms-overflow-style: none;
							scrollbar-width: none;
						}
						.nex-scroll-container::-webkit-scrollbar {
							display: none;
						}
						.nex-nav-item {
							cursor: pointer;
							z-index: 0;
							background-color: var(--bs-primary-border-subtle);
							color: var(--bs-primary-text-emphasis) !important;
						}
						.nex-nav-item .active {
							background-color: var(--bs-primary);
							color: var(--bs-body-color) !important;
						}
						.nex-nav-link:active {
							background-color: var(--bs-body-color);
							color: var(--bs-body-bg) !important;
						}
						.nex-nav-item:hover {
							background-color: var(--bs-info-border-subtle);
							color: var(--bs-info-text-emphasis) !important;
						}
						.nex-brand {
							background-color: var(--bs-primary-border-subtle);
							border-radius: 100%;
						}
						.nex-brand-img {
							object-fit: contain;
						}
						.nex-brand:hover {
							background-color: var(--bs-info-border-subtle);
							filter: contrast(150%);
						}
						.nav-brand:active {
							background-color: var(--bs-body-color);
						}
						.nex-nav-content {
							background: repeating-radial-gradient(var(--bs-tertiary-bg), var(--bs-secondary-bg), var(--bs-body-bg) 50px);
						}
					`
				}
			]
		},
		'body': {
			'cls': {
				'add': 'd-flex flex-column w-100'
			},
			'css': {
				'min-height': '100lvh'
			}
		}
	}).nodes.head[0].meta([
			{
				'paths': {
					'static': [
						'img/music-circle.png'
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
					'https://cdn.jsdelivr.net/npm': [
						'bootstrap@5.3.3/dist/css/bootstrap.min.css',
						'@xz/fonts@1/serve/inter.css'
					]
				},
				'link': {
					'bootstrap@5.3.3/dist/css/bootstrap.min.css' : {
						'integrity': 'sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH',
						'crossorigin': 'anonymous'
					},
					'@xz/fonts@1/serve/inter.css': {
						'integrity': 'sha384-tmaXBGDXDylqHmGdj38lMQk2xeYhgDuaYTcFdBofHNPMW1C+rCYIy85wiTmfMQ4J',
						'crossorigin': 'anonymous'
					}
				}
			}
		]
	).back().nodes.body[0].meta([
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
			}
		}
	]).frag([
		{
			'tag': 'header',
			'cls': {
				'add': 'nex-blurb w-100 h-25 flex-shrink-0 d-flex postition-relative align-self-top'
			},
			'child': [
				{
					'tag': 'img',
					'cls': {
						'add': 'nex-img border-bottom object-fit-cover img-fluid w-100 h-25 position-absolute opacity-25'
					},
					'prop': {
						'src': 'static/img/posix-nexus-image-9.jpeg',
						'alt': '...'
					}
				},
				{
					'tag': 'div',
					'cls': {
						'add': 'nex-scroll-container d-flex flex-column text-center justify-content-sm-center align-items-center w-100 h-100 position-relative'
					},
					'child': [
						{
							'tag': 'h3',
							'cls': {
								'add':  'pt-2 px-2'
							},
							'text': 'Posix-Nexus',
						},
						{
							'tag': 'p',
							'cls': {
								'add':  'px-2'
							},
							'text': 'Performance and Portability Redefined',
						}
					]
				}
			]
		},
		{
			'tag': 'hgroup',
			'cls': {
				'add': 'w-100 flex-grow-1 d-flex flex-column postition-relative '
			}
		},
		{
			'tag': 'footer',
			'text': `© ${new Date().getFullYear()} Evelyn Stroobach, all rights reserved`,
			'cls': {
				'add': 'nex-footer border-top text-body-secondary text-center py-3 bg-body-tertiary w-100 postition-relative '
			},
		}
	]);

	const svgBox = new nexSvgDefs({
		'to': root,
		'attach': {
			'place': 'first'
		},
		'size': {
			'h': '0',
			'w': '0',
		},
		'css': {
			'position': 'absolute',
			'visibility': 'hidden'
		}
	}).defs([
		{
			'svg': 'symbol',
			'id': 'card-checklist',
			'child': [
				{
					'svg': 'path',
					'd': 'M14.5 3a.5.5 0 0 1 .5.5v9a.5.5 0 0 1-.5.5h-13a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5zm-13-1A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h13a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2z'
				},
				{
					'svg': 'path',
					'd': 'M7 5.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5m-1.496-.854a.5.5 0 0 1 0 .708l-1.5 1.5a.5.5 0 0 1-.708 0l-.5-.5a.5.5 0 1 1 .708-.708l.146.147 1.146-1.147a.5.5 0 0 1 .708 0M7 9.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5m-1.496-.854a.5.5 0 0 1 0 .708l-1.5 1.5a.5.5 0 0 1-.708 0l-.5-.5a.5.5 0 0 1 .708-.708l.146.147 1.146-1.147a.5.5 0 0 1 .708 0'
				}
			]
		},
		{
			'svg': 'symbol',
			'id': 'code',
			'child': { 
					'svg': 'path',
					'd': 'M5.854 4.854a.5.5 0 1 0-.708-.708l-3.5 3.5a.5.5 0 0 0 0 .708l3.5 3.5a.5.5 0 0 0 .708-.708L2.707 8l3.147-3.146zm4.292 0a.5.5 0 0 1 .708-.708l3.5 3.5a.5.5 0 0 1 0 .708l-3.5 3.5a.5.5 0 0 1-.708-.708L13.293 8l-3.147-3.146z'
			}
		},
		{
			'svg': 'symbol',
			'id': 'menu',
			'child': {
				'svg': 'path',
				'd': 'M1.5 0A1.5 1.5 0 0 0 0 1.5v2A1.5 1.5 0 0 0 1.5 5h13A1.5 1.5 0 0 0 16 3.5v-2A1.5 1.5 0 0 0 14.5 0h-13zm1 2h3a.5.5 0 0 1 0 1h-3a.5.5 0 0 1 0-1zm9.927.427A.25.25 0 0 1 12.604 2h.792a.25.25 0 0 1 .177.427l-.396.396a.25.25 0 0 1-.354 0l-.396-.396zM0 8a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V8zm1 3v2a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2H1zm14-1V8a1 1 0 0 0-1-1H2a1 1 0 0 0-1 1v2h14zM2 8.5a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 0 1h-9a.5.5 0 0 1-.5-.5zm0 4a.5.5 0 0 1 .5-.5h6a.5.5 0 0 1 0 1h-6a.5.5 0 0 1-.5-.5z'
			}
		},
		{
			'svg': 'symbol',
			'id': 'tools',
			'child': {
				'svg': 'path',
				'd': 'M1 0 0 1l2.2 3.081a1 1 0 0 0 .815.419h.07a1 1 0 0 1 .708.293l2.675 2.675-2.617 2.654A3.003 3.003 0 0 0 0 13a3 3 0 1 0 5.878-.851l2.654-2.617.968.968-.305.914a1 1 0 0 0 .242 1.023l3.356 3.356a1 1 0 0 0 1.414 0l1.586-1.586a1 1 0 0 0 0-1.414l-3.356-3.356a1 1 0 0 0-1.023-.242L10.5 9.5l-.96-.96 2.68-2.643A3.005 3.005 0 0 0 16 3c0-.269-.035-.53-.102-.777l-2.14 2.141L12 4l-.364-1.757L13.777.102a3 3 0 0 0-3.675 3.68L7.462 6.46 4.793 3.793a1 1 0 0 1-.293-.707v-.071a1 1 0 0 0-.419-.814L1 0zm9.646 10.646a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708l-3-3a.5.5 0 0 1 0-.708zM3 11l.471.242.529.026.287.445.445.287.026.529L5 13l-.242.471-.026.529-.445.287-.287.445-.529.026L3 15l-.471-.242L2 14.732l-.287-.445L1.268 14l-.026-.529L1 13l.242-.471.026-.529.445-.287.287-.445.529-.026L3 11z'
			}
		},
		{
			'svg': 'symbol',
			'id': 'lightning-bolt',
			'child': {
				'svg': 'path',
				'd': 'M11.251.068a.5.5 0 0 1 .227.58L9.677 6.5H13a.5.5 0 0 1 .364.843l-8 8.5a.5.5 0 0 1-.842-.49L6.323 9.5H3a.5.5 0 0 1-.364-.843l8-8.5a.5.5 0 0 1 .615-.09z'
			}
		},
		{
			'svg': 'symbol',
			'id': 'magic-wand',
			'child': {
				'svg': 'path',
				'd': 'M9.5 2.672a.5.5 0 1 0 1 0V.843a.5.5 0 0 0-1 0v1.829Zm4.5.035A.5.5 0 0 0 13.293 2L12 3.293a.5.5 0 1 0 .707.707L14 2.707ZM7.293 4A.5.5 0 1 0 8 3.293L6.707 2A.5.5 0 0 0 6 2.707L7.293 4Zm-.621 2.5a.5.5 0 1 0 0-1H4.843a.5.5 0 1 0 0 1h1.829Zm8.485 0a.5.5 0 1 0 0-1h-1.829a.5.5 0 0 0 0 1h1.829ZM13.293 10A.5.5 0 1 0 14 9.293L12.707 8a.5.5 0 1 0-.707.707L13.293 10ZM9.5 11.157a.5.5 0 0 0 1 0V9.328a.5.5 0 0 0-1 0v1.829Zm1.854-5.097a.5.5 0 0 0 0-.706l-.708-.708a.5.5 0 0 0-.707 0L8.646 5.94a.5.5 0 0 0 0 .707l.708.708a.5.5 0 0 0 .707 0l1.293-1.293Zm-3 3a.5.5 0 0 0 0-.706l-.708-.708a.5.5 0 0 0-.707 0L.646 13.94a.5.5 0 0 0 0 .707l.708.708a.5.5 0 0 0 .707 0L8.354 9.06Z'
			}
		},
		{
			'svg': 'symbol',
			'id': 'auto-mode',
			'child': {
				'svg': 'path',
				'd': 'M8 15A7 7 0 1 0 8 1v14zm0 1A8 8 0 1 1 8 0a8 8 0 0 1 0 16z'
			}
		},
		{
			'svg': 'symbol',
			'id': 'dark-mode',
			'child': [
				{
					'svg': 'path',
					'd': 'M6 .278a.768.768 0 0 1 .08.858 7.208 7.208 0 0 0-.878 3.46c0 4.021 3.278 7.277 7.318 7.277.527 0 1.04-.055 1.533-.16a.787.787 0 0 1 .81.316.733.733 0 0 1-.031.893A8.349 8.349 0 0 1 8.344 16C3.734 16 0 12.286 0 7.71 0 4.266 2.114 1.312 5.124.06A.752.752 0 0 1 6 .278z'
				},
				{
					'svg': 'path',
					'd': 'M10.794 3.148a.217.217 0 0 1 .412 0l.387 1.162c.173.518.579.924 1.097 1.097l1.162.387a.217.217 0 0 1 0 .412l-1.162.387a1.734 1.734 0 0 0-1.097 1.097l-.387 1.162a.217.217 0 0 1-.412 0l-.387-1.162A1.734 1.734 0 0 0 9.31 6.593l-1.162-.387a.217.217 0 0 1 0-.412l1.162-.387a1.734 1.734 0 0 0 1.097-1.097l.387-1.162zM13.863.099a.145.145 0 0 1 .274 0l.258.774c.115.346.386.617.732.732l.774.258a.145.145 0 0 1 0 .274l-.774.258a1.156 1.156 0 0 0-.732.732l-.258.774a.145.145 0 0 1-.274 0l-.258-.774a1.156 1.156 0 0 0-.732-.732l-.774-.258a.145.145 0 0 1 0-.274l.774-.258c.346-.115.617-.386.732-.732L13.863.1z'
				}
			]
		},
		{
			'svg': 'symbol',
			'id': 'light-mode',
			'child': {
				'svg': 'path',
				'd': 'M8 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM8 0a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 0zm0 13a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 13zm8-5a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1h2a.5.5 0 0 1 .5.5zM3 8a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1h2A.5.5 0 0 1 3 8zm10.657-5.657a.5.5 0 0 1 0 .707l-1.414 1.415a.5.5 0 1 1-.707-.708l1.414-1.414a.5.5 0 0 1 .707 0zm-9.193 9.193a.5.5 0 0 1 0 .707L3.05 13.657a.5.5 0 0 1-.707-.707l1.414-1.414a.5.5 0 0 1 .707 0zm9.193 2.121a.5.5 0 0 1-.707 0l-1.414-1.414a.5.5 0 0 1 .707-.707l1.414 1.414a.5.5 0 0 1 0 .707zM4.464 4.465a.5.5 0 0 1-.707 0L2.343 3.05a.5.5 0 1 1 .707-.707l1.414 1.414a.5.5 0 0 1 0 .708z'
			}
		},
		{
			'svg': 'symbol',
			'id': 'book',
			'child': {
				'svg': 'path',
				'd': 'M1 2.828c.885-.37 2.154-.769 3.388-.893 1.33-.134 2.458.063 3.112.752v9.746c-.935-.53-2.12-.603-3.213-.493-1.18.12-2.37.461-3.287.811zm7.5-.141c.654-.689 1.782-.886 3.112-.752 1.234.124 2.503.523 3.388.893v9.923c-.918-.35-2.107-.692-3.287-.81-1.094-.111-2.278-.039-3.213.492zM8 1.783C7.015.936 5.587.81 4.287.94c-1.514.153-3.042.672-3.994 1.105A.5.5 0 0 0 0 2.5v11a.5.5 0 0 0 .707.455c.882-.4 2.303-.881 3.68-1.02 1.409-.142 2.59.087 3.223.877a.5.5 0 0 0 .78 0c.633-.79 1.814-1.019 3.222-.877 1.378.139 2.8.62 3.681 1.02A.5.5 0 0 0 16 13.5v-11a.5.5 0 0 0-.293-.455c-.952-.433-2.48-.952-3.994-1.105C10.413.809 8.985.936 8 1.783'
			}
		},
		{
			'svg': 'symbol',
			'id': 'mail',
			'child': {
				'svg': 'path',
				'd': 'M8.47 1.318a1 1 0 0 0-.94 0l-6 3.2A1 1 0 0 0 1 5.4v.817l5.75 3.45L8 8.917l1.25.75L15 6.217V5.4a1 1 0 0 0-.53-.882zM15 7.383l-4.778 2.867L15 13.117zm-.035 6.88L8 10.082l-6.965 4.18A1 1 0 0 0 2 15h12a1 1 0 0 0 .965-.738ZM1 13.116l4.778-2.867L1 7.383v5.734ZM7.059.435a2 2 0 0 1 1.882 0l6 3.2A2 2 0 0 1 16 5.4V14a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V5.4a2 2 0 0 1 1.059-1.765z'
			}
		},
		{
			'svg': 'symbol',
			'id': 'pen',
			'child': [
				{
					'svg': 'path',
					'path': { 'r': 'e' },
					'd': 'M2.832 13.228 8 9a1 1 0 1 0-1-1l-4.228 5.168-.026.086z'
				},
				{
					'svg': 'path',
					'path': { 'r': 'e' },
					'd': 'M10.646.646a.5.5 0 0 1 .708 0l4 4a.5.5 0 0 1 0 .708l-1.902 1.902-.829 3.313a1.5 1.5 0 0 1-1.024 1.073L1.254 14.746 4.358 4.4A1.5 1.5 0 0 1 5.43 3.377l3.313-.828zm-1.8 2.908-3.173.793a.5.5 0 0 0-.358.342l-2.57 8.565 8.567-2.57a.5.5 0 0 0 .34-.357l.794-3.174-3.6-3.6z'
				}
			]
		},
		{
			'svg': 'symbol',
			'id': 'star',
			'child': {
				'svg': 'path',
				'd': 'M2.866 14.85c-.078.444.36.791.746.593l4.39-2.256 4.389 2.256c.386.198.824-.149.746-.592l-.83-4.73 3.522-3.356c.33-.314.16-.888-.282-.95l-4.898-.696L8.465.792a.513.513 0 0 0-.927 0L5.354 5.12l-4.898.696c-.441.062-.612.636-.283.95l3.523 3.356-.83 4.73zm4.905-2.767-3.686 1.894.694-3.957a.56.56 0 0 0-.163-.505L1.71 6.745l4.052-.576a.53.53 0 0 0 .393-.288L8 2.223l1.847 3.658a.53.53 0 0 0 .393.288l4.052.575-2.906 2.77a.56.56 0 0 0-.163.506l.694 3.957-3.686-1.894a.5.5 0 0 0-.461 0z'
			}
		},
		{
			'svg': 'symbol',
			'id': 'file',
			'child': [
				{
					'svg': 'path',
					'd': 'M14 4.5V14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h5.5L14 4.5zm-3 0A1.5 1.5 0 0 1 9.5 3V1H4a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V4.5h-2z'
				},
				{
					'svg': 'path',
					'd': 'M4.5 12.5A.5.5 0 0 1 5 12h3a.5.5 0 0 1 0 1H5a.5.5 0 0 1-.5-.5zm0-2A.5.5 0 0 1 5 10h6a.5.5 0 0 1 0 1H5a.5.5 0 0 1-.5-.5zm1.639-3.708 1.33.886 1.854-1.855a.25.25 0 0 1 .289-.047l1.888.974V8.5a.5.5 0 0 1-.5.5H5a.5.5 0 0 1-.5-.5V8s1.54-1.274 1.639-1.208zM6.25 6a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5z'
				}
			]
		},
		{
			'svg': 'symbol',
			'id': 'plus',
			'child': {
				'svg': 'path',
				'd': 'M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z'
			}
		},
		{
			'svg': 'symbol',
			'id': 'palette',
			'child': {
				'svg': 'path',
				'd': 'M0 .5A.5.5 0 0 1 .5 0h5a.5.5 0 0 1 .5.5v5.277l4.147-4.131a.5.5 0 0 1 .707 0l3.535 3.536a.5.5 0 0 1 0 .708L10.261 10H15.5a.5.5 0 0 1 .5.5v5a.5.5 0 0 1-.5.5H3a2.99 2.99 0 0 1-2.121-.879A2.99 2.99 0 0 1 0 13.044m6-.21 7.328-7.3-2.829-2.828L6 7.188v5.647zM4.5 13a1.5 1.5 0 1 0-3 0 1.5 1.5 0 0 0 3 0zM15 15v-4H9.258l-4.015 4H15zM0 .5v12.495V.5z'
			}
		},
		{
			'svg': 'symbol',
			'id': 'three-dots',
			'child': {
				'svg': 'path',
				'd': 'M3 9.5a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3zm5 0a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3zm5 0a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3z'
			}
		},
		{
			'svg': 'symbol',
			'id': 'radio',
			'child': {
				'svg': 'path',
				'd': 'M7 2.5a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-7a.5.5 0 0 1-.5-.5v-1zM0 12a3 3 0 1 1 6 0 3 3 0 0 1-6 0zm7-1.5a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-7a.5.5 0 0 1-.5-.5v-1zm0-5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5zm0 8a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5zM3 1a3 3 0 1 0 0 6 3 3 0 0 0 0-6zm0 4.5a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3z'
			}
		},
		{
			'svg': 'symbol',
			'id': 'globe',
			'child': {
				'svg': 'path',
				'd': 'M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm7.5-6.923c-.67.204-1.335.82-1.887 1.855-.143.268-.276.56-.395.872.705.157 1.472.257 2.282.287V1.077zM4.249 3.539c.142-.384.304-.744.481-1.078a6.7 6.7 0 0 1 .597-.933A7.01 7.01 0 0 0 3.051 3.05c.362.184.763.349 1.198.49zM3.509 7.5c.036-1.07.188-2.087.436-3.008a9.124 9.124 0 0 1-1.565-.667A6.964 6.964 0 0 0 1.018 7.5h2.49zm1.4-2.741a12.344 12.344 0 0 0-.4 2.741H7.5V5.091c-.91-.03-1.783-.145-2.591-.332zM8.5 5.09V7.5h2.99a12.342 12.342 0 0 0-.399-2.741c-.808.187-1.681.301-2.591.332zM4.51 8.5c.035.987.176 1.914.399 2.741A13.612 13.612 0 0 1 7.5 10.91V8.5H4.51zm3.99 0v2.409c.91.03 1.783.145 2.591.332.223-.827.364-1.754.4-2.741H8.5zm-3.282 3.696c.12.312.252.604.395.872.552 1.035 1.218 1.65 1.887 1.855V11.91c-.81.03-1.577.13-2.282.287zm.11 2.276a6.696 6.696 0 0 1-.598-.933 8.853 8.853 0 0 1-.481-1.079 8.38 8.38 0 0 0-1.198.49 7.01 7.01 0 0 0 2.276 1.522zm-1.383-2.964A13.36 13.36 0 0 1 3.508 8.5h-2.49a6.963 6.963 0 0 0 1.362 3.675c.47-.258.995-.482 1.565-.667zm6.728 2.964a7.009 7.009 0 0 0 2.275-1.521 8.376 8.376 0 0 0-1.197-.49 8.853 8.853 0 0 1-.481 1.078 6.688 6.688 0 0 1-.597.933zM8.5 11.909v3.014c.67-.204 1.335-.82 1.887-1.855.143-.268.276-.56.395-.872A12.63 12.63 0 0 0 8.5 11.91zm3.555-.401c.57.185 1.095.409 1.565.667A6.963 6.963 0 0 0 14.982 8.5h-2.49a13.36 13.36 0 0 1-.437 3.008zM14.982 7.5a6.963 6.963 0 0 0-1.362-3.675c-.47.258-.995.482-1.565.667.248.92.4 1.938.437 3.008h2.49zM11.27 2.461c.177.334.339.694.482 1.078a8.368 8.368 0 0 0 1.196-.49 7.01 7.01 0 0 0-2.275-1.52c.218.283.418.597.597.932zm-.488 1.343a7.765 7.765 0 0 0-.395-.872C9.835 1.897 9.17 1.282 8.5 1.077V4.09c.81-.03 1.577-.13 2.282-.287z'
			}
		},
		{
			'svg': 'symbol',
			'id': 'check',
			'child': {
				'svg': 'path',
				'd': 'M13.854 3.646a.5.5 0 0 1 0 .708l-7 7a.5.5 0 0 1-.708 0l-3.5-3.5a.5.5 0 1 1 .708-.708L6.5 10.293l6.646-6.647a.5.5 0 0 1 .708 0z'
			}
		},
		{
			'svg': 'symbol',
			'id': 'braces',
			'child': {
				'svg': 'path',
				'd': 'M2.114 8.063V7.9c1.005-.102 1.497-.615 1.497-1.6V4.503c0-1.094.39-1.538 1.354-1.538h.273V2h-.376C3.25 2 2.49 2.759 2.49 4.352v1.524c0 1.094-.376 1.456-1.49 1.456v1.299c1.114 0 1.49.362 1.49 1.456v1.524c0 1.593.759 2.352 2.372 2.352h.376v-.964h-.273c-.964 0-1.354-.444-1.354-1.538V9.663c0-.984-.492-1.497-1.497-1.6zM13.886 7.9v.163c-1.005.103-1.497.616-1.497 1.6v1.798c0 1.094-.39 1.538-1.354 1.538h-.273v.964h.376c1.613 0 2.372-.759 2.372-2.352v-1.524c0-1.094.376-1.456 1.49-1.456V7.332c-1.114 0-1.49-.362-1.49-1.456V4.352C13.51 2.759 12.75 2 11.138 2h-.376v.964h.273c.964 0 1.354.444 1.354 1.538V6.3c0 .984.492 1.497 1.497 1.6z'
			}
		},
		{
			'svg': 'symbol',
			'id': 'book-half',
			'child': {
				'svg': 'path',
				'd': 'M8.5 2.687c.654-.689 1.782-.886 3.112-.752 1.234.124 2.503.523 3.388.893v9.923c-.918-.35-2.107-.692-3.287-.81-1.094-.111-2.278-.039-3.213.492V2.687zM8 1.783C7.015.936 5.587.81 4.287.94c-1.514.153-3.042.672-3.994 1.105A.5.5 0 0 0 0 2.5v11a.5.5 0 0 0 .707.455c.882-.4 2.303-.881 3.68-1.02 1.409-.142 2.59.087 3.223.877a.5.5 0 0 0 .78 0c.633-.79 1.814-1.019 3.222-.877 1.378.139 2.8.62 3.681 1.02A.5.5 0 0 0 16 13.5v-11a.5.5 0 0 0-.293-.455c-.952-.433-2.48-.952-3.994-1.105C10.413.809 8.985.936 8 1.783z'
			}
		},
		{
			'svg': 'symbol',
			'id': 'clipboard',
			'child': [
				{
					'svg': 'path',
					'd': 'M4 1.5H3a2 2 0 0 0-2 2V14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V3.5a2 2 0 0 0-2-2h-1v1h1a1 1 0 0 1 1 1V14a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V3.5a1 1 0 0 1 1-1h1v-1z'
				},
				{
					'svg': 'path',
					'd': 'M9.5 1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5h3zm-3-1A1.5 1.5 0 0 0 5 1.5v1A1.5 1.5 0 0 0 6.5 4h3A1.5 1.5 0 0 0 11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3z'
				}
			]
		},
		{
			'svg': 'symbol',
			'id': 'docs',
			'child': [
				{
					'svg': 'path',
					'd': 'M5 4a.5.5 0 0 0 0 1h6a.5.5 0 0 0 0-1zm-.5 2.5A.5.5 0 0 1 5 6h6a.5.5 0 0 1 0 1H5a.5.5 0 0 1-.5-.5M5 8a.5.5 0 0 0 0 1h6a.5.5 0 0 0 0-1zm0 2a.5.5 0 0 0 0 1h3a.5.5 0 0 0 0-1z'
				},
				{
					'svg': 'path',
					'd': 'M2 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2zm10-1H4a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1'
				}
			]
		},
		{
			'svg': 'symbol',
			'id': 'file-person',
			'child': [
				{
					'svg': 'path',
					'd': 'M11 8a3 3 0 1 1-6 0 3 3 0 0 1 6 0'
				},
				{
					'svg': 'path',
					'd': 'M14 14V4.5L9.5 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2M9.5 3A1.5 1.5 0 0 0 11 4.5h2v9.255S12 12 8 12s-5 1.755-5 1.755V2a1 1 0 0 1 1-1h5.5z'
				}
			]
		},
		{
			'svg': 'symbol',
			'id': 'house',
			'child': {
				'svg': 'path',
				'd': 'M8.707 1.5a1 1 0 0 0-1.414 0L.646 8.146a.5.5 0 0 0 .708.708L2 8.207V13.5A1.5 1.5 0 0 0 3.5 15h9a1.5 1.5 0 0 0 1.5-1.5V8.207l.646.647a.5.5 0 0 0 .708-.708L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293zM13 7.207V13.5a.5.5 0 0 1-.5.5h-9a.5.5 0 0 1-.5-.5V7.207l5-5z'
			}
		},
		{
			'svg': 'symbol',
			'id': 'person',
			'child': [
				{
					'svg': 'path',
					'd': 'M12 1a1 1 0 0 1 1 1v10.755S12 11 8 11s-5 1.755-5 1.755V2a1 1 0 0 1 1-1zM4 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2z'
				
				},
				{
					'svg': 'path',
					'd': 'M8 10a3 3 0 1 0 0-6 3 3 0 0 0 0 6'
				}
			]
		},
		{
			'svg': 'symbol',
			'id': 'house-fill',
			'child': [
				{
					'svg': 'path',
					'd': 'M8.707 1.5a1 1 0 0 0-1.414 0L.646 8.146a.5.5 0 0 0 .708.708L8 2.207l6.646 6.647a.5.5 0 0 0 .708-.708L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293z'
				},
				{
					'svg': 'path',
					'd': 'm8 3.293 6 6V13.5a1.5 1.5 0 0 1-1.5 1.5h-9A1.5 1.5 0 0 1 2 13.5V9.293z'
				}
			]
		},
		{
			'svg': 'symbol',
			'id': 'text-body',
			'child': {
				'svg': 'path',
				'path': { 'r': 'e' },
				'd': 'M0 .5A.5.5 0 0 1 .5 0h4a.5.5 0 0 1 0 1h-4A.5.5 0 0 1 0 .5m0 2A.5.5 0 0 1 .5 2h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5m9 0a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5m-9 2A.5.5 0 0 1 .5 4h3a.5.5 0 0 1 0 1h-3a.5.5 0 0 1-.5-.5m5 0a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5m7 0a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 0 1h-3a.5.5 0 0 1-.5-.5m-12 2A.5.5 0 0 1 .5 6h6a.5.5 0 0 1 0 1h-6a.5.5 0 0 1-.5-.5m8 0a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5m-8 2A.5.5 0 0 1 .5 8h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5m7 0a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5m-7 2a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 0 1h-8a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h4a.5.5 0 0 1 0 1h-4a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1h-2a.5.5 0 0 1-.5-.5'
			}
		},
		{
			'svg': 'symbol',
			'id': 'disc-draw',
				'child': [
					{
						'svg': 'path',
						'd': 'M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16'
					},
					{
						'svg': 'path',
						'd': 'M10 8a2 2 0 1 1-4 0 2 2 0 0 1 4 0M8 4a4 4 0 0 0-4 4 .5.5 0 0 1-1 0 5 5 0 0 1 5-5 .5.5 0 0 1 0 1m4.5 3.5a.5.5 0 0 1 .5.5 5 5 0 0 1-5 5 .5.5 0 0 1 0-1 4 4 0 0 0 4-4 .5.5 0 0 1 .5-.5'
					}
				]
		},
		{
			'svg': 'symbol',
			'id': 'concert-mic',
			'child': [
				{
					'svg': 'path',
					'd': 'M6 13c0 1.105-1.12 2-2.5 2S1 14.105 1 13s1.12-2 2.5-2 2.5.896 2.5 2m9-2c0 1.105-1.12 2-2.5 2s-2.5-.895-2.5-2 1.12-2 2.5-2 2.5.895 2.5 2'
				},
				{
					'svg': 'path',
					'path': { 'r': 'e' },
					'd': 'M14 11V2h1v9zM6 3v10H5V3z'
				},
				{
					'svg': 'path',
					'd': 'M5 2.905a1 1 0 0 1 .9-.995l8-.8a1 1 0 0 1 1.1.995V3L5 4z'
				}
			]
		},
		{
			'svg': 'symbol',
			'id': 'radio-tv',
			'child': [
				{
					'svg': 'path',
					'd': 'M5 3a3 3 0 0 1 6 0v5a3 3 0 0 1-6 0z'
				},
				{
					'svg': 'path',
					'd': 'M3.5 6.5A.5.5 0 0 1 4 7v1a4 4 0 0 0 8 0V7a.5.5 0 0 1 1 0v1a5 5 0 0 1-4.5 4.975V15h3a.5.5 0 0 1 0 1h-7a.5.5 0 0 1 0-1h3v-2.025A5 5 0 0 1 3 8V7a.5.5 0 0 1 .5-.5'
				}
			]
		},
		{
			'svg': 'symbol',
			'id': 'publication',
			'child': {
				'svg': 'path',
				'd': 'M1 2.828c.885-.37 2.154-.769 3.388-.893 1.33-.134 2.458.063 3.112.752v9.746c-.935-.53-2.12-.603-3.213-.493-1.18.12-2.37.461-3.287.811zm7.5-.141c.654-.689 1.782-.886 3.112-.752 1.234.124 2.503.523 3.388.893v9.923c-.918-.35-2.107-.692-3.287-.81-1.094-.111-2.278-.039-3.213.492zM8 1.783C7.015.936 5.587.81 4.287.94c-1.514.153-3.042.672-3.994 1.105A.5.5 0 0 0 0 2.5v11a.5.5 0 0 0 .707.455c.882-.4 2.303-.881 3.68-1.02 1.409-.142 2.59.087 3.223.877a.5.5 0 0 0 .78 0c.633-.79 1.814-1.019 3.222-.877 1.378.139 2.8.62 3.681 1.02A.5.5 0 0 0 16 13.5v-11a.5.5 0 0 0-.293-.455c-.952-.433-2.48-.952-3.994-1.105C10.413.809 8.985.936 8 1.783'
			}
		},
		{
			'svg': 'symbol',
			'id': 'membership',
			'child': {
				'svg': 'path',
				'd': 'M7 14s-1 0-1-1 1-4 5-4 5 3 5 4-1 1-1 1zm4-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6m-5.784 6A2.24 2.24 0 0 1 5 13c0-1.355.68-2.75 1.936-3.72A6.3 6.3 0 0 0 5 9c-4 0-5 3-5 4s1 1 1 1zM4.5 8a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5'
			}
		},
		{
			'svg': 'symbol',
			'id': 'compositions',
			'child': [
				{
					'svg': 'path',
					'd': 'M12 13c0 1.105-1.12 2-2.5 2S7 14.105 7 13s1.12-2 2.5-2 2.5.895 2.5 2'
				},
				{
					'svg': 'path',
					'path': { 'r': 'e' },
					'd': 'M12 3v10h-1V3z'
				},
				{
					'svg': 'path',
					'd': 'M11 2.82a1 1 0 0 1 .804-.98l3-.6A1 1 0 0 1 16 2.22V4l-5 1z'
				},
				{
					'svg': 'path',
					'path': { 'r': 'e' },
					'd': 'M0 11.5a.5.5 0 0 1 .5-.5H4a.5.5 0 0 1 0 1H.5a.5.5 0 0 1-.5-.5m0-4A.5.5 0 0 1 .5 7H8a.5.5 0 0 1 0 1H.5a.5.5 0 0 1-.5-.5m0-4A.5.5 0 0 1 .5 3H8a.5.5 0 0 1 0 1H.5a.5.5 0 0 1-.5-.5'
				}
			]
		}
	]);

	const myNav = new nexNav({
		'to': root.nodes.hgroup[0],
		'toggle': 'offcanvas',
		'navmain': true,
		'close': true,
		'cls': {
			'add': 'navbar-expand-lg sticky-top bg-body-tertiary'
		},
		'navbar': {
			'backdrop': true,
			'scroll': false,
			'cls': {
				'add': 'offcanvas-end'
			},
			'navhead': {
				'cls': {
					'add': 'border-bottom'
				},
				'title': {
					'tag': 'h3',
					'text': 'Evelyn Stroobach'
				}
			},
			'navbody': {
			},
			'navlist': {
				'cls': {
					'add': 'justify-content-center nav align-items-center nav-fill w-100'
				}
			}
		},
		'brand': {
			'prop': {
				'href': '#home'
			},
			'child': {
				'tag': 'img',
				'cls': {
					'add': 'nex-brand-img'
				},
				'prop': {
					'alt': '...',
					'src': 'static/img/music-circle.png',
					'height': '41px',
					'width': '41px'
				}
			}
		},
	}).link({
		'cls': {
			'add': 'd-flex d-lg-none'
		},
		'svg': '#house-fill',
		'link': {
			'text': 'Home',
		}
	}).link({
		'svg': '#docs',
		'link': {
			'text': 'Biography',
		}
	}).link({
		'svg': '#disc-draw',
		'link': {
			'text': 'CDs',
		}
	}).link({
		'svg': '#concert-mic',
		'link': {
			'text': 'Concerts',
		}
	}).link({
		'svg': '#radio-tv',
		'link': {
			'text': 'Radio Television Broadcasts',
		}
	}).link({
		'svg': '#publication',
		'link': {
			'text': 'Publications',
		}
	}).link({
		'svg': '#compositions',
		'link': {
			'text': 'Compositions',
		}
	}).link({
		'svg': '#membership',
		'link': {
			'text': 'Memberships',
		}
	});

	new nexDrop({
		'to': myNav.list,
		'tag': 'li',
		'cls': {
			'add': 'rounded nex-nav-item'
		},
		'css': {
			'z-index': '2048'
		},
		'toggle': {
			'tag': 'a',
			'cls': {
				'add': 'btn nav-link align-items-center ps-1 pe-2 py-2 justify-content-center d-flex nex-nav-link'
			}
		},
		'list': {
			'cls': {
				'add': 'mt-0 mt-lg-4 dropdown-menu-end'
			}
		}
	}).header({
		'item': {
			'text': 'Toggle theme'
		}
	}).hr().item({
		'item': {
			'tag': 'button',
			'text': 'Auto',
			'svg': '#auto-mode',
			'evt': [
				{
					'on': 'c',
					'act': () => {
						nexAnime.setTheme('auto');
					}
				}
			]
		}
	}).item({
		'item': {
			'tag': 'button',
			'text': 'Dark',
			'svg': '#dark-mode',
			'evt': [
				{
					'on': 'c',
					'act': () => {
						nexAnime.setTheme('dark');
					}
				}
			]
		}
	}).item({
		'item': {
			'tag': 'button',
			'text': 'Light',
			'svg': '#light-mode',
			'evt': [
				{
					'on': 'c',
					'act': () => {
						nexAnime.setTheme('light');
					}
				}
			]

		}
	}).hr();

	new nexCard({
		'to': myNav.getTab('Biography').frag({
			'tag': 'section',
			'cls': {
				'add': 'container-fluid'
			},
		}).nodes.section[0]
	}).card([
		{
			'card': 'header',
			'text': 'Biography',
			'cls': {
				'add': 'h4'
			}
		},
		{
			'card': 'body',
			'child': [
				{
					'tag': 'img',
					'cls': {
						'add': 'float-end clearfix img-fluid w-50 img-thumbnail ms-3'
					},
					'prop': {
						'alt': '...',
						'src': 'static/img/img.env/evelyn-stroobach.jpg',
					}
				},
				{
					'tag': 'p',
					'html': `
						Evelyn Stroobach is a professional musician and an award-winning, published composer. Presently, 
						Stroobach is a PhD researcher/candidate in Music Composition at the University of Sheffield in the UK. 
						To aid in her doctoral studies, Stroobach is the recipient of the Gladys Hall scholarship. 
						She has received regional, national, and international recognition for her works. 
						Stroobach was honoured in both the Senate and the House of Commons at the Houses of Parliament in Ottawa, 
						Canada for her participation as composer on the <i>Aboriginal Inspirations</i> CD (<a href='https://cmccanada.org/shop/cd-ai6209/'>cmccanada.org<a/>).
						<br><br>
						Stroobach has had her compositions performed at Carnegie Hall, at the Ottawa International Chamber Music Festival, 
						National Gallery of Canada, in the Senate and in the Peace Tower at the Houses of Parliament in Ottawa, Canada, 
						at the Wabano Centre in Ottawa, at the Shenkman Arts Centre in Ottawa, at the Saint John Arts Centre in New Brunswick, 
						Canada, Ars Universalis: Culture Days and the National Palace of Culture in Sofia, 
						Bulgaria as well as many other concert halls around the world. Her compositions have 
						also been performed in concerts held at the University of Literature & Philosophy, in Rome, 
						Italy, Indiana University, University of Central Missouri, McGill University, 
						the University of Ottawa, Lakehead University and Saint Thomas University.
						<br><br>
						Her works have been broadcasted on television in Europe and the United States as well as aired 
						on radio stations around the world. Stroobach's works have been aired across Canada on CBC radio 
						as well as on CKWR radio which broadcasts out of Waterloo, Ontario and The Grand Radio which broadcasts 
						out of Fergus, Ontario. In Europe, she has been heard on Radio Monalisa which broadcasts out of Amsterdam, 
						the Netherlands, Hildegard to Hildegard which broadcasts out of South Devon, the United Kingdom, 
						ZAIKS radio which broadcasts out of Poland and Teleradio-Moldova which broadcasts out of Chisinau. 
						She has also been broadcasted in Romania. In Asia, her compositions have been broadcasted on KOMCA 
						radio in South Korea. In the United States, her compositions have been aired on WPRB radio which broadcasts 
						out of Princeton, New Jersey, WWFM radio which broadcasts out of West Windsor, New Jersey, WMBR radio which 
						broadcasts out of Cambridge, Massachusetts, WOMR radio which broadcasts out of Provincetown, Massachusetts, 
						KWAX radio which broadcasts out of Eugene, Oregon, KNHD radio which also broadcasts out of Eugene, Oregon, 
						KMFA radio which broadcasts out of Austin, Texas, KGNU radio which broadcasts out of Boulder, Colorado, WFCF 
						radio which broadcasts out of St. Augustine, Florida and ECR radio which broadcasts out of Ellensburg, Washington.
					`
				}
			]
		},
		{
			'card': 'footer'
		}
	]);


	// CDs
	new nexCard({
		'to': myNav.getTab('CDs').frag({
			'tag': 'section',
			'cls': {
				'add': 'row row-cols-1 gx-0 gy-4'
			},
		}).nodes.section[0]
	}).card([
		{
			'card': 'header',
			'child': {
				'card': 'title',
				'html': '<a href="https://cmccanada.org/shop/cd-esnb-20062/"><i>Aurora Borealis</i></a>'
			}
		},
		{
			'tag': 'div',
			'cls': {
				'add': 'row'
			},
			'child': [
				{
					'tag': 'img',
					'cls': {
						'add': 'col-12 col-md-3 img-fluid object-fit-cover'
					},
					'prop': {
						'alt': '...',
						'src': 'static/img/img.env/aurora-borealis.jpg'
					}
				},
				{
					'card': 'body',
					'cls': {
						'add': 'col-12 col-md-9'
					},
					'child': {
						'card': 'text',
						'html': `
							Pierre-Daniel Rheault, former SOCAN President, wrote the following after listening to <i>Aurora Borealis</i>: ''It is fabulous...gorgeous...very pleasurable listening.''
							<br><br>
							In a review published in the Journal of the International Alliance for Women in Music, Volume 13, No.1, 2007, Dr. Margaret Lucia wrote: ''Therefore we find in this disc (<i>Aurora Borealis</i>) not only the excellent work of a gifted composer but also the graciousness of a fine collaborator as well.'' Pages 32-33
							<br><br>
							<i>Aurora Borealis</i> CD received a nomination for BEST CLASSICAL CONTEMPORARY ALBUM. The awards nominations were selected from over 560,000 entries world-wide (http://www.justplainfolks.org/09albumnoms.html) and were announced on June 25th, 2009 by the largest music organization in the world, JPF.
						`
					}
				}
			]
		},
		{
	
			'card': 'body',
			'child': {
				'card': 'text',
				'html': `
					Stroobach's compact disc entitled <i>Aurora Borealis</i> contains eleven of her compositions composed for a variety of different musical genres and her works are performed by some of Canada's leading musicians. The CD project was awarded funding by FACTOR (Foundation to Assist Canadian Talent on Records), the Council for the Arts in Ottawa and the Corel Endowment for the Arts. <i>Aurora Borealis</i> is available through the Canadian Music Centre.
				`
			}
		},
		{
			'card': 'footer'
		}
	])

	new nexCard({
		'to': myNav.getTab('CDs').nodes.section[0]
	}).card([
		{
			'card': 'header',
			'child': {
				'card': 'title',
				'html': '<a href="https://cmccanada.org/shop/cd-ai6209/"><i>Aboriginal Inspirations</i></a>'
			}
		},
		{
			'tag': 'div',
			'cls': {
				'add': 'row'
			},
			'child': [
				{
					'tag': 'img',
					'cls': {
						'add': 'col-12 col-md-3 img-fluid object-fit-cover'
					},
					'prop': {
						'alt': '...',
						'src': 'static/img/img.env/aboriginal-inspirations.jpg'
					}
				},
				{
					'card': 'body',
					'cls': {
						'add': 'col-12 col-md-9'
					},
					'child': {
						'card': 'text',
						'cls': {
							'add': 'm-3'
						},
						'html': `
							Kimberly Greene, PhD, reviews editor of the International Alliance for Women in Music Journal wrote: “I must say that the music (included on the <i>Aboriginal Inspirations</i> CD) is extremely impressive and provocative; especially your Fire Dance.”
							<br><br>
							Carol Ann Weaver, Professor Emerita of the University of Waterloo submitted a review about <i>Aboriginal Inspirations</i> which was published in the International Alliance for Women in Music Journal. In the review Professor Weaver wrote: “Evelyn Stroobach’s Fire Dance for flute, viola, and drum is a concise, well-constructed piece with excellent counterpoint, which depicts an imagined “event where people gather around the warmth of the fire and a dance is performed after dark” (Liner Notes). Stroobach’s musical language allows the listeners to envision both the “movement and purpose of the dance” (Liner Notes). In this respect, the viola’s percussive, double-stop rhythm in fast 6/8, answered by the drum’s basic pulse, is followed by an imitative dialogue between flute and viola. As the viola and drum continue a steady beat, the flute transforms into a folk-like soliloquy, before returning to an imitative dialogue with the viola. Throughout the composition, the drum plays mostly unvaried downbeats. Notably, Stroobach’s music allows the two cultural worlds to collide, rather than fully intermingle, creating a stunning musical experience.”
						`
					}
				}
			]
		},
		{
			'card': 'body',
			'child': {
				'card': 'text',
				'html': `
					<i>Aboriginal Inspirations</i> CD was released on April 21st, 2017 at the Embassy of the Republic of Bulgaria in Ottawa, Canada. Stroobach was invited to attend this event. Stroobach’s composition entitled Fire Dance composed for flute, viola and aboriginal drum is included on the disc. Ron Korb (whose CD Asia Beauty was nominated for a Grammy Award) performed the flute, Ralitsa Tcholakova performed the viola and Dominique Moreau performed the drum part.
					<br><br>
					Stroobach as well as the other composers and performers on the CD were honoured in the Senate and the House of Commons at the Houses of Parliament in Ottawa, Canada for their participation on the newly released <i>Aboriginal Inspirations</i> CD.
					<br><br>
					The Canadian Music Centre has agreed to distribute <i>Aboriginal Inspirations</i>, and both the Canadian Music Centre and NAXOS have agreed to do the digital distribution.
					<br><br>
					Ralitsa Tcholakova wrote the following: “The compositions included on this CD were composed by eight Ottawa-based or born composers whose music was inspired by Canadian aboriginal myths, legends, symbols or issues. The musical compositions highlight the spiritual values of aboriginal people and, in so doing, seek to encourage a dialogue between generations and cultures mediated through art and culture. Music has the unique ability to transform an artist’s feelings and ideas into a powerful cultural phenomenon that embraces the past, the present and the future. This CD project embraces and celebrates, in musical form, the universal need for love and forgiveness.” 
				`
			}
		},
		{
			'card': 'footer'
		}
	])

	new nexCard({
		'to': myNav.getTab('CDs').nodes.section[0]
	}).card([
		{
			'card': 'header',
			'child': {
				'card': 'title',
				'html': '<a href="https://www.livingmusicdatabase.com/albums/holidays-of-the-new-era-vol-1-reese-williams-golub-powers-stroobach-and-others#:~:text=Holidays%20Of%20The%20New%20Era%2C%20Vol.%201:,Powers%2C%20Stroobach%20and%20Others%2C%20released%20on%202006-01-01">EMR</a>'
			}
		},
		{
			'tag': 'div',
			'cls': {
				'add': 'row'
			},
			'child': [
				{
					'tag': 'img',
					'cls': {
						'add': 'col-12 col-md-3 img-fluid object-fit-cover'
					},
					'prop': {
						'alt': '...',
						'src': 'static/img/img.env/emr.jpeg'
					}
				},
				{
					'card': 'body',
					'cls': {
						'add': 'col-12 col-md-9'
					},
					'child': {
						'card': 'text',
						'cls': {
							'add': 'm-3'
						},
						'html': `
						`
					}
				}
			]
		},
		{
			'card': 'body',
			'child': {
				'card': 'text',
				'html': `
				`
			}
		},
		{
			'card': 'footer'
		}
	])


	new nexCard({
		'to': myNav.getTab('RadioTelevisionBroadcasts')
	}).card([
		{
			'card': 'body',
			'child': {
				'card': 'text',
				'html': `
					On November 15, 2023, Ellen Grolman, producer and host of the radio program Music of our Mothers: Celebrating Women at WFCF radio, who broadcasts out of Flagler College radio in Jacksonville, Florida, and around the world via the internet (http://www.iheart.com/live/WFCF-88Five-FM-5246/), aired Stroobach's work entitled Dark Blue composed for alto saxophone performed by Doug Martin and piano performed by Evelyn Stroobach. 
					<br><br>
					On January 27th, 2023, International Holocaust Remembrance Day, Stroobach’s work composed for orchestra and SATB chorus, Holocaust - Remembrance, received a world premiere performance by the National Symphony Orchestra and Chorus of Teleradio-Moldova in Chisinau (https://t.co/vrbKyHloY3) (https://www.facebook.com/teleradiomoldova/videos/3243084146003184/?extid=CL-UNK-UNK-UNK-IOS_GK0T-GK1C&mibextid=2Rb1fB&ref=sharing). Maestro Romeo Rimbu (http://www.romeorimbu.ro/repertoire/) conducted Holocaust - Remembrance during this concert performance. Before the performance, Maestro Rimbu talked about the work, explaining that it is a religious work full of symbolism. He also talked about the composers’ background and that Holocaust - Remembrance is dedicated to Stroobach’s great-uncle, Abraham Samuel Fernandes (https://yvng.yadvashem.org/index.html?language=en&s_id=&s_last), who was murdered by the Nazis for fighting in the resistance in the Netherlands during WWII. The concert was broadcasted live on the radio, which could be heard throughout Europe. The concert could also be viewed/heard throughout the world via the internet. 
					<br><br>
					On August 28, 2022, Tom Quick, producer and host of the radio program Classical Concert with Tom Quick at The Grand Radio, who broadcasts out of Fergus, Ontario, Canada and around the world via the internet (www.thegrand101.com), aired two of Stroobach’s works composed for string orchestra: Aria for Strings and La petite danse, from her Aurora Borealis CD (https://collections.cmccanada.org/final/Portal/Composer-Showcase.aspx?lang=en-CA).
					<br><br>
					Between April 1 and June 30, 2021, Stroobach's composition Dark Blue composed for alto saxophone and piano was broadcasted on ZAIKS radio in Poland. 
					<br><br>
					Between April 1 and June 30, 2020, Stroobach's compositions Crepuscule composed for harpsichord and Fanfare composed for organ were broadcasted on KOMCA radio in South Korea. 
					<br><br>
					On December 12, 2019, Kath Fraser, producer and host of the radio program Gathering Her Notes at ECR radio, who broadcasts out of Ellensburg, Washington, and around the world via the internet (www.eburgradio.org), aired Stroobach's work composed for SATB chorus and violoncello entitled O Come, O Come, Emmanuel (https://eburgradio.org/programs/gathering-her-notes/ - 52:12 – 57:36).
					<br><br>
					On March 27, 2019, Ellen Grolman, producer and host of the radio program Music of our Mothers: Celebrating Women at WFCF radio, who broadcasts out of Flagler College radio in Jacksonville, Florida, and around the world via the internet (http://www.iheart.com/live/WFCF-88Five-FM-5246/), aired Stroobach's work entitled Dark Blue. Grolman said the following on air, “The second hour starts out with music by Evelyn Stroobach, a Canadian composer, whose works are performed worldwide. We will hear her Dark Blue. The work is subdued, earnest and absorbing and in this performance played by Doug Martin on alto sax and the composer herself Evelyn Stroobach on piano.” (https://www.musicofourmothers.com/archives-past-shows) 
					<br><br>
					On January 3, 2019, Kath Fraser, producer and host of the radio program Gathering Her Notes at ECR radio, who broadcasts out of Ellensburg, Washington, and around the world via the internet (www.eburgradio.org), aired Stroobach's work entitled Dark Blue composed for alto saxophone performed by Doug Martin and piano performed by Evelyn Stroobach.
					<br><br>
					On December 13, 2018, Kath Fraser, producer and host of the radio program Gathering Her Notes at ECR radio, who broadcasts out of Ellensburg, Washington, and around the world via the internet (www.eburgradio.org), aired Stroobach's work composed for SATB chorus and violoncello entitled O Come, O Come, Emmanuel. 
					<br><br>
					On December 12, 2018, Ellen Grolman, producer and host of the radio program Music of our Mothers: Celebrating Women at WFCF radio, who broadcasts out of Flagler College radio in Jacksonville, Florida, and around the world via the internet (http://www.iheart.com/live/WFCF-88Five-FM-5246/), aired Stroobach's work entitled In Flanders Fields composed for SATB chorus and string orchestra. Because Stroobach’s music was broadcasted on Music of our Mothers, she was the featured composer on the show’s companion website (www.musicofourmothers.com/featured-composers).
					<br><br>
					On September 8, 2018 Stroobach's composition for string orchestra entitled Aria for Strings received a live concert performance by the National Symphony Orchestra of Teleradio-Moldova in Chisinau. Maestro Kypros Markou conducted the orchestra in this concert performance. In addition to the audience members, thousands of people were listening to the concert which was broadcasted on the radio, television and the internet. 
					<br><br>
					On December 21, 2017, Kath Fraser, producer and host of the radio program Gathering Her Notes at ECR radio, who broadcasts out of Ellensburg, Washington, and around the world via the internet (https://www.mixcloud.com/Kathfraser/gathering-her-notes-12-21-2017-holiday-music/), aired Stroobach's work composed for SATB chorus and violoncello entitled O Come, O Come, Emmanuel. 
					<br><br>
					On November 16, 2017, Ariane Delaunois, producer and host of the radio program Hildegard to Hildegard, who broadcasts out of South Devon, the United Kingdom and around the world via the internet (www.mixcloud.com/SAR4AD), aired two of Stroobach’s compositions. Broadcasted were Stroobach’s work from the Aboriginal Inspirations CD (www.musiccentre.ca/node/147580) entitled Fire Dance composed for flute, viola and aboriginal drum and Aria for Strings composed or string orchestra from Stroobach's CD Aurora Borealis (http://www.musiccentre.ca/node/40412).
					<br><br>
					On October 29, 2017, Richard Beckman, producer and host of the radio program Worldwide Classical at KNHD radio, who broadcasts out of Eugene, Oregon and around the world via the internet (knhd1047.radiostream321.com) and/or (knhd1047.listen2myshow.com) aired Stroobach’s work.
					<br><br>
					On September 10, 2017, Stroobach's orchestral composition entitled Dark Blue received a live concert performance by the National Symphony Orchestra of Teleradio-Moldova in Chisinau. Maestro Gary Cheung conducted the orchestra in this concert performance. In addition to the audience members, thousands of people were listening to the concert which was broadcasted on the radio, television and the internet. 
					<br><br>
					On June 14, 2017, Ellen Grolman, producer and host of the radio program Music of our Mothers: Celebrating Women at WFCF radio, who broadcasts out of Flagler College radio in Jacksonville, Florida, and around the world via the internet (http://www.iheart.com/live/WFCF-88Five-FM-5246/), aired Stroobach's work entitled Fire Dance composed for flute, viola and aboriginal drum from the newly released CD Aboriginal Inspirations (http://www.musiccentre.ca/node/147580).
					<br><br>
					On June 11, 2017, Tom Quick, producer and host of the radio program Women in Music at The Grand Radio, who broadcasts out of Fergus, Ontario, Canada and around the world via the internet (www.thegrand101.com) aired Stroobach’s work from the Aboriginal Inspirations CD entitled Fire Dance composed for flute, viola and aboriginal drum. Ron Korb (whose CD Asia Beauty was nominated for a Grammy Award) performed the flute, Ralitsa Tcholakova performed the viola and Dominique Moreau performed the drum part.
					<br><br>
					On June 8, 2017, Kath Fraser, producer and host of the radio program Gathering Her Notes at ECR radio, who broadcasts out of Ellensburg, Washington, and around the world via the internet (http://www.streamlicensing.com/stations/ecr/), aired La petite danse composed for string orchestra from Stroobach's CD Aurora Borealis (http://www.musiccentre.ca/node/40412). Kath Fraser described La petite danse as a “lovely piece”.
					<br><br>
					On June 6, 2017, Ken Field, producer and host of the radio program The New Edge at WMBR radio, who broadcasts out of Cambridge, Massachusetts and around the world via the internet (www.wmbr.org) aired Stroobach’s work Fire Dance composed for flute, viola and aboriginal drum from the CD Aboriginal Inspirations and Daydream composed for carillon from her Aurora Borealis CD. 
					<br><br>
					On May 21, 2017, Richard Beckman, producer and host of the radio program Worldwide Classical at KNHD radio, who broadcasts out of Eugene, Oregon and around the world via the internet (knhd1047.radiostream321.com) and/or (knhd1047.listen2myshow.com) aired Stroobach’s work Fire Dance composed for flute, viola and aboriginal drum from the CD Aboriginal Inspirations. 
					<br><br>
					On May 21, 2017, Stroobach’s composition O Come, O Come, Emmanuel composed for SATB chorus and violoncello was broadcasted on KNHD radio, which broadcasts out of Eugene, Oregon and around the world via the internet (knhd1047.radiostream321.com) and/or (knhd1047.listen2myshow.com).
					<br><br>
					On May 18, 2017, Kath Fraser, producer and host of the radio program Gathering Her Notes at ECR radio, who broadcasts out of Ellensburg, Washington, and around the world via the internet (http://www.streamlicensing.com/stations/ecr/), aired Aurora Borealis composed for orchestra and all three movements of Aria for Strings composed or string orchestra from Stroobach's CD Aurora Borealis (http://www.musiccentre.ca/node/40412) and Fire Dance composed for flute, viola and aboriginal drum from the CD Aboriginal Inspirations. 
					<br><br>
					On May 7, 2017, Richard Beckman, producer and host of the radio program Worldwide Classical at KNHD radio, who broadcasts out of Eugene, Oregon and around the world via the internet (knhd1047.radiostream321.com) and/or (knhd1047.listen2myshow.com) aired Stroobach’s work Bereft composed for violin and violoncello from her CD Aurora Borealis (http://www.musiccentre.ca/node/40412). 
					<br><br>
					On April 30, 2017, Richard Beckman, producer and host of the radio program Worldwide Classical at KNHD radio, who broadcasts out of Eugene, Oregon and around the world via the internet (knhd1047.radiostream321.com) and/or (knhd1047.listen2myshow.com) aired two works from Stroobach’s CD Aurora Borealis (http://www.musiccentre.ca/node/40412). Broadcasted were Aurora Borealis composed for orchestra and performed by the Ottawa Symphony Orchestra under the baton of David Currie and Aria for Strings composed for string orchestra and performed by the Thirteen Strings of Ottawa under the baton of Winstin Weber.
					<br><br>
					On February 3, 2017, Stroobach's orchestral composition entitled Aurora Borealis received a live concert performance by the National Symphony Orchestra of Teleradio-Moldova in Chisinau. Maestro Howie Ching conducted the orchestra in this concert performance. In addition to the audience members, thousands of people were listening to the concert which was broadcasted on the radio, television and the internet. Stroobach was interviewed by Teleradio-Moldova via Skype from her home in Ottawa, Canada before the concert.
					<br><br>
					On December 22, 2016, Kath Fraser, producer and host of the radio program Gathering Her Notes at ECR radio, who broadcasts out of Ellensburg, Washington, and around the world via the internet (http://www.streamlicensing.com/stations/ecr/), aired Stroobach's work composed for SATB chorus and violoncello entitled O Come, O Come, Emmanuel. 
					<br><br>
					On December 20, 2016, Canary Burton, producer and host of the radio program The Latest Score at WOMR radio, who broadcasts out of Provincetown, Massachusetts, and around the world via the internet (www.womr.org), aired Stroobach's work composed for SATB chorus and violoncello entitled O Come, O Come, Emmanuel, Aurora Borealis composed for orchestra and all three movements of Aria for Strings composed for string orchestra. 
					<br><br>
					On December 7, 2016, Ellen Grolman, producer and host of the radio program Music of our Mothers: Celebrating Women at WFCF radio, who broadcasts out of Flagler College radio in Jacksonville, Florida, and around the world via the internet (http://www.iheart.com/live/WFCF-88Five-FM-5246/), aired Stroobach's work composed for SATB chorus and violoncello entitled O Come, O Come, Emmanuel. Ellen Grolman described the work as a “Lovely piece!”.
					<br><br>
					On December 22, 2015, Canary Burton, producer and host of the radio program The Latest Score at WOMR radio, who broadcasts out of Provincetown, Massachusetts, and around the world via the internet (www.womr.org), aired Stroobach's work composed for SATB chorus and violoncello entitled O Come, O Come, Emmanuel. 
					<br><br>
					On December 21, 2015, Tom Quick, producer and host of the radio program Women in Music at CKWR radio, who broadcasts out of Waterloo, Ontario, Canada, and around the world via the internet (www.ckwr.com), aired Stroobach's composition O Come, O Come, Emmanuel composed for SATB chorus and violoncello.
					<br><br>
					On February 10, 2015, Canary Burton, producer and host of the radio program The Latest Score at WOMR radio, who broadcasts out of Provincetown, Massachusetts, and around the world via the internet (www.womr.org), aired four of Stroobach's compositions. Broadcasted were Dark Blue composed for alto saxophone performed by Doug Martin and piano performed by Evelyn Stroobach, Crepuscule composed for harpsichord and performed by Thomas Annand, Daydream composed for carillon performed by Canada's Dominion carillonneur Gordon Slater and Fanfare composed for organ performed by Thomas Annand. 
					<br><br>
					On December 24, 2014, Ellen Grolman, producer and host of the radio program Music of our Mothers: Celebrating Women at WFCF radio, who broadcasts out of Flagler College radio in Jacksonville, Florida, and around the world via the internet (http://www.iheart.com/live/WFCF-88Five-FM-5246/), aired Stroobach's work composed for SATB chorus and violoncello entitled O Come, O Come, Emmanuel.
					<br><br>
					On December 23, 2014, Canary Burton, producer and host of the radio program The Latest Score at WOMR radio, who broadcasts out of Provincetown, Massachusetts, and around the world via the internet (www.womr.org), aired Stroobach's work composed for SATB chorus and violoncello entitled O Come, O Come, Emmanuel. 
					<br><br>
					On December 10, 2014, Ellen Grolman, producer and host of the radio program Music of our Mothers: Celebrating Women at WFCF radio, who broadcasts out of Flagler College radio in Jacksonville, Florida, and around the world via the internet (http://www.iheart.com/live/WFCF-88Five-FM-5246/), aired all three movements of Stroobach’s work for string orchestra called Aria for Strings.
					<br><br>
					On December 8, 2014, Tom Quick, producer and host of the radio program Women in Music at CKWR radio, who broadcasts out of Waterloo, Ontario, Canada, and around the world via the internet (www.ckwr.com), aired Stroobach's composition O Come, O Come, Emmanuel composed for SATB chorus and violoncello.
					<br><br>
					In October 2014, Ellen Grolman, producer and host of the radio program Music of our Mothers: Celebrating Women at WFCF radio, who broadcasts out of Flagler College radio in Jacksonville, Florida, and around the world via the internet (http://www.iheart.com/live/WFCF-88Five-FM-5246/), aired two of Stroobach's compositions. Broadcasted were Fanfare composed for organ and Nonet composed for woodwind quartet and string quintet.
					<br><br>
					In August 2014, Ellen Grolman, producer and host of the radio program Music of our Mothers: Celebrating Women at WFCF radio, who broadcasts out of Flagler College radio in Jacksonville, Florida, and around the world via the internet (http://www.iheart.com/live/WFCF-88Five-FM-5246/), aired all four movements of Stroobach's work entitled Bereft composed for violin and violoncello.
					<br><br>
					On June 23, 2014, Tom Quick, producer and host of the radio program Women in Music at CKWR radio, who broadcasts out of Waterloo, Ontario, Canada, and around the world via the internet (www.ckwr.com), aired Stroobach's work composed for string orchestra called Aria for Strings as well as her orchestral work Aurora Borealis.
					<br><br>
					On February 11, 2014, Canary Burton, producer and host of the radio program The Latest Score at WOMR radio, who broadcasts out of Provincetown, Massachusetts, and around the world via the internet (www.womr.org), aired three of Stroobach's compositions. Broadcasted were Aurora Borealis composed for orchestra and Aria for Strings and La petite danse both composed for string orchestra.
					<br><br>
					On December 18, 2013, Ellen Grolman, producer and host of the radio program Music of our Mothers: Celebrating Women at WFCF radio, who broadcasts out of Flagler College radio in Jacksonville, Florida, and around the world via the internet (http://www.iheart.com/live/WFCF-88Five-FM-5246/), aired Stroobach’s work for SATB chorus and violoncello called O Come, O Come, Emmanuel.
					<br><br>
					On December 17, 2013, Canary Burton, producer and host of the radio program The Latest Score at WOMR radio, who broadcasts out of Provincetown, Massachusetts, and around the world via the internet (www.womr.org), aired Stroobach's composition O Come, O Come, Emmanuel composed for SATB chorus and violoncello. Canary Burton wrote the following about 
					O Come, O Come, Emmanuel: “You just have "know" it's beautiful!!!”
					<br><br>
					On December 16, 2013, Tom Quick, producer and host of the radio program Monday Evening Concert at CKWR radio, who broadcasts out of Waterloo, Ontario, Canada, and around the world via the internet (www.ckwr.com), aired Stroobach's composition O Come, O Come, Emmanuel composed for SATB chorus and violoncello.
					<br><br>
					On November 20, 2013, Ellen Grolman, producer and host of the radio program Music of our Mothers: Celebrating Women at WFCF radio, who broadcasts out of Flagler College radio in Jacksonville, Florida, and around the world via the internet (http://www.iheart.com/live/WFCF-88Five-FM-5246/), aired two of Stroobach’s works. Broadcasted were Aurora Borealis for orchestra and Aria for Strings composed for string orchestra.
					<br><br>
					On August 7, 2013, Ellen Grolman, producer and host of the radio program Music of our Mothers: Celebrating Women at WFCF radio, who broadcasts out of Flagler College radio in Jacksonville, Florida, and around the world via the internet (http://www.iheart.com/live/WFCF-88Five-FM-5246/), aired Stroobach’s work composed for soprano, flute, viola and violoncello entitled The Human Abstract.
					<br><br>
					In August 2013, Ellen Grolman, producer and host of the radio program Music of our Mothers: Celebrating Women at WFCF radio, who broadcasts out of Flagler College radio in Jacksonville, Florida, and around the world via the internet (http://www.iheart.com/live/WFCF-88Five-FM-5246/), aired all four movements of Stroobach's work entitled Bereft composed for violin and violoncello.
					<br><br>
					On March 18, 2013, Tom Quick, producer and host of the radio program Monday Evening Concert at CKWR radio, who broadcasts out of Waterloo, Ontario, Canada, and around the world via the internet (www.ckwr.com), aired Stroobach's work composed for string orchestra called Aria for Strings.
					<br><br>
					On December 19, 2012, Marvin Rosen, producer and host of the radio program Classical Discoveries (http://ourworld.cs.com/clasdis) at WPRB radio, who broadcasts from Princeton, New Jersey, and around the world via the internet (www.wprb.com), broadcasted Stroobach's composition entitled O Come, O Come, Emmanuel composed for SATB chorus and violoncello.
					<br><br>
					On December 18, 2012, Canary Burton, producer and host of the radio program The Latest Score at WOMR radio, who broadcasts out of Provincetown, Massachusetts, and around the world via the internet (www.womr.org), aired Stroobach's composition O Come, O Come, Emmanuel composed for SATB chorus and violoncello.
					<br><br>
					On December 17, 2012, Tom Quick, producer and host of the radio program Monday Evening Concert at CKWR radio, who broadcasts out of Waterloo, Ontario, Canada, and around the world via the internet (www.ckwr.com), aired Stroobach's composition O Come, O Come, Emmanuel composed for SATB chorus and violoncello.
					<br><br>
					On September 4, 2012, Canary Burton, producer and host of the radio program The Latest Score at WOMR radio, who broadcasts out of Provincetown, Massachusetts, and around the world via the internet (www.womr.org), aired four of Stroobach's compositions. Broadcasted were Petition written for solo guitar, Crepuscule composed for harpsichord, Daydream written for carillon, and Fanfare composed for organ. All of these works are recorded onto Stroobach's compact disc entitled Aurora Borealis.
					<br><br>
					On February 14, 2012, Canary Burton, producer and host of the radio program The Latest Score at WOMR radio, who broadcasts out of Provincetown, Massachusetts, and around the world via the internet (www.womr.org), aired Stroobach's orchestral composition entitled Aurora Borealis from her compact disc of the same name. This work was performed by the Ottawa Symphony Orchestra and conducted by Maestro David Currie.
					<br><br>
					In January 2012, Alan Neal, producer and host of All in a Day on CBC Radio, who broadcasts out of Ottawa, Ontario, Canada and around the world via the internet (http://www.cbc.ca/allinaday/), aired Stroobach's orchestral composition entitled Aurora Borealis from her compact disc of the same name. This work was performed by the Ottawa Symphony Orchestra and conducted by Maestro David Currie.
					<br><br>
					On December 22, 2011, Bill Zagorski, producer and host of the radio program New Releases at WWFM radio, who broadcasts out of West Windsor, New Jersey, and around the world via internet (http://www.wwfm.org/), aired Stroobach's composition entitled O Come, O Come, Emmanuel composed for SATB chorus and violoncello.
					<br><br>
					On December 20, 2011, Canary Burton, producer and host of the radio program The Latest Score at WOMR radio, who broadcasts out of Provincetown, Massachusetts, and around the world via the internet (www.womr.org), aired Stroobach's composition entitled O Come, O Come, Emmanuel composed for SATB chorus and violoncello.
					<br><br>
					On December 12, 2011, Tom Quick, producer and host of the radio program Monday Evening Concert at CKWR radio, who broadcasts out of Waterloo, Ontario, Canada, and around the world via the internet (www.ckwr.com), aired Stroobach's composition O Come, O Come, Emmanuel composed for SATB chorus and violoncello.
					<br><br>
					On October 25, 2011, Canary Burton, producer and host of the radio program The Latest Score at WOMR radio, who broadcasts out of Provincetown, Massachusetts, and around the world via the internet (www.womr.org), broadcasted Stroobach's composition entitled The Human Abstract composed for soprano, flute, viola and violoncello.
					<br><br>
					On July 28, 2011, Bill Zagorski, producer and host of the radio program New Releases at WWFM radio, who broadcasts out of West Windsor, New Jersey, and around the world via internet (http://www.wwfm.org/), aired Stroobach's orchestral composition entitled Aurora Borealis from her compact disc of the same name. This work was performed by the Ottawa Symphony Orchestra and conducted by Maestro David Currie.
				`
			}
		}
	]);


	new nexCard({
		'to': myNav.getTab('Publications')
	}).card([
		{
			'card': 'body',
			'child': {
				'card': 'text',
				'html': `
Publication – Medieval Tales: The Art of the Mode

<br><br>
Stroobach's music book entitled Medieval Tales: The Art of the Mode (https://www.musiccentre.ca/node/28060) was published by Oceanna Music Publications in June 2005. Medieval Tales contains six piano compositions written in different modes and also includes performance notes and relevant history written by the composer. The book is offered for sale across Canada and the United States and can be viewed on-line at: www.oceannamusic.com/new_piano_releases.htm. ISBN 1-894969-88-X 

<br><br>



On June 23rd, 2006, Stroobach's publisher, Oceanna Music Publications, asked her to give a presentation at the ORMTA (Ontario Registered Music Teachers Association) Convention which was held in Ottawa on her published piano book Medieval Tales. Stroobach's presentation included a talk about the piano compositions in Medieval Tales as well as as a performance of piano works included in the music book in order to illustrate her discussion.

<br><br>



Aury Murray, who is a member of ORMTA, conducted a workshop of 'Modes' at the 'Summer Sizzle' which was held from July 15-17, 2007, in Palmerston, Ontario. Her presentation dealt with the history of modes from ancient Greece to the present day. Since 'Summer Sizzle' promotes the music of Canadian composers, she included in her presentation Stroobach's published piano book Medieval Tales: The Art of the Mode and also performed a work from her book.
<br><br>




Pianist and musicologist, Dr. Joo Yeon Tarina Kim, in her published dissertation, The Solo Piano Music of Selected Contemporary Canadian Women Composers: Database, Audio Samples, and Annotated Bibliography, (2011) wrote: "A truly unique and pedagogically important volume, the Medieval Tales consists of six captivating pieces, each in a different mode. In addition, this collection is quite informative with extensive program notes, relevant music history, performance hints, and illustrations." page 120
<br><br>







Publications about or by Evelyn Stroobach
<br><br>




Badian, Maya, 'Evelyn Stroobach', Women of Note: Music by European Women Composers, (March 19, 2016), 3
<br><br>

Bojilov, Maxim, 'Our Violinist Plays a Concert at the Canadian Parliament', Bulgarian Horizons: Canadian Bulgarian Newspaper, Issue No. 11, Volume 17 (June 1, 2015), 6
<br><br>

Borys, Roman, 'Evelyn Stroobach', Chamberfest '07 100 + Concerts Programme, Ottawa International Chamber Music Festival, (2007), 185
<br><br>

Borys, Roman, 'Music by Ottawa Composers', Chamberfest '07 100 + Concerts Programme, Ottawa International Chamber Music Festival, (2007), 114
<br><br>

Borys, Roman, 'Music by Ottawa Composers', Chamberfest '07 100 + Concerts Programme, Ottawa International Chamber Music Festival, (2007), 22
<br><br>

Burge, John, 'Membership', Canadian League of Composers Bulletin, Winter (2006-2007), 8
<br><br>

Campitelli, Vilma, ‘Nonet, Aurora Borealis and The Human Abstract’, Compendium Musicae Flauta: Catalogue of flute music by women composers (2019), 263
<br><br>

Chang, Wah Keung, ‘Ottawa International Chamber Music Festival’, La Scena Musicale: Reviews – Upcoming Concerts: Montreal, Quebec, Ottawa and More!, (June-July 2012), 41
<br><br>

Colton, Glenn David, ‘Across the Pond and Back Again’, Newfoundland Rhapsody: Frederick R. Emerson and the Musical Culture of the Island, (2014), 63
<br><br>

Danard, Rebecca, 'Evelyn Stroobach', Ottawa New Music Creators: 60X60, (2012), 10
<br><br>

Elliott, Julia, 'The loneliness of the female composer', Ottawa Citizen, (August 6, 2012), A1, D1
<br><br>

Evison, Fiona, ‘Member News: Evelyn Stroobach’, The Association of Canadian Women Composers, Fall 2019 / Winter 2020 Journal (2019), 54
<br><br>

Fava, Matthew, ‘Evelyn Stroobach’, Ontario Notations, Fall (2016), 69
<br><br>

Fava, Matthew, ‘Evelyn Stroobach’, Ontario Notations, Spring (2016), 86
<br><br>

Fava, Matthew, 'Evelyn Stroobach’, Ontario Notations, Fall (2015), 57
<br><br>

Fava, Mathew, 'Stroobach in Europe', Ontario Notations, Winter (2015), 57
<br><br>

Fava, Matthew, 'Evelyn Stroobach on the Airwaves', Ontario Notations, Spring (2014), 32
<br><br>

Fava, Matthew, 'Evelyn Stroobach performed in Europe', Ontario Notations, Spring (2013), 8
<br><br>

Habermehl, Dirk, 'Lament', White Ribbon Campaign Newsletter, Spring (2009), 1
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 29, No. 1 (2023), 38
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 28, No. 3 (2022), 43
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 27, No. 2 (2021), 52
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 27, No. 1 (2021), 50
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 26, No. 1 (2020), 38
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 25, No. 2 (2019), 42
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 24, No. 2 (2018), 46
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 23, No. 2 (2017), 62
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 23, No. 1 (2017), 50
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 22, No. 1 (2016), 49
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 21, No. 2 (2015), 62
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 21, No. 1 (2015), 57
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 20, No. 2 (2014), 61-62
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 20, No. 1 (2014), 57-58
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 19, No. 2 (2013), 57
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 19, No. 1 (2013), 52-53
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 18, No. 2 (2012), 56
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 18, No. 1 (2012), 55-56
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 17, No. 2 (2011), 65
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 17, No. 1 (2011), 56
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 16, No. 2 (2010), 60
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 16, No. 1 (2010), 48
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 15, No. 2 (2009), 59
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 15, No. 1 (2009), 59
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 14, No. 2 (2008), 63
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 14, No. 1 (2008), 46
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 13, No. 2 (2007), 70-71
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 13, No. 1 (2007), 53
<br><br>

Hanawalt, Anita, 'Members' News: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 12, No. 2 (2006), 59
<br><br>

Hayes, Jim, 'Evelyn Stroobach: Aurora Borealis', TBSO Curtain Call, (2008-2009), 17-18
<br><br>

Kim, Joo Yeon Tarina, 'Evelyn Stroobach', The Solo Piano Music of Selected Contemporary Canadian Women Composers: Database, Audio Samples, and Annotated Bibliography, (2011), 32, 118-121, 175, 178-179
<br><br>

Lucia, Margaret, 'Evelyn Stroobach: Aurora Borealis', Journal of the International Alliance for Women in Music, Volume 13, No. 1 (2007), 32-33
<br><br>

Masis, Julie, ‘70 years after the Holocaust, a Surinamese memorial for Caribbean victims’, The Times of Israel, (December 13, 2016)
<br><br>

Mermelstein, Julia, ‘Evelyn Stroobach’, The Association of Canadian Women Composers, Spring / Summer Journal (2019), 30
<br><br>

Meyer, Eve, 'Evelyn Stroobach: Aboriginal Inspirations', Journal of the International Alliance for Women in Music, Volume 23, 
<br><br>

No. 2 (2017), 45
<br><br>

Meyer, Eve, 'Evelyn Stroobach: Reverberations of Aboriginal Inspirations', Journal of the International Alliance for Women in Music, Volume 23, No. 1 (2017), 33
<br><br>

Meyer, Eve, 'Honors for Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 22, No. 1 (2016), 39- 40
<br><br>

Meyer, Eve, 'Congratulations to Award Winners: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 15, No. 2 (2009), 55
<br><br>

Meyer, Eve, 'Congratulations to Award Winners!: Evelyn Stroobach', Journal of the International Alliance for Women in Music, Volume 14, No. 1 (2008), 26-27
<br><br>

Murray, Aury, 'Demystifying Modes', Canadian National Conservatory of Music Newsletter, Volume 2 Issue 7, (January, 2008), 6 
<br><br>

Orlando, Stephanie, ‘Evelyn Stroobach’, ACWC/AFCC SoundBox: October 2024
<br><br>

Orlando, Stephanie, ‘Evelyn Stroobach’, ACWC/AFCC SoundBox: January 2023
<br><br>

Orlando, Stephanie, ‘Evelyn Stroobach’, ACWC/AFCC SoundBox: November 2022
<br><br>

Orlando, Stephanie, ‘Evelyn Stroobach’, ACWC/AFCC SoundBox: June 2022
<br><br>

Orlando, Stephanie, ‘Evelyn Stroobach’, ACWC/AFCC SoundBox: March 2022
<br><br>

Orlando, Stephanie, ‘Evelyn Stroobach’, ACWC/AFCC SoundBox: November 2021
<br><br>

Orlando, Stephanie, ‘Evelyn Stroobach’, ACWC/AFCC SoundBox: August 2021
<br><br>

Orlando, Stephanie, ‘Evelyn Stroobach’, ACWC/AFCC SoundBox: March 2021
<br><br>

Orlando, Stephanie, ‘Evelyn Stroobach’, ACWC/AFCC SoundBox: February 2021
<br><br>

Orlando, Stephanie, ‘Evelyn Stroobach’, ACWC/AFCC SoundBox: May 2020
<br><br>

Orlando, Stephanie, ‘Evelyn Stroobach’, ACWC/AFCC SoundBox: January 2020
<br><br>

Orlando, Stephanie, ‘Evelyn Stroobach’, ACWC/AFCC SoundBox: December 2019
<br><br>

Ouellette, Jeannine, 'Women in Ottawa: Mentors and Milestones', Celebrating the Story of Women as Makers of History, (2012)
<br><br>

Perlman, David, ‘Ottawa Chamberfest,’ The WholeNote: Concert Listings, (July 1- September 7, 2012), 48
<br><br>

Reid, Darlene Chepil, 'Postcard from Thunder Bay', Ontario Notations, Winter (2009), 4
<br><br>

Robb, Peter, 'She's in Rare Company: Ottawa pianist among small number of female composers', The Ottawa Citizen, (August 6, 2012), A1
<br><br>

Robb, Peter, 'An artist and a teacher', The Ottawa Citizen, (August 4, 2012), A2
<br><br>

Rumancik, Maryanne, 'Medieval Tales: The Art of the Mode', MRMTA Take Note, Volume 3, Issue 3, Spring (2007), 41
<br><br>

Sibley, Robert, 'Change coming, natives promised', Ottawa Citizen, (October 28, 2015), A1, A8
<br><br>

Steinberg, Jacob, ‘Bereft’, Israelitishe Gemeente Suriname, (March 18, 2016), 29
<br><br>

Steinberg, Jacob, ‘The Story of Abraham Samuel Fernandes’, Chai Vekayam, (December 2014), 1-3
<br><br>

Steinberg, Jacob, ‘The Ceremony’, Chai Vekayam, (April 2016), 4
<br><br>

Strachan, Jeremy, 'A String of Performances for Stroobach', Ontario Notations, fall (2012), 17
<br><br>

Stroobach, Evelyn, ‘Holocaust - Remembrance’, Journal of the International Alliance for Women in Music, Volume 28, No. 4 
<br><br>

(2022), 33
<br><br>

Stroobach, Evelyn, ‘Special Edition’, Chai Vekayam, (January 2020), 1-8
<br><br>

Stroobach, Evelyn, 'Reverberations of Aboriginal Inspirations', Journal of the International Alliance for Women in Music, Volume 21, No. 2 (2015), 54
<br><br>

Stroobach, Evelyn, Medieval Tales: The Art of the Mode, Oceanna Music Publications, (2005)
<br><br>

Todd, Richard, 'String quartet draws warm response: New Music Now, Day 1', Ottawa Citizen, (August 7, 2012), C8
<br><br>

Truhlar, Richard, 'Independents: Aurora Borealis: Compositions by Evelyn Stroobach', Living Music: Compact Discs New Releases, (2007), 31
<br><br>

Tuduka, Oszkar, 'The Soaring Spirit', Bihari-Naplo: Naprakesz, (2008)
<br><br>

Turnevicius, Leonard, ‘Rileys and the HPO’, The Hamilton Spectator, (November 1, 2018), G3
<br><br>

van Eyk, Jason, 'Canadian Composers Across America', Ontario Notations, Winter (2011), 19
<br><br>

van Eyk, Jason, 'Evelyn Stroobach in Central Asia', Ontario Notations, Winter (2010), 21
<br><br>

van Eyk, Jason, 'Evelyn Stroobach in Romania', Ontario Notations, Winter (2009), 22
<br><br>

van Eyk, Jason, 'Hear the Music', Ontario Notations, Winter (2009), 18-19
<br><br>

van Eyk, Jason, 'Evelyn Stroobach Nominated in JPF Awards', Ontario Notations, Fall (2009), 26
<br><br>

van Eyk, Jason, 'Hear the Music', Ontario Notations, Winter (2008), 10
<br><br>

van Eyk, Jason, 'Evelyn Stroobach in Europe', Ontario Notations, Winter (2008), 19
<br><br>

van Eyk, Jason, 'Regional Postcards', Ontario Notations, Fall (2008), 3
<br><br>

van Eyk, Jason, 'Surge of CDs for Ontario Associates', Ontario Notations, Winter (2007), 23
<br><br>

van Eyk, Jason, 'Welcome to a New Associate Composer', Ontario Notations, Summer (2006), 14
<br><br>

Ware, Evan, 'Regional Postcards', Ontario Notations, Fall (2008), 3
<br><br>

Weaver, Carol Ann, 'Aboriginal Inspirations', Journal of the International Alliance for Women in Music, Volume 25, No. 1 (2019), 28-29
<br><br>

Weaver, Carol Ann, 'In Celebration as ACWC/ACC Turns 40: Finding Our "Necessary" Voices', Association of Canadian Women Composers, Spring Journal (2021), 6-7
<br><br>

Weaver, Carol Ann, 'Member Opportunities and News', Association of Canadian Women Composers, Spring Journal (2021), 53
				`
			}
		}
	]);

	new nexCard({
		'to': myNav.getTab('Concerts')
	}).card([
		{
			'card': 'body',
			'child': {
				'card': 'text',
				'html': `
					National Symphony Orchestra and Chorus of Teleradio-Moldova in Chisinau performed 
					<br><br>
					Holocaust - Remembrance
					<br><br>
					Stroobach’s Holocaust - Remembrance is dedicated to the six million Jews, including members of Stroobach’s own family, who were murdered during the Shoah, the largest scale genocide the world has ever known. Stroobach’s choice to compose Holocaust - Remembrance for orchestra and SATB chorus in 60-minutes and six movements is symbolic of the six million Jews killed during the Holocaust. With this work, Stroobach wishes to honour those who were murdered during the Shoah simply because they were Jews and to remember them with respect and dignity. Stroobach also wishes to create awareness/educate audiences about the Shoah with the powerful message of “never again”.
					<br><br>
					Holocaust - Remembrance received a world premiere performance by the National Symphony Orchestra and Chorus of Teleradio-Moldova in Chisinau on January 27th, 2023, International Holocaust Remembrance Day (https://t.co/vrbKyHloY3)
					<br><br>
					(https://www.facebook.com/teleradiomoldova/videos/3243084146003184/?extid=CL-UNK-UNK-UNK-IOS_GK0T-GK1C&mibextid=2Rb1fB&ref=sharing). Maestro Romeo Rimbu (http://www.romeorimbu.ro/repertoire/) conducted Holocaust - Remembrance during this concert performance. Before the performance, Maestro Rimbu talked about the work, explaining that it is rich in Jewish religious/cultural symbolism. He also talked about the composers’ background and that Holocaust - Remembrance is dedicated to Stroobach’s great-uncle, Abraham Samuel Fernandes (https://yvng.yadvashem.org/index.html?language=en&s_id=&s_last), who was murdered by the Nazis for fighting in the resistance in the Netherlands during WWII. The concert was broadcasted live on the radio, which could be heard throughout Europe. The concert could also be viewed/heard throughout the world via the internet. 
					<br><br>
					A Prayer for Peace performed at Carnegie Hall 
					<br><br>
					Stroobach’s composition written in three contrasting movements for solo viola, entitled A Prayer for Peace, received a world premiere concert performance at the composers’ division of the Laureate Gala at Carnegie Hall in New York City on November 21, 2022 (https://www.progressivemusicians.com/evelyn-stroobach). The concert violist, Ralitsa Tcholakova performed the work.
					<br><br>





					Solar Flare included in the ACWC (Association of Canadian Women Composers) 
					<br><br>

					Educational Piano Music Catalogue
					<br><br>




					As of September 2022, Stroobach’s piano composition entitled Solar Flare is included in the ACWC (Association of Canadian Women Composers) Educational Piano Music Catalogue. Solar Flare is approximately at the grade 9 or 10 RCM (Royal Conservatory of Music) level. Solar Flare, to be performed con fuoco, is a fiery work for solo piano which programmatically depicts the blazingly hot solar flares as they violently fling off the surface of the sun. The work is available through the CMC (Canadian Music Centre) and the composer.
					<br><br>





					Petition performed at McGill University in Montreal
					<br><br>




					Stroobach’s composition for solo guitar entitled Petition received a concert performance by Doctor of Music candidate Razvan Benza at McGill University in Montreal on May 31, 2022. For this concert, Stroobach prepared a short video where she discussed the work. Benza’s research focuses on classical guitar compositions written by Canadian women guitarists/composers. A recording of the work by Ottawa guitarist Garry Elliott can be found on her Aurora Borealis CD (https://cmccanada.org/shop/cd-esnb-20062/) on track # 10. 
					<br><br>




					Holocaust - Remembrance - Movement VI - Lament
					<br><br>




					For her PhD, Stroobach has composed a work for orchestra and SATB chorus, entitled Holocaust - Remembrance. On October 25, 2021, the 13-minute Movement VI entitled Lament was workshopped by the Sheffield University Symphony Orchestra in the UK under the baton of Dr Cayenna Ponchione-Bailey.
					<br><br>




					Ligeti Quartet workshopped The Negotiations
					<br><br>




					On June 29, 2021, three of the five movements of Stroobach's 20-minute composition for string quartet entitled The Negotiations were workshopped by the Ligeti Quartet in London, UK.
					<br><br>





					Stroobach presented her doctoral research at the University of Sheffield in England
					<br><br>




					On April 23, 2021, Stroobach, who is a PhD candidate in Music Composition at the University of Sheffield in England, presented her research and six movement composition for SATB chorus and orchestra entitled Holocaust - Remembrance before fellow PhD students and professors in the Department of Music. In preparation for her presentation, Stroobach prepared a 10 minute, 40 second video also titled Holocaust Remembrance. After her presentation, Stroobach answered questions.
					<br><br>





					Association of Canadian Women Composers 
					<br><br>

					airs Stroobach's compositions
					<br><br>




					The Association of Canadian Women Composers (ACWC), of which Stroobach is a member, is celebrating its 40th anniversary. As of February 2021, three of Stroobach's compositions have been included on the ACWC's playlist. On the list are Stroobach's:
					<br><br>




					1) Aurora Borealis composed for orchestra and performed by the Ottawa Symphony Orchestra under the baton of Maestro David Currie: (https://acwc.ca/acwc-anniversary-playlists/ - see July 2021) and (https://soundcloud.com/acwc-acc/evelyn-stroobach-aurora-borealis?in=acwc-acc/sets/october-2024 - see October 2024)
					<br><br>

					2) Daydream composed for carillon and performed by Gordon Slater, Canada's former Dominion Carillonneur and recorded onto CD at the Peace Tower Carillon at the Houses of Parliament in Ottawa:
					<br><br>

					(https://acwc.ca/acwc-anniversary-playlists/ - see April 2021), and;
					<br><br>

					3) Dark Blue composed for alto saxophone and piano and recorded by Doug Martin performing the alto saxophone and Stroobach playing the piano: (https://acwc.ca/acwc-anniversary-playlists/ - see March 2021).
					<br><br>




					Dark Blue receives radio broadcast in Poland
					<br><br>




					Stroobach's composition Dark Blue composed for alto saxophone and piano was broadcasted on ZAIKS radio in Poland between April 1 and June 30, 2021.
					<br><br>




					Nonet performed on television out of Miami, Florida
					<br><br>




					Stroobach's composition for chamber orchestra entitled Nonet received a television broadcast on December 27, 2020 out of Miami, Florida by Newartmusik.
					<br><br>




					Crepuscule and Fanfare receive radio broadcast in South Korea
					<br><br>




					Stroobach's compositions Crepuscule composed for harpsichord and Fanfare composed for organ were broadcasted on KOMCA radio in South Korea between April 1 and June 30, 2020.
					<br><br>




					Nonet performed in Vienna, Austria
					<br><br>



					Stroobach's composition for chamber orchestra entitled Nonet received a European premier performance in Vienna, Austria at the Kaisersaal on November 2, 2019, by the Euroamerican Newartmusic Sinfonietta, under the baton of Maestro Christian Wenzel. The three movement Nonet, as the name implies, is composed for nine instruments: flute, oboe, clarinet in Bb, bassoon, violin I, violin II, viola, violoncello and contrabass. This Euroamerican Fest concert was given to honour the bicentennial anniversary of Clara Schumann and was dedicated to women composers. Stroobach was the Canadian representative at the concert.
					<br><br>




					Meastra Sylvia Constantinidis, concert organizer, wrote: “Concert went great. Every one likes your piece. Congrats. !!!!”
					<br><br>




					Preconcert press: 
					<br><br>

					https://www.venezuelasinfonica.com/sylvia-constantinidis-brillara-en-viena-como-pianista-y-compositora/ 
					<br><br>

					https://correocultural.com/2019/11/sylvia-constantinidis-brillara-en-viena-como-pianista-y-compositora/ 
					<br><br>

					https://www.entornointeligente.com/sylvia-constantinidis-brillar-en-viena-como-pianista-y-compositora/ 
					<br><br>




					Postconcert press: 
					<br><br>

					https://globovision.com/article/el-festival-euroamerican-se-estreno-exitosamente-en-viena https://www.venezuelasinfonica.com/el-festival-euroamerican-se-estrena-exitosamente-en-viena/ 
					<br><br>

					http://www.eluniversal.com/entretenimiento/55084/pianista-venezolana-presente-en-el-festival-euroamerican-en-viena 
					<br><br>

					https://www.analitica.com/emprendimiento/noti-tips/newartmusik-inicio-el-2022-con-importante-concierto-online/ 
					<br><br>

					https://www.analitica.com/emprendimiento/noti-tips/newartmusik-estrena-documental-sobre-clara-schumann-en-su-metaverso/ 
					<br><br>




					A write-up by Stephanie Orlando about the concert was also published in the ACWC/AFCC SoundBox: December 2019 internet publication. 
					<br><br>




					Excerpts from Aurora Borealis and Aboriginal Inspirations CDs played at the 
					<br><br>

					University of Sheffield in England
					<br><br>




					Matt Jones, Departmental Administration Manager in the Department of Music at the University of Sheffield in England, informed Stroobach that on September 18, 2019, during a Music Faculty “Welcome Back” event, excerpts from her Aurora Borealis and Aboriginal Inspirations CDs were played and Stroobach was acknowledged as the composer.
					<br><br>



					Hamilton Philharmonic Orchestra and the Bach Elgar Choir of Hamilton performed
					<br><br>

					In Flanders Fields
					<br><br>




					Stroobach's composition for SATB chorus and string orchestra entitled In Flanders Fields received a live concert performance by the Hamilton Philharmonic Orchestra and the Bach Elgar Choir of Hamilton on November 10, 2018. Maestra Gemma New conducted the orchestra for this concert performance. 
					<br><br>

					On November 1, 2018 The Hamilton Spectator, under the title Rileys and the HPO wrote “but also a moment of solemnity with Evelyn Stroobach’s setting for chorus and strings of John McCrae’s poem, “In Flanders Fields.”
					<br><br>

					(https://www.pressreader.com/canada/the-hamilton-spectator/20181101/282187947021619)
					<br><br>




					Aurora Borealis performed in Paris, France
					<br><br>




					Stroobach's orchestral composition entitled Aurora Borealis received a second live concert performance at the Euroamerican Festival of Contemporary Music by the Tutti Maestro Orchestra of Venezuela in Paris, France on November 3, 2018. Maestro Christian Wenzel conducted the orchestra in this concert performance. 
					<br><br>




					Maestra Constantinidis wrote: “Maestro Wenzel ... loved your Aurora Borealis... - as did the musicians also.”
					<br><br>




					The following articles were published about the concert:
					<br><br>

					http://www.contrapunto.com/noticia/estampas-de-espana-con-sello-venezolano-brillaran-en-paris-en-formato-sinfonico-232253/
					<br><br>

					https://www.revistavenezolana.com/2018/11/pianista-sylvia-constantinidis-se-presenta-en-paris-con-estampas-de-espana/
					<br><br>

					https://crestametalica.com/estampas-de-espana-con-sello-venezolano-brillaron-en-paris-con-sonidos-sinfonicos/
					<br><br>




					Aurora Borealis received its first live concert performance at the Euroamerican Festival of Contemporary Music by the Tutti Maestro Orchestra of Venezuela in Paris, France on July 28, 2018. Maestra Sylvia Constantinidis conducted the orchestra in this concert performance. Maestra Constantinidis wrote: “We are inviting the embassies in Paris. So I will write your embassy to let them know of your participation and invite them for the concert.” Maestra Constantinidis also wrote: “There has been quite a bit of press.” 
					<br><br>




					Aria for Strings performed in Chisinau, Moldova
					<br><br>




					Stroobach's composition for string orchestra entitled Aria for Strings received a live concert performance by the National Symphony Orchestra of Teleradio-Moldova in Chisinau on September 8, 2018. Maestro Kypros Markou conducted the orchestra in this concert performance. In addition to the audience members, thousands of people were listening to the concert, which was broadcasted on the radio, television, and the internet. 
					<br><br>




					Maestro Markou wrote: “Regarding Aria for Strings, I came to understand better and better why you wrote it the way you did. I must also say that I became very fond of this piece... I really appreciate your music; I believe that there is a lot more in it than what appears at first. I am actually eager to explore more of your music.”
					<br><br>




					Zabrze Philharmonic of Poland performed Dark Blue
					<br><br>




					Stroobach's composition for alto saxophone and orchestra entitled Dark Blue received a live concert performance by the Zabrze Philharmonic of Poland in honour of Women's International Day on March 23, 2018. Maestro Jerzy Kosek conducted the orchestra for this concert performance and Arthur Kika performed the solo saxophone part: (https://drive.google.com/file/d/1P_kbkv69R1IXGAJpiscVQEYBO31VWMze/view).
					<br><br>





					Dark Blue performed in Chisinau, Moldova
					<br><br>




					Stroobach's composition for alto saxophone and orchestra entitled Dark Blue received a live concert performance by the National Symphony Orchestra of Teleradio-Moldova in Chisinau on September 10, 2017. Maestro Gary Cheung conducted the orchestra in this concert performance and Alexei Litvin performed the solo saxophone part. In addition to the audience members, thousands of people were listening to the concert which was broadcasted on the radio, television, and the internet.
					<br><br>




					Alexei Litvin, the saxophonist, wrote the following: “I love the work. I was a little surprised when I played it for the first time with the orchestra because I found the accompaniment very original. Working only on the solo part, I didn’t imagine the orchestra role. The work has good energy, is bright, but also with nice romantic shades. The sax register was in a good ambitus. I loved to play this piece." 

					<br><br>



					Daydream for Carillon performed at the Peace Tower Carillon 
					<br><br>

					at the Houses of Parliament in Ottawa, Canada
					<br><br>




					As part of celebrating Canada’s 150th birthday, Stroobach’s composition entitled Daydream composed for carillon received another performance on July 18th, 2017 at the Peace Tower Carillon at the Houses of Parliament in Ottawa, Canada by Gordon Slater, the former Dominion Carillonneur, during his summer Carillon Recital.
					<br><br>




					Stroobach Named as Composer of the Week by the 
					<br><br>

					International Alliance for Women in Music
					<br><br>




					The International Alliance for Women in Music Advocacy Committee asks that its members telephone or e-mail local and/or Internet radio stations during June 18-24, 2017, requesting that they play music by Evelyn Stroobach.
					<br><br>

					As usual, the selection, which is different every week, has been made by Ursula Rempel. The selections, she explains, "are based on a combination of factors: availability of CDs, geography/nationality, accessibility/appeal of the music for general audiences, and a concern to feature both historical and contemporary women composers." 
					<br><br>




					Previously, in August 5-11, 2007, Stroobach was also named composer of the week by the International Alliance for Women in Music.
					<br><br>




					Carol Ann Weaver, Professor Emerita Conrad Grebel University College University of Waterloo and fellow International Alliance for Women in Music member wrote: “Your work is truly impressive, your track record strong, your performance lists impressive.”
					<br><br>
					Aurora Borealis performed in Chisinau, Moldova
					<br><br>
					Stroobach's orchestral composition entitled Aurora Borealis received a live concert performance by the National Symphony Orchestra of Teleradio-Moldova in Chisinau on February 3, 2017. Maestro Howie Ching conducted the orchestra in this concert performance. In addition to the audience members, thousands of people were listening to the concert which was broadcasted on the radio, television and the internet.
					<br><br>
					Stroobach was interviewed by Teleradio-Moldova via Skype from her home in Ottawa, Canada before the concert.
					<br><br>
					Bereft was performed by Symphony New Brunswick’s 
					<br><br>
					‘Virtuoso Series’, starring the Saint John String Quartet 
					<br><br>
					All four movements of Stroobach's composition entitled Bereft composed for duo strings received three live concert performances in New Brunswick, Canada in December 2016. (http://symphonynb.com/events/spectral-adventures/) On December 8 the work was performed at McCain Hall at Saint Thomas University in Fredericton, on December 10 the work was performed at Place Resurgo Place in Moncton and on December 11 Bereft was performed at the Saint John Arts Centre in Saint John (https://www.sjartscentre.ca/2016/11/18/symphonynb/). These three concerts were part of Symphony New Brunswick’s ‘Virtuoso Series’, featuring the Saint John String Quartet. Danielle Sametz, Principle Second Violin player, with Symphony New Brunswick, performed the violin part and Andrew Reed Miller, Principle Double Bass player, also with the SNB, performed the double bass part. Andrew Miller wrote: “We enjoyed playing it, especially the 3rd and 4th movements! The audience dug it too, I remember hearing them sort of gasp a couple times when we finished the last note, as the visceral angry energy is so strong there.”
					<br><br>
					Jennifer Grant, the General Manager of Symphony New Brunswick, wrote: “ The audience really enjoyed your piece.”
					<br><br>
					Bereft
					<br><br>
					I - Contemplatively
					<br><br>
					II - Intensity
					<br><br>
					III - Lament
					<br><br>
					IV - Angrily
					<br><br>
					Canary Burton, producer and host of the radio program The Latest Score at WOMR radio, who broadcasts out of Provincetown, Massachusetts, wrote the following about Bereft: “I love that you are using atonality IN THE SERVICE OF MUSIC. (it's a rare thing). The rhythm held it. It seems in the second movement you ease up a bit and sort of spread out maybe get a breath of air. In the third movement. WOWSER! That lick is very cool. It's very listenable. Ah, that waving back and forth before it seems a great dive! Oh the intensity. Again, using the atonal or maybe the a tonal is beautiful in your hands, well in your mind. Mysterioso, lurking about the mind on slippered feet.... You bring that from straight up to misery in no time. Introspection until the cello comes back and energizes the violin with interesting intervals sawed.... And it ends!"
					<br><br>
					Embassy of the Kingdom of the Netherlands
					<br><br>
					On April 26, 2016 Stroobach was invited by the Ambassador Extraordinary and Plenipotentiary of the Kingdom of the Netherlands, Mr. Cees J. Kole and his wife Mrs. Saskia Kole-Jordans, to celebrate King’s Day at the Canadian Museum of History in Ottawa. King’s Day is the official birthday of the Dutch king: His Majesty King Willem – Alexander. The previous month, Stroobach had represented the Embassy of the Kingdom of the Netherlands as the Dutch representative at the Women of Note concert that was held in Ottawa on March 19, 2016.
					<br><br>
					On April 27, 2017 Stroobach was invited by Mr. Henk van der Zwanhe, the Ambassador at the Embassy of the Kingdom of the Netherlands, to celebrate King’s Day at the Canada Aviation and Space Museum in Ottawa.
					<br><br>
					Stroobach was invited to the Senate at the Houses of Parliament in Ottawa
					<br><br>
					On April 20th, 2016, Stroobach whose composition Fire Dance is included on the Aboriginal Inspirations CD was invited by His Excellency Ambassador Dr. Nikolay Milkov and Vice President of Ottawa Region Bulgarian Foundation, Ms Ralitsa Tcholakova, to attend the Annual General Meeting of the Canada-Bulgaria Inter-Parliamentary friendship group. This meeting was hosted by Senator Yonah Martin in the Senate at the Houses of Parliament in Ottawa.
					<br><br>
					Stroobach was acknowledged during this meeting for her contribution as a composer to this historically significant CD project. Also present during this meeting was the Right Honourable Adrienne Clarkson, (former Governor General of Canada), the European Union's Ambassador Marie-Anne Coninsx, as well as other ambassadors, senators and Members of Parliament.
					<br><br>
					Fire Dance recorded onto a CD entitled 
					<br><br>
					Aboriginal Inspirations in Toronto
					<br><br>
					On April 12th, 2016 Stroobach travelled from Ottawa to Toronto to record her composition Fire Dance at Kuhl Muzik Studio. Fire Dance is to be included on a CD entitled Aboriginal Inspirations. Ron Korb (whose CD Asia Beauty was nominated for a Grammy Award) performed the flute, Ralitsa Tcholakova performed the viola and Dominique Moreau performed the drum part. 
					<br><br>
					Into the Wind and Fire Dance were performed at the 
					<br><br>
					Women of Note concert at the European Union Delegation to Canada in Ottawa
					<br><br>
					Stroobach received a request from Anna Rijk, Senior Advisor Public Diplomacy, Press & Cultural Affairs of the Embassy of the Kingdom of the Netherlands, to be the Dutch representative at a program titled Women of Note, a concert of music by European Female Composers presented by the European Union Delegation to Canada (https://www.musiccentre.ca/node/138302). Stroobach attended alongside representatives, ambassadors, and ministers from the Embassies and Cultural Institutes of Austria, Bulgaria, Ireland, Poland, Portugal, Romania, Slovakia, and Spain as well as the Netherlands. The concert took place at the Shenkman Arts Centre in Ottawa on March 19, 2016. 
					<br><br>
					Two of Stroobach’s works, Into the Wind for solo violin and Fire Dance for flute, viola and Aboriginal drum, received a live performance at the concert. Ralitsa Tcholakova performed the solo violin part in Into the Wind. Jennifer McLachlen, flute; Ralitsa Tcholakova, viola; and Dominique Moreau, Aboriginal drum, performed Fire Dance. The European Union's Ambassador Marie-Anne Coninsx, Anna Rijk, as well as other representatives from the Dutch Embassy, representatives, and ambassadors from a number of other countries as well as ministers were in the audience.
					<br><br>
					Marie-Anne Coninsx began this special evening with a thought-provoking speech about women’s achievements in the music world. Stroobach gave a brief talk in both Dutch and English thanking the Embassy of the Kingdom of the Netherlands for asking her to be the Dutch representative at the Women of Note concert and introducing her two compositions that were performed as well as the talented musicians who performed her music. After the concert the Dutch Embassy presented Stroobach with a beautiful bouquet of flowers and a lovely card. In the card Anna Rijk wrote: “Dear Ms Stroobach/Evelyn, Thank you for a beautiful concert, for setting a perfect example of how women can achieve all the desires in their heart and for touching hearts with your pieces. Also, on behalf of Ambassador Kole, thank you so much for making this evening a success. Kindest regards Anna Rijk, Netherlands Embassy.”
					<br><br>
					Anna Rijk also wrote: “All in all, it was a very successful event, and your contribution was really substantial to the mix of the pieces performed. Thank you again for the kind word expressed on stage with regards of our embassy. It was greatly appreciated.”
					<br><br>
					Dr. Maya Badian, a Romanian – Canadian composer, who attended the Women of Note concert wrote: “I enjoyed listening to your music and I appreciate your gift of composing naturally blended with an interesting manner of structuring your works. I very much like the musical techniques you have chosen to express your musical thoughts ... I also liked how you were dressed – chic and in fashion!”
					<br><br>
					Bereft was performed at a Holocaust Memorial Ceremony in 
					<br><br>
					Paramaribo, Suriname, South America
					<br><br>
					The Jewish community of Suriname, on the northeastern coast of South America, is the oldest continuous Jewish community in the Americas. During the Inquisition in Portugal and Spain in the late-fifteenth century, many Jews fled to Holland and to the Dutch colonies to escape torture and condemnation to the stake. Many of the Jews who went to Holland departed later for the Dutch colony of Suriname, arriving as early as the 1630s.
					<br><br>
					Stroobach felt deeply honoured that her composition titled Bereft was performed in Paramaribo, the capital city of Suriname, on March 18, 2016 during a ceremony of the “Unveiling of the Memorial Monument,” which was created “In Loving Memory of Those who Perished in the Holocaust” to honour and remember the 104 Surinamese Jews who were killed in the Shoah during World War II. This ceremony took place at the Neve Shalom Synagogue in Paramaribo. (http://www.surinamejewishcommunity.com/#!synagogues/c4fi) The stone monument has the names of all 104 Surinamese Jews inscribed on it. (https://www.timesofisrael.com/70-years-after-the-holocaust-a-surinamese-memorial-for-caribbean-victims/)(http://www.bevrijdingintercultureel.nl/bi/eng/surijoods.html)
					<br><br>
					The ceremony began with speeches given by members of the community, Suriname officials and the Ambassador of Israel to Suriname. This was followed by a performance of Stroobach’s composition Bereft, which was performed by the string section of the Eddy Snijders Orchestra of Suriname, conducted by Maestra Rielle Mardjo. The work was performed to commemorate her great-uncle Abraham (Bram) Fernandes, a resistance fighter and a member of the Geuzen resistance group, who was arrested by the Germans and tortured to death at the Oranjehotel, a German prison in Scheveningen in March 1941. After the performance, additional speeches were given, and the theme from Schindler's List was performed during the carrying of the wreath. In remembrance of the six million Jews who were murdered in the Second World War, six red roses were laid on the remaining three sides of the Memorial Monument by children of prominent members of the Surinamese and/or Jewish Community. The “Unveiling of the Memorial Monument” ceremony was attended by ambassadors and representatives from Argentina, Brazil, France, Germany, Guyana, Israel, The Netherlands, and the USA as well as religious leaders from the Catholic, Protestant, Muslim and Hindu communities.  
					<br><br>
					The tour company “Suriname Jewish Heritage Tours” recognized Holocaust Remembrance Day, on May 2, 2019, by visiting the Holocaust Memorial Monument at Neve Shalom Synagogue in Paramaribo.
					<br><br>
					(https://www.facebook.com/SurinameJewishHeritageTours/photos/pcb.2710672635625891/2710672075625947/?type=3&theater)
					<br><br>
					January 27, 2020 was the 75th anniversary of the liberation of the Auschwitz-Birkenau concentration camps. Stroobach was asked to write an article which was published in the Chai Vekayam (https://kulanu.org/wp-content/uploads/Chai-News-January-2020.pdf) for this occasion. Among the readers of the Chai Vekayam are Dr. Alexander Avram, the Director of the Hall of Names at the Yad Vashem, as well as others who work at the Holocaust Museum in Jerusalem. Also, Jacques Grishaver, the Chairman of the Dutch Auschwitz Committee, and Aisley Henrique, the leader of the Jamaican Jewish community are among the newsletter’s subscribers.
					<br><br>
					From the readers of the article, Stroobach has received the following comments:
					<br><br>
					“Thank you for sharing this remarkable story. It is an unbelievable story how they survived those terrible times."
					<br><br>
					"You (the editor) are doing outstanding work! We will never forget.”
					<br><br>
					“This remarkable story really had a profound effect on me.”
					<br><br>
					“It was very interesting--and very moving--to read this article, in which you clearly documented the experience of your family during the Shoah and WWII. Thank you for sharing it with me. I think there is great importance for current generations in communicating the suffering of previous generations, who were not always willing or able to share their experiences publicly.”
					<br><br>
					“Very profound is the only way I can describe it. The world can be a horrible place, I have seen acts of cruelty and horror in person.  It can also have friendship, love and inspiration. I hope your family finds eternal peace.”  
					<br><br>
					On January 27, 2020, Holocaust Remembrance Day, a ceremony to commemorate the 104 Surinamese Jews who were murdered during the Holocaust was held in front of the Memorial Monument at the Neve Shalom Synagogue in Paramaribo.
					<br><br>
					In the ACWC/AFCC SoundBox: May 2020 internet publication, Stephanie Orlando wrote, “This article by Evelyn Stroobach on the liberation of the Auschwitz-Birkenau concentration camps, was published in the “Chai Vekayam” and received heartfelt reviews. Read it here!”
					<br><br>
					Fire Dance was performed in concert at the Wabano Centre in Ottawa, Canada
					<br><br>
					Stroobach's composition Fire Dance received a live concert performance at the Wabano Centre, in Ottawa, Canada as part of the Aboriginal celebration “Harvest Moon Extravaganza” on October, 27, 2015
					<br><br>
					(http://www.wabano.com/events/wabano-events/harvest-moon-2015/). Jennifer McLachlen performed the flute, Ralitsa Tcholakova performed the viola and Melissa Hammell, an Aboriginal drummer, performed the drum part. They were very fortunate to be able to choreograph Fire Dance with Lisa Odjig, an internationally known Ojibwe hoop dancer. A thought provoking, energy charged welcome speech about 'what it means when someone has placed their trust in you' was given by Prime Minister Justin Trudeau's wife, Sophie Gregoire-Trudeau. Sophie Gregoire-Trudeau's speech was immediately followed by the performance of Stroobach's work. Sophie Gregoire-Trudeau graciously listened to Fire Dance.
					<br><br>
					The following morning, October 28, 2015 the “Harvest Moon Extravaganza” event made front page news in the Ottawa Citizen which included a photo of Sophie Gregoire-Trudeau. More about the event and Sophie Gregoire-Trudeau's speech can be found on A8. (http://www.pressreader.com/canada/ottawa-citizen/20151028/281479275276823/TextView)
					<br><br>
					Fire Dance performed in the Senate at the Houses of Parliament in Ottawa 
					<br><br>
					Stroobach's composition entitled Fire Dance composed for flute, viola and Aboriginal drum, was performed in the Senate at the Houses of Parliament in Ottawa on May 28th, 2015. The concert was entitled Reverberations of Aboriginal Inspirations. Jennifer McLachlen performed the flute, Ralitsa Tcholakova performed the viola and Dominique Moraeu the Aboriginal drum. 
					<br><br>
					Stroobach gave a brief talk about her composition Fire Dance before it was performed. Present in the audience were the Right Honourable Adrienne Clarkson, (former Governor General of Canada), her husband (John Ralston Saul), the Honourable Shelley Glover (Minister of Canadian Heritage who proudly shared with us that she is Metis), Ambassadors and High Commissioners from various countries. There were Members of Parliament, leaders from the Aboriginal Community (Chiefs) and a number of photographers.
					<br><br>
					After the noon hour concert, the musicians were escorted through the corridors of Parliament by security where they were led to the House of Commons to be recognized. All the musicians' names were displayed on the screen. A speech was given honouring our Reverberations of Aboriginal Inspirations concert and the musicians were asked to stand. 
					<br><br>
					Aria for Strings performed in Constanta, Romania
					<br><br>
					Stroobach's composition for string orchestra entitled Aria for Strings was performed by the Constanta Symphony Orchestra in Constanta, Romania on May 22nd, 2015. Maestro Eldred Marshall conducted the orchestra in this concert performance:
					<br><br>
					http://www.mp3tunes.tk/download?v=s0Bg45bU9AI.
					<br><br>
					Fire Dance performed at Reverberations of Aboriginal Inspirations Concert in Ottawa
				`
			}
		}
	]);

	new nexTable({
		'to': myNav.getTab('Compositions').frag({
			'tag': 'section',
			'cls': {
				'add': 'container-fluid'
			}
		}).nodes.section[0],
		'border': true,
		'striped': true,
		'hover': true
	}).table([
		{
			'table': 'thead',
			'child': {
				'table': 'tr',
				'child': [
					{
						'table': 'td',
						'text': 'Title'
					},
					{
						'table': 'td',
						'text': 'Gendre'
					},
					{
						'table': 'td',
						'text': 'Duration'
					},
					{
						'table': 'td',
						'text': 'Year'
					}
				]
			}
		},
		{
			'table': 'tbody',
			'child': [
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>Holocaust – Remembrance</i>'
						},
						{
							'table': 'td',
							'text': 'Orchestra and SATB chorus'
						},
						{
							'table': 'td',
							'text': '60’'
						},
						{
							'table': 'td',
							'text': '2024'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>The Wanderer</i>'
						},
						{
							'table': 'td',
							'text': 'String quartet'
						},
						{
							'table': 'td',
							'text': '10’'
						},
						{
							'table': 'td',
							'text': '2024'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>Resistance</i>'
						},
						{
							'table': 'td',
							'text': 'Percussion ensemble and two violins (8 instruments)'
						},
						{
							'table': 'td',
							'text': '8’'
						},
						{
							'table': 'td',
							'text': '2023'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>A Prayer for Peace</i>'
						},
						{
							'table': 'td',
							'text': 'Solo viola'
						},
						{
							'table': 'td',
							'text': '12’'
						},
						{
							'table': 'td',
							'text': '2023'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>Fire Dance</i>'
						},
						{
							'table': 'td',
							'text': 'Flute, viola and Aboriginal drum'
						},
						{
							'table': 'td',
							'text': '4’'
						},
						{
							'table': 'td',
							'text': '2016'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>Into the Wind</i>'
						},
						{
							'table': 'td',
							'text': 'Solo violin'
						},
						{
							'table': 'td',
							'text': '15’'
						},
						{
							'table': 'td',
							'text': '2012'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>Crepuscule</i>'
						},
						{
							'table': 'td',
							'text': 'Orchestra'
						},
						{
							'table': 'td',
							'text': '7’'
						},
						{
							'table': 'td',
							'text': '2011'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>Dark Blue</i>'
						},
						{
							'table': 'td',
							'text': 'Orchestra and alto saxophone'
						},
						{
							'table': 'td',
							'text': '6’05'
						},
						{
							'table': 'td',
							'text': '2011'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>In Flanders Fields</i>'
						},
						{
							'table': 'td',
							'text': 'SATB chorus and string quartet'
						},
						{
							'table': 'td',
							'text': '10’'
						},
						{
							'table': 'td',
							'text': '2006'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>Sweetest love, I do not go</i>'
						},
						{
							'table': 'td',
							'text': 'SATB chorus and string quartet'
						},
						{
							'table': 'td',
							'text': '10’'
						},
						{
							'table': 'td',
							'text': '2005'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>Medieval Tales: The Art of the Mode</i>'
						},
						{
							'table': 'td',
							'text': '6 junior piano solos'
						},
						{
							'table': 'td',
							'text': '10’'
						},
						{
							'table': 'td',
							'text': '2005'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>Dark Blue</i>'
						},
						{
							'table': 'td',
							'text': 'Piano and alto saxophone'
						},
						{
							'table': 'td',
							'text': '6’05'
						},
						{
							'table': 'td',
							'text': '2005'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>Petition</i>'
						},
						{
							'table': 'td',
							'text': 'Guitar'
						},
						{
							'table': 'td',
							'text': '7’20'
						},
						{
							'table': 'td',
							'text': '2005'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>Bereft</i>'
						},
						{
							'table': 'td',
							'text': 'Violin and violoncello'
						},
						{
							'table': 'td',
							'text': '9’50'
						},
						{
							'table': 'td',
							'text': '2004'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>Crepuscule</i>'
						},
						{
							'table': 'td',
							'text': 'Harpsichord'
						},
						{
							'table': 'td',
							'text': '6’50'
						},
						{
							'table': 'td',
							'text': '2004'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>O Come, O Come, Emmanuel</i>'
						},
						{
							'table': 'td',
							'text': 'SATB chorus and violoncello'
						},
						{
							'table': 'td',
							'text': '5’30'
						},
						{
							'table': 'td',
							'text': '2003'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>Aurora Borealis</i>'
						},
						{
							'table': 'td',
							'text': 'Orchestra'
						},
						{
							'table': 'td',
							'text': '5’10'
						},
						{
							'table': 'td',
							'text': '1995'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>Nonet</i>'
						},
						{
							'table': 'td',
							'text': 'Woodwind quartet and string quintet'
						},
						{
							'table': 'td',
							'text': '9’35'
						},
						{
							'table': 'td',
							'text': '1993'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>The Human Abtract</i>'
						},
						{
							'table': 'td',
							'text': 'Soprano, Flute, Viola and Violoncello'
						},
						{
							'table': 'td',
							'text': '7’30'
						},
						{
							'table': 'td',
							'text': '1992'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>La petite danse</i>'
						},
						{
							'table': 'td',
							'text': 'String orchestra'
						},
						{
							'table': 'td',
							'text': '2’15'
						},
						{
							'table': 'td',
							'text': '1992'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>Daydream</i>'
						},
						{
							'table': 'td',
							'text': 'Carillon'
						},
						{
							'table': 'td',
							'text': '6’50'
						},
						{
							'table': 'td',
							'text': '1992'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>Fanfare</i>'
						},
						{
							'table': 'td',
							'text': 'Organ'
						},
						{
							'table': 'td',
							'text': '2’40'
						},
						{
							'table': 'td',
							'text': '1992'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>Aria for Strings</i>'
						},
						{
							'table': 'td',
							'text': 'String orchestra'
						},
						{
							'table': 'td',
							'text': '11’10'
						},
						{
							'table': 'td',
							'text': '1989'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>Etude for Percussion</i>'
						},
						{
							'table': 'td',
							'text': 'Percussion ensemble (9 instruments)'
						},
						{
							'table': 'td',
							'text': '1’45'
						},
						{
							'table': 'td',
							'text': '1989'
						}
					]
				},
				{
					'table': 'tr',
					'child': [
						{
							'table': 'td',
							'html': '<i>Solar Flare</i>'
						},
						{
							'table': 'td',
							'text': 'Piano solo'
						},
						{
							'table': 'td',
							'text': '1’40'
						},
						{
							'table': 'td',
							'text': '1989'
						}
					]
				},
			]
		}
	])

	console.log(Arr.lengths(["apple", "banana", "kiwi"], ',', false)) // 4
	console.log(Arr.lengths(["apple", "banana", "kiwi"], ',', true)) // 6


	/*
	myNav.getTab('Home').class({
		'add': 'row'
	}).frag(tmpa);

	new nexCard({
		'to': myNav.getTab('Home').nodes.section[0]
	}).card([
		{
			'card': 'header',
			'text': 'Posix-Nexus',
			'cls': {
				'add': 'h4'
			}
		},
		{
			'card': 'body',
			'child': {
				'card': 'text',
				'text': `
					Welcome to POSIX-Nexus, a cutting-edge open-source project dedicated to enhancing the performance of the POSIX shell. By leveraging the power of awk, sed, and c90 backends, we bring speed and efficiency to data manipulation and script execution, all while staying true to POSIX standards for compatibility and portability.
				`
			}
		},
		{
			'card': 'footer'
		}
	]);

	new nexCard({
		'to': myNav.getTab('Home').nodes.section[1]
	}).card([
		{
			'card': 'header',
			'text': 'Why Choose POSIX-Nexus?',
			'cls': {
				'add': 'h4'
			}
		},
		{
			'card': 'body',
			'child': [
				{
					'card': 'subtitle',
					'tag': 'h5',
					'text': 'Seamless Compatibility'
				},
				{
					'card': 'text',
					'text': `
						Built to adhere to the POSIX draft 1003.2 (draft 11.3) standards, ensuring reliable functionality across a broad range of UNIX-like operating systems.
					`
				}
			]
		},
		{
			'card': 'body',
			'child': [
				
				{
					'card': 'subtitle',
					'tag': 'h5',
					'text': 'Enhanced Performance'
				},
				{
					'card': 'text',
					'text': `
						Supercharges data processing using optimized awk, sed, and c90 utilities, perfect for handling large datasets and complex tasks.
					`
				}
			]
		},
		{
			'card': 'body',
			'child': [
				
				{
					'card': 'subtitle',
					'tag': 'h5',
					'text': 'Unparalleled Portability'
				},
				{
					'card': 'text',
					'text': `
						Designed for effortless integration into various environments without the need for modifications.
					`
				}
			]
		},
		{
			'card': 'footer'
		}
	]);
	*/
});
