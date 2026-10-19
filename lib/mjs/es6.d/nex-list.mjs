export const List = {};
List.getList = function(value)
{
	if ((value ?? '') === '')
		return [];
	if (value instanceof Set || Array.isArray(value))
		return value;
	return [value];
}
List.getArray = function(value)
{
	if ((value ?? '') === '')
		return [];
	if (value instanceof Set)
		return Array.from(value);
	return Array.isArray(value) ? value : [value];
}
List.getSet = function(value)
{
	if ((value ?? '') === '')
		return new Set();
	if (value instanceof Set)
		return value;
	return new Set(Array.isArray(value) ? value : [value]);
}
List.add = function(value)
{
	if (Array.isArray(value))
		return value.push;
	if (value instanceof Set)
		return value.add;
	return null;
}
List.flatten = function(value)
{
	return [...List.getArray(value).filter(row => row.some(cell => cell !== "")).map(row => row[0])];
}

List.toCSV = function(value) {
	return value.map(v => `${String(v).replace(/,/g, '\\,')}`).join(",");
}
List.size = function(value)
{
	if (Array.isArray(value))
		return value.length;
	if (value instanceof Set)
		return value.size;
	return -1;
}

