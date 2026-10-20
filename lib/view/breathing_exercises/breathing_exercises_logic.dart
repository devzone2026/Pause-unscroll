import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pause_and_scroll/backend/helper/appRoute.dart';
import '../../backend/models/get_breathing_techniques_model.dart';
import '../../backend/models/get_music_model.dart';
import '../../utils/appAssets.dart';
import 'breathing_exercises_state.dart';

enum BreathPhase { inhale, hold, exhale }
enum SessionStatus { idle, running, paused }

class BreathingExercisesLogic extends GetxController {
  final BreathingExercisesState state;
  BreathingExercisesLogic({required this.state});

  // ─── Data ──────────────────────────────────────────────────────────────────
  List<DemoBreathingExercisesModel> demoList = [];
  GetBreathingTechniquesModel breathingTech = GetBreathingTechniquesModel();
  GetMusicModel getMusicList = GetMusicModel();
  BreathTechBody workingBreathClass = BreathTechBody();
  MusicBody musicBody = MusicBody();
  bool isThisExercise = true;
  RxBool saveLoader = false.obs;


  // ─── Observables ───────────────────────────────────────────────────────────
  final RxInt currentTab                = 0.obs;
  final RxInt elapsedSeconds            = 0.obs;
  final Rx<SessionStatus> sessionStatus = SessionStatus.idle.obs;
  final Rx<BreathPhase> breathingPhase  = BreathPhase.inhale.obs;
  final RxInt phaseCountdown            = 0.obs;
  final RxBool exerciseComplete         = false.obs;
  final RxInt setTimeLimit              = 10.obs; // minutes
  final RxInt remainingSeconds          = 0.obs;  // countdown in seconds

  // ─── Private state ─────────────────────────────────────────────────────────
  Timer? masterTimer;
  int _elapsed        = 0;
  int _phaseRemaining = 0;
  int _inhale = 0, _hold = 0, _exhale = 0;
  int totalSecondSaved = 0;
  String songID = "";
  final player = AudioPlayer();

  static const List<BreathPhase> _cycle = [
    BreathPhase.inhale,
    BreathPhase.hold,
    BreathPhase.exhale,
  ];

