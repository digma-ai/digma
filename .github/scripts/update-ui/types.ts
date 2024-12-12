export interface UIDependenciesDiff {
  release: string;
  dependencies: Record<string, string>;
}

type UIDependenciesRelease = Record<string, string>;

export interface UIDependencies {
  releases: Record<string, UIDependenciesRelease>;
}

const isObject = (
  x: unknown
): x is Record<string | number | symbol, unknown> =>
  typeof x === "object" && x !== null;

export const isUIDependenciesDiff = (obj: unknown): obj is UIDependenciesDiff => 
  isObject(obj) &&
  !Array.isArray(obj) &&
  typeof obj.release === 'string' &&
  isObject(obj.dependencies) &&
  !Array.isArray(obj.dependencies) &&
  Object.values(obj.dependencies).every(value => typeof value === 'string')

export const isUIDependenciesRelease = (obj: unknown): obj is UIDependenciesRelease => 
  isObject(obj) &&
  !Array.isArray(obj) &&
  Object.values(obj).every(value => typeof value === 'string')

export const isUIDependencies = (obj: unknown): obj is UIDependencies =>
  isObject(obj) &&
  !Array.isArray(obj) &&
  isObject(obj.releases) &&
  Object.values(obj.releases).every(isUIDependenciesRelease)

