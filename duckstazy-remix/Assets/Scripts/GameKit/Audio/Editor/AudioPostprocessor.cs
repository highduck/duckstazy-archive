using UnityEditor;

class AudioPostprocessor : AssetPostprocessor {
	internal void OnPreprocessAudio() {
		var audioImporter = assetImporter as AudioImporter;
		if (audioImporter == null) {
			return;
		}

		audioImporter.forceToMono = true;
		audioImporter.hardware = false;
		audioImporter.threeD = true;
		if (assetPath.Contains("Sound")) {
			//audioImporter.format = AudioImporterFormat.Native;
			// audioImporter.loadType = UnityEngine.AudioClipLoadType.DecompressOnLoad;
			// audioImporter.compressionBitrate = 96000;
		}
		else if (assetPath.Contains("Music") || assetPath.Contains("Ambient")) {
			//audioImporter.format = AudioImporterFormat.Compressed;
			// audioImporter.loadType = UnityEngine.AudioClipLoadType.Streaming;
			// audioImporter.compressionBitrate = 96000;
		}
	}
}