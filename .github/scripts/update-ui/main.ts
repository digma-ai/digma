const uiDependenciesPath = "../../../ui_dependencies.json";
const uiDependenciesDiffPath = "../../../ui_dependencies_diff.json";

import { isUIDependencies, isUIDependenciesDiff, UIDependencies, UIDependenciesDiff } from "./types.ts";

const DEPENDENCY_RENAME_MAP: Record<string, string> = {
  jetBrainsPluginVersion: "minJetbrainsPluginVersion"
}

try {
  const uiDependenciesDiffText = await Deno.readTextFile(uiDependenciesDiffPath);
  const uiDependenciesDiffObject = JSON.parse(uiDependenciesDiffText);

  if (!isUIDependenciesDiff(uiDependenciesDiffObject)) {
    throw new Error("Invalid format in ui_dependencies_diff.json");
  }

  const uiDependenciesText = await Deno.readTextFile(uiDependenciesPath);
  const uiDependenciesObject = JSON.parse(uiDependenciesText);

  if (!isUIDependencies(uiDependenciesObject)) {
    throw new Error("Invalid format in ui_dependencies.json");
  }

  const uiDependencies: UIDependencies = uiDependenciesObject;
  const uiDependenciesDiff: UIDependenciesDiff = uiDependenciesDiffObject;
  const dependencies = Object.entries(uiDependenciesDiff.dependencies).reduce((acc, [key, value]) => {
    const newKey = DEPENDENCY_RENAME_MAP[key] || `min${key[0].toUpperCase()}${key.slice(1)}`;
    acc[newKey] = value;
    return acc;
  }, {} as Record<string, string>);
  
  uiDependencies.releases[uiDependenciesDiff.release] = dependencies;
  
  const updatedUIDependenciesText = JSON.stringify(uiDependencies, null, 4);
  await Deno.writeTextFile(uiDependenciesPath, updatedUIDependenciesText);
  
  console.log("ui_dependencies.json has been updated successfully.");
} catch (error) {
  console.error("Error updating ui_dependencies.json:", error);
}