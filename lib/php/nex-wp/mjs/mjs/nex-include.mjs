
export class NxInclude {
	constructor(options = {}) {
		this.sigil = options.sigil ?? "#";
		this.directive = options.directive ?? "nx_include";
		this.searchPaths = options.searchPaths ?? [];
		this.cache = new Map();
		this.visited = new Set();
	}

	async load(url) {
		const abs = new URL(url, location.href).href;

		if (this.cache.has(abs))
			return this.cache.get(abs);

		if (this.visited.has(abs))
			throw new Error(`NxInclude: include cycle detected at ${abs}`);

		this.visited.add(abs);

		const text = await this.fetchText(abs);
		const expanded = await this.expandIncludes(text, abs);

		this.cache.set(abs, expanded);
		return expanded;
	}

	async fetchText(url) {
		const res = await fetch(url);
		if (!res.ok)
			throw new Error(`NxInclude: failed to fetch ${url}`);
		return await res.text();
	}

	async expandIncludes(text, baseUrl) {
		const lines = text.split(/\r?\n/);
		const out = [];

		const includeRegex = new RegExp(
			`^\\s*${this.sigil}${this.directive}\\s+([^\\s]+)`
		);

		for (let line of lines) {
			const m = line.match(includeRegex);

			if (!m) {
				out.push(line);
				continue;
			}

			const includeName = m[1];
			const resolved = await this.resolvePath(includeName, baseUrl);

			if (!resolved)
				throw new Error(`NxInclude: cannot resolve ${includeName}`);

			const includedText = await this.load(resolved);
			out.push(includedText);
		}

		return out.join("\n");
	}

	async resolvePath(name, baseUrl) {
		// Relative to the current file
		{
			const rel = new URL(name, baseUrl).href;
			if (await this.exists(rel))
				return rel;
		}

		// Search paths
		for (const sp of this.searchPaths) {
			const candidate = new URL(name, sp).href;
			if (await this.exists(candidate))
				return candidate;
		}

		return null;
	}

	async exists(url) {
		const res = await fetch(url, { method: "HEAD" });
		return res.ok;
	}
}

