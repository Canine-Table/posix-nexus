export const TypeCheck = {};

TypeCheck.isNormal = function(value)
{
  return value !== "" &&
    value !== null &&
    value !== undefined &&
    value !== Infinity &&
    value !== -Infinity &&
    !Number.isNaN(value);
}
TypeCheck.isObject = function(value)
{
  return typeof value === 'object' &&
    value !== null &&
    !(TypeCheck.isList(value) ||
    value instanceof Map ||
    value instanceof WeakMap);
}
TypeCheck.isPlainObject = TypeCheck.isObject;
TypeCheck.isNormalPrimitive = function(value)
{
  return TypeCheck.isNormal(value) &&
    typeof value !== 'object' &&
    typeof value !== 'function';
}
TypeCheck.isPrimitive = function(value)
{
  return value === null ||
    typeof value !== 'object' &&
    typeof value !== 'function';
}
TypeCheck.isClass = function(value)
{
  return typeof value === 'function' && /^\s*class\s+/.test(value.toString());
}
TypeCheck.isImage = function(value)
{
  return (
    value &&
    typeof value === 'object' &&
    typeof value.getContentType === 'function' &&
    /^image\/.*$/i.test(value.getContentType())
  );
}
TypeCheck.isDocument = function(value)
{
  if (
    !value ||
    typeof value !== 'object' ||
    typeof value.getContentType !== 'function'
  ) return false;

  const mime = value.getContentType().toLowerCase();

  return (
    mime === 'application/pdf' ||
    mime === 'application/msword' ||
    mime === 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' ||
    mime === 'text/plain' ||
    mime === 'text/markdown' ||
    mime === 'application/rtf' ||
    mime === 'application/vnd.oasis.opendocument.text'
  );
}
TypeCheck.isUrl = function(value) {
  try {
    new URL(value);
    return true;
  } catch {
    return false;
  }
}
TypeCheck.isList = function(instance)
{
  return Array.isArray(instance) || instance instanceof Array || instance instanceof Set || instance instanceof WeakSet;
}
TypeCheck.isPair = function(instance)
{
  return TypeCheck.isObject(instance) || instance instanceof Map || instance instanceof WeakMap;
}
TypeCheck.isValidKey = function(instance)
{
  if (instance instanceof Map || TypeCheck.isList(instance))
    return (value) => TypeCheck.isNormal(value);
  else if (TypeCheck.isObject(instance))
    return (value) => TypeCheck.isNormal(value) && !(typeof value === 'object' || typeof value === 'function');
  else if (Array.isArray(instance))
    return (value) => parseInt(value) === Number(value);
  else
    return () => null;
}
TypeCheck.isBoolean = function(value)
{
  return typeof value === 'boolean' || value instanceof Boolean;
}

