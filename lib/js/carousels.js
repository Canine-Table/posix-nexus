#!/usr/bin/env node
function addCarousel(obj)
{
	if (isObjectType(obj)) {
		obj.theme = isDefinedType(obj.theme, 'dark');
		obj.id = getTagId(obj.id, '-carousel');
		if (isDefinedType(obj.auto))
			obj.prop.data-bs-ride = 'carousel';
		let tag = addTag({
			'tag': 'div',
			'id': `carousel${obj.id}`,
			'to': obj.to,
			'clsSet': `carousel slide bg-body-tertiary ${obj.clsOut}`,
			'prop': {
				'data-bs-theme': obj.theme
			}
		});
		addProp(tag, obj);
		if (! isDefinedType(obj.to))
			document.body.appendChild(tag);
		if (isDefinedType(obj.ind)) {
			addTag({
				'tag': 'div',
				'id': `carousel${obj.id}Indicator`,
				'to': `carousel${obj.id}`,
				'clsSet': `carousel-indicators ${obj.clsInd}`,
			});
		}
		addTag({
			'tag': 'div',
			'id': `carousel${obj.id}Inner`,
			'to': `carousel${obj.id}`,
			'clsSet': `carousel-inner carousel slide bg-body-tertiary ${obj.clsIn}`,
		});
		if (isDefinedType(obj.prv) || isDefinedType(obj.btn))
			addCarouselButton(obj, 1);
		if (isDefinedType(obj.nxt) || isDefinedType(obj.btn))
			addCarouselButton(obj);
		return tag;
	}
}

function addCarouselButton(obj, loc)
{
	if (isObjectType(obj)) {
		if (isDefinedType(loc))
			var loc = 'next';
		else
			var loc = 'prev';
		if (isObjectType(getObjId(`carousel${obj.id}`)) && ! isObjectType(getObjId(`carousel${obj.id}Button${loc}`))) {
			addTag({
				'tag': 'button',
				'id': `carousel${obj.id}Button${loc}`,
				'to': `carousel${obj.id}`,
				'clsSet': `carousel-control-${loc}`,
				'prop': {
					'type': 'button',
					'data-bs-target': `#carousel${obj.id}`,
					'data-bs-slide': loc
				}
			});
			addTag({
				'tag': 'span',
				'id': `carousel${obj.id}Button${loc}Icon`,
				'to': `carousel${obj.id}Button${loc}`,
				'clsSet': `carousel-control-${loc}-icon`,
				'prop': {
					'aria-hidden': true
				}
			});
			addTag({
				'tag': 'span',
				'id': `carousel${obj.id}Button${loc}Label`,
				'to': `carousel${obj.id}Button${loc}`,
				'clsSet': 'visually-hidden',
				'txtAdd': loc
			});
		}
	}
}

function addCarouselItem(obj)
{
	if (isObjectType(getObjId(`carousel${obj.to}Inner`))) {
		let ind = getObjId(`carousel${obj.to}Indicator`);
		if (isObjectType(ind)) {
			let num = ind.childElementCount;
			if (num === 0)
				obj.clsInd = `${obj.clsInd} active`
			addTag({
				'tag': 'button',
				'id': `carouselItem${obj.id}${num}`,
				'to': `carousel${obj.to}Indicator`,
				'clsSet': obj.clsInd,
				'prop': {
					'data-bs-target': "#carouselExampleIndicators",
					'data-bs-slide-to': num,
					'aria-current': true,
					'aria-label': `Slide ${num + 1}`
				}
			});
		}
		if (getObjId(`carousel${obj.to}Inner`).childElementCount === 0)
			obj.clsCar = `${obj.clsCar} active`
		let tag = addTag({
			'tag': 'div',
			'id': `carouselItem${obj.id}`,
			'to': `carousel${obj.to}Inner`,
			'clsSet': `carousel-item ${obj.clsCar}`
		});
		addTag({
			'tag': 'img',
			'id': `carouselItem${obj.id}Image`,
			'to': `carouselItem${obj.id}`,
			'clsSet': `d-block w-100 ${obj.clsImg}`,
			'prop': {
				'alt': isDefinedType(obj.alt, '...'),
				'src': isDefinedType(obj.src, 'https://picsum.photos/2000/3000?random=1')
			}
		});
		addTag({
			'tag': 'div',
			'id': `carouselItem${obj.id}Caption`,
			'to': `carouselItem${obj.id}`,
			'clsSet': `carousel-caption d-none d-md-block ${obj.clsCap}`
		});
		if (isDefinedType(obj.hdr)) {
			addTag({
				'tag': `h${isDefinedType(obj.hdrnum, 5)}`,
				'id': `carouselItem${obj.id}CaptionHeader`,
				'to': `carouselItem${obj.id}Caption`,
				'txtAdd': obj.hdr
			});
		}
		if (isDefinedType(obj.par)) {
			addTag({
				'tag': 'p',
				'id': `carouselItem${obj.id}CaptionParagraph`,
				'to': `carouselItem${obj.id}Caption`,
				'txtAdd': obj.par
			});
		}
		return tag;
	}
}

