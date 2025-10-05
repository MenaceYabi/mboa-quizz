// Service audio minimal qui ne requiert pas de dépendance externe.
// Cette version évite les erreurs d'analyse si `audioplayers` n'a pas
// été récupéré. Pour une version complète, installez `audioplayers`
// et remplacez ce fichier.

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  AudioService._internal();

  Future<void> playBackground(String assetPath, {bool loop = true}) async {
    // no-op
    return;
  }

  Future<void> stopBackground() async {
    // no-op
    return;
  }

  Future<void> playClick({String assetPath = 'assets/sounds/click.mp3'}) async {
    // no-op
    return;
  }
}
