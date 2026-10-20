

class AssetPath {


  static const String _iconBasePath = "assets/icons/";
  static const String _imagesBasePath = "assets/images/";
  static const String _animationBasePath = "assets/animation/";

  static String _iconPath(String fileName) => _iconBasePath + fileName;
  static String _imagesPath(String fileName) => _imagesBasePath + fileName;
  static String _animationPath(String fileName) => _animationBasePath + fileName;



  //TODO: FOR ICONS(SVG FILE)
  static final iconApple = _iconPath("icon_apple.svg");
  static final iconEmail = _iconPath("icon_email.svg");
  static final iconGoogle = _iconPath("icon_google.svg");
  static final iconLock = _iconPath("icon_lock.svg");
  static final iconUnVisible = _iconPath("icon_visible.svg");
  static final iconVisible = _iconPath("icon_unvisible.svg");
  static final iconPerson = _iconPath("icon_person.svg");
  static final iconCancel = _iconPath("icon_cancel.svg");
  static final leftLine = _iconPath("left_line.svg");
  static final rightLine = _iconPath("right_line.svg");
  static final iconDel = _iconPath("icon_del.svg");
  static final iconEdit = _iconPath("icon_edit.svg");
  static final iconLogout = _iconPath("icon_logout.svg");
  static final iconNoti = _iconPath("icon_noti.svg");
  static final iconNotiNone = _iconPath("icon_notify_none.svg");
  static final iconSave = _iconPath("icon_save.svg");
  static final iconCamera = _iconPath("icon_camera.svg");
  static final iconApplee = _iconPath("icon_applee.svg");
  static final iconCalender = _iconPath("icon_calender.svg");
  static final iconHome = _iconPath("icon_home.svg");
  static final iconIdea = _iconPath("icon_idea.svg");
  static final iconMaterial = _iconPath("icon_material.svg");
  static final iconSparkles = _iconPath("icon_sparkles.svg");
  static final iconWorkout = _iconPath("icon_workout.svg");
  static final iconSmile = _iconPath("icon_smile.svg");
  static final iconMeditation = _iconPath("icon_meditation.svg");
  static final iconNote = _iconPath("icon_note.svg");
  static final iconDrop = _iconPath("icon_drop.svg");
  static final iconStop = _iconPath("icon_stop.svg");
  static final iconPlay = _iconPath("icon_play.svg");
  static final iconMusic = _iconPath("icon_music.svg");
  static final iconPlayer = _iconPath("icon_player.svg");
  static final iconKey = _iconPath("icon_key.svg");
  static final iconRecord = _iconPath("icon_record.svg");
  static final iconAdd = _iconPath("icon_add.svg");
  static final iconEditNote = _iconPath("icon_edit_note.svg");
  static final iconDailProgress = _iconPath("icon_daily_progress.svg");
  static final iconTodo = _iconPath("icon_todo.svg");
  static final iconSearch = _iconPath("icon_search.svg");

  static final iconBrain = _iconPath("icon_brain.svg");
  static final iconEmoji = _iconPath("icon_emoji.svg");
  static final iconDumBell = _iconPath("icon_dumbell.svg");
  static final iconSmileEyes = _iconPath("icon_smileeyes.svg");

  static final iconThunder = _iconPath("icon_thunder.svg");
  static final iconTeaCup = _iconPath("icon_tea_cup.svg");




  static final bannerNotify = _iconPath("banner_notify.svg");
  static final bannerHome = _iconPath("img_home.svg");
  static final bannerBreath = _iconPath("img_breath.svg");
  static final bannerJournal = _iconPath("banner_journal.svg");
  static final bannerTodo = _iconPath("banner_todo.svg");




  //TODO: FOR IMAGE(PNG FILE)
  static final splashLogo = _imagesPath("logo.png");
  static final imgDemo = _imagesPath("demo.png");
  static final imgSleep = _imagesPath("sleep.png");
  static final imgEnergy = _imagesPath("energy.png");
  static final imgMentalHealth = _imagesPath("mental_health.png");
  static final imgIrritability = _imagesPath("irritability.png");
  static final imgStressBrain = _imagesPath("stress_brain.png");




  //TODO: FOR ANIMATION(JSON FILE)
  static final homeAnimation = _animationPath("logo.png");
}