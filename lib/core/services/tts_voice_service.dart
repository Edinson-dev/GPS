import 'package:flutter_tts/flutter_tts.dart';

class TTSVoiceService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isMuted = false;

  TTSVoiceService() {
    _initTTS();
  }

  Future<void> _initTTS() async {
    try {
      await _flutterTts.setLanguage("es-ES");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
    } catch (e) {
      // Ignorar error si el dispositivo no soporta TTS sintético
    }
  }

  Future<void> speakInstruction(String text) async {
    if (_isMuted || text.isEmpty) return;
    try {
      await _flutterTts.stop();
      await _flutterTts.speak(text);
    } catch (e) {
      // Fallback silencioso
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
  }

  bool get isMuted => _isMuted;

  void dispose() {
    _flutterTts.stop();
  }
}