  // ─── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _populateDemoList();
      breathingTechniquesApi();
      meditationMusicApi();
      update();
    });
  }

  @override
  void onClose() {
    masterTimer?.cancel();
    super.onClose();
  }

  // ─── Demo list ─────────────────────────────────────────────────────────────
  void _populateDemoList() {
    demoList = [
      DemoBreathingExercisesModel(
        title: "Breathing Exercises",
        subTitle: "Come back to yourself",
        icon: AssetPath.iconMaterial,
        desc: "Practice mindful breathing techniques and calming meditation sessions to center yourself",
      ),
      DemoBreathingExercisesModel(
        title: "Meditation",
        subTitle: "Music & Timer",
        icon: AssetPath.iconMusic,
        desc: "Practice mindful breathing techniques and calming meditation sessions to center yourself",
      ),
    ];
  }

  // ─── Navigation ────────────────────────────────────────────────────────────
  void startSession() {
    workingBreathClass = breathingTech.data![currentTab.value];
    Get.toNamed(AppRouter.startBreathingScreen);
    update();
  }

  // ─── Toggle (single button entry point) ────────────────────────────────────
  void toggleSession() {
    if (exerciseComplete.value) return;
    if (isThisExercise) {
      _toggleBreathingSession();
    } else {
      _toggleMeditationSession();
    }
  }

  void _toggleBreathingSession() {
    switch (sessionStatus.value) {
      case SessionStatus.idle:    _startSession();
      case SessionStatus.running: _pauseSession();
      case SessionStatus.paused:  _resumeSession();
    }
  }

  void _toggleMeditationSession() {
    switch (sessionStatus.value) {
      case SessionStatus.idle:    _startTimer();
      case SessionStatus.running: pause();
      case SessionStatus.paused:  resume();
    }
  }

  // ─── Meditation timer ───────────────────────────────────────────────────────

  /// Progress 0.0 → 1.0 — uses fixed setTimeLimit so it never shrinks
  double get progress {
    final totalSeconds = setTimeLimit.value * 60;
    if (totalSeconds == 0) return 0.0;
    return (elapsedSeconds.value / totalSeconds).clamp(0.0, 1.0);
  }

  void _startTimer() async{
    await player.setLoopMode(LoopMode.all);
    player.play();
    remainingSeconds.value = setTimeLimit.value * 60; // minutes → seconds
    elapsedSeconds.value   = 0;
    sessionStatus.value    = SessionStatus.running;
    _tick();
  }

  void pause() {
    player.pause();
    masterTimer?.cancel();
    sessionStatus.value = SessionStatus.paused;
  }

  /// Continues from remainingSeconds — does NOT reset
  void resume() {
    player.play();
    sessionStatus.value = SessionStatus.running;
    _tick();
  }

  void stop() {
    player.stop();
    masterTimer?.cancel();
    totalSecondSaved       = setTimeLimit.value;
    sessionStatus.value    = SessionStatus.idle;
    remainingSeconds.value = 0;
    elapsedSeconds.value   = 0;
  }

  /// Shared tick — used by both _startTimer() and resume()
  void _tick() {
    masterTimer?.cancel();
    masterTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds.value <= 0) {
        stop();
        return;
      }
      elapsedSeconds.value++;
      remainingSeconds.value--;
      debugPrint("⏱ elapsed: ${elapsedSeconds.value} | remaining: ${remainingSeconds.value}");
    });
  }

  // ─── Breathing session ─────────────────────────────────────────────────────
  void _startSession() {
    _elapsed = 0;
    elapsedSeconds.value   = 0;
    exerciseComplete.value = false;

    _inhale = workingBreathClass.inhale ?? 0;
    _hold   = workingBreathClass.hold   ?? 0;
    _exhale = workingBreathClass.exhale ?? 0;

    _beginPhase(BreathPhase.inhale);
    sessionStatus.value = SessionStatus.running;
    _startMasterTimer();
  }

  void _pauseSession() {
    masterTimer?.cancel();
    sessionStatus.value = SessionStatus.paused;
  }

  void _resumeSession() {
    sessionStatus.value = SessionStatus.running;
    _startMasterTimer();
  }

  void stopSession({required bool value}) => _stopSession(completed: value);

  void _stopSession({required bool completed}) {
    masterTimer?.cancel();
    sessionStatus.value    = SessionStatus.idle;
    _elapsed               = 0;
    totalSecondSaved       = elapsedSeconds.value == 0 ? setTimeLimit.value : elapsedSeconds.value;
    elapsedSeconds.value   = 0;
    phaseCountdown.value   = 0;
    exerciseComplete.value = completed;
    update();
  }

  // ─── Master timer (breathing — drives elapsed + phase countdown) ────────────
  void _startMasterTimer() {
    masterTimer?.cancel();
    masterTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsed++;
      elapsedSeconds.value = _elapsed;

      _phaseRemaining--;
      phaseCountdown.value = _phaseRemaining;

      if (_phaseRemaining <= 0) _advancePhase();
    });
  }

  // ─── Phase management ──────────────────────────────────────────────────────
  void _beginPhase(BreathPhase phase) {
    breathingPhase.value = phase;
    _phaseRemaining      = durationFor(phase);
    phaseCountdown.value = _phaseRemaining;
  }

  void _advancePhase() {
    final cycle = _activeCycle;
    if (cycle.isEmpty) {
      _stopSession(completed: true);
      return;
    }
    final nextIndex = (cycle.indexOf(breathingPhase.value) + 1) % cycle.length;
    _beginPhase(cycle[nextIndex]);
  }

  List<BreathPhase> get _activeCycle {
    final cycle = <BreathPhase>[];
    if (_inhale > 0) cycle.add(BreathPhase.inhale);
    if (_hold   > 0) cycle.add(BreathPhase.hold);
    if (_exhale > 0) cycle.add(BreathPhase.exhale);
    return cycle;
  }

  int durationFor(BreathPhase phase) => switch (phase) {
    BreathPhase.inhale => _inhale,
    BreathPhase.hold   => _hold,
    BreathPhase.exhale => _exhale,
  };

  // ─── Reset ─────────────────────────────────────────────────────────────────
  void resetSession() {
    masterTimer?.cancel();
    _elapsed        = 0;
    _phaseRemaining = 0;
    _inhale         = 0;
    _hold           = 0;
    _exhale         = 0;

    player.stop();
    elapsedSeconds.value   = 0;
    sessionStatus.value    = SessionStatus.idle;
    breathingPhase.value   = BreathPhase.inhale;
    phaseCountdown.value   = 0;
    exerciseComplete.value = false;
    remainingSeconds.value = 0;
    workingBreathClass     = BreathTechBody();
    update();
  }

  // ─── API ───────────────────────────────────────────────────────────────────
  Future<void> breathingTechniquesApi() async {
    try {
      final response = await state.breathingTechniquesState();
      if (response?.statusCode == 200) {
        final map = Map<String, dynamic>.from(response!.data as Map);
        debugPrint("Breathing Tech. Response :: $map");
        breathingTech = GetBreathingTechniquesModel.fromJson(map);
        update();
      }
    } catch (error) {
      debugPrint("breathingTechniquesApi error: $error");
    }
  }

  Future<void> meditationMusicApi() async {
    try {
      final response = await state.meditationMusicState();
      if (response?.statusCode == 200) {
        final map = Map<String, dynamic>.from(response!.data as Map);
        debugPrint("Music Response :: $map");
        getMusicList = GetMusicModel.fromJson(map);
        update();
      }
    } catch (error) {
      debugPrint("meditationMusicApi error: $error");
    }
  }

  Future<void> saveBreathingTechniquesApi({
    required int totalSecond,
    required String breathId,
    required String? musicId,
  }) async {
    try {
      final data = {
        "totalMeditationTime": totalSecond,
        "breathingId": breathId,
        "musicId": musicId ?? "",
        "type": isThisExercise ? "breathing" : "meditation",
      };
      debugPrint("body :: $data");
      final response = await state.saveBreathingTechniquesState(data);
      if (response?.statusCode == 200) {
        final map = Map<String, dynamic>.from(response!.data as Map);
        debugPrint("Save Breathing Tech. Response :: $map");
        saveLoader.value = false;
        update();
        Get.back();
      }
    } catch (error) {
      debugPrint("saveBreathingTechniquesApi error: $error");
    }
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  /// Formats seconds as MM:SS, or HH:MM:SS if hours > 0
  String formatTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;

    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // Convenience getters for the UI
  bool get isRunning => sessionStatus.value == SessionStatus.running;
  bool get isPaused  => sessionStatus.value == SessionStatus.paused;
  bool get isIdle    => sessionStatus.value == SessionStatus.idle;

  /// Human-readable phase label for the UI
  String get phaseLabel => switch (breathingPhase.value) {
    BreathPhase.inhale => 'Inhale',
    BreathPhase.hold   => 'Hold',
    BreathPhase.exhale => 'Exhale',
  };
}