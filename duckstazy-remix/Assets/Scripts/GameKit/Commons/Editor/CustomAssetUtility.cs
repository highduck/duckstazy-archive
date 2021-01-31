using System.IO;
using UnityEditor;
using UnityEngine;

public static class CustomAssetUtility {
	public static T CreateAsset<T>(string name = null) where T : ScriptableObject {
		var asset = ScriptableObject.CreateInstance<T>();

		string path = AssetDatabase.GetAssetPath(Selection.activeObject);
		if (path == "") {
			path = "Assets";
		}
		else if (Path.GetExtension(path) != "") {
			path = path.Replace(Path.GetFileName(AssetDatabase.GetAssetPath(Selection.activeObject)), "");
		}
		if (string.IsNullOrEmpty(name)) {
			name = "New " + typeof (T).Name;
		}
		string assetPathAndName = AssetDatabase.GenerateUniqueAssetPath(path + "/" + name + ".asset");

		AssetDatabase.CreateAsset(asset, assetPathAndName);

		AssetDatabase.SaveAssets();
		EditorUtility.FocusProjectWindow();
		Selection.activeObject = asset;
		return asset;
	}
}