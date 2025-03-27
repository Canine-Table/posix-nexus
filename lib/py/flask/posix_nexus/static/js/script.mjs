import { Obj } from './js/obj.mjs';
import { Type } from './js/type.mjs';
import { Str } from './js/str.mjs';
import { Arr } from './js/arr.mjs';
import { nexAnime } from './js/anime.mjs';
import { Int } from './js/int.mjs';
import { nexLog } from './js/log.mjs';
import { nexClass } from './js/class.mjs';
import { nexForm } from './js/components/nex-form.mjs';
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

document.addEventListener('DOMContentLoaded', () => {

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
					'text': 'posix-nexus'
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
						'content': 'Canine-Table'
					}
				},
				{
					'tag': 'meta',
					'prop': {
						'name': 'description',
						'content': 'POSIX (Portable Operating System Interface) is a set of standards specified by the IEEE to ensure compatibility and portability across different operating systems.'
					}
				},
				{
					'tag': 'meta',
					'prop': {
						'name': 'keywords',
						'content': 'c90, sed, awk, posix, portability'
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
						'content': 'posix-nexus'
					}
				},
				{
					'tag': 'meta',
					'prop': {
						'property': 'og:description',
						'content': 'POSIX (Portable Operating System Interface) is a set of standards specified by the IEEE to ensure compatibility and portability across different operating systems.'
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
						'content': 'posix-nexus'
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
						'img/posix-nexus.png'
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
			'text': `© ${new Date().getFullYear()} posix-nexus, all rights reserved`,
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
					'text': 'Exploring the nexus'
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
					'src': 'static/img/posix-nexus.png',
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
			'text': 'Documentation',
		}
	}).link({
		'svg': '#tools',
		'link': {
			'text': 'Utilities',
		}
	}).link({
		'svg': '#text-body',
		'link': {
			'text': 'Examples',
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
	
	tmpa = [];
	for (let i = 0; i < 2; i++) {
		tmpa.push({
			'tag': 'section',
			'cls': {
				'add': 'container-fluid mb-4'
			}
		});
	}

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
});
