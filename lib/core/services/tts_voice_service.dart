import 'package:flutter_tts/flutter_tts.dart';

class TtsVoiceService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isMuted = false;

  bool get isMuted => _isMuted;

  TtsVoiceService() {
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage('es-ES');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      _flutterTts.stop();
    }
  }

  Future<void> speak(String text) async {
    if (_isMuted || text.isEmpty) return;
    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  Future<void> speakInstruction(String text) async {
    await speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
