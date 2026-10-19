import { List } from "./nex-list.mjs";

export const Fallback = {};
Fallback.firstMatch = function(list, type, fallback)
{
  for(const item of List.getArray(list)) {
    if (typeof item === type)
      return item;
  }
  return fallback;
}
Fallback.firstRange = function(list, range, fallback)
{
  const start = parseInt(range[0] ?? 0);
  const end = parseInt(range[1] ?? 0);
  const skip = parseInt(range[2] ?? 1);
  for(const item of List.getArray(list)) {
    const number = parseInt(item);
    if (number >= start && number <= end && number % skip === 0)
      return number;
  }
  return fallback;
}

