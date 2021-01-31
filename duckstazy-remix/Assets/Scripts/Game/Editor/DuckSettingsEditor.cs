using UnityEditor;
using UnityEngine;

[CustomEditor(typeof (DuckSettings))]
public class DuckSettingsEditor : Editor {

	[MenuItem("Assets/Create/Duck Settings")]
	public static void CreateAssetFromFiles() {
		var settings = CustomAssetUtility.CreateAsset<DuckSettings>("duck_settings");
		EditorUtility.SetDirty(settings);
	}

	[MenuItem("CONTEXT/BoxCollider2D/Make 3D")]
	public static void ConvertToBoxCollider(MenuCommand command) {
		var c2d = command.context as BoxCollider2D;
		var go = c2d.gameObject;
		var size = c2d.size;
		var center = c2d.offset;
		var isTrigger = c2d.isTrigger;
		DestroyImmediate(c2d);
		var c = go.AddComponent<BoxCollider>();
		c.size = size;
		c.center = center;
		c.isTrigger = isTrigger;
	}

	[MenuItem("CONTEXT/CircleCollider2D/Make 3D")]
	public static void ConvertToSphereCollider(MenuCommand command) {
		var c2d = command.context as CircleCollider2D;
		var go = c2d.gameObject;
		var radius = c2d.radius;
		var center = c2d.offset;
		var isTrigger = c2d.isTrigger;
		DestroyImmediate(c2d);
		var c = go.AddComponent<SphereCollider>();
		c.radius = radius;
		c.center = center;
		c.isTrigger = isTrigger;
	}

	[MenuItem("CONTEXT/Rigidbody2D/Make 3D")]
	public static void ConvertToRigidBody(MenuCommand command) {
		var r2d = command.context as Rigidbody2D;
		var go = r2d.gameObject;
		DestroyImmediate(r2d);
		var rb = go.AddComponent<Rigidbody>();
		rb.isKinematic = true;
		rb.constraints = RigidbodyConstraints.FreezePositionZ;
		rb.freezeRotation = true;
	}

}

