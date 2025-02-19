package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	private static var curSelected:Int = 0;
	private static var curDifficulty:Int = 2;

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	public static var storymenu:Bool = false;

	var weeks:Array<String> = ['WEEK 1', 'WEEK 2', 'WEEK 3', 'WEEK 5', 'WEEK 6', 'WEEK 7', 'WEEK J'
	, 'Modded Roles', '???', 'EXTRAS', 'HENRY'
	, 'The Skinny Nuts Saga', 'Forever Gone', ''
	, 'WEEK L'
	];

	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;

	override function create()
	{
		FlxG.mouse.visible = true;

		FlxG.mouse.visible = true;
		#if MODS_ALLOWED
		Paths.destroyLoadedImages();
		#end
		WeekData.reloadWeekFiles(false);
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		/*for (i in 0...WeekData.weeksList.length) {
			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];
			for (j in 0...leWeek.songs.length) {
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs) {
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3) {
					colors = [146, 113, 253];
				}
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}
		WeekData.setDirectoryFromWeek();*/

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		for (i in 0...initSonglist.length)
		{
			if(initSonglist[i] != null && initSonglist[i].length > 0) {
				var songArray:Array<String> = initSonglist[i].split(":");
				addSong(songArray[0], 0, songArray[1], Std.parseInt(songArray[2]));
			}
		}

		// LOAD MUSIC

		if (storymenu){
			addSong('Polus Problems', 1, 'impostor', FlxColor.WHITE);
			addSong('Mira Mania', 1, 'crewmate', FlxColor.WHITE);
			addSong('Airship Atrocities', 1, 'yellow', FlxColor.WHITE);
			addSong('Magmatic Monstrosity', 1, 'maroon', FlxColor.WHITE);
			addSong('Deadly Delusion', 1, 'gray', FlxColor.WHITE);
			addSong('Humane Heartbeat', 1, 'pink', FlxColor.WHITE);
			addSong("Jorsawsee's Jams", 1, 'jorsawsee', FlxColor.WHITE);
			addSong('Battling the Boyfriend', 1, 'henry', FlxColor.WHITE);
			addSong('Rousey Rival', 1, 'tomongus', FlxColor.WHITE);
			addSong("Loggo's Halloween", 1, 'fella', FlxColor.WHITE);
			addSong("Loggo's Halloween DX+", 1, 'loggo', FlxColor.WHITE);
			addSong('Jads Jams', 1, 'jads', FlxColor.WHITE);
			addSong('???', 1, 'black', FlxColor.WHITE);
		}else{
			addSong('WEEK 1', 1, ' ', FlxColor.WHITE);

			addSong('sussus-moogus', 1, 'impostor', FlxColor.RED);
			addSong('sabotage', 1, 'impostor', FlxColor.RED);
			addSong('meltdown', 1, 'impostor2', FlxColor.RED);
	
			addSong('WEEK 2', 1, ' ', FlxColor.WHITE);
	
			addSong('sussus-toogus', 1, 'crewmate', FlxColor.GREEN);
			addSong('lights-down', 1, 'impostor3', FlxColor.GREEN);
			addSong('reactor', 1, 'impostor3', FlxColor.GREEN);
			addSong('ejected', 1, 'parasite', FlxColor.GREEN);
			addSong('double-trouble', 1, 'dt', FlxColor.GREEN);
	
			addSong('WEEK 3', 1, ' ', FlxColor.WHITE);
	
			addSong('mando', 1, 'yellow', FlxColor.YELLOW);
			addSong('dlow', 1, 'yellow', FlxColor.YELLOW);
			addSong('oversight', 1, 'white', FlxColor.WHITE);
			addSong('Danger', 1, 'black', FlxColor.BLACK);
			addSong('Double-Kill', 1, 'whiteblack', FlxColor.BLACK);
	
			addSong('WEEK 5', 1, ' ', FlxColor.WHITE);
	
			addSong('Ashes', 1, 'maroon', FlxColor.fromRGB(82,35,47));
			addSong('Stealth', 1, 'maroon', FlxColor.fromRGB(82,35,47));
			addSong('Magmatic', 1, 'maroon', FlxColor.fromRGB(82,35,47));
			addSong('Boiling-Point', 1, 'boilingpoint', FlxColor.fromRGB(82,35,47));
	
			addSong('WEEK 6', 1, ' ', FlxColor.WHITE);
	
			addSong('Delusion', 1, 'gray', FlxColor.GRAY);
			addSong('Insane', 1, 'gray', FlxColor.GRAY);
			addSong('Blackout', 1, 'gray', FlxColor.GRAY);
			addSong('Neurotic', 1, 'gray', FlxColor.GRAY);
	
			addSong('WEEK 7', 1, ' ', FlxColor.WHITE);
	
			addSong('pretender', 1, 'pretender', FlxColor.GRAY);
	
			addSong('WEEK J', 1, ' ', FlxColor.WHITE);
	
			addSong('voting-time', 1, 'votingtime', FlxColor.RED);
			addSong('turbulence', 1, 'redmungus', FlxColor.RED);
			addSong('victory', 1, 'warchief', FlxColor.PURPLE);

			addSong('WEEK L', 1, ' ', FlxColor.WHITE);

			addSong('Lemon Lime', 1, 'jads', FlxColor.LIME);
			addSong('Chlorescene', 1, 'jads', FlxColor.LIME);
			addSong('Inflorescence', 1, 'jads', FlxColor.LIME);
			addSong('Stargazer', 1, 'jads', FlxColor.LIME);
	
			addSong('Modded Roles', 1, ' ', FlxColor.WHITE);
	
			addSong('???', 1, ' ', FlxColor.BLACK);
	
			addSong('Defeat', 1, 'black', FlxColor.BLACK);
			addSong('Ominous', 1, 'black', FlxColor.BLACK);
			addSong('Finale', 1, 'black', FlxColor.BLACK);
			addSong('True Finale', 1, 'black', FlxColor.BLACK);
			//addSong('Final Finale', 1, 'black', FlxColor.BLACK);
			//addSong('Final Fates Of Destiny', 1, 'black', FlxColor.BLACK);
	
			addSong('HENRY', 1, ' ', FlxColor.WHITE);
	
			addSong('titular', 1, 'henry', FlxColor.GRAY);
			addSong('greatest-plan', 1, 'charles', FlxColor.GRAY);
			addSong('reinforcements', 1, 'ellie', FlxColor.GRAY);
			addSong('armed', 1, 'rhm', FlxColor.GRAY);
	
			addSong('The Skinny Nuts Saga', 1, ' ', FlxColor.WHITE);
	
			addSong('Skinny Nuts', 1, 'skinnynuts', FlxColor.WHITE);
			addSong('Skinny Nuts 2', 1, 'skinnynuts', FlxColor.WHITE);
	
			addSong('EXTRAS', 1, ' ', FlxColor.WHITE);
	
			addSong('drippypop', 1, 'drippy', FlxColor.PURPLE);
			//addSong('Your Mother', 1, 'drippy', FlxColor.PURPLE); // spy tf2
			addSong('sauces-moogus', 1, 'chef', FlxColor.ORANGE);
			addSong('who', 1, 'whoguys', FlxColor.WHITE);
			addSong('Fight Or Flight', 1, 'lime', FlxColor.LIME);
			addSong('Escape From The City', 1, 'sonic', FlxColor.BLUE);

			//addSong("Loggo's Halloween DX+", 1, 'loggo', FlxColor.GREEN);

			addSong('Defeat Old', 1, 'blackold', FlxColor.BLACK);

			/*addSong('Forever Gone', 1, ' ', FlxColor.WHITE);

			addSong('Lost Fever', 1, 'black', FlxColor.BLUE);*/
		}

		// LOAD CHARACTERS

		bg = new FlxSprite().loadGraphic(Paths.image('spacep'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			Paths.currentModDirectory = songs[i].folder;
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		WeekData.setDirectoryFromWeek();

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);
		
		scoreText.visible = false;
		scoreBG.visible = false;
		diffText.visible = false;

		if(curSelected >= songs.length) curSelected = 0;
		bg.color = songs[curSelected].color;
		intendedColor = bg.color;
		changeSelection();
		changeDiff();

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */
		super.create();
		FlxG.mouse.visible = true;

		FlxG.mouse.visible = true;
	}

	override function closeSubState() {
		changeSelection();
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color));
	}

	/*public function addWeek(songs:Array<String>, weekNum:Int, weekColor:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);
			this.songs[this.songs.length-1].color = weekColor;

			if (songCharacters.length != 1)
				num++;
		}
	}*/

	var instPlaying:Int = -1;
	private static var vocals:FlxSound = null;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + ((Math.floor(lerpRating * 10000) / 100)) + '%)';
		positionHighscore();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		if (upP)
		{
			changeSelection(-shiftMult);
		}
		if (downP)
		{
			changeSelection(shiftMult);
		}

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		if (controls.UI_RIGHT_P)
			changeDiff(1);
		
		if (FlxG.keys.justPressed.THREE)
			{
				FlxG.mouse.visible = !FlxG.mouse.visible;
			}
		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			if (storymenu){
				storymenu = false;
			}
			curSelected = 0;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if(space)
		{
			/*destroyFreeplayVocals();
			Paths.currentModDirectory = songs[curSelected].folder;
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			if (PlayState.SONG.needsVoices)
				vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
			else
				vocals = new FlxSound();

			FlxG.sound.list.add(vocals);
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
			vocals.play();
			vocals.persist = true;
			vocals.looped = true;
			vocals.volume = 0.7;
			instPlaying = curSelected;*/
			//openSubState(new OptionsState.PreferencesSubstate());
		}
		else if(FlxG.keys.justPressed.CONTROL)
		{
			//openSubState(new OptionsState.ControlsSubstate());
		}
		else if(FlxG.keys.justPressed.ALT)
		{
			//openSubState(new OptionsState.NotesSubstate());
		}
		else if (accepted)
		{
			if (!weeks.contains(songs[curSelected].songName)){
				if (songs[curSelected].songName == "Lost Fever"){
					/*var lostfever:String = "lost-fever";
					var unknown:String = "unknown";*/
					var songLowercase:String = Paths.formatToSongPath("unknown");
					var poop:String = Highscore.formatSong("lost-fever", 2);
					#if MODS_ALLOWED
					if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
					#else
					if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
					#end
						poop = songLowercase;
						curDifficulty = 2;
						trace('Couldnt find file');
					}
					trace(poop);
		
					PlayState.SONG = Song.loadFromJson(poop, songLowercase);
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = curDifficulty;
		
					PlayState.storyWeek = songs[curSelected].week;
					trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
					if(colorTween != null) {
						colorTween.cancel();
					}
					LoadingState.loadAndSwitchState(new PlayState());
					FlxG.sound.music.volume = 0;
						
					destroyFreeplayVocals();
				}else if (songs[curSelected].songName == "Loggo's Halloween DX+"){
					FlxG.openURL('https://www.mediafire.com/file/ylso0qlotekaesg/dxplusbuild5.zip/file');
				}else{
					var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
					var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
					#if MODS_ALLOWED
					if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
					#else
					if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
					#end
						poop = songLowercase;
						curDifficulty = 2;
						trace('Couldnt find file');
					}
					trace(poop);
		
					PlayState.SONG = Song.loadFromJson(poop, songLowercase);
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = curDifficulty;
		
					PlayState.storyWeek = songs[curSelected].week;
					trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
					if(colorTween != null) {
						colorTween.cancel();
					}
					LoadingState.loadAndSwitchState(new PlayState());
					FlxG.sound.music.volume = 0;
						
					destroyFreeplayVocals();
				}
			}
		}
		else if(controls.RESET)
		{
			if (!weeks.contains(songs[curSelected].songName)){
				openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
		}
		super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 2)
			curDifficulty = 2;
		if (curDifficulty >= 2)
			curDifficulty = 2;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '< ' + CoolUtil.difficultyString() + ' >';
		positionHighscore();
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		var newColor:Int = songs[curSelected].color;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		changeDiff();
		Paths.currentModDirectory = songs[curSelected].folder;
	}

	private function positionHighscore() {
		scoreText.x = FlxG.width - scoreText.width - 6;

		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}
