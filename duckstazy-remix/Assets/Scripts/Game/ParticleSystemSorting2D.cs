using UnityEngine;
using System.Collections;

[RequireComponent(typeof(ParticleSystem))]
public class ParticleSystemSorting2D : MonoBehaviour {

	public string SortingLayerName = "Default";
	public int SortingOrder;

	// Use this for initialization
	void Start () {
		var psRenderer = GetComponent<ParticleSystem>().GetComponent<Renderer>();
		psRenderer.sortingLayerName = SortingLayerName;
		psRenderer.sortingOrder = SortingOrder;
	}

	#if UNITY_EDITOR
	// Update is called once per frame
	void Update () {
		var psRenderer = GetComponent<ParticleSystem>().GetComponent<Renderer>();
		if (psRenderer != null) {
			psRenderer.sortingLayerName = SortingLayerName;
			psRenderer.sortingOrder = SortingOrder;
		}
	}
	#endif
}

