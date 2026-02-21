export class NxForm
{
	constructor(title, fields = true) {
		this.form = document.createElement("form");
		if (fields) {
			this.fields = document.createElement("fieldset");
			this.form.appendChild(this.fields);
		} else {
			this.fields = this.form;
		}
		if (title) {
			fields = document.createElement("legend");
			fields.textContent = title;
			this.fields.appendChild(fields);
		}
	}

	// --- Structural primitives ---

	createFieldset(seed = {}) {
		const fs = document.createElement("fieldset");

		if (seed.legend) {
			const lg = document.createElement("legend");
			lg.textContent = seed.legend;
			fs.appendChild(lg);
		}

		if (seed.id) fs.id = seed.id;
		if (seed.class) fs.className = seed.class;

		return fs;
	}

	createField(name, config = {}) {
		const label = document.createElement("label");
		if (config.label) label.textContent = config.label;

		const input = this.#createInput(name, config);
		label.appendChild(input);

		return label;
	}

	#createInput(name, config) {
		const type = config.type || "text";

		let el;

		if (type === "textarea") {
			el = document.createElement("textarea");
		} else if (type === "select") {
			el = document.createElement("select");
			if (config.options) {
				for (const opt of config.options) {
					const o = document.createElement("option");
					o.value = opt.value;
					o.textContent = opt.label;
					el.appendChild(o);
				}
			}
		} else {
			el = document.createElement("input");
			el.type = type;
		}

		el.name = name;
		return el;
	}

	// --- Helpers ---

	addFieldset(seed, parent = this.fields) {
		const fs = this.createFieldset(seed);
		parent.appendChild(fs);
		return fs;
	}

	addFieldSets(seed, parent) {
		this.addFieldSets(seed, parent);
		return this;
	}

	addField(name, config, parent = this.fields) {
		const field = this.createField(name, config);
		if ([ 'checkbox', 'radio'].includes(config.type))
			field.appendChild(field.firstChild);
		field.classList.add(`nx-${config.type}`);
		parent.appendChild(field);
		
		return field;
	}

	addFields(name, config, parent) {
		this.addField(name, config, parent);
		return this;
	}

	getData() {
		const data = {};
		const fd = new FormData(this.form);
		for (const [k, v] of fd.entries()) data[k] = v;
		return data;
	}

	setData(obj) {
		for (const key in obj) {
			const el = this.form.querySelector(`[name="${key}"]`);
			if (el) el.value = obj[key];
		}
	}

	clear() {
		this.form.reset();
	}

	mailTo(sendTo) {
		this.form.addEventListener('submit', e => {
			e.preventDefault();
			const data = new FormData(this.form);
			let body = "";
			for (const [key, value] of data.entries())
				body += `${key}: ${value}\n`;
			document.querySelectorAll('input[type="checkbox"]').forEach(cb => {
				body += `${cb.name}: ${cb.checked ? 'yes' : 'no'}\n`;
			});
			const subject = "Offering Submission";
			const mailto = `mailto:${sendTo ?? 'entropy@origin.null'}?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`;
			window.location.href = mailto;
		});
		return this;
	}
}

