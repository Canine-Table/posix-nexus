function switchTab(evt, id) {
		let tab = document.getElementsByClassName('container-tab');
		for (let i = 0; i < tab.length; i++)
			tab[i].style.display = 'none';
		let link = document.getElementsByClassName('tab-link');
		for (let i = 0; i < link.length; i++)
			link[i].className = link[i].className.replace(' active', '');
		document.getElementById(id).style.display = 'flex';
		evt.currentTarget.className += ' active';
}

