import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    // ********* English ********** //
    'en_US': {
      // main screen
      'nickname_prompt': 'Enter your nickname',
      'nickname_hint': 'Your nickname',
      'description': 'Sound Learning Game for Wood Engineering Students',
      'start_playing': 'Start Playing',
      'rules_button': 'Rules & Settings',
      'sponsored': 'Sponsored by TH OWL',
      'rights': 'All rights reserved © TH OWL',
      'please_wait': 'Please wait...',
      'internet_connection_failed': 'Internet Connection Failed',
      'internet_connection_failed_message':
          'Please check your connection and try again.',
      'try_again': 'Try Again',
      // Rules Screen - welcome card
      'welcome_title': 'Welcome to Wood Star!',
      'welcome_subtitle': 'Turn up the volume and test your ears!',
      'welcome_description':
          'Wood Star is a fast-paced educational sound game designed for wood engineering students to recognize real woodworking machine and tool sounds.',

      // Rules Screen - how to play card
      'how_to_play_title': 'How to Play',
      'how_to_play_step_1': 'A woodworking machine or tool sound will play.',
      'how_to_play_step_2': 'Listen carefully — every detail matters!',
      'how_to_play_step_3':
          'Identify the correct machine or tool before the timer ends.',

      // Rules Screen - Beat Timer
      'beat_timer_title': 'Beat the Timer',
      'beat_timer_step_1': 'Each round has a countdown timer.',
      'beat_timer_step_2': 'Faster correct answers earn more points.',
      'beat_timer_step_3': 'Slower answers give fewer points.',
      'beat_timer_step_4':
          'Wrong answers earn zero points — but you can try again!',

      // Rules Screen - point leaderboard card
      'point_leaderboard_title': 'Points & Leaderboard',
      'point_leaderboard_step_1': 'Points are based on speed + accuracy.',
      'point_leaderboard_step_2': 'Higher scores move you up the leaderboard.',
      'point_leaderboard_step_3':
          'Compete with other students and become the ultimate Wood Star 🌟',

      // Rules Screen - Game Modes
      'game_modes_title': 'Game Modes Explained',
      'game_modes_subtitle': 'Master Machine Sounds.',
      'game_modes_des':
          'Practice real woodworking machine sounds to strengthen practical knowledge.',
      // Rules Screen - Learning Tip Card
      'learning_tip_title': 'Learning Tip',
      'learning_tip_des':
          'The more you play, the sharper your ears become — just like real workshop training!',
      // Rules Screen - Settings
      'settings_title': 'Settings',
      'settings_quiz_pause_title': 'Pause before next question',
      'settings_quiz_pause_subtitle':
          'When on, those modes pause and ask you to continue after each answer. Turn off to go to the next question automatically.',
      'settings_first_round_rules_title': 'Show rules before first round',
      'settings_first_round_rules_subtitle':
          'When on, scoring rules appear once before round 1 in QR Sound Hunt and Sound to Picture. Turn off to start playing immediately.',
      'settings_country_region': 'Country / Region Selection',
      'settings_language_selection': 'Language',
      // Home Screen - Header
      'home_header_title': 'Welcome back,',
      'home_title': 'Choose Game Mode',
      'home_subtitle': 'Master Woodworking Machine Sounds',
      'home_description': 'Sharpen your ears and master woodworking sounds.',

      // Home Screen - Qr Sound Hunt
      'qr_hunt_title': 'QR Sound Hunt',
      'qr_hunt_highlight': 'Scan. Listen. Guess.',
      'qr_hunt_description':
          'Scan the QR code, listen to the sound, and identify the correct machine or tool.',
      'qr_hunt_footer':
          'Train your ears and test your practical workshop knowledge.',
      // Home Screen - Sound to Picture
      'sound_to_picture_title': 'Sound to Picture',
      'sound_to_picture_highlight': 'Sound → Visual Match',
      'sound_to_picture_description':
          'Listen to the sound and choose the matching image of the machine or tool.',
      'sound_to_picture_footer':
          'Build strong sound recognition skills step by step.',
      'sound_to_pic_ready_next': 'Are you ready for the next question?',
      'sound_to_pic_ready_finish': 'Ready to see your results?',
      'sound_to_pic_lets_go': "Let's go",
      // Sound to Picture play mode selection
      'sound_to_pic_modes_screen_title': 'Sound to Picture Modes',
      'sound_to_pic_modes_screen_subtitle': 'How do you want to play?',
      'sound_to_pic_modes_screen_hint':
          'Pick how you want to play—each mode uses the same listen-and-match flow.',
      'sound_to_pic_mode_same_device_title': 'Single Device Multiplayer',
      'sound_to_pic_mode_same_device_highlight': 'Pass & play · One phone',
      'sound_to_pic_mode_same_device_description':
          'Take turns on the same device: listen to the sound and hand the phone to the next player.',
      'sound_to_pic_mode_same_device_footer':
          'Fun for pairs or small groups in class.',
      'sound_to_pic_mode_multi_device_title': 'Multi device & Multi player',
      'sound_to_pic_mode_multi_device_highlight': 'Each player · Own device',
      'sound_to_pic_mode_multi_device_description':
          'Everyone uses their own phone while staying in sync for the same quiz session.',
      'sound_to_pic_mode_multi_device_footer':
          'Best for teams spread around the room.',
      // Sound to Picture lobby & timer
      'sound_to_pic_lobby_title': 'Sound to Picture · Players',
      'sound_to_pic_lobby_subtitle': 'Add guests, then start the quiz together.',
      'sound_to_pic_lobby_rounds': 'Total rounds',
      'sound_to_pic_lobby_start': 'Start Quiz',
      'sound_to_pic_lobby_hint':
          'Listen to each sound and pick the matching image. Players take turns on this device.',
      'sound_to_pic_round_timeout_title': "Time's up!",
      'sound_to_pic_round_timeout_message':
          'No answer in time — this round scores 0. Ready for the next one?',
      'sound_to_pic_round_timeout_message_same_device':
          'Time ran out — the active player gets 0 for this round. Hand the phone to the next player when ready.',
      'sound_to_pic_round_timeout_next': 'Next Round',
      'sound_to_pic_hurry_title': '⏰ Hurry Up!',
      'sound_to_pic_hurry_body': 'Only a few seconds left!',
      // Home Screen - Picture to Sound
      'picture_to_sound_title': 'Picture to Sound',
      'picture_to_sound_highlight': 'Visual → Sound Match',
      'picture_to_sound_description':
          'See the image and guess the sound it makes.',
      'picture_to_sound_footer':
          'Connect visual learning with real workshop experience.',
      'picture_to_sound_ready_next': 'Are you ready for the next question?',
      'picture_to_sound_ready_finish': 'Ready to see your results?',

      // Home Screen - Player Stats Card
      'player_stats_title': 'Player Stats',
      'games_played': 'Games Played',
      'wins': 'Wins',
      'total_score': 'Total Score',

      // Qr Scan Mode Screen
      'qr_round': 'Round',
      'qr_score': 'Score',
      'qr_sound_doc_score': 'This sound (max pts)',
      'qr_round_max_points': 'This round (max)',
      'qr_instruction':
          'Scan the QR code to hear the machine sound. Identify the tool for points!',
      'qr_button_scan': 'Scan QR Code',
      'qr_frame_text': 'Position QR code in frame',
      'qr_scan_loading_title': 'Loading sound',
      'qr_scan_loading_subtitle':
          'Hang tight — we are fetching this QR from the cloud.',
      'session_finish_loading_title': 'Saving your results',
      'session_finish_loading_subtitle':
          'Hang tight — your summary is almost ready.',

      // QR play mode selection (how to play QR Sound Hunt)
      'qr_modes_screen_title': 'QR Sound Modes',
      'qr_modes_screen_subtitle': 'How do you want to play?',
      'qr_modes_screen_hint':
          'Pick how you want to play—each mode uses the same scan-and-listen flow.',
      'qr_mode_single_title': 'Single Player',
      'qr_mode_single_highlight': 'Solo · Your pace',
      'qr_mode_single_description':
          'Play rounds on your own—scan, listen, and answer without sharing the device.',
      'qr_mode_single_footer': 'Ideal for focused practice and self-study.',
      'qr_mode_same_device_title': 'Single Device Multiplayer',
      'qr_mode_same_device_highlight': 'Pass & play · One phone',
      'qr_mode_same_device_description':
          'Take turns on the same device: scan the code and hand the phone to the next player.',
      'qr_mode_same_device_footer': 'Fun for pairs or small groups in class.',
      'qr_mode_multi_device_title': 'Multi device & Multi player',
      'qr_mode_multi_device_highlight': 'Each player · Own device',
      'qr_mode_multi_device_description':
          'Everyone uses their own phone while staying in sync for the same hunt or session.',
      'qr_mode_multi_device_footer': 'Best for teams spread around the room.',

      'qr_same_device_lobby_title': 'Players on this phone',
      'qr_same_device_lobby_subtitle':
          'Host + up to 4 guests (5 players max). Names must match profile rules (4–30 letters, numbers, spaces).',
      'qr_same_device_host_label': 'Host (you)',
      'qr_same_device_host_placeholder': '(Set nickname from home)',
      'qr_same_device_guests_label': 'Guests',
      'qr_same_device_add_hint': 'Guest nickname',
      'qr_same_device_add_button': 'Add player',
      'qr_same_device_limit_reached':
          'Maximum 4 guest players reached (5 players total).',
      'qr_same_device_duplicate': 'This player is already in the list.',
      'qr_same_device_invalid_nick':
          'Use 4–30 characters: letters, numbers, and spaces only.',
      'qr_same_device_same_as_host':
          'That is your host name — pick another guest.',
      'qr_same_device_snackbar_title': 'Players',

      'qr_same_device_dialog_hint':
          'Add up to 4 guest nicknames (5 players with host). Names: 4–30 letters, numbers, or spaces. Existing profiles are linked; new names create a user entry.',
      'qr_same_device_manage_players_btn': 'Add / manage players',
      'qr_same_device_manage_players_sub': '{n} of {max} guests added',
      'qr_same_device_dialog_title': 'Pass & play — players',
      'qr_same_device_dialog_done': 'Done',
      'qr_same_device_total_rounds_hint_solo':
          '{r} rounds — solo on this device (4 scans).',
      'qr_same_device_total_rounds_hint_multi':
          '{r} rounds — {players} players × 4 scans each',

      // Sound Play Screen
      'sound_play_title': 'Now Playing',
      'sound_playing_track': 'Playing Track',
      'next_button_text': 'Next Round',
      'finish_button_text': 'Finish Game',
      'qr_surrender_round_button': 'Wrong answer (0 pts)',
      'qr_surrender_round_title': 'Count this round as wrong?',
      'qr_surrender_round_message':
          'You will get 0 points for this round. Your total score so far will not change.',
      'qr_surrender_confirm': 'Yes, 0 points',
      'qr_surrender_cancel': 'Cancel',
      'qr_round_timer_label': 'Timer:',
      'qr_round_timer_hint':
          'Correct scan: under 20s → 1 point per second (max 20). From 20s to 30s → 20 points. Wrong (0 pts): you get 0; in pass & play each other player gets 5.',
      'qr_round_timeout_title': "Time's up!",
      'qr_round_timeout_message':
          '30 seconds have passed without continuing. You get 0 points for this round. Tap Next to continue.',
      'qr_round_timeout_message_same_device':
          '30 seconds have passed. The active player gets 0 points. Each other player receives 5 points automatically.',
      'qr_round_timeout_next': 'Next Round',

      // Success Screen – QR Sound Hunt
      'qr_hunt_success_title': 'QR Sound Hunt',
      'qr_hunt_success_msg': 'Good Work!',
      // Success Screen – mode subtitle (under main message)
      'sound_to_picture_success_title': 'Sound to Picture',
      'picture_to_sound_success_title': 'Picture to Sound',
      'success_score_text': 'Your Score',
      'play_again_button': 'Play Again',
      'manu_button_text': 'Back to Menu',
      'success_accuracy': 'Accuracy',
      'success_streak': 'Streak',
      'success_time': 'Time',
      'success_career_firestore_title': 'Your profile (saved)',
      'success_career_best_streak': 'Best streak',
      'success_career_best_accuracy': 'Best accuracy',
      'success_career_best_time': 'Best time',
      'qr_same_device_success_table_title': 'Pass & play — results',
      'qr_same_device_success_col_player': 'Player',
      'qr_same_device_success_col_score': 'Pts',
      'qr_same_device_success_col_correct': 'Correct',
      'qr_same_device_success_group_total_label': 'Group total',

      // Leaderboard (Firestore users / profile totalScore)
      'leaderboard_subtitle':
          'Players ranked by profile total score (saved games).',
      'leaderboard_by_mode': 'Points per mode',
      'leaderboard_total_score': 'Your total score',
      'player_default_name': 'Player',
      'leaderboard_you': 'You',
      'leaderboard_your_row': 'Your score',
      'leaderboard_no_players':
          'No players in the cloud yet. Finish a game with your nickname saved.',
      'leaderboard_ranked_hint':
          'Ranks use your Firestore profile (total score from saved sessions).',
      'leaderboard_rankings_title': 'Rankings',
      'leaderboard_load_error':
          'Could not load the leaderboard. Check your connection and Firestore rules.',
      'leaderboard_local_score_hint':
          'Not on the cloud list yet — showing combined score from this device.',
      'retry': 'Retry',
      'best_accuracy_short': 'Best acc.',
      'best_streak_short': 'Streak',
      'best_time_short': 'Best time',
      'leaderboard_games_played_count': '{n} games',
      'leaderboard_qr_solo_abbr': 'QR solo',
      'leaderboard_qr_multi_abbr': 'QR multi ',
      'leaderboard_qr_same_device_abbr': 'QR same device',
      'leaderboard_stp_abbr': 'Sound to Pic',
      'leaderboard_stp_same_device_abbr': 'STP same device',
      'leaderboard_stp_multi_abbr': 'STP multi device',
      'qr_mode_same_device_coming_soon':
          'Pass-and-play on one device is coming soon.',
      'question_text': 'Question',
      'listening_text': 'Listen Carefully!',
      'subtitle_text': 'Which machine is this?',
      'replay_button': 'Replay Sound',

      // Picture to sound
      'pic_to_sound_title': 'Look at the Machine',
      'pic_to_sound_subtitle': 'Which sound does it make?',
      // Picture → Sound — option labels (asset → name)
      'snd_unknown': 'Unknown sound',
      'snd_bensaw_fair_wood': 'Bench saw (fair wood)',
      'snd_chipboard_circular_saw': 'Chipboard circular saw',
      'snd_cordless_screwdriver': 'Cordless screwdriver',
      'snd_cordless_screwdriver_alt': 'Cordless screwdriver (alt.)',
      'snd_drilling_chipboard': 'Drilling — chipboard',
      'snd_drilling_fair_wood': 'Drilling — fair wood',
      'snd_drilling_machine_fair_wood': 'Drilling machine — fair wood',
      'snd_drilling_oak_tree': 'Drilling — oak tree',
      'snd_drilling_oak_wood': 'Drilling — oak wood',
      'snd_drilling_different_tool': 'Drilling — different tool',
      'snd_drilling_with_fair_wood': 'Drilling with fair wood',
      'snd_edge_grinder': 'Edge grinder',
      'snd_electric_heater': 'Electric heater',
      'snd_hand_circular_saw': 'Hand circular saw',
      'snd_jigsaw': 'Jigsaw',
      'snd_lamello_cutter': 'Lamello cutter',
      'snd_milling_machine': 'Milling machine',
      'snd_nailing': 'Nailing',
      'snd_nailing_wood_piece': 'Nailing wood piece',
      'snd_oak_tree_circular_saw': 'Oak tree circular saw',
      'snd_planning_machine_beech': 'Planing machine — beech wood',
      'snd_planning_machine_2': 'Planing machine (2)',
      'snd_router': 'Router',
      'snd_sanding_fair_wood': 'Sanding — fair wood',
      'snd_table_milling_change_blade': 'Table milling — blade change',
      'snd_table_milling_machine': 'Table milling machine',
      'snd_veneer_press': 'Veneer press machine',
      'snd_vertical_panel_saw': 'Vertical panel saw',
      'snd_wet_grinding': 'Wet grinding machine',
      'snd_wide_belt_sander': 'Wide belt sander',

      // Rules book dialog
      'rules_book_title': 'WOODSTAR – GAME RULES',
      'rules_book_close': 'Got it',
      'rules_book_section_timing': 'Timing & Scoring',
      'rules_book_timing_1':
          'Each round has a *30-second* countdown (30 → 0). Max points come from the sound\'s score in the database (up to 20).',
      'rules_book_timing_2':
          'If *20 seconds or more* remain on the timer → *Full Points*.',
      'rules_book_timing_3':
          'If *less than 20 seconds* remain → points equal the *remaining seconds* (e.g. 11 s left → 11 points).',
      'rules_book_section_timers': 'Game Timers',
      'rules_book_timers_1': '*QR Game Total Time:* 30 seconds',
      'rules_book_timers_2': '*Sound to Picture Time:* 24 seconds',
      'rules_book_section_no_answer': 'No Answer',
      'rules_book_no_answer_1': 'If a player does not answer:',
      'rules_book_no_answer_2': 'Player gets *0 points*',
      'rules_book_no_answer_3':
          'In pass-and-play multiplayer, each other player gets *+5 points*.',
      'rules_book_section_wrong': 'Wrong Answer',
      'rules_book_wrong_1': 'If a player gives a wrong answer:',
      'rules_book_wrong_2': 'Player gets *0 points*',
      'rules_book_wrong_3': 'Opponent gets *+5 points*',
      'rules_book_section_skip': 'Skip',
      'rules_book_skip_1': 'If a player skips:',
      'rules_book_skip_2': 'Player gets *0 points*',
      'rules_book_skip_3': 'Opponent also gets *0 points*',
      'rules_book_section_strikes': 'Strikes Bonus',
      'rules_book_strikes_1': 'Each strike earned gives:',
      'rules_book_strikes_2': '*+1 extra point per strike*',
      'rules_book_section_note': 'Note',
      'rules_book_note_1': 'These rules apply to *both game modes*.',
      'rules_book_footer': 'Play fast. Think smart. Score big! 🚀',
    },

    // ********** German Translations ********** //
    'de_DE': {
      // main screen
      'nickname_prompt': 'Geben Sie Ihren Spitznamen ein',
      'nickname_hint': 'Ihr Spitzname',
      'description': 'Sound-Lernspiel für Holzbauingenieur-Studierende',
      'start_playing': 'Spiel starten',
      'rules_button': 'Regeln & Einstellungen',
      'settings_quiz_pause_title': 'Pause vor der nächsten Frage',
      'settings_quiz_pause_subtitle':
          'Wenn an, musst du in Sound→Bild und Bild→Sound nach jeder Antwort auf „Los geht’s“ tippen. Aus, um automatisch weiterzugehen.',
      'settings_first_round_rules_title': 'Regeln vor der ersten Runde',
      'settings_first_round_rules_subtitle':
          'Wenn an, erscheinen die Punkteregeln einmal vor Runde 1 in QR-Sound-Jagd und Sound zu Bild. Aus, um sofort zu spielen.',
      'sponsored': 'Gesponsert von TH OWL',
      'rights': 'Alle Rechte vorbehalten © TH OWL',
      'please_wait': 'Even geduld...',
      'internet_connection_failed': 'Internetverbindung fehlgeschlagen',
      'internet_connection_failed_message':
          'Bitte überprüfe deine Verbindung und versuche es erneut.',
      'try_again': 'Erneut versuchen',

      // Rules Screen – welcome card
      'welcome_title': 'Willkommen bei Wood Star!',
      'welcome_subtitle': 'Dreh die Lautstärke auf und teste dein Gehör!',
      'welcome_description':
          'Wood Star ist ein rasantes, edukatives Sound-Spiel für Studierende des Holzingenieurwesens, '
          'bei dem echte Geräusche von Holzbearbeitungsmaschinen und Werkzeugen erkannt werden müssen.',

      // Rules Screen – how to play card
      'how_to_play_title': 'So wird gespielt',
      'how_to_play_step_1':
          'Ein Geräusch einer Holzbearbeitungsmaschine oder eines Werkzeugs wird abgespielt.',
      'how_to_play_step_2': 'Hör genau hin – jedes Detail zählt!',
      'how_to_play_step_3':
          'Erkenne die richtige Maschine oder das richtige Werkzeug, bevor die Zeit abläuft.',

      // Rules Screen – Beat the Timer
      'beat_timer_title': 'Schlage die Zeit',
      'beat_timer_step_1': 'Jede Runde hat einen Countdown-Timer.',
      'beat_timer_step_2': 'Schnelle richtige Antworten bringen mehr Punkte.',
      'beat_timer_step_3': 'Langsamere Antworten geben weniger Punkte.',
      'beat_timer_step_4':
          'Falsche Antworten bringen keine Punkte – aber du kannst es erneut versuchen!',

      // Rules Screen – Point & Leaderboard
      'point_leaderboard_title': 'Punkte & Rangliste',
      'point_leaderboard_step_1':
          'Die Punkte basieren auf Geschwindigkeit und Genauigkeit.',
      'point_leaderboard_step_2':
          'Höhere Punktzahlen bringen dich in der Rangliste nach oben.',
      'point_leaderboard_step_3':
          'Tritt gegen andere Studierende an und werde der ultimative Wood Star 🌟',

      // Rules Screen - Game Modes
      'game_modes_title': 'Spielmodi erklärt',
      'game_modes_subtitle': 'Meistere Maschinengeräusche.',
      'game_modes_des':
          'Übe echte Geräusche von Holzbearbeitungsmaschinen, um dein praktisches Wissen zu stärken.',
      // Rules Screen - Learning Tip Card
      'learning_tip_title': 'Lerntipp',
      'learning_tip_des':
          'Je öfter du spielst, desto besser wird dein Gehör – genau wie beim echten Werkstatttraining!',

      // Rules Screen - Settings
      'settings_title': 'Einstellungen',
      'settings_country_region': 'Länder- / Regionsauswahl',
      'settings_language_selection': 'Sprachauswahl',

      // Home Screen – QR Sound Hunt
      'qr_hunt_title': 'QR-Soundjagd',
      'qr_hunt_highlight': 'Scannen. Hören. Raten.',
      'qr_hunt_description':
          'Scanne den QR-Code, höre dir das Geräusch an und erkenne die richtige Maschine oder das richtige Werkzeug.',
      'qr_hunt_footer':
          'Trainiere dein Gehör und teste dein praktisches Werkstattwissen.',
      // Home Screen
      'home_header_title': 'Willkommen zurück,',
      'home_title': 'Spielmodus wählen',
      'home_subtitle': 'Meistere Geräusche von Holzbearbeitungsmaschinen',
      'home_description':
          'Schärfe dein Gehör und beherrsche Holzbearbeitungsgeräusche.',

      // Home Screen – Sound to Picture
      'sound_to_picture_title': 'Sound zu Bild',
      'sound_to_picture_highlight': 'Sound → Bildabgleich',
      'sound_to_picture_description':
          'Höre dir das Geräusch an und wähle das passende Bild der Maschine oder des Werkzeugs aus.',
      'sound_to_picture_footer':
          'Baue Schritt für Schritt starke Fähigkeiten zur Geräuscherkennung auf.',
      'sound_to_pic_ready_next': 'Bist du bereit für die nächste Frage?',
      'sound_to_pic_ready_finish': 'Bereit für dein Ergebnis?',
      'sound_to_pic_lets_go': 'Los geht’s',
      // Sound to Picture play mode selection
      'sound_to_pic_modes_screen_title': 'Sound-zu-Bild-Modi',
      'sound_to_pic_modes_screen_subtitle': 'Wie möchtest du spielen?',
      'sound_to_pic_modes_screen_hint':
          'Wähle, wie du spielen möchtest—jeder Modus nutzt denselben Hör-und-Zuordnen-Ablauf.',
      'sound_to_pic_mode_same_device_title': 'Mehrspieler · Ein Gerät',
      'sound_to_pic_mode_same_device_highlight': 'Weitergabe · Ein Handy',
      'sound_to_pic_mode_same_device_description':
          'Wechselt euch am gleichen Gerät: Sound anhören und das Handy an die nächste Person geben.',
      'sound_to_pic_mode_same_device_footer':
          'Praktisch zu zweit oder in kleinen Gruppen.',
      'sound_to_pic_mode_multi_device_title': 'Mehrere Geräte & Spieler',
      'sound_to_pic_mode_multi_device_highlight': 'Jede Person · Eigenes Gerät',
      'sound_to_pic_mode_multi_device_description':
          'Alle nutzen ihr eigenes Smartphone und bleiben für dieselbe Quiz-Session synchron.',
      'sound_to_pic_mode_multi_device_footer': 'Gut für Teams im gesamten Raum.',
      // Sound to Picture lobby & timer
      'sound_to_pic_lobby_title': 'Sound zu Bild · Spieler',
      'sound_to_pic_lobby_subtitle':
          'Gäste hinzufügen, dann startet ihr das Quiz gemeinsam.',
      'sound_to_pic_lobby_rounds': 'Runden gesamt',
      'sound_to_pic_lobby_start': 'Quiz starten',
      'sound_to_pic_lobby_hint':
          'Hört jeden Sound und wählt das passende Bild. Ihr wechselt euch am Gerät ab.',
      'sound_to_pic_round_timeout_title': 'Zeit abgelaufen!',
      'sound_to_pic_round_timeout_message':
          'Keine Antwort rechtzeitig — diese Runde bringt 0 Punkte. Bereit für die nächste?',
      'sound_to_pic_round_timeout_message_same_device':
          'Zeit abgelaufen — der aktive Spieler erhält 0 für diese Runde. Gebt das Handy weiter, wenn ihr bereit seid.',
      'sound_to_pic_round_timeout_next': 'Nächste Runde',
      'sound_to_pic_hurry_title': '⏰ Beeil dich!',
      'sound_to_pic_hurry_body': 'Nur noch wenige Sekunden!',

      // Home Screen – Picture to Sound
      'picture_to_sound_title': 'Bild zu Sound',
      'picture_to_sound_highlight': 'Bild → Soundabgleich',
      'picture_to_sound_description':
          'Sieh dir das Bild an und errate, welches Geräusch es erzeugt.',
      'picture_to_sound_footer':
          'Verbinde visuelles Lernen mit echter Werkstatterfahrung.',
      'picture_to_sound_ready_next': 'Bist du bereit für die nächste Frage?',
      'picture_to_sound_ready_finish': 'Bereit für dein Ergebnis?',
      // Home Screen - Player Stats Card
      'player_stats_title': 'Spielerstatistiken',
      'games_played': 'Gespeilte Spiele',
      'wins': 'Gewonnene Spiele',
      'total_score': 'Gesamtpunktzahl',

      // QR-Scan-Mode
      'qr_round': 'Runde',
      'qr_score': 'Punktestand',
      'qr_sound_doc_score': 'Dieser Sound (max. Pkt.)',
      'qr_round_max_points': 'Diese Runde (max.)',
      'qr_instruction':
          'Scanne den QR-Code, um das Maschinengeräusch zu hören. Erkenne das Werkzeug für Punkte!',
      'qr_button_scan': 'QR-Code scannen',
      'qr_frame_text': 'Positioniere den QR-Code im Rahmen',
      'qr_scan_loading_title': 'Sound wird geladen',
      'qr_scan_loading_subtitle':
          'Einen Moment — wir laden diesen QR aus der Cloud.',
      'session_finish_loading_title': 'Ergebnisse werden gespeichert',
      'session_finish_loading_subtitle':
          'Einen Moment — deine Zusammenfassung folgt gleich.',

      // QR-Spielmodus (wie du die QR-Soundjagd spielst)
      'qr_modes_screen_title': 'QR-Sound-Modi',

      'qr_modes_screen_subtitle': 'Wie möchtest du spielen?',
      'qr_modes_screen_hint':
          'Wähle, wie du spielen möchtest—jeder Modus nutzt denselben Scan-und-Hör-Ablauf.',
      'qr_mode_single_title': 'Einzelspieler',
      'qr_mode_single_highlight': 'Solo · Eigenes Tempo',
      'qr_mode_single_description':
          'Spiele allein Runden—scannen, hören und antworten, ohne das Gerät zu teilen.',
      'qr_mode_single_footer':
          'Ideal für konzentriertes Üben und Selbststudium.',
      'qr_mode_same_device_title': 'Mehrspieler · Ein Gerät',
      'qr_mode_same_device_highlight': 'Weitergabe · Ein Handy',
      'qr_mode_same_device_description':
          'Wechselt euch am gleichen Gerät: QR-Code scannen und das Handy an die nächste Person geben.',
      'qr_mode_same_device_footer':
          'Praktisch zu zweit oder in kleinen Gruppen.',
      'qr_mode_multi_device_title': 'Mehrere Geräte & Spieler',
      'qr_mode_multi_device_highlight': 'Jede Person · Eigenes Gerät',
      'qr_mode_multi_device_description':
          'Alle nutzen ihr eigenes Smartphone und bleiben für dieselbe Jagd oder Session synchron.',
      'qr_mode_multi_device_footer': 'Gut für Teams im gesamten Raum.',

      'qr_same_device_lobby_title': 'Spieler auf diesem Gerät',
      'qr_same_device_lobby_subtitle':
          'Host + bis zu 4 Gäste (max. 5 Spieler). Namen müssen den Profilregeln entsprechen (4–30 Buchstaben, Zahlen, Leerzeichen).',
      'qr_same_device_host_label': 'Host (du)',
      'qr_same_device_host_placeholder':
          '(Spitznamen auf der Startseite setzen)',
      'qr_same_device_guests_label': 'Gäste',
      'qr_same_device_add_hint': 'Gast-Spitzname',
      'qr_same_device_add_button': 'Spieler hinzufügen',
      'qr_same_device_limit_reached':
          'Maximal 4 Gäste erreicht (5 Spieler insgesamt).',
      'qr_same_device_duplicate': 'Dieser Spieler steht schon in der Liste.',
      'qr_same_device_invalid_nick':
          '4–30 Zeichen: nur Buchstaben, Zahlen und Leerzeichen.',
      'qr_same_device_same_as_host':
          'Das ist dein Host-Name — wähle einen anderen Gast.',
      'qr_same_device_snackbar_title': 'Spieler',

      'qr_same_device_dialog_hint':
          'Bis zu 4 Gast-Spitznamen (5 Spieler mit Host). 4–30 Zeichen: Buchstaben, Zahlen, Leerzeichen. Vorhandene Profile werden verknüpft; neue Namen legen einen Nutzer an.',
      'qr_same_device_manage_players_btn': 'Spieler hinzufügen / verwalten',
      'qr_same_device_manage_players_sub': '{n} von {max} Gästen',
      'qr_same_device_dialog_title': 'Pass & play — Spieler',
      'qr_same_device_dialog_done': 'Fertig',
      'qr_same_device_total_rounds_hint_solo':
          '{r} Runden — solo auf diesem Gerät (4 Scans).',
      'qr_same_device_total_rounds_hint_multi':
          '{r} Runden — {players} Spieler × 4 Scans je Person',

      // Sound Play Screen
      'sound_play_title': 'Jetzt läuft',
      'sound_playing_track': 'Aktueller Sound',
      'next_button_text': 'Nächste Runde',
      'finish_button_text': 'Spiel beenden',
      'qr_surrender_round_button': 'Falsche Antwort (0 Pkt.)',
      'qr_surrender_round_title': 'Diese Runde als falsch werten?',
      'qr_surrender_round_message':
          'Du erhältst 0 Punkte für diese Runde. Dein bisheriger Gesamtstand bleibt unverändert.',
      'qr_surrender_confirm': 'Ja, 0 Punkte',
      'qr_surrender_cancel': 'Abbrechen',
      'qr_round_timer_label': 'Timer:',
      'qr_round_timer_hint':
          'Richtiger Scan: unter 20s → 1 Punkt pro Sekunde (max. 20). Ab 20s bis 30s → 20 Punkte. Falsch (0 Pkt.): du 0; bei Pass & Play je 5 für die anderen.',
      'qr_round_timeout_title': 'Zeit abgelaufen!',
      'qr_round_timeout_message':
          '30 Sekunden sind vorbei. Du erhältst 0 Punkte für diese Runde. Tippe auf Weiter.',
      'qr_round_timeout_message_same_device':
          '30 Sekunden sind vorbei. Der aktive Spieler erhält 0 Punkte. Jeder andere Spieler bekommt automatisch 5 Punkte.',
      'qr_round_timeout_next': 'Nächste Runde',
      // Success Screen – QR Sound Hunt
      'qr_hunt_success_title': 'QR-Soundjagd',
      'qr_hunt_success_msg': 'Gute Arbeit!',
      // Success Screen – mode subtitle (under main message)
      'sound_to_picture_success_title': 'Sound zu Bild',
      'picture_to_sound_success_title': 'Bild zu Sound',
      'success_score_text': 'Dein Punktestand',
      'play_again_button': 'Nochmal spielen',
      'manu_button_text': 'Zurück zum Menü',
      'success_accuracy': 'Genauigkeit',
      'success_streak': 'Serie',
      'success_time': 'Zeit',
      'success_career_firestore_title': 'Dein Profil (gespeichert)',
      'success_career_best_streak': 'Beste Serie',
      'success_career_best_accuracy': 'Beste Genauigkeit',
      'success_career_best_time': 'Beste Zeit',
      'qr_same_device_success_table_title': 'Ergebnis — ein Gerät',
      'qr_same_device_success_col_player': 'Spieler',
      'qr_same_device_success_col_score': 'Pkt',
      'qr_same_device_success_col_correct': 'Richtig',
      'qr_same_device_success_group_total_label': 'Gruppensumme',

      // Leaderboard (Firestore users / profile totalScore)
      'leaderboard_subtitle':
          'Spieler nach Profil-Gesamtpunktzahl (gespeicherte Spiele).',
      'leaderboard_by_mode': 'Punkte pro Modus',
      'leaderboard_total_score': 'Deine Gesamtpunktzahl',
      'player_default_name': 'Spieler',
      'leaderboard_you': 'Du',
      'leaderboard_your_row': 'Dein Ergebnis',
      'leaderboard_no_players':
          'Noch keine Spieler in der Cloud. Beende ein Spiel mit gespeichertem Spitznamen.',
      'leaderboard_ranked_hint':
          'Ränge nutzen dein Firestore-Profil (Gesamtpunktzahl aus gespeicherten Sessions).',
      'leaderboard_rankings_title': 'Rangliste',
      'leaderboard_load_error':
          'Rangliste konnte nicht geladen werden. Verbindung und Firestore-Regeln prüfen.',
      'leaderboard_local_score_hint':
          'Noch nicht in der Cloud — zeigt kombinierte Punkte von diesem Gerät.',
      'retry': 'Erneut versuchen',
      'best_accuracy_short': 'Beste Genau.',
      'best_streak_short': 'Serie',
      'best_time_short': 'Beste Zeit',
      'leaderboard_games_played_count': '{n} gespielte',
      'leaderboard_qr_solo_abbr': 'QR Solo ',
      'leaderboard_qr_multi_abbr': 'QR Multi',
      'leaderboard_qr_same_device_abbr': 'QR ein Gerät ',
      'leaderboard_stp_abbr': 'Ton zu Bild',
      'leaderboard_stp_same_device_abbr': 'STP ein Gerät',
      'leaderboard_stp_multi_abbr': 'STP Multi',

      'qr_mode_same_device_coming_soon':
          'Weiterspielen auf einem Gerät kommt bald.',

      // Sound to Picture Mode
      'question_text': 'Frage',
      'listening_text': 'Hör gut zu!',
      'subtitle_text': 'Welche Maschine ist das?',
      'replay_button': 'Ton erneut abspielen',

      // Picture to sound
      'pic_to_sound_title': 'Sieh dir die Maschine an',
      'pic_to_sound_subtitle': 'Welches Geräusch macht sie?',
      // Picture → Sound — Bezeichnungen
      'snd_unknown': 'Unbekanntes Geräusch',
      'snd_bensaw_fair_wood': 'Tisch-/Bandsäge (Edelholz)',
      'snd_chipboard_circular_saw': 'Kreissäge — Spanplatte',
      'snd_cordless_screwdriver': 'Akku-Schrauber',
      'snd_cordless_screwdriver_alt': 'Akku-Schrauber (Variante)',
      'snd_drilling_chipboard': 'Bohren — Spanplatte',
      'snd_drilling_fair_wood': 'Bohren — Edelholz',
      'snd_drilling_machine_fair_wood': 'Bohrmaschine — Edelholz',
      'snd_drilling_oak_tree': 'Bohren — Eiche',
      'snd_drilling_oak_wood': 'Bohren — Eichenholz',
      'snd_drilling_different_tool': 'Bohren — anderes Werkzeug',
      'snd_drilling_with_fair_wood': 'Bohren mit Edelholz',
      'snd_edge_grinder': 'Kantenfräser / Kantenschleifer',
      'snd_electric_heater': 'Elektroheizer',
      'snd_hand_circular_saw': 'Handkreissäge',
      'snd_jigsaw': 'Stichsäge',
      'snd_lamello_cutter': 'Lamello-Fräse',
      'snd_milling_machine': 'Fräsmaschine',
      'snd_nailing': 'Nageln',
      'snd_nailing_wood_piece': 'Nageln — Holzstück',
      'snd_oak_tree_circular_saw': 'Kreissäge — Eichenholz',
      'snd_planning_machine_beech': 'Hobelmaschine — Buche',
      'snd_planning_machine_2': 'Hobelmaschine (2)',
      'snd_router': 'Oberfräse',
      'snd_sanding_fair_wood': 'Schleifen — Edelholz',
      'snd_table_milling_change_blade': 'Tischfräse — Wechselklinge',
      'snd_table_milling_machine': 'Tischfräsmaschine',
      'snd_veneer_press': 'Furnierpresse',
      'snd_vertical_panel_saw': 'Vertikale Plattenaufteilsäge',
      'snd_wet_grinding': 'Nassschleifmaschine',
      'snd_wide_belt_sander': 'Breitbandschleifer',

      // Rules book dialog
      'rules_book_title': 'WOODSTAR – SPIELREGELN',
      'rules_book_close': 'Verstanden',
      'rules_book_section_timing': 'Zeit & Punkte',
      'rules_book_timing_1':
          'Jede Runde hat einen *30-Sekunden*-Countdown (30 → 0). Maximalpunkte kommen aus dem Sound-Score in der Datenbank (bis 20).',
      'rules_book_timing_2':
          'Bleiben *20 Sekunden oder mehr* auf dem Timer → *Volle Punkte*.',
      'rules_book_timing_3':
          'Bleiben *weniger als 20 Sekunden* → Punkte entsprechen den *verbleibenden Sekunden* (z. B. 11 s → 11 Punkte).',
      'rules_book_section_timers': 'Spiel-Timer',
      'rules_book_timers_1': '*QR-Spiel Gesamtzeit:* 30 Sekunden',
      'rules_book_timers_2': '*Sound zu Bild Zeit:* 24 Sekunden',
      'rules_book_section_no_answer': 'Keine Antwort',
      'rules_book_no_answer_1': 'Wenn ein Spieler nicht antwortet:',
      'rules_book_no_answer_2': 'Spieler erhält *0 Punkte*',
      'rules_book_no_answer_3':
          'Im Pass-and-Play-Mehrspielermodus erhält jeder andere Spieler *+5 Punkte*.',
      'rules_book_section_wrong': 'Falsche Antwort',
      'rules_book_wrong_1': 'Wenn ein Spieler falsch antwortet:',
      'rules_book_wrong_2': 'Spieler erhält *0 Punkte*',
      'rules_book_wrong_3': 'Gegner erhält *+5 Punkte*',
      'rules_book_section_skip': 'Überspringen',
      'rules_book_skip_1': 'Wenn ein Spieler überspringt:',
      'rules_book_skip_2': 'Spieler erhält *0 Punkte*',
      'rules_book_skip_3': 'Gegner erhält ebenfalls *0 Punkte*',
      'rules_book_section_strikes': 'Streak-Bonus',
      'rules_book_strikes_1': 'Jeder erreichte Streak bringt:',
      'rules_book_strikes_2': '*+1 Extra-Punkt pro Streak*',
      'rules_book_section_note': 'Hinweis',
      'rules_book_note_1': 'Diese Regeln gelten für *beide Spielmodi*.',
      'rules_book_footer': 'Schnell spielen. Clever denken. Groß abräumen! 🚀',
    },
  };
}
