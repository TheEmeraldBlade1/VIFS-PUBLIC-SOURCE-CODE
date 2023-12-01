// you shouldn't be here - emerald
package;

#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxEmitter;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import openfl.utils.Assets as OpenFlAssets;
import editors.ChartingState;
import editors.CharacterEditorState;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import ShopState.BeansPopup;
import Achievements;
import StageData;
import FunkinLua;
import DialogueBoxPsych;

#if sys
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var STRUM_X = 42;
	public static var STRUM_X_MIDDLESCROLL = -278;

	var votingnoteRows:Array<Array<Array<Note>>> = [[],[]];

	public var votingnotes:FlxTypedGroup<Note>;
	public var unspawnVotingNotes:Array<Note> = [];

	var creditsText:FlxTypedGroup<FlxText>;
	var creditoText:FlxText;
	var box:FlxSprite;

	private var task:TaskSong;

	var stopEvents:Bool = false;

		// - fight or flight
		var deadHedgehog:BGSprite;
		var mcdonaldTowers:BGSprite;
		var burgerKingCities:BGSprite;
		var wendysLight:FlxSprite;
		var pizzaHutStage:BGSprite;
		// - the fear mechanic
		var fearUi:FlxSprite;
		var fearUiBg:FlxSprite;
		var fearTween:FlxTween;
		var fearTimer:FlxTimer;
		public var fearNo:Float = 0;
		public var fearBar:FlxBar;
		public static var isFear:Bool = false;
		var doFearCheck = false;
		var fearNum:FlxText;

	public var tweeningChar:Bool = false;

		//armed
		var armedGuy:FlxSprite;
		var dustcloud:FlxSprite;
		var armedDark:FlxSprite;

	var noMissBf:Array<String> = ['Victory_BF'];

	var fofStages:Array<String> = ['monochrome', 'esculent', 'nuzzus', 'limeStarved', 'LostFever', 'starved'];

	var blackChars:Array<String> = ['black', 'blackdk', 'black-run', 'blackalt', 'blackparasite'];

	var dtChars:Array<String> = ['parasite', 'parasiteOld', 'double-trouble', 'dt'];

	var whiteChars:Array<String> = ['white', 'whitedk'];

	var monotoneChars:Array<String> = ['bfscary', 'monotone', 'attack'];

	var dontoverwritenotetextures:Array<String> = ['Opponent 2 Sing', 'Both Opponents Sing', 'Hurt Note'];

	private var highestCombo:Int = 0;

	var sky3:FlxSprite;
	var rocksbg:FlxSprite;
	var rocks3:FlxSprite;
	var ground3:FlxSprite;

	// votingtime
	var table:FlxSprite;
	var votingbg:FlxSprite;
	var otherroom:FlxSprite;
	var chairs:FlxSprite;
	var vt_light:FlxSprite;
	var bars:FlxSprite;
	var bars2:FlxSprite;

	var pet:Pet;

	var opponent2sing:Bool = false;
	var bothOpponentSing:Bool = false;

	var bfAnchorPoint:Array<Float> = [0, 0];
	var dadAnchorPoint:Array<Float> = [0, 0];

	public var bfLegs:Boyfriend;
	public var bfLegsmiss:Boyfriend;
	public var dadlegs:Character;

	var lavaOverlay:FlxSprite; 
	var emberEmitter:FlxEmitter;
	var heatwaveShader:HeatwaveShader;
	var caShader:ChromaticAbberation;
	var glitchShader:GlitchShader;
	var isChrom:Bool;
	var chromAmount:Float = 0;
	var chromFreq:Int = 1;
	var chromTween:FlxTween;
	var glitchTween:FlxTween;


		// airship shit
		var whiteAwkward:FlxSprite;
		var henryTeleporter:FlxSprite;
		var wires:FlxSprite;

		var airshipPlatform:FlxTypedGroup<FlxSprite>;
		var airFarClouds:FlxTypedGroup<FlxSprite>;
		var airMidClouds:FlxTypedGroup<FlxSprite>;
		var airCloseClouds:FlxTypedGroup<FlxSprite>;
		var airBigCloud:FlxSprite;
		var bigCloudSpeed:Float = 10;
		var airshipskyflash:FlxSprite;

		
		// pink
		var cloud1:FlxBackdrop;
		var cloud2:FlxBackdrop;
		var cloud3:FlxBackdrop;
		var cloud4:FlxBackdrop;
		var cloudbig:FlxBackdrop;
		var greymira:FlxSprite;
		var cyanmira:FlxSprite;
		var limemira:FlxSprite;
		var bluemira:FlxSprite;
		var pot:FlxSprite;
		var oramira:FlxSprite;
		var vines:FlxSprite;
	
		var ventNotSus:FlxSprite;
		var greytender:FlxSprite;
		var pretenderDark:FlxSprite;
		var noootomatomongus:FlxSprite;
		var longfuckery:FlxSprite;
	
		var gfDeadPretender:FlxSprite;

	var snow2:FlxSprite;
	var crowd:FlxSprite = new FlxSprite();

		//double kill
		var cargoDark:FlxSprite;
		var cargoDarkFG:FlxSprite;
		var cargoAirsip:FlxSprite;
		var cargoDarken:Bool;
		var cargoReadyKill:Bool;
		var showDlowDK:Bool;
	
		var lightoverlayDK:FlxSprite;
		var mainoverlayDK:FlxSprite;
		var defeatDKoverlay:FlxSprite;


	// defeat
	var defeatthing:FlxSprite;
	var defeatblack:FlxSprite;
	var bodiesfront:FlxSprite;

	var bodies2:FlxSprite;
	var bodies:FlxSprite;
	
	var defeatDark:Bool = false;

	var cameraLocked:Bool = false;

	public static var skinnyNuts:Bool = false;
	public static var skinnyNuts2:Bool = false;

	var airSpeedlines:FlxTypedGroup<FlxSprite>;

	var bfStartpos:FlxPoint;
	var dadStartpos:FlxPoint;
	var gfStartpos:FlxPoint;

	//turbulence! :D
	var turbsky:FlxSprite;
	var backerclouds:FlxSprite;
	var hotairballoon:FlxSprite;
	var midderclouds:FlxSprite;
	var hookarm:FlxSprite;
	var clawshands:FlxSprite;
	var turbFrontCloud:FlxTypedGroup<FlxSprite>;
	var turbEnding:Bool = false;
	
	var turbSpeed:Float = 1.0;

	// toogus
	var saxguy:FlxSprite;
	var lightoverlay:FlxSprite;
	var yellowdead:FlxSprite;
	var mainoverlay:FlxSprite;
	var crowd2:FlxSprite;
	var walker:WalkingCrewmate;
	var ldSpeaker:FlxSprite;
	var toogusblue:FlxSprite;
	var toogusblue2:FlxSprite;
	var toogusorange:FlxSprite;
	var tooguswhite:FlxSprite;
	var bfvent:FlxSprite;
	var loBlack:FlxSprite;

	// ejected SHIT
	var cloudScroll:FlxTypedGroup<FlxSprite>;
	var farClouds:FlxTypedGroup<FlxSprite>;
	var middleBuildings:Array<FlxSprite>;
	var rightBuildings:Array<FlxSprite>;
	var leftBuildings:Array<FlxSprite>;
	var fgCloud:FlxSprite;
	var speedLines:FlxBackdrop;
	var speedPass:Array<Float> = [11000, 11000, 11000, 11000];
	var farSpeedPass:Array<Float> = [11000, 11000, 11000, 11000, 11000, 11000, 11000];
	var plat:FlxSprite;

	//chef
	var chefBluelight:FlxSprite;
	var chefBlacklight:FlxSprite;
	var gray:FlxSprite = new FlxSprite();
	var saster:FlxSprite = new FlxSprite();

	// reactor
	var amogus:FlxSprite;
	var dripster:FlxSprite;
	var yellow:FlxSprite;
	var brown:FlxSprite;
	var ass2:FlxSprite;
	var ass3:FlxSprite;
	var orb:FlxSprite = new FlxSprite();

	//boiling point
	var bpFire:FlxEmitter;
	var bpFire2:FlxEmitter;

	//victory
	var VICTORY_TEXT:FlxSprite;
	var bg_vic:FlxSprite;
	var bg_jelq:FlxSprite;
	var bg_war:FlxSprite;
	var bg_jor:FlxSprite;
	var fog_back:FlxSprite;
	var fog_mid:FlxSprite;
	var fog_front:FlxSprite;
	var spotlights:FlxSprite;
	var vicPulse:FlxSprite;
	//stealing from reactor for victory hey guys
	var victoryDarkness:FlxSprite;

	var snow:FlxSprite;

	var curSpeed:Float = 1;

	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public var healthBarOverlay:FlxSprite;

	var vifsWatermark:FlxText;
	public var water:FlxText;

	var judgementCounter:FlxText;

	public static var instance:PlayState;

	public static var simplescore:Bool = false;

	public static var simplejudge:Bool = false;

	public static var funnimode:Bool = false;

	public static var epicscore:Bool = false;

	public static var holdnotehp:Bool = false;

	var speaker:FlxSprite;

	var notesHitArray:Array<Date> = [];

	public static var ratingStuff:Array<Dynamic> = [
		['Actually Try!!', 0.1],
		['Press Buttons!', 0.15],
		['You Suck!', 0.2],
		['Bro?', 0.25],
		['Ass', 0.3],
		['Crap', 0.35],
		['Shit', 0.4],
		['Loser', 0.45],
		['Bad', 0.5],
		['Stupid', 0.55],
		['Bruh', 0.6],
		['Meh', 0.65],
		['Decent', 0.69],
		['Nice', 0.7],
		['Alright', 0.75],
		['Good', 0.8],
		['Awesome!', 0.85],
		['Great!', 0.9],
		['Sick!', 0.93],
		['Sus!', 0.95],
		['Sussy!', 1],
		['Mistrustful!!', 1]
	];

	public static var ratingAA2AA:Array<Dynamic> = [
		['F', 0.2], //From 0% to 19%
		['E', 0.4], //From 20% to 39%
		['D', 0.5], //From 40% to 49%
		['C', 0.6], //From 50% to 59%
		['B', 0.69], //From 60% to 68%
		['A', 0.7], //69%
		['AA', 0.8], //From 70% to 79%
		['AAA', 0.9], //From 80% to 89%
		['AAAA', 1], //From 90% to 99%
		['AAAAA', 1] //The value on this one isn't used actually, since Perfect is always "1"
	];
	
	#if (haxe >= "4.0.0")
	public var modchartTweens:Map<String, FlxTween> = new Map();
	public var modchartSprites:Map<String, ModchartSprite> = new Map();
	public var modchartTimers:Map<String, FlxTimer> = new Map();
	public var modchartSounds:Map<String, FlxSound> = new Map();
	#else
	public var modchartTweens:Map<String, FlxTween> = new Map<String, FlxTween>();
	public var modchartSprites:Map<String, ModchartSprite> = new Map<String, Dynamic>();
	public var modchartTimers:Map<String, FlxTimer> = new Map<String, FlxTimer>();
	public var modchartSounds:Map<String, FlxSound> = new Map<String, FlxSound>();
	#end

	//event variables
	private var isCameraOnForcedPos:Bool = false;
	#if (haxe >= "4.0.0")
	public var boyfriendMap:Map<String, Boyfriend> = new Map();
	public var dadMap:Map<String, Character> = new Map();
	public var momMap:Map<String, Character> = new Map();
	public var gfMap:Map<String, Character> = new Map();
	#else
	public var boyfriendMap:Map<String, Boyfriend> = new Map<String, Boyfriend>();
	public var dadMap:Map<String, Character> = new Map<String, Character>();
	public var momMap:Map<String, Character> = new Map<String, Character>();
	public var gfMap:Map<String, Character> = new Map<String, Character>();
	#end

	public var BF_X:Float = 770;
	public var BF_Y:Float = 100;
	public var DAD_X:Float = 100;
	public var DAD_Y:Float = 100;
	public var GF_X:Float = 400;
	public var GF_Y:Float = 130;
	public var MOM_X:Float = 100;
	public var MOM_Y:Float = 100;

	public var boyfriendGroup:FlxSpriteGroup;
	public var dadGroup:FlxSpriteGroup;
	public var momGroup:FlxSpriteGroup;
	public var gfGroup:FlxSpriteGroup;

	public static var curStage:String = '';
	public static var isPixelStage:Bool = false;
	public static var SONG:SwagSong = null;
	public static var isStoryMode:Bool = false;
	public static var loadedmenu:Bool = false;
	public static var loadedmenu2:Bool = false;
	public static var loadedmenu3:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;

	public var vocals:FlxSound;

	public var dad:Character;
	public var mom:Character;
	public var gf:Character;
	public var boyfriend:Boyfriend;

	public var dadGhostTween:FlxTween = null;
	public var momGhostTween:FlxTween = null;
	public var bfGhostTween:FlxTween = null;
	public var momGhost:FlxSprite = null;
	public var dadGhost:FlxSprite = null;
	public var bfGhost:FlxSprite = null;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];
	public var eventNotes:Array<Dynamic> = [];

	private var strumLine:FlxSprite;

	//Handles the new epic mega sexy cam code that i've done
	private var camFollow:FlxPoint;
	private var camFollowPos:FlxObject;
	private static var prevCamFollow:FlxPoint;
	private static var prevCamFollowPos:FlxObject;
	private static var resetSpriteCache:Bool = false;

	public var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var opponentStrums:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	public var camZooming:Bool = false;
	private var curSong:String = "";

	public var gfSpeed:Int = 1;
	public var health:Float = 1;
	public var combo:Int = 0;
	public static var hits2:Int = 0;

	private var healthBarBG:AttachedSprite;
	public var healthBar:FlxBar;
	var songPercent:Float = 0;

	private var timeBarBG:AttachedSprite;
	public var timeBar:FlxBar;

	private var Ratings:AttachedSprite;

	private var generatedMusic:Bool = false;
	public var endingSong:Bool = false;
	private var startingSong:Bool = false;
	private var updateTime:Bool = false;
	public static var practiceMode:Bool = false;
	public static var usedPractice:Bool = false;
	public static var changedDifficulty:Bool = false;
	public static var cpuControlled:Bool = false;

	var botplaySine:Float = 0;
	var botplayTxt:FlxText;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;
	public var cameraSpeed:Float = 1;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	var dialogueJson:DialogueFile = null;

	var halloweenBG:BGSprite;
	var halloweenWhite:BGSprite;

	var phillyCityLights:FlxTypedGroup<BGSprite>;
	var phillyTrain:BGSprite;
	var blammedLightsBlack:ModchartSprite;
	var blammedLightsBlackTween:FlxTween;
	var phillyCityLightsEvent:FlxTypedGroup<BGSprite>;
	var phillyCityLightsEventTween:FlxTween;
	var trainSound:FlxSound;

	var limoKillingState:Int = 0;
	var limo:BGSprite;
	var limoMetalPole:BGSprite;
	var limoLight:BGSprite;
	var limoCorpse:BGSprite;
	var limoCorpseTwo:BGSprite;
	var bgLimo:BGSprite;
	var grpLimoParticles:FlxTypedGroup<BGSprite>;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:BGSprite;

	var upperBoppers:BGSprite;
	var bottomBoppers:BGSprite;
	var santa:BGSprite;
	var heyTimer:Float;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();
	var bgGhouls:BGSprite;

	var tankWatchtower:BGSprite;
	var tankGround:BGSprite;
	var tankmanRun:FlxTypedGroup<TankmenBG>;
	var foregroundSprites:FlxTypedGroup<BGSprite>;

	public var songScore:Int = 0;
	public var songScore2:Int = 0;
	public var earlys:Int = 0;
	public var songHits:Int = 0;
	public var songMisses:Int = 0;
	public var starvedFearBarReduce:Int = 0;
	public var ghostMisses:Int = 0;
	public var scoreTxt:FlxText;
	var timeTxt:FlxText;
	var timeTxt2:FlxText;
	var scoreTxtTween:FlxTween;

	public static var campaignScore:Int = 0;
	public static var campaignMisses:Int = 0;
	public static var seenCutscene:Bool = false;
	public static var deathCounter:Int = 0;

	public var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	public var inCutscene:Bool = false;
	var songLength:Float = 0;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	public var luaArray:Array<FunkinLua> = [];

	//Achievement shit
	var keysPressed:Array<Bool> = [false, false, false, false];
	var boyfriendIdleTime:Float = 0.0;
	var boyfriendIdled:Bool = false;

	// Lua shit
	private var luaDebugGroup:FlxTypedGroup<DebugLuaText>;
	public var introSoundsSuffix:String = '';


	var precacheList:Map<String, String> = new Map<String, String>();

	override public function create()
	{

		sicks = 0;
		goods = 0;
		bads = 0;
		shits = 0;
		combo = 0;
		hits2 = 0;
		earlys = 0;

		MyOwnCodeTypedWithMyOwnHands.lmfao = 0.00;
		MyOwnCodeTypedWithMyOwnHands.pansexual = 0.00;
		MyOwnCodeTypedWithMyOwnHands.bisexual = 0;
		MyOwnCodeTypedWithMyOwnHands.lesbian = 0;

		/*if (!Main.debugBuild){
			ClientPrefs.overRidebfDebug = false;
			ClientPrefs.overRidegfDebug = false;
			ClientPrefs.overRidepetDebug = false;
		}*/

		if (blackChars.contains(SONG.player2) || dtChars.contains(SONG.player2)){
			health = 2;
		}

		FunctionHandler.combobreaks = 0;

		if (ClientPrefs.scoretxttype == 2)
		{
			FlxG.save.data.epicscore = false;
			FlxG.save.data.simplescore = true;
		}
		else if (ClientPrefs.scoretxttype == 1)
		{
			FlxG.save.data.epicscore = true;
			FlxG.save.data.simplescore = false;
		}
		else
		{
			FlxG.save.data.epicscore = false;
			FlxG.save.data.simplescore = false;
		}

		if (!ClientPrefs.hss){
			curSpeed = SONG.speed;
		}

		if (ClientPrefs.hss){
			curSpeed = ClientPrefs.speed;
		}

		trace("loading " + SONG.song);

		#if MODS_ALLOWED
		Paths.destroyLoadedImages(resetSpriteCache);
		#end
		resetSpriteCache = false;

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		simplescore = FlxG.save.data.simplescore;

		epicscore = FlxG.save.data.epicscore;

		simplejudge = FlxG.save.data.simplejudge;

		funnimode = FlxG.save.data.funnimode;

		holdnotehp = FlxG.save.data.holdnotehp;

		practiceMode = false;
		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camOther = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;

		missLimited = false;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camOther);
		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();

		FlxCamera.defaultCameras = [camGame];
		CustomFadeTransition.nextCamera = camOther;
		//FlxG.cameras.setDefaultDrawTarget(camGame, true);

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		#if desktop
		storyDifficultyText = '' + CoolUtil.difficultyStuff[storyDifficulty][0];

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: " + WeekData.getCurrentWeek().weekName;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		#end

		GameOverSubstate.resetVariables();
		var songName:String = Paths.formatToSongPath(SONG.song);
		curStage = PlayState.SONG.stage;
		trace('stage is: ' + curStage);
		if(PlayState.SONG.stage == null || PlayState.SONG.stage.length < 1) {
			switch (songName)
			{
				case 'spookeez' | 'south' | 'monster':
					curStage = 'spooky';
				case 'pico' | 'blammed' | 'philly' | 'philly-nice':
					curStage = 'philly';
				case 'milf' | 'satin-panties' | 'high':
					curStage = 'limo';
				case 'cocoa' | 'eggnog':
					curStage = 'mall';
				case 'winter-horrorland':
					curStage = 'mallEvil';
				case 'senpai' | 'roses':
					curStage = 'school';
				case 'thorns':
					curStage = 'schoolEvil';
				case 'ugh':
					curStage = 'tank';
				case 'guns':
					curStage = 'tank';
				case 'stress':
					curStage = 'tank';
				default:
					curStage = 'stage';
			}
		}

		var stageData:StageFile = StageData.getStageFile(curStage);
		if(stageData == null) { //Stage couldn't be found, create a dummy stage for preventing a crash
			stageData = {
				directory: "",
				defaultZoom: 0.9,
				isPixelStage: false,
			
				boyfriend: [770, 100],
				girlfriend: [400, 130],
				opponent: [100, 100],
				secondopp: [100, 100]
			};
		}

		defaultCamZoom = stageData.defaultZoom;
		isPixelStage = stageData.isPixelStage;
		BF_X = stageData.boyfriend[0];
		BF_Y = stageData.boyfriend[1];
		GF_X = stageData.girlfriend[0];
		GF_Y = stageData.girlfriend[1];
		DAD_X = stageData.opponent[0];
		DAD_Y = stageData.opponent[1];
		MOM_X = stageData.secondopp[0];
		MOM_Y = stageData.secondopp[1];

		boyfriendGroup = new FlxSpriteGroup(BF_X, BF_Y);
		dadGroup = new FlxSpriteGroup(DAD_X, DAD_Y);
		gfGroup = new FlxSpriteGroup(GF_X, GF_Y);
		momGroup = new FlxSpriteGroup(MOM_X, MOM_Y);

		switch (curStage)
		{
			case 'starved':
				// fhjdslafhlsa dead hedgehogs

				/*———————————No hedgehogs?———————————
				⠀⣞⢽⢪⢣⢣⢣⢫⡺⡵⣝⡮⣗⢷⢽⢽⢽⣮⡷⡽⣜⣜⢮⢺⣜⢷⢽⢝⡽⣝
				⠸⡸⠜⠕⠕⠁⢁⢇⢏⢽⢺⣪⡳⡝⣎⣏⢯⢞⡿⣟⣷⣳⢯⡷⣽⢽⢯⣳⣫⠇
				⠀⠀⢀⢀⢄⢬⢪⡪⡎⣆⡈⠚⠜⠕⠇⠗⠝⢕⢯⢫⣞⣯⣿⣻⡽⣏⢗⣗⠏⠀
				⠀⠪⡪⡪⣪⢪⢺⢸⢢⢓⢆⢤⢀⠀⠀⠀⠀⠈⢊⢞⡾⣿⡯⣏⢮⠷⠁⠀⠀
				⠀⠀⠀⠈⠊⠆⡃⠕⢕⢇⢇⢇⢇⢇⢏⢎⢎⢆⢄⠀⢑⣽⣿⢝⠲⠉⠀⠀⠀⠀
				⠀⠀⠀⠀⠀⡿⠂⠠⠀⡇⢇⠕⢈⣀⠀⠁⠡⠣⡣⡫⣂⣿⠯⢪⠰⠂⠀⠀⠀⠀
				⠀⠀⠀⠀⡦⡙⡂⢀⢤⢣⠣⡈⣾⡃⠠⠄⠀⡄⢱⣌⣶⢏⢊⠂⠀⠀⠀⠀⠀⠀
				⠀⠀⠀⠀⢝⡲⣜⡮⡏⢎⢌⢂⠙⠢⠐⢀⢘⢵⣽⣿⡿⠁⠁⠀⠀⠀⠀⠀⠀⠀
				⠀⠀⠀⠀⠨⣺⡺⡕⡕⡱⡑⡆⡕⡅⡕⡜⡼⢽⡻⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
				⠀⠀⠀⠀⣼⣳⣫⣾⣵⣗⡵⡱⡡⢣⢑⢕⢜⢕⡝⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
				⠀⠀⠀⣴⣿⣾⣿⣿⣿⡿⡽⡑⢌⠪⡢⡣⣣⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
				⠀⠀⠀⡟⡾⣿⢿⢿⢵⣽⣾⣼⣘⢸⢸⣞⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
				⠀⠀⠀⠀⠁⠇⠡⠩⡫⢿⣝⡻⡮⣒⢽⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
				—————————————————————————————*/

				GameOverSubstate.deathSoundName = 'starved-death';
				GameOverSubstate.loopSoundName = 'starved-loop';
				GameOverSubstate.endSoundName = 'starved-retry';
				GameOverSubstate.characterName = 'bf-starved-die';

				defaultCamZoom = 0.85;
				burgerKingCities = new BGSprite('starved/city', -100, 0, 1, 0.9);
				burgerKingCities.setGraphicSize(Std.int(burgerKingCities.width * 1.5));
				add(burgerKingCities);

				mcdonaldTowers = new BGSprite('starved/towers', -100, 0, 1, 0.9);
				mcdonaldTowers.setGraphicSize(Std.int(mcdonaldTowers.width * 1.5));
				add(mcdonaldTowers);

				pizzaHutStage = new BGSprite('starved/stage', -100, 0, 1, 0.9);
				pizzaHutStage.setGraphicSize(Std.int(pizzaHutStage.width * 1.5));
				add(pizzaHutStage);

				// sonic died
				deadHedgehog = new BGSprite('starved/sonicisfuckingdead', 0, 100, 1, 0.9);
				deadHedgehog.setGraphicSize(Std.int(deadHedgehog.width * 0.65));
				add(deadHedgehog);

				// hes still dead

				wendysLight = new BGSprite('starved/light', 0, 0, 1, 0.9);
				wendysLight.setGraphicSize(Std.int(wendysLight.width * 1.2));

			case 'stage': //Week 1
				var bg:BGSprite = new BGSprite('stageback', -600, -200, 0.9, 0.9);
				add(bg);

				var stageFront:BGSprite = new BGSprite('stagefront', -650, 600, 0.9, 0.9);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				add(stageFront);

				if(!ClientPrefs.lowQuality) {
					var stageLight:BGSprite = new BGSprite('stage_light', -125, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					add(stageLight);
					var stageLight:BGSprite = new BGSprite('stage_light', 1225, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					stageLight.flipX = true;
					add(stageLight);

					var stageCurtains:BGSprite = new BGSprite('stagecurtains', -500, -300, 1.3, 1.3);
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					add(stageCurtains);
				}

				case 'airship':
				GameOverSubstate.characterName = 'bf-running-death';
			
			    airshipPlatform = new FlxTypedGroup<FlxSprite>();
				airFarClouds = new FlxTypedGroup<FlxSprite>();
				airMidClouds = new FlxTypedGroup<FlxSprite>();
				airCloseClouds = new FlxTypedGroup<FlxSprite>();
				airSpeedlines = new FlxTypedGroup<FlxSprite>();

				var sky:FlxSprite = new FlxSprite(-1404, -897.55).loadGraphic(Paths.image('airship/sky', 'impostor'));
				sky.antialiasing = true;
				sky.updateHitbox();
				sky.scale.set(1.5, 1.5);
				sky.scrollFactor.set(0, 0);
				add(sky);

				airshipskyflash = new FlxSprite(0, -200);
				airshipskyflash.frames = Paths.getSparrowAtlas('airship/screamsky', 'impostor');
				airshipskyflash.animation.addByPrefix('bop', 'scream sky  instance 1', 24, false);
				airshipskyflash.setGraphicSize(Std.int(airshipskyflash.width * 3));
				airshipskyflash.antialiasing = false;
				airshipskyflash.scrollFactor.set(1, 1);
				airshipskyflash.active = true;
				add(airshipskyflash);
				airshipskyflash.alpha = 0;

				for (i in 0...2)
				{
					var cloud:FlxSprite = new FlxSprite(-1148.05, -142.2).loadGraphic(Paths.image('airship/farthestClouds', 'impostor'));
					switch (i)
					{
						case 1:
							cloud.setPosition(-5678.95, -142.2);
						case 2:
							cloud.setPosition(3385.95, -142.2);
					}
					cloud.antialiasing = true;
					cloud.updateHitbox();
					cloud.scrollFactor.set(0.1, 0.1);
					airFarClouds.add(cloud);
				}
				add(airFarClouds);

				for (i in 0...2)
				{
					var cloud:FlxSprite = new FlxSprite(-1162.4, 76.55).loadGraphic(Paths.image('airship/backClouds', 'impostor'));
					switch (i)
					{
						case 1:
							cloud.setPosition(3352.4, 76.55);
						case 2:
							cloud.setPosition(-5651.4, 76.55);
					}
					cloud.antialiasing = true;
					cloud.updateHitbox();
					cloud.scrollFactor.set(0.2, 0.2);
					airMidClouds.add(cloud);
				}
				add(airMidClouds);

				var airship:FlxSprite = new FlxSprite(1114.75, -873.05).loadGraphic(Paths.image('airship/airship', 'impostor'));
				airship.antialiasing = true;
				airship.updateHitbox();
				airship.scrollFactor.set(0.25, 0.25);
				add(airship);

				var fan:FlxSprite = new FlxSprite(2285.4, 102);
				fan.frames = Paths.getSparrowAtlas('airship/airshipFan', 'impostor');
				fan.animation.addByPrefix('idle', 'ala avion instance 1', 24, true);
				fan.animation.play('idle');
				fan.updateHitbox();
				fan.antialiasing = true;
				fan.scrollFactor.set(0.27, 0.27);
				add(fan);

				airBigCloud = new FlxSprite(3507.15, -744.2).loadGraphic(Paths.image('airship/bigCloud', 'impostor'));
				airBigCloud.antialiasing = true;
				airBigCloud.updateHitbox();
				airBigCloud.scrollFactor.set(0.4, 0.4);
				add(airBigCloud);

				for (i in 0...2)
				{
					var cloud:FlxSprite = new FlxSprite(-1903.9, 422.15).loadGraphic(Paths.image('airship/frontClouds', 'impostor'));
					switch (i)
					{
						case 1:
							cloud.setPosition(-9900.2, 422.15);
						case 2:
							cloud.setPosition(6092.2, 422.15);
					}
					cloud.antialiasing = true;
					cloud.updateHitbox();
					cloud.scrollFactor.set(0.3, 0.3);
					airCloseClouds.add(cloud);
				}
				add(airCloseClouds);

				for (i in 0...2)
				{
					var platform:FlxSprite = new FlxSprite(-1454.2, 282.25).loadGraphic(Paths.image('airship/fgPlatform', 'impostor'));
					switch (i)
					{
						case 1:
							platform.setPosition(-7184.8, 282.25);

						case 2:
							platform.setPosition(4275.15, 282.25);
					}
					platform.antialiasing = true;
					platform.updateHitbox();
					platform.scrollFactor.set(1, 1);
					add(platform);
					airshipPlatform.add(platform);
				}

				airshipskyflash = new FlxSprite(0, -300);
				airshipskyflash.frames = Paths.getSparrowAtlas('airship/screamsky', 'impostor');
				airshipskyflash.animation.addByPrefix('bop', 'scream sky  instance 1', 24, false);
				airshipskyflash.setGraphicSize(Std.int(airshipskyflash.width * 3));
				airshipskyflash.antialiasing = false;
				airshipskyflash.scrollFactor.set(1, 1);
				airshipskyflash.active = true;
				add(airshipskyflash);
				airshipskyflash.alpha = 0;

				case 'voting': // lotowncorry + 02

				GameOverSubstate.loopSoundName = 'Jorsawsee_Loop';
				GameOverSubstate.endSoundName = 'Jorsawsee_End';

				var otherroom:FlxSprite = new FlxSprite(387.3, 194.1).loadGraphic(Paths.image('airship/backer_groung_voting', 'impostor'));
				otherroom.antialiasing = true;
				otherroom.scrollFactor.set(0.8, 0.8);
				otherroom.active = false;
				add(otherroom);

				var votingbg:FlxSprite = new FlxSprite(-315.15, 52.85).loadGraphic(Paths.image('airship/main_bg_meeting', 'impostor'));
				votingbg.antialiasing = true;
				votingbg.scrollFactor.set(0.95, 0.95);
				votingbg.active = false;
				add(votingbg);

				var chairs:FlxSprite = new FlxSprite(-7.9, 644.85).loadGraphic(Paths.image('airship/CHAIRS!!!!!!!!!!!!!!!', 'impostor'));
				chairs.antialiasing = true;
				chairs.scrollFactor.set(1.0, 1.0);
				chairs.active = false;
				add(chairs);

				table = new FlxSprite(209.4, 679.55).loadGraphic(Paths.image('airship/table_voting', 'impostor'));
				table.antialiasing = true;
				table.scrollFactor.set(1.0, 1.0);
				table.active = false;

				cameraLocked = true;


				case 'polus3':
					curStage = 'polus3';
	
					caShader = new ChromaticAbberation(0);
					add(caShader);
					caShader.amount = -0.2;
					var filter2:ShaderFilter = new ShaderFilter(caShader.shader);
	
					heatwaveShader = new HeatwaveShader();
					add(heatwaveShader);
					var filter:ShaderFilter = new ShaderFilter(heatwaveShader.shader);
					camGame.setFilters([filter, filter2]);
	
					//		var sky:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('polus/SkyPolusLol', 'impostor'));
					//		sky.antialiasing = true;
					//		sky.scrollFactor.set(0.5, 0.5);
					//		sky.active = false;
					//		sky.setGraphicSize(Std.int(sky.width * 1));
					//		add(sky);
	
					//		var rocksbg:FlxSprite = new FlxSprite(-250, -400).loadGraphic(Paths.image('polus/Back_Rocks', 'impostor'));
					//		rocksbg.updateHitbox();
					//		rocksbg.antialiasing = true;
					//		rocksbg.setGraphicSize(Std.int(rocksbg.width * 1));
					//	rocksbg.scrollFactor.set(0.7, 0.7);
					//		rocksbg.active = false;
					//	add(rocksbg);
	
					//		var rocks:FlxSprite = new FlxSprite(-100, 0).loadGraphic(Paths.image('polus/polus2rocks', 'impostor'));
					//		rocks.updateHitbox();
					//		rocks.antialiasing = true;
					//		rocks.setGraphicSize(Std.int(rocks.width * 1));
					//		rocks.scrollFactor.set(0.8, 0.8);
					//		rocks.active = false;
					//		add(rocks);
				
	
					var lava = new FlxSprite(-400, -650);
					lava.frames = Paths.getSparrowAtlas('polus/wallBP', 'impostor');
					lava.animation.addByPrefix('bop', 'Back wall and lava', 24, true);
					lava.animation.play('bop');
					lava.setGraphicSize(Std.int(lava.width * 1));
					lava.antialiasing = false;
					lava.scrollFactor.set(1, 1);
					lava.active = true;
					add(lava);
	
					var ground:FlxSprite = new FlxSprite(1050, 650).loadGraphic(Paths.image('polus/platform', 'impostor'));
					ground.updateHitbox();
					ground.setGraphicSize(Std.int(ground.width * 1));
					ground.antialiasing = true;
					ground.scrollFactor.set(1, 1);
					ground.active = false;
					add(ground);
	
					var bubbles = new FlxSprite(800, 850);
					bubbles.frames = Paths.getSparrowAtlas('polus/bubbles', 'impostor');
					bubbles.animation.addByPrefix('bop', 'Lava Bubbles', 24, true);
					bubbles.animation.play('bop');
					bubbles.setGraphicSize(Std.int(bubbles.width * 1));
					bubbles.antialiasing = false;
					bubbles.scrollFactor.set(1, 1);
					bubbles.active = true;
					add(bubbles);
	
					emberEmitter = new FlxEmitter(-1200, 1000);
	
					for (i in 0 ... 150)
						{
						var p = new FlxParticle();
						p.frames = Paths.getSparrowAtlas('polus/ember', 'impostor');
						p.animation.addByPrefix('ember', 'ember', 24, true);
						p.animation.play('ember');
						p.exists = false;
						p.animation.curAnim.curFrame = FlxG.random.int(0, 9);
						p.blend = ADD;
						emberEmitter.add(p);
					}
					emberEmitter.launchMode = FlxEmitterMode.SQUARE;
					emberEmitter.velocity.set(-50, -400, 50, -800, -100, 0, 100, -800);
					emberEmitter.scale.set(1, 1, 0.8, 0.8, 0, 0, 0, 0);
					emberEmitter.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
					emberEmitter.width = 4200.45;
					emberEmitter.alpha.set(1, 1);
					emberEmitter.lifespan.set(4, 4.5);
					//heartEmitter.loadParticles(Paths.image('mira/littleheart', 'impostor'), 500, 16, true);
							
					emberEmitter.start(false, FlxG.random.float(0.3, 0.4), 100000);
	
					lavaOverlay = new FlxSprite(1000, -50).loadGraphic(Paths.image('polus/overlaythjing', 'impostor'));
					lavaOverlay.updateHitbox();
					lavaOverlay.scale.set(1.5, 1.5);
					lavaOverlay.blend = ADD;
					lavaOverlay.alpha = 0.7;
					lavaOverlay.antialiasing = true;
					lavaOverlay.scrollFactor.set(1, 1);

					sky3 = new FlxSprite(-200, -500).loadGraphic(Paths.image('polus/flashback/SkyPolusLol', 'impostor'));
					sky3.antialiasing = true;
					sky3.scrollFactor.set(0.5, 0.5);
					sky3.active = false;
					sky3.setGraphicSize(Std.int(sky3.width * 1));
					add(sky3);		
					sky3.visible = false;

					rocksbg = new FlxSprite(-250, -400).loadGraphic(Paths.image('polus/flashback/Back_Rocks', 'impostor'));
					rocksbg.updateHitbox();
					rocksbg.antialiasing = true;
					rocksbg.setGraphicSize(Std.int(rocksbg.width * 1));
					rocksbg.scrollFactor.set(0.7, 0.7);
					rocksbg.active = false;
					add(rocksbg);	
					rocksbg.visible = false;
	
					rocks3 = new FlxSprite(-100, 0).loadGraphic(Paths.image('polus/flashback/polus2rocks', 'impostor'));
					rocks3.updateHitbox();
					rocks3.antialiasing = true;
					rocks3.setGraphicSize(Std.int(rocks3.width * 1));
					rocks3.scrollFactor.set(0.8, 0.8);
					rocks3.active = false;
					add(rocks3);	
					rocks3.visible = false;

					crowd = new FlxSprite(-450, -300);
					crowd.frames = Paths.getSparrowAtlas('polus/flashback/Specimen_boppers', 'impostor');
					crowd.animation.addByPrefix('bop', 'Specimen Path Bopping', 24, false);
					crowd.animation.play('bop');
					crowd.antialiasing = true;
					crowd.scrollFactor.set(0.85, 0.85);
					crowd.setGraphicSize(Std.int(crowd.width * 0.8));
					crowd.active = true;
					add(crowd);
					crowd.visible = false;

					ground3 = new FlxSprite(-300, -100).loadGraphic(Paths.image('polus/flashback/polus2ground', 'impostor'));
					ground3.updateHitbox();
					ground3.setGraphicSize(Std.int(ground3.width * 1));
					ground3.antialiasing = true;
					ground3.scrollFactor.set(1, 1);
					ground3.active = false;
					add(ground3);
					ground3.visible = false;

					case 'cargo': // double kill
				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('airship/cargo', 'impostor'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				cargoDark = new FlxSprite(-1000, -1000).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
				cargoDark.antialiasing = true;
				cargoDark.updateHitbox();
				cargoDark.scrollFactor.set();
				cargoDark.alpha = 0.001;
				add(cargoDark);
				
				cargoAirsip = new FlxSprite(2200, 800).loadGraphic(Paths.image('airship/airshipFlashback', 'impostor'));
				cargoAirsip.antialiasing = true;
				cargoAirsip.updateHitbox();
				cargoAirsip.scrollFactor.set(1,1);
				cargoAirsip.setGraphicSize(Std.int(cargoAirsip.width * 1.3));
				cargoAirsip.alpha = 0.001;
				add(cargoAirsip);
		

				cargoDarkFG = new FlxSprite(-1000, -1000).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
				cargoDarkFG.antialiasing = true;
				cargoDarkFG.updateHitbox();
				cargoDarkFG.scrollFactor.set();

			case 'drippypop': // SHIT ASS
				curStage = 'drippypop';

				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('drip/ng', 'impostor'));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				
			case 'henry': // stick Min
				var bg:BGSprite = new BGSprite('stagehenry', -1600, -300, 1, 1);
				add(bg);

			if(SONG.song.toLowerCase() == 'reinforcements'){
				trace('enry');

				armedGuy = new FlxSprite(-800, -300);
				armedGuy.frames = Paths.getSparrowAtlas('henry/i_schee_u_enry', 'impostor');
				armedGuy.animation.addByPrefix('crash', 'rhm intro shadow', 16, false);
				armedGuy.antialiasing = true;
				armedGuy.alpha = 0.001;
			}
			if(SONG.song.toLowerCase() == 'armed' && isStoryMode){
				trace('enry');

				armedDark = new FlxSprite(-300).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
				armedDark.alpha = 0;
				add(armedDark);

				dustcloud = new FlxSprite(120, 450);
				dustcloud.frames = Paths.getSparrowAtlas('henry/Dust_Cloud', 'impostor');
				dustcloud.animation.addByPrefix('dust', 'dust clouds', 24, false);
				dustcloud.antialiasing = true;
			}

				case 'chef': // mayhew has gone mad
				var wall:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('chef/Back Wall Kitchen', 'impostor'));
				wall.antialiasing = true;
				wall.scrollFactor.set(1, 1);
				wall.setGraphicSize(Std.int(wall.width * 0.8));
				wall.active = false;
				add(wall);

				var floor:FlxSprite = new FlxSprite(-850, 1000).loadGraphic(Paths.image('chef/Chef Floor', 'impostor'));
				floor.antialiasing = true;
				floor.scrollFactor.set(1, 1);
				floor.active = false;
				add(floor);

				var backshit:FlxSprite = new FlxSprite(-50, 170).loadGraphic(Paths.image('chef/Back Table Kitchen', 'impostor'));
				backshit.antialiasing = true;
				backshit.scrollFactor.set(1, 1);
				backshit.setGraphicSize(Std.int(backshit.width * 0.8));
				backshit.active = false;
				add(backshit);

				var oven:FlxSprite = new FlxSprite(1600, 400).loadGraphic(Paths.image('chef/oven', 'impostor'));
				oven.antialiasing = true;
				oven.scrollFactor.set(1, 1);
				oven.setGraphicSize(Std.int(oven.width * 0.8));
				oven.active = false;
				add(oven);

				gray = new FlxSprite(1000, 525);
				gray.frames = Paths.getSparrowAtlas('chef/Boppers', 'impostor');
				gray.animation.addByPrefix('bop', 'grey', 24, false);
				gray.animation.play('bop');
				gray.antialiasing = true;
				gray.scrollFactor.set(1, 1);
				gray.setGraphicSize(Std.int(gray.width * 0.8));
				gray.active = true;
				add(gray);

				saster = new FlxSprite(1300, 525);
				saster.frames = Paths.getSparrowAtlas('chef/Boppers', 'impostor');
				saster.animation.addByPrefix('bop', 'saster', 24, false);
				saster.animation.play('bop');
				saster.antialiasing = true;
				saster.scrollFactor.set(1, 1);
				saster.setGraphicSize(Std.int(saster.width * 1.2));
				saster.active = true;
				add(saster);

				var frontable:FlxSprite = new FlxSprite(800, 700).loadGraphic(Paths.image('chef/Kitchen Counter', 'impostor'));
				frontable.antialiasing = true;
				frontable.scrollFactor.set(1, 1);
				frontable.active = false;
				add(frontable);

				chefBluelight = new FlxSprite(0, -300).loadGraphic(Paths.image('chef/bluelight', 'impostor'));
				chefBluelight.antialiasing = true;
				chefBluelight.scrollFactor.set(1, 1);
				chefBluelight.active = false;
				chefBluelight.blend = ADD;

				chefBlacklight = new FlxSprite(0, -300).loadGraphic(Paths.image('chef/black_overhead_shadow', 'impostor'));
				chefBlacklight.antialiasing = true;
				chefBlacklight.scrollFactor.set(1, 1);
				chefBlacklight.active = false;

				case 'grey': // SHIT ASS
				curStage = 'grey';
				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('airship/graybg', 'impostor'));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				var thebackground = new FlxSprite(1930, 400);
				thebackground.frames = Paths.getSparrowAtlas('airship/grayglowy', 'impostor');
				thebackground.animation.addByPrefix('bop', 'jar??', 24, true);
				thebackground.animation.play('bop');
				thebackground.antialiasing = true;
				thebackground.scrollFactor.set(1, 1);
				thebackground.setGraphicSize(Std.int(thebackground.width * 1));
				thebackground.active = true;
				add(thebackground);

				crowd = new FlxSprite(240, 350);
				crowd.frames = Paths.getSparrowAtlas('airship/grayblack', 'impostor');
				crowd.animation.addByPrefix('bop', 'whoisthismf', 24, false);
				crowd.animation.play('bop');
				crowd.antialiasing = true;
				crowd.scrollFactor.set(1, 1);
				crowd.setGraphicSize(Std.int(crowd.width * 1));
				crowd.active = true;
				add(crowd);

			case 'who': // dead dead guy
				var bg:FlxSprite = new FlxSprite(0, 100).loadGraphic(Paths.image('polus/deadguy', 'impostor'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);
				cameraLocked = true;


				case 'defeat':
					GameOverSubstate.characterName = 'bf-defeat-dead';
					GameOverSubstate.deathSoundName = 'defeat_kill_sfx';
	
					curStage = 'defeat';
	
					defeatthing = new FlxSprite(-400, -150);
					defeatthing.frames = Paths.getSparrowAtlas('defeat');
					defeatthing.animation.addByPrefix('bop', 'defeat', 24, false);
					defeatthing.animation.play('bop');
					defeatthing.setGraphicSize(Std.int(defeatthing.width * 1.3));
					defeatthing.antialiasing = true;
					defeatthing.scrollFactor.set(0.8, 0.8);
					defeatthing.active = true;
					add(defeatthing);
	
					bodies2 = new FlxSprite(-500, 150).loadGraphic(Paths.image('lol thing'));
					bodies2.antialiasing = true;
					bodies2.setGraphicSize(Std.int(bodies2.width * 1.3));
					bodies2.scrollFactor.set(0.9, 0.9);
					bodies2.active = false;
					bodies2.alpha = 0;
					add(bodies2);
	
					bodies = new FlxSprite(-2760, 0).loadGraphic(Paths.image('deadBG'));
					bodies.setGraphicSize(Std.int(bodies.width * 0.4));
					bodies.antialiasing = true;
					bodies.scrollFactor.set(0.9, 0.9);
					bodies.active = false;
					bodies.alpha = 0;
					add(bodies);
	
					defeatblack = new FlxSprite().makeGraphic(FlxG.width * 4, FlxG.height + 700, FlxColor.BLACK);
					defeatblack.alpha = 0;
					defeatblack.screenCenter(X);
					defeatblack.screenCenter(Y);
					add(defeatblack);
	
					
					mainoverlayDK = new FlxSprite(250, 125).loadGraphic(Paths.image('defeatfnf'));
					mainoverlayDK.antialiasing = true;
					mainoverlayDK.scrollFactor.set(1, 1);
					mainoverlayDK.active = false;
					mainoverlayDK.setGraphicSize(Std.int(mainoverlayDK.width * 2));
					mainoverlayDK.alpha = 0;
					add(mainoverlayDK);
					
	
					bodiesfront = new FlxSprite(-2830, 0).loadGraphic(Paths.image('deadFG'));
					bodiesfront.setGraphicSize(Std.int(bodiesfront.width * 0.4));
					bodiesfront.antialiasing = true;
					bodiesfront.scrollFactor.set(0.5, 1);
					bodiesfront.active = false;
					bodiesfront.alpha = 0;
	
					missLimited = true;


			case 'toogus':
				curStage = 'toogus';
					var bg:FlxSprite = new FlxSprite(-1600, 50).loadGraphic(Paths.image('mirabg'));
					bg.setGraphicSize(Std.int(bg.width * 1.06));
					bg.antialiasing = true;
					bg.scrollFactor.set(1, 1);
					bg.active = false;
					add(bg);
	
					//	bgDark = new FlxSprite(0,50).loadGraphic(Paths.image('MiraDark'));
					//	bgDark.setGraphicSize(Std.int(bgDark.width * 1.4));
					//	bgDark.antialiasing = true;
					//	bgDark.scrollFactor.set(1, 1);
					//	bgDark.active = false;
					//	bgDark.alpha = 0;
					//	add(bgDark);
	
					var fg:FlxSprite = new FlxSprite(-1600, 50).loadGraphic(Paths.image('mirafg'));
					fg.setGraphicSize(Std.int(fg.width * 1.06));
					fg.antialiasing = true;
					fg.scrollFactor.set(1, 1);
					fg.active = false;
					add(fg);
	
					//	machineDark = new FlxSprite(1000, 150).loadGraphic(Paths.image('vending_machineDark'));
					//	machineDark.updateHitbox();
					//	machineDark.antialiasing = true;
					///	machineDark.scrollFactor.set(1, 1);
					//	machineDark.active = false;
					//	machineDark.alpha = 0;
					//	add(machineDark);
	
					if (SONG.song.toLowerCase() == 'sussus toogus')
					{
						walker = new WalkingCrewmate(FlxG.random.int(0, 1), [-700, 1850], 50, 0.8);
						add(walker);
	
						var walker2:WalkingCrewmate = new WalkingCrewmate(FlxG.random.int(2, 3), [-700, 1850], 50, 0.8);
						add(walker2);
	
						var walker3:WalkingCrewmate = new WalkingCrewmate(FlxG.random.int(4, 5), [-700, 1850], 50, 0.8);
						add(walker3);
					}

					if (SONG.song.toLowerCase() == 'lights-down')
						{
							toogusblue = new FlxSprite(1200, 250);
							toogusblue.frames = Paths.getSparrowAtlas('mira/mirascaredmates', 'impostor');
							toogusblue.animation.addByPrefix('bop', 'blue', 24, false);
							toogusblue.animation.addByPrefix('bop2', '1body', 24, false);
							toogusblue.animation.play('bop');
							toogusblue.setGraphicSize(Std.int(toogusblue.width * 0.7));
							toogusblue.scrollFactor.set(1, 1);
							toogusblue.active = true;
							toogusblue.antialiasing = true;
							toogusblue.flipX = true;
							add(toogusblue);
		
							toogusorange = new FlxSprite(-300, 250);
							toogusorange.frames = Paths.getSparrowAtlas('mira/mirascaredmates', 'impostor');
							toogusorange.animation.addByPrefix('bop', 'orange', 24, false);
							toogusorange.animation.addByPrefix('bop2', '2body', 24, false);
							toogusorange.animation.play('bop');
							toogusorange.setGraphicSize(Std.int(toogusorange.width * 0.7));
							toogusorange.scrollFactor.set(1, 1);
							toogusorange.active = true;
							toogusorange.antialiasing = true;
							add(toogusorange);
		
							tooguswhite = new FlxSprite(1350, 200);
							tooguswhite.frames = Paths.getSparrowAtlas('mira/mirascaredmates', 'impostor');
							tooguswhite.animation.addByPrefix('bop', 'white', 24, false);
							tooguswhite.animation.addByPrefix('bop2', '3body', 24, false);
							tooguswhite.animation.play('bop');
							tooguswhite.setGraphicSize(Std.int(tooguswhite.width * 0.9));
							tooguswhite.scrollFactor.set(1, 1);
							tooguswhite.active = true;
							tooguswhite.antialiasing = true;
							tooguswhite.flipX = true;
							add(tooguswhite);
		
							bfvent = new FlxSprite(70, 200);
							bfvent.frames = Paths.getSparrowAtlas('mira/bf_mira_vent', 'impostor');
							bfvent.animation.addByPrefix('vent', 'bf vent', 24, false);
							bfvent.animation.play('vent');
							bfvent.scrollFactor.set(1, 1);
							bfvent.active = true;
							bfvent.antialiasing = true;
							bfvent.alpha = 0.001;
							add(bfvent);
						}
	
					var tbl:FlxSprite = new FlxSprite(-1600, 50).loadGraphic(Paths.image('table_bg'));
					tbl.setGraphicSize(Std.int(tbl.width * 1.06));
					tbl.antialiasing = true;
					tbl.scrollFactor.set(1, 1);
					tbl.active = false;
					add(tbl);
	
					if (SONG.song.toLowerCase() == 'lights-down')
					{
						ldSpeaker = new FlxSprite(400, 420);
						ldSpeaker.frames = Paths.getSparrowAtlas('mira/stereo_taken', 'impostor');
						ldSpeaker.animation.addByPrefix('boom', 'stereo boom', 24, false);
						ldSpeaker.scrollFactor.set(1, 1);
						ldSpeaker.active = true;
						ldSpeaker.antialiasing = true;
						ldSpeaker.visible = false;
						add(ldSpeaker);
					}
	
				//	lightsOutSprite.alpha = 0;
				//	flashSprite.scrollFactor.set(0, 0);
				//	add(lightsOutSprite); // lights out stuff
	
				//	add(stageCurtains);
			
				case 'ejected':
				defaultCamZoom = 0.45;
				GameOverSubstate.deathSoundName = 'ejected_death';
				GameOverSubstate.characterName = 'bf-fall';
				GameOverSubstate.loopSoundName = 'new_Gameover';
				GameOverSubstate.endSoundName = 'gameover-New_end';
				curStage = 'ejected';
				cloudScroll = new FlxTypedGroup<FlxSprite>();
				farClouds = new FlxTypedGroup<FlxSprite>();
				var sky:FlxSprite = new FlxSprite(-2372.25, -4181.7).loadGraphic(Paths.image('ejected/sky', 'impostor'));
				sky.antialiasing = true;
				sky.updateHitbox();
				sky.scrollFactor.set(0, 0);
				add(sky);

				fgCloud = new FlxSprite(-2660.4, -402).loadGraphic(Paths.image('ejected/fgClouds', 'impostor'));
				fgCloud.antialiasing = true;
				fgCloud.updateHitbox();
				fgCloud.scrollFactor.set(0.2, 0.2);
				add(fgCloud);

				for (i in 0...farClouds.members.length)
				{
					add(farClouds.members[i]);
				}
				add(farClouds);

				rightBuildings = [];
				leftBuildings = [];
				middleBuildings = [];
				for (i in 0...2)
				{
					var rightBuilding = new FlxSprite(1022.3, -390.45);
					rightBuilding.frames = Paths.getSparrowAtlas('ejected/buildingSheet', 'impostor');
					rightBuilding.animation.addByPrefix('1', 'BuildingB1', 24, false);
					rightBuilding.animation.addByPrefix('2', 'BuildingB2', 24, false);
					rightBuilding.animation.play('1');
					rightBuilding.antialiasing = true;
					rightBuilding.updateHitbox();
					rightBuilding.scrollFactor.set(0.5, 0.5);
					add(rightBuilding);
					rightBuildings.push(rightBuilding);
				}

				for (i in 0...2)
				{
					var middleBuilding = new FlxSprite(-76.15, 1398.5);
					middleBuilding.frames = Paths.getSparrowAtlas('ejected/buildingSheet', 'impostor');
					middleBuilding.animation.addByPrefix('1', 'BuildingA1', 24, false);
					middleBuilding.animation.addByPrefix('2', 'BuildingA2', 24, false);
					middleBuilding.animation.play('1');
					middleBuilding.antialiasing = true;
					middleBuilding.updateHitbox();
					middleBuilding.scrollFactor.set(0.5, 0.5);
					add(middleBuilding);
					middleBuildings.push(middleBuilding);
				}

				for (i in 0...2)
				{
					var leftBuilding = new FlxSprite(-1099.3, 7286.55);
					leftBuilding.frames = Paths.getSparrowAtlas('ejected/buildingSheet', 'impostor');
					leftBuilding.animation.addByPrefix('1', 'BuildingB1', 24, false);
					leftBuilding.animation.addByPrefix('2', 'BuildingB2', 24, false);
					leftBuilding.animation.play('1');
					leftBuilding.antialiasing = true;
					leftBuilding.updateHitbox();
					leftBuilding.scrollFactor.set(0.5, 0.5);
					add(leftBuilding);
					leftBuildings.push(leftBuilding);
				}

				rightBuildings[0].y = 6803.1;
				middleBuildings[0].y = 8570.5;
				leftBuildings[0].y = 14050.2;

				for (i in 0...3)
				{
					// now i could add the clouds manually
					// but i wont!!! trolled
					var newCloud:FlxSprite = new FlxSprite();
					newCloud.frames = Paths.getSparrowAtlas('ejected/scrollingClouds', 'impostor');
					newCloud.animation.addByPrefix('idle', 'Cloud' + i, 24, false);
					newCloud.animation.play('idle');
					newCloud.updateHitbox();
					newCloud.alpha = 1;

					switch (i)
					{
						case 0:
							newCloud.setPosition(-9.65, -224.35);
							newCloud.scrollFactor.set(0.8, 0.8);
						case 1:
							newCloud.setPosition(-1342.85, -350.45);
							newCloud.scrollFactor.set(0.6, 0.6);
						case 2:
							newCloud.setPosition(1784.65, -957.05);
							newCloud.scrollFactor.set(1.3, 1.3);
						case 3:
							newCloud.setPosition(-2217.45, -1377.65);
							newCloud.scrollFactor.set(1, 1);
					}
					cloudScroll.add(newCloud);
				}

				for (i in 0...7)
				{
					var newCloud:FlxSprite = new FlxSprite();
					newCloud.frames = Paths.getSparrowAtlas('ejected/scrollingClouds', 'impostor');
					newCloud.animation.addByPrefix('idle', 'Cloud' + i, 24, false);
					newCloud.animation.play('idle');
					newCloud.updateHitbox();
					newCloud.alpha = 0.5;

					switch (i)
					{
						case 0:
							newCloud.setPosition(-1308, -1039.9);
						case 1:
							newCloud.setPosition(464.3, -890.5);
						case 2:
							newCloud.setPosition(2458.45, -1085.85);
						case 3:
							newCloud.setPosition(-666.95, -172.05);
						case 4:
							newCloud.setPosition(-1616.6, 1016.95);
						case 5:
							newCloud.setPosition(1714.25, 200.45);
						case 6:
							newCloud.setPosition(-167.05, 710.25);
					}
					farClouds.add(newCloud);
				}

				speedLines = new FlxBackdrop(Paths.image('ejected/speedLines', 'impostor'), 1, 1, true, true);
				speedLines.antialiasing = true;
				speedLines.updateHitbox();
				speedLines.scrollFactor.set(1.3, 1.3);
				speedLines.alpha = 0.3;

					case 'polus':
						curStage = 'polus';
		
						var sky:FlxSprite = new FlxSprite(-400, -400).loadGraphic(Paths.image('polus/polus_custom_sky', 'impostor'));
						sky.antialiasing = true;
						sky.scrollFactor.set(0.5, 0.5);
						sky.setGraphicSize(Std.int(sky.width * 1.4));
						sky.active = false;
						add(sky);
		
						var rocks:FlxSprite = new FlxSprite(-700, -300).loadGraphic(Paths.image('polus/polusrocks', 'impostor'));
						rocks.updateHitbox();
						rocks.antialiasing = true;
						rocks.scrollFactor.set(0.6, 0.6);
						rocks.active = false;
						add(rocks);
		
						var hills:FlxSprite = new FlxSprite(-1050, -180.55).loadGraphic(Paths.image('polus/polusHills', 'impostor'));
						hills.updateHitbox();
						hills.antialiasing = true;
						hills.scrollFactor.set(0.9, 0.9);
						hills.active = false;
						add(hills);
		
						var warehouse:FlxSprite = new FlxSprite(50, -400).loadGraphic(Paths.image('polus/polus_custom_lab', 'impostor'));
						warehouse.updateHitbox();
						warehouse.antialiasing = true;
						warehouse.scrollFactor.set(1, 1);
						warehouse.active = false;
						add(warehouse);
		
						var ground:FlxSprite = new FlxSprite(-1350, 80).loadGraphic(Paths.image('polus/polus_custom_floor', 'impostor'));
						ground.updateHitbox();
						ground.antialiasing = true;
						ground.scrollFactor.set(1, 1);
						ground.active = false;
						add(ground);
		
						speaker = new FlxSprite(300, 185);
						speaker.frames = Paths.getSparrowAtlas('polus/speakerlonely', 'impostor');
						speaker.animation.addByPrefix('bop', 'speakers lonely', 24, false);
						speaker.animation.play('bop');
						speaker.setGraphicSize(Std.int(speaker.width * 1));
						speaker.antialiasing = false;
						speaker.scrollFactor.set(1, 1);
						speaker.active = true;
						speaker.antialiasing = true;
						if (SONG.song.toLowerCase() == 'sabotage')
						{
							add(speaker);
						}
						if (SONG.song.toLowerCase() == 'meltdown')
						{
							GameOverSubstate.characterName = 'bfg-dead';
							var bfdead:FlxSprite = new FlxSprite(600, 525).loadGraphic(Paths.image('polus/bfdead', 'impostor'));
							bfdead.setGraphicSize(Std.int(bfdead.width * 0.8));
							bfdead.updateHitbox();
							bfdead.antialiasing = true;
							bfdead.scrollFactor.set(1, 1);
							bfdead.active = false;
							add(speaker);
							add(bfdead);
						}

						case 'reactor2':
				curStage = 'reactor2';

				var bg0:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('reactor/wallbgthing', 'impostor'));
				bg0.updateHitbox();
				bg0.antialiasing = true;
				bg0.scrollFactor.set(1, 1);
				bg0.active = false;
				add(bg0);

				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('reactor/floornew', 'impostor'));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				toogusorange = new FlxSprite(875, 915);
				toogusorange.frames = Paths.getSparrowAtlas('reactor/yellowcoti', 'impostor');
				toogusorange.animation.addByPrefix('bop', 'Pillars with crewmates instance 1', 24, false);
				toogusorange.animation.play('bop');
				toogusorange.setGraphicSize(Std.int(toogusorange.width * 1));
				toogusorange.scrollFactor.set(1, 1);
				toogusorange.active = true;
				toogusorange.antialiasing = true;
				add(toogusorange);

				var bg2:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('reactor/backbars', 'impostor'));
				bg2.updateHitbox();
				bg2.antialiasing = true;
				bg2.scrollFactor.set(1, 1);
				bg2.active = false;
				add(bg2);

				toogusblue = new FlxSprite(450, 995);
				toogusblue.frames = Paths.getSparrowAtlas('reactor/browngeoff', 'impostor');
				toogusblue.animation.addByPrefix('bop', 'Pillars with crewmates instance 1', 24, false);
				toogusblue.animation.play('bop');
				toogusblue.setGraphicSize(Std.int(toogusblue.width * 1));
				toogusblue.scrollFactor.set(1, 1);
				toogusblue.active = true;
				toogusblue.antialiasing = true;
				add(toogusblue);

				var bg3:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('reactor/frontpillars', 'impostor'));
				bg3.updateHitbox();
				bg3.antialiasing = true;
				bg3.scrollFactor.set(1, 1);
				bg3.active = false;
				add(bg3);

				tooguswhite = new FlxSprite(1200, 100);
				tooguswhite.frames = Paths.getSparrowAtlas('reactor/ball lol', 'impostor');
				tooguswhite.animation.addByPrefix('bop', 'core instance 1', 24, false);
				tooguswhite.animation.play('bop');
				tooguswhite.scrollFactor.set(1, 1);
				tooguswhite.active = true;
				tooguswhite.antialiasing = true;
				add(tooguswhite);

			//	add(stageCurtains);

			case 'victory': // victory

				GameOverSubstate.loopSoundName = 'Jorsawsee_Loop';
				GameOverSubstate.endSoundName = 'Jorsawsee_End';

				VICTORY_TEXT = new FlxSprite(410, 75);
				VICTORY_TEXT.frames = Paths.getSparrowAtlas('victorytext');
				VICTORY_TEXT.animation.addByPrefix('expand', 'VICTORY', 24, false);
				VICTORY_TEXT.animation.play('expand');
				VICTORY_TEXT.antialiasing = true;
				VICTORY_TEXT.scrollFactor.set(0.8, 0.8);
				VICTORY_TEXT.active = true;
				add(VICTORY_TEXT);

				bg_vic = new FlxSprite(-97.75, 191.85);
				bg_vic.frames = Paths.getSparrowAtlas('vic_bgchars');
				bg_vic.animation.addByPrefix('bop', 'lol thing', 24, false);
				bg_vic.animation.play('bop');
				bg_vic.antialiasing = true;
				bg_vic.scrollFactor.set(0.9, 0.9);
				bg_vic.active = true;
				add(bg_vic);

				var fog_back:FlxSprite = new FlxSprite(338.15, 649.4).loadGraphic(Paths.image('fog_back'));
				fog_back.antialiasing = true;
				fog_back.scrollFactor.set(0.95, 0.95);
				fog_back.active = false;
				fog_back.alpha = 0.16;
				add(fog_back);

				bg_jelq = new FlxSprite(676.05, 478.3);
				bg_jelq.frames = Paths.getSparrowAtlas('vic_jelq');
				bg_jelq.animation.addByPrefix('bop', 'jelqeranim', 24, false);
				bg_jelq.animation.play('bop');
				bg_jelq.antialiasing = true;
				bg_jelq.scrollFactor.set(0.975, 0.975);
				bg_jelq.alpha = 0;
				bg_jelq.active = true;
				add(bg_jelq);

				bg_war = new FlxSprite(693.7, 421.9);
				bg_war.frames = Paths.getSparrowAtlas('vic_war');
				bg_war.animation.addByPrefix('bop', 'warchiefbganim', 24, false);
				bg_war.animation.play('bop');
				bg_war.antialiasing = true;
				bg_war.scrollFactor.set(0.975, 0.975);
				bg_war.alpha = 0;
				bg_war.active = true;
				add(bg_war);
				
				bg_jor = new FlxSprite(998.6, 408.9);
				bg_jor.frames = Paths.getSparrowAtlas('vic_jor');
				bg_jor.animation.addByPrefix('bop', 'jorsawseebganim', 24, false);
				bg_jor.animation.play('bop');
				bg_jor.antialiasing = true;
				bg_jor.scrollFactor.set(0.975, 0.975);
				bg_jor.alpha = 0;
				bg_jor.active = true;
				add(bg_jor);

				var fog_mid:FlxSprite = new FlxSprite(-192.9, 607.25).loadGraphic(Paths.image('fog_mid'));
				fog_mid.antialiasing = true;
				fog_mid.scrollFactor.set(0.975, 0.975);
				fog_mid.active = false;
				fog_mid.alpha = 0.19;
				add(fog_mid);

			case 'turbulence': // TURBULENCE!!!

				GameOverSubstate.loopSoundName = 'Jorsawsee_Loop';
				GameOverSubstate.endSoundName = 'Jorsawsee_End';
				GameOverSubstate.characterName = 'bf_turb';

				airSpeedlines = new FlxTypedGroup<FlxSprite>();

				turbFrontCloud = new FlxTypedGroup<FlxSprite>();	

				var turbsky:FlxSprite = new FlxSprite(-866.9, -400.05).loadGraphic(Paths.image('airship/turbulence/turbsky', 'impostor'));
				turbsky.antialiasing = true;
				turbsky.scrollFactor.set(0.5, 0.5);
				add(turbsky);
				
				backerclouds = new FlxSprite(1296.55, 175.55).loadGraphic(Paths.image('airship/turbulence/backclouds', 'impostor'));
				backerclouds.antialiasing = true;
				backerclouds.scrollFactor.set(0.65, 0.65);
				add(backerclouds);

				hotairballoon = new FlxSprite(134.7, 147.05).loadGraphic(Paths.image('airship/turbulence/hotairballoon', 'impostor'));
				hotairballoon.antialiasing = true;
				hotairballoon.scrollFactor.set(0.65, 0.65);
				add(hotairballoon);

				midderclouds = new FlxSprite(-313.55, 253.05).loadGraphic(Paths.image('airship/turbulence/midclouds', 'impostor'));
				midderclouds.antialiasing = true;
				midderclouds.scrollFactor.set(0.8, 0.8);
				add(midderclouds);

				hookarm = new FlxSprite(-597.85, 888.4).loadGraphic(Paths.image('airship/turbulence/clawback', 'impostor'));
				hookarm.antialiasing = true;
				hookarm.scrollFactor.set(1, 1);

				clawshands = new FlxSprite(1873, 690.1);
				clawshands.frames = Paths.getSparrowAtlas('airship/turbulence/clawfront', 'impostor');
				clawshands.animation.addByPrefix('squeeze', 'clawhands', 24, false);
				clawshands.animation.play('squeeze');
				clawshands.antialiasing = true;
				clawshands.scrollFactor.set(1, 1);
				clawshands.active = true;


				case 'polus2':
					curStage = 'polus2';
	
					var sky:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('polus/newsky', 'impostor'));
					sky.antialiasing = true;
					sky.scrollFactor.set(1, 1);
					sky.active = false;
					sky.setGraphicSize(Std.int(sky.width * 0.75));
					add(sky);
	
					var cloud:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('polus/newcloud', 'impostor'));
					cloud.antialiasing = true;
					cloud.scrollFactor.set(1, 1);
					cloud.active = false;
					cloud.setGraphicSize(Std.int(cloud.width * 0.75));
					cloud.alpha = 0.59;
					add(cloud);
	
					var rocks:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('polus/newrocks', 'impostor'));
					rocks.antialiasing = true;
					rocks.scrollFactor.set(1, 1);
					rocks.active = false;
					rocks.setGraphicSize(Std.int(rocks.width * 0.75));
					rocks.alpha = 0.49;
					add(rocks);
	
					var backwall:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('polus/backwall', 'impostor'));
					backwall.antialiasing = true;
					backwall.scrollFactor.set(1, 1);
					backwall.active = false;
					backwall.setGraphicSize(Std.int(backwall.width * 0.75));
					add(backwall);
	
					var stage = new FlxSprite(0, 0).loadGraphic(Paths.image('polus/newstage', 'impostor'));
					stage.antialiasing = true;
					stage.scrollFactor.set(1, 1);
					stage.active = false;
					stage.setGraphicSize(Std.int(stage.width * 0.75));
					add(stage);
			
				case 'pretender': // pink stage
					GameOverSubstate.characterName = 'pretender';
					var bg:FlxSprite = new FlxSprite(-1500, -800).loadGraphic(Paths.image('mira/pretender/bg sky', 'impostor'));
					bg.antialiasing = true;
					bg.scrollFactor.set(1, 1);
					bg.active = false;
					add(bg);
	
					var bg:FlxSprite = new FlxSprite(-1300, -100).loadGraphic(Paths.image('mira/pretender/cloud fathest', 'impostor'));
					bg.antialiasing = true;
					bg.scrollFactor.set(1, 1);
					bg.active = false;
					add(bg);
	
					var bg:FlxSprite = new FlxSprite(-1300, 0).loadGraphic(Paths.image('mira/pretender/cloud front', 'impostor'));
					bg.antialiasing = true;
					bg.scrollFactor.set(1, 1);
					bg.active = false;
					add(bg);
	
					cloud1 = new FlxBackdrop(Paths.image('mira/pretender/cloud 1', 'impostor'), 1, 1, true, true);
					cloud1.setPosition(0, -1000);
					cloud1.updateHitbox();
					cloud1.antialiasing = true;
					cloud1.scrollFactor.set(1, 1);
					add(cloud1);
	
					cloud2 = new FlxBackdrop(Paths.image('mira/pretender/cloud 2', 'impostor'), 1, 1, true, true);
					cloud2.setPosition(0, -1200);
					cloud2.updateHitbox();
					cloud2.antialiasing = true;
					cloud2.scrollFactor.set(1, 1);
					add(cloud2);
	
					cloud3 = new FlxBackdrop(Paths.image('mira/pretender/cloud 3', 'impostor'), 1, 1, true, true);
					cloud3.setPosition(0, -1400);
					cloud3.updateHitbox();
					cloud3.antialiasing = true;
					cloud3.scrollFactor.set(1, 1);
					add(cloud3);
	
					cloud4 = new FlxBackdrop(Paths.image('mira/pretender/cloud 4', 'impostor'), 1, 1, true, true);
					cloud4.setPosition(0, -1600);
					cloud4.updateHitbox();
					cloud4.antialiasing = true;
					cloud4.scrollFactor.set(1, 1);
					add(cloud4);
	
					cloudbig = new FlxBackdrop(Paths.image('mira/pretender/bigcloud', 'impostor'), 1, 1, true, true);
					cloudbig.setPosition(0, -1200);
					cloudbig.updateHitbox();
					cloudbig.antialiasing = true;
					cloudbig.scrollFactor.set(1, 1);
					add(cloudbig);
	
					var bg:FlxSprite = new FlxSprite(-1200, -750).loadGraphic(Paths.image('mira/pretender/ground', 'impostor'));
					bg.antialiasing = true;
					bg.scrollFactor.set(1, 1);
					bg.active = false;
					add(bg);
	
					var bg:FlxSprite = new FlxSprite(0, -650).loadGraphic(Paths.image('mira/pretender/front plant', 'impostor'));
					bg.antialiasing = true;
					bg.scrollFactor.set(1, 1);
					bg.active = false;
					add(bg);
	
					var bg:FlxSprite = new FlxSprite(1000, 230).loadGraphic(Paths.image('mira/pretender/knocked over plant', 'impostor'));
					bg.antialiasing = true;
					bg.scrollFactor.set(1, 1);
					bg.active = false;
					add(bg);
	
					var bg:FlxSprite = new FlxSprite(-800, 260).loadGraphic(Paths.image('mira/pretender/knocked over plant 2', 'impostor'));
					bg.antialiasing = true;
					bg.scrollFactor.set(1, 1);
					bg.active = false;
					add(bg);
	
					var deadmungus:FlxSprite = new FlxSprite(950, 250).loadGraphic(Paths.image('mira/pretender/tomatodead', 'impostor'));
					deadmungus.antialiasing = true;
					deadmungus.scrollFactor.set(1, 1);
					deadmungus.active = false;
					add(deadmungus);
	
					gfDeadPretender = new FlxSprite(0, 100);
					gfDeadPretender.frames = Paths.getSparrowAtlas('mira/pretender/gf_dead_p', 'impostor');
					gfDeadPretender.animation.addByPrefix('bop', 'GF Dancing Beat', 24, false);
					gfDeadPretender.animation.play('bop');
					gfDeadPretender.setGraphicSize(Std.int(gfDeadPretender.width * 1.1));
					gfDeadPretender.antialiasing = true;
					gfDeadPretender.active = true;
					add(gfDeadPretender);
	
					var ripbozo:FlxSprite = new FlxSprite(700, 450).loadGraphic(Paths.image('mira/pretender/ripbozo', 'impostor'));
					ripbozo.antialiasing = true;
					ripbozo.setGraphicSize(Std.int(ripbozo.width * 0.7));
					add(ripbozo);
	
					var rhmdead:FlxSprite = new FlxSprite(1350, 450).loadGraphic(Paths.image('mira/pretender/rhm dead', 'impostor'));
					rhmdead.antialiasing = true;
					rhmdead.scrollFactor.set(1, 1);
					rhmdead.active = false;
					add(rhmdead);
	
					bluemira = new FlxSprite(-1150, 400);
					bluemira.frames = Paths.getSparrowAtlas('mira/pretender/blued', 'impostor');
					bluemira.animation.addByPrefix('bop', 'bob bop', 24, false);
					bluemira.animation.play('bop');
					bluemira.antialiasing = true;
					bluemira.scrollFactor.set(1.2, 1);
					bluemira.active = true;
					
					pot = new FlxSprite(-1550, 650).loadGraphic(Paths.image('mira/pretender/front pot', 'impostor'));
					pot.antialiasing = true;
					pot.setGraphicSize(Std.int(pot.width * 1));
					pot.scrollFactor.set(1.2, 1);
					pot.active = false;
	
					vines = new FlxSprite(-1450, -550).loadGraphic(Paths.image('mira/pretender/green', 'impostor'));
					vines.antialiasing = true;
					vines.setGraphicSize(Std.int(vines.width * 1));
					vines.scrollFactor.set(1.2, 1);
					vines.active = false;

					case 'airshipRoom': // thanks fabs

					var element8 = new FlxSprite(-1468, -995).loadGraphic(Paths.image('airship/newAirship/fartingSky', 'impostor'));
					element8.antialiasing = true;
					element8.scale.set(1, 1);
					element8.updateHitbox();
					element8.scrollFactor.set(0.3, 0.3);
					add(element8);
	
					var element5 = new FlxSprite(-1125, 284).loadGraphic(Paths.image('airship/newAirship/backSkyyellow', 'impostor'));
					element5.antialiasing = true;
					element5.scale.set(1, 1);
					element5.updateHitbox();
					element5.scrollFactor.set(0.4, 0.7);
					add(element5);
	
					var element6 = new FlxSprite(1330, 283).loadGraphic(Paths.image('airship/newAirship/yellow cloud 3', 'impostor'));
					element6.antialiasing = true;
					element6.scale.set(1, 1);
					element6.updateHitbox();
					element6.scrollFactor.set(0.5, 0.8);
					add(element6);
	
					var element7 = new FlxSprite(-837, 304).loadGraphic(Paths.image('airship/newAirship/yellow could 2', 'impostor'));
					element7.antialiasing = true;
					element7.scale.set(1, 1);
					element7.updateHitbox();
					element7.scrollFactor.set(0.6, 0.9);
					add(element7);
	
					var element2 = new FlxSprite(-1387, -1231).loadGraphic(Paths.image('airship/newAirship/window', 'impostor'));
					element2.antialiasing = true;
					element2.scale.set(1, 1);
					element2.updateHitbox();
					element2.scrollFactor.set(1, 1);
					add(element2);
	
					var element4 = new FlxSprite(-1541, 242).loadGraphic(Paths.image('airship/newAirship/cloudYellow 1', 'impostor'));
					element4.antialiasing = true;
					element4.scale.set(1, 1);
					element4.updateHitbox();
					element4.scrollFactor.set(0.8, 0.8);
					add(element4);
	
					var element1 = new FlxSprite(-642, 325).loadGraphic(Paths.image('airship/newAirship/backDlowFloor', 'impostor'));
					element1.antialiasing = true;
					element1.scale.set(1, 1);
					element1.updateHitbox();
					element1.scrollFactor.set(0.9, 1);
					add(element1);
	
					var element0 = new FlxSprite(-2440, 336).loadGraphic(Paths.image('airship/newAirship/DlowFloor', 'impostor'));
					element0.antialiasing = true;
					element0.scale.set(1, 1);
					element0.updateHitbox();
					element0.scrollFactor.set(1, 1);
					add(element0);
	
					var element3 = new FlxSprite(-1113, -1009).loadGraphic(Paths.image('airship/newAirship/glowYellow', 'impostor'));
					element3.antialiasing = true;
					element3.blend = ADD;
					element3.scale.set(1, 1);
					element3.updateHitbox();
					element3.scrollFactor.set(1, 1);
					add(element3);
	
					var yellowdead:FlxSprite = new FlxSprite(-240, 736).loadGraphic(Paths.image('deadyellow'));
					yellowdead.antialiasing = true;
					yellowdead.scrollFactor.set(1, 1);
					yellowdead.active = false;
					yellowdead.x -= 470;
					trace(SONG.song.toLowerCase());
					if (SONG.song.toLowerCase() == 'oversight')
					{
						trace('lol');
						add(yellowdead);
					}
	
					whiteAwkward = new FlxSprite(298, 480);
					whiteAwkward.frames = Paths.getSparrowAtlas('airship/newAirship/white_awkward', 'impostor');
					whiteAwkward.animation.addByPrefix('sweat', 'fetal position', 24, true);
					whiteAwkward.animation.addByPrefix('stare', 'white stare', 24, false);
					whiteAwkward.animation.play('sweat');
					whiteAwkward.antialiasing = true;
					add(whiteAwkward);
	
					/*if (isStoryMode && SONG.song.toLowerCase() != 'oversight')
					{
						henryTeleporter = new FlxSprite(998, 620).loadGraphic(Paths.image('airship/newAirship/Teleporter', 'impostor'));
						henryTeleporter.antialiasing = true;
						henryTeleporter.scale.set(1, 1);
						henryTeleporter.updateHitbox();
						henryTeleporter.scrollFactor.set(1, 1);
						henryTeleporter.visible = true;
						add(henryTeleporter);
	
						FlxMouseEventManager.add(henryTeleporter, function onMouseDown(teleporter:FlxSprite)
						{
							henryTeleporter.visible = false;
							henryTeleport();
						}, null, null, null);
					}*/

		}

		if(isPixelStage) {
			introSoundsSuffix = '-pixel';
		}

		add(gfGroup);

		switch (curStage.toLowerCase()){
			case 'cargo':
				add(momGroup);
		}

		loBlack = new FlxSprite().makeGraphic(FlxG.width * 4, FlxG.height + 700, FlxColor.BLACK);
		loBlack.alpha = 0;
		loBlack.screenCenter(X);
		loBlack.screenCenter(Y);

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		switch (curStage.toLowerCase()){
			case 'voting':
				add(momGroup);
			case 'attack':
				add(momGroup);
			case 'charles':
				add(momGroup);
		}

		if (curStage != 'turbulence' && curStage != 'starved'){
			add(boyfriendGroup);
			add(dadGroup);
		}

		if (curStage == 'turbulence'){
			add(dadGroup);
			add(hookarm);
			add(boyfriendGroup);
		}

		if (curStage == 'starved'){
			add(dadGroup);
			add(boyfriendGroup);
		}

		if(curStage.toLowerCase() == 'henry' && SONG.song.toLowerCase() == 'armed'){
			add(momGroup);
		}

		if (curStage == 'defeat'){
			add(bodiesfront);
		}

		if (curStage == 'voting'){
			add(table);
		}
		
		if(curStage == 'spooky') {
			add(halloweenWhite);
		}
		if (curStage == 'tank'){
			add(foregroundSprites);
		}
		switch(curStage.toLowerCase()){
			case 'pretender':
				add(bluemira);
				add(pot);
				add(vines);

				var pretenderLighting:FlxSprite = new FlxSprite(-1670, -700).loadGraphic(Paths.image('mira/pretender/lightingpretender', 'impostor'));
				pretenderLighting.antialiasing = true;
				//pretenderLighting.alpha = 0.33;
				add(pretenderLighting);
			case 'polus3':
				add(emberEmitter);
				add(lavaOverlay);
			case 'chef':
				add(chefBluelight);
				add(chefBlacklight);
			case 'grey':

				caShader = new ChromaticAbberation(0);
				add(caShader);
				caShader.amount = -0.5;
				var filter:ShaderFilter = new ShaderFilter(caShader.shader);
				camGame.setFilters([filter]);

				var lightoverlay:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('airship/grayfg', 'impostor'));
				lightoverlay.antialiasing = true;
				lightoverlay.scrollFactor.set(1, 1);
				lightoverlay.active = false;
				lightoverlay.alpha = 1;
				//lightoverlay.blend = MULTIPLY;
				add(lightoverlay);

				var lightoverlay:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('airship/graymultiply', 'impostor'));
				lightoverlay.antialiasing = true;
				lightoverlay.scrollFactor.set(1, 1);
				lightoverlay.active = false;
				lightoverlay.alpha = 1;
				lightoverlay.blend = MULTIPLY;
				add(lightoverlay);
				
				//var overlayImage:BitmapData = Assets.getBitmapData(Paths.image('airship/grayoverlay', 'impostor'));
				//var overlayShader:OverlayShader = new OverlayShader();

				//overlayShader.setBitmapOverlay(overlayImage);

				//var overlayFilter:ShaderFilter = new ShaderFilter(overlayShader);
				//FlxG.camera.setFilters([overlayFilter]);

				var lightoverlay:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('airship/grayoverlay', 'impostor'));
				lightoverlay.antialiasing = true;
				lightoverlay.scrollFactor.set(1, 1);
				lightoverlay.active = false;
				lightoverlay.alpha = 0.4;
				lightoverlay.blend = MULTIPLY;
				add(lightoverlay);
			case 'reactor2':
				var lightoverlay:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('reactor/frontblack', 'impostor'));
				lightoverlay.antialiasing = true;
				lightoverlay.scrollFactor.set(1, 1);
				lightoverlay.active = false;
				add(lightoverlay);
	
				var mainoverlay:FlxSprite = new FlxSprite(750, 100).loadGraphic(Paths.image('reactor/yeahman', 'impostor'));
				mainoverlay.antialiasing = true;
				mainoverlay.animation.addByPrefix('bop', 'Reactor Overlay Top instance 1', 24, true);
				mainoverlay.animation.play('bop');
				mainoverlay.scrollFactor.set(1, 1);
				mainoverlay.active = false;
				add(mainoverlay);
			case 'toogus':
				saxguy = new FlxSprite(0, 0);
				saxguy.frames = Paths.getSparrowAtlas('mira/cyan_toogus', 'impostor');
				saxguy.animation.addByPrefix('bop', 'Cyan Dancy', 24, true);
				saxguy.animation.play('bop');
				saxguy.updateHitbox();
				saxguy.antialiasing = true;
				saxguy.scrollFactor.set(1, 1);
				saxguy.setGraphicSize(Std.int(saxguy.width * 1));
				saxguy.active = true;
			case 'polus':
				snow = new FlxSprite(0, -250);
				snow.frames = Paths.getSparrowAtlas('polus/snow', 'impostor');
				snow.animation.addByPrefix('cum', 'cum', 24);
				snow.animation.play('cum');
				snow.scrollFactor.set(1, 1);
				snow.antialiasing = true;
				snow.updateHitbox();
				snow.setGraphicSize(Std.int(snow.width * 2));

				add(snow);
				crowd2 = new FlxSprite(-900, 150);
				crowd2.frames = Paths.getSparrowAtlas('polus/boppers_meltdown', 'impostor');
				crowd2.animation.addByPrefix('bop', 'BoppersMeltdown', 24, false);
				crowd2.animation.play('bop');
				crowd2.scrollFactor.set(1.5, 1.5);
				crowd2.antialiasing = true;
				crowd2.updateHitbox();
				crowd2.scale.set(1, 1);
				if (SONG.song.toLowerCase() == 'meltdown')
				{
					add(crowd2);
				}
			case 'victory':
				var spotlights:FlxSprite = new FlxSprite(119.4, 0).loadGraphic(Paths.image('victory_spotlights'));
				spotlights.antialiasing = true;
				spotlights.scrollFactor.set(1, 1);
				spotlights.active = false;
				spotlights.alpha = 0.69;
				spotlights.blend = ADD;
				add(spotlights);
	
				vicPulse = new FlxSprite(-269.85, 261.05);
				vicPulse.frames = Paths.getSparrowAtlas('victory_pulse');
				vicPulse.animation.addByPrefix('pulsate', 'animatedlight', 24, false);
				vicPulse.animation.play('pulsate');
				vicPulse.antialiasing = true;
				vicPulse.scrollFactor.set(1, 1);
				vicPulse.blend = ADD;
				vicPulse.active = true;
				add(vicPulse);
	
				var fog_front:FlxSprite = new FlxSprite(-875.8, 873.70).loadGraphic(Paths.image('fog_front'));
				fog_front.antialiasing = true;
				fog_front.scrollFactor.set(1.5, 1.5);
				fog_front.active = false;
				fog_front.alpha = 0.44;
				add(fog_front);

				case 'ejected':
					bfStartpos = new FlxPoint(1008.6, 504);
					gfStartpos = new FlxPoint(114.4, 78.45);
					dadStartpos = new FlxPoint(-775.75, 274.3);
					if (SONG.song.toLowerCase() == 'ejected'){
						camHUD.visible = false;
						camGame.visible = false;
					}
					for (i in 0...cloudScroll.members.length)
					{
						add(cloudScroll.members[i]);
					}
					add(cloudScroll);
					add(speedLines);

					case 'turbulence':
						add(hookarm);
						add(clawshands);
		
						for (i in 0...2)
							{
								var frontercloud:FlxSprite = new FlxSprite(-1399.75,1012.65).loadGraphic(Paths.image('airship/turbulence/frontclouds', 'impostor'));
								switch (i)
								{
									case 1:
										frontercloud.setPosition(-1399.75, 1012.65);
			
									case 2:
										frontercloud.setPosition(4102, 1012.65);
								}
								frontercloud.antialiasing = true;
								frontercloud.updateHitbox();
								frontercloud.scrollFactor.set(1, 1);
								add(frontercloud);
								turbFrontCloud.add(frontercloud);
							}
		
						var turblight:FlxSprite = new FlxSprite(-83.1, -876.7).loadGraphic(Paths.image('airship/turbulence/TURBLIGHTING', 'impostor'));
						turblight.antialiasing = true;
						turblight.scrollFactor.set(1.3, 1.3);
						turblight.active = false;
						turblight.alpha = 0.41;
						turblight.blend = ADD;
						add(turblight);
						
						for (i in 0...2)
						{
							var speedline:FlxSprite = new FlxSprite(912.75, -1035.95).loadGraphic(Paths.image('airship/speedlines', 'impostor'));
							switch (i)
							{
								case 1:
									speedline.setPosition(3352.1, 135.95);
								case 2:
									speedline.setPosition(-5140.05, 135.95);
							}
							speedline.antialiasing = true;
							speedline.alpha = 0.2;
							speedline.updateHitbox();
							speedline.scrollFactor.set(1.3, 1.3);
							add(speedline);
							airSpeedlines.add(speedline);
						}
						add(airSpeedlines);

						case 'defeat':
							lightoverlay = new FlxSprite(-550, -100).loadGraphic(Paths.image('iluminao omaga'));
							lightoverlay.antialiasing = true;
							lightoverlay.scrollFactor.set(1, 1);
							lightoverlay.active = false;
							lightoverlay.blend = ADD;
							add(lightoverlay);

							case 'polus2':
								snow2 = new FlxSprite(1150, 600);
								snow2.frames = Paths.getSparrowAtlas('polus/snowback', 'impostor');
								snow2.animation.addByPrefix('cum', 'Snow group instance 1', 24);
								snow2.animation.play('cum');
								snow2.scrollFactor.set(1, 1);
								snow2.antialiasing = true;
								snow2.alpha = 0.53;
								snow2.updateHitbox();
								snow2.setGraphicSize(Std.int(snow2.width * 2));
				
								snow = new FlxSprite(1150, 800);
								snow.frames = Paths.getSparrowAtlas('polus/snowfront', 'impostor');
								snow.animation.addByPrefix('cum', 'snow fall front instance 1', 24);
								snow.animation.play('cum');
								snow.scrollFactor.set(1, 1);
								snow.antialiasing = true;
								snow.alpha = 0.37;
								snow.updateHitbox();
								snow.setGraphicSize(Std.int(snow.width * 2));
				
								var mainoverlay:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('polus/newoverlay', 'impostor'));
								mainoverlay.antialiasing = true;
								mainoverlay.scrollFactor.set(1, 1);
								mainoverlay.active = false;
								mainoverlay.setGraphicSize(Std.int(mainoverlay.width * 0.75));
								mainoverlay.alpha = 0.44;
								mainoverlay.blend = ADD;
								add(mainoverlay);
				
								var lightoverlay:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('polus/newoverlay', 'impostor'));
								lightoverlay.antialiasing = true;
								lightoverlay.scrollFactor.set(1, 1);
								lightoverlay.active = false;
								lightoverlay.setGraphicSize(Std.int(lightoverlay.width * 0.75));
								lightoverlay.alpha = 0.21;
								lightoverlay.blend = ADD;
								add(lightoverlay);
								add(snow2);
								add(snow);

								case 'airship':
									for (i in 0...2)
									{
										var speedline:FlxSprite = new FlxSprite(-912.75, -1035.95).loadGraphic(Paths.image('airship/speedlines', 'impostor'));
										switch (i)
										{
											case 1:
												speedline.setPosition(-3352.1, -1035.95);
											case 2:
												speedline.setPosition(5140.05, -1035.95);
										}
										speedline.antialiasing = true;
										speedline.alpha = 0.2;
										speedline.updateHitbox();
										speedline.scrollFactor.set(1.3, 1.3);
										add(speedline);
										airSpeedlines.add(speedline);
									}

									case 'cargo':
										lightoverlayDK = new FlxSprite(0, 0).loadGraphic(Paths.image('airship/scavd', 'impostor'));
										lightoverlayDK.antialiasing = true;
										lightoverlayDK.scrollFactor.set(1, 1);
										lightoverlayDK.active = false;
										lightoverlayDK.alpha = 0.51;
										lightoverlayDK.blend = ADD;
										add(lightoverlayDK);
						
										mainoverlayDK = new FlxSprite(-100, 0).loadGraphic(Paths.image('airship/overlay ass dk', 'impostor'));
										mainoverlayDK.antialiasing = true;
										mainoverlayDK.scrollFactor.set(1, 1);
										mainoverlayDK.active = false;
										mainoverlayDK.alpha = 0.6;
										mainoverlayDK.blend = ADD;
										add(mainoverlayDK);
						
										defeatDKoverlay = new FlxSprite(900, 350).loadGraphic(Paths.image('iluminao omaga'));
										defeatDKoverlay.antialiasing = true;
										defeatDKoverlay.scrollFactor.set(1, 1);
										defeatDKoverlay.active = false;
										defeatDKoverlay.blend = ADD;
										defeatDKoverlay.alpha = 0.001;
										add(defeatDKoverlay);
		}

		/*if (curSong == 'ejected'){
			canPause = false;
			camHUD.visible = false;
			camGame.visible = false;
		}*/

		victoryDarkness = new FlxSprite(0, 0).makeGraphic(3000, 3000, 0xff000000);
		victoryDarkness.alpha = 0;
		add(victoryDarkness);

		#if LUA_ALLOWED
		luaDebugGroup = new FlxTypedGroup<DebugLuaText>();
		luaDebugGroup.cameras = [camOther];
		add(luaDebugGroup);
		#end

		// "GLOBAL" SCRIPTS
		#if LUA_ALLOWED
		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('scripts/')];

		#if MODS_ALLOWED
		foldersToCheck.insert(0, Paths.mods('scripts/'));
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/scripts/'));

		for(mod in Paths.getGlobalMods())
			foldersToCheck.insert(0, Paths.mods(mod + '/scripts/'));
		#end

		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if(file.endsWith('.lua') && !filesPushed.contains(file))
					{
						luaArray.push(new FunkinLua(folder + file));
						filesPushed.push(file);
					}
				}
			}
		}
		#end

		#if (MODS_ALLOWED && LUA_ALLOWED)
		var doPush:Bool = false;
		var luaFile:String = 'stages/' + curStage + '.lua';
		if(FileSystem.exists(Paths.modFolders(luaFile))) {
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}

		if(curStage == 'philly') {
			phillyCityLightsEvent = new FlxTypedGroup<BGSprite>();
			for (i in 0...5)
			{
				var light:BGSprite = new BGSprite('philly/win' + i, -10, 0, 0.3, 0.3);
				light.visible = false;
				light.setGraphicSize(Std.int(light.width * 0.85));
				light.updateHitbox();
				phillyCityLightsEvent.add(light);
			}
		}
		
		if(doPush) 
			luaArray.push(new FunkinLua(luaFile));

		if(!modchartSprites.exists('blammedLightsBlack')) { //Creates blammed light black fade in case you didn't make your own
			blammedLightsBlack = new ModchartSprite(FlxG.width * -0.5, FlxG.height * -0.5);
			blammedLightsBlack.makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
			var position:Int = members.indexOf(gfGroup);
			if(members.indexOf(boyfriendGroup) < position) {
				position = members.indexOf(boyfriendGroup);
			} else if(members.indexOf(dadGroup) < position) {
				position = members.indexOf(dadGroup);
			}
			insert(position, blammedLightsBlack);

			blammedLightsBlack.wasAdded = true;
			modchartSprites.set('blammedLightsBlack', blammedLightsBlack);
		}
		if(curStage == 'philly') insert(members.indexOf(blammedLightsBlack) + 1, phillyCityLightsEvent);
		blammedLightsBlack = modchartSprites.get('blammedLightsBlack');
		blammedLightsBlack.alpha = 0.0;
		#end

		if (ClientPrefs.charOverrides[1] != '' && ClientPrefs.charOverrides[1] != 'gf' && !isStoryMode && !SONG.allowGFskin)
		{
			SONG.player3 = ClientPrefs.charOverrides[1];
		}
		else if (ClientPrefs.overRidegfDebug && Main.debugBuild && SONG.allowGFskin)
		{
			SONG.player3 = ClientPrefs.charOverrides[1];
		}

		var gfVersion:String = SONG.player3;
		if(gfVersion == null || gfVersion.length < 1) {
			switch (curStage)
			{
				case 'limo':
					gfVersion = 'gf-car';
				case 'mall' | 'mallEvil':
					gfVersion = 'gf-christmas';
				case 'school' | 'schoolEvil':
					gfVersion = 'gf-pixel';
				case 'tank':
					gfVersion = 'gf-tankmen';
				default:
					gfVersion = 'gf';
			}
			SONG.player3 = gfVersion; //Fix for the Chart Editor
		}

		gf = new Character(0, 0, gfVersion);
		startCharacterPos(gf);
		if (curSong == 'Ejected')
		{
			gf.scrollFactor.set(0.7, 0.7);
		}
		else
		{
			//gf.scrollFactor.set(1, 1);
			gf.scrollFactor.set(0.95, 0.95);
		}
		gfGroup.add(gf);

		if (curStage == 'starved'){
			gfGroup.visible = false;
		}

		switch(gf.curCharacter){
			case 'gfpolus':
				if (curStage != 'polus2' || curStage != 'polus3'){
					gf.y -= 50;
				}
		}

		if(gfVersion == 'pico-speaker')
			{
				if(!ClientPrefs.lowQuality)
				{
					var firstTank:TankmenBG = new TankmenBG(20, 500, true);
					firstTank.resetShit(20, 600, true);
					firstTank.strumTime = 10;
					tankmanRun.add(firstTank);

					for (i in 0...TankmenBG.animationNotes.length)
					{
						if(FlxG.random.bool(16)) {
							var tankBih = tankmanRun.recycle(TankmenBG);
							tankBih.strumTime = TankmenBG.animationNotes[i][0];
							tankBih.resetShit(500, 200 + FlxG.random.int(50, 100), TankmenBG.animationNotes[i][1] < 2);
							tankmanRun.add(tankBih);
						}
					}
				}
			}

			
		if (SONG.player1 == 'bf-running')
			{
				bfLegs = new Boyfriend(0, 0, 'bf-legs');
				boyfriendGroup.add(bfLegs);
				bfLegsmiss = new Boyfriend(0, 0, 'bf-legsmiss');
				boyfriendGroup.add(bfLegsmiss);
			}


		if (curStage.toLowerCase() == 'charles')
		{
			SONG.player1 = 'henryphone';
		}
		else if (ClientPrefs.charOverrides[0] != '' && ClientPrefs.charOverrides[0] != 'bf' && !isStoryMode && !SONG.allowBFskin)
		{
			SONG.player1 = ClientPrefs.charOverrides[0];
		}
		else if (ClientPrefs.overRidebfDebug && Main.debugBuild && SONG.allowBFskin)
		{
			SONG.player1 = ClientPrefs.charOverrides[0];
		}
		boyfriend = new Boyfriend(0, 0, SONG.player1);
		startCharacterPos(boyfriend);
		boyfriendGroup.add(boyfriend);

		
		if (SONG.player2 == 'black-run')
			{
				dadlegs = new Character(0, 0, 'blacklegs');
				dadGroup.add(dadlegs);
			}
			
		dad = new Character(0, 0, SONG.player2);
		startCharacterPos(dad, true);
		dadGroup.add(dad);

			if (SONG.player2 == 'black-run')
				{
					dadlegs.x = dad.x;
					dadlegs.y = dad.y;
				}

				mom = new Character(0, 0, SONG.player4);
				startCharacterPos(mom, true);
				momGroup.add(mom);

		if(curStage.toLowerCase() == 'turbulence'){
			dad.scrollFactor.set(0.8, 0.9);
			mom.scrollFactor.set(1, 1);
		}else{
			dad.scrollFactor.set(1, 1);
			mom.scrollFactor.set(1, 1);
		}
		
		var camPos:FlxPoint = new FlxPoint(gf.getGraphicMidpoint().x, gf.getGraphicMidpoint().y);
		camPos.x += gf.cameraPosition[0];
		camPos.y += gf.cameraPosition[1];

		if(dad.curCharacter.startsWith('gf')) {
			dad.setPosition(GF_X, GF_Y);
			gf.visible = false;
		}

		pet = new Pet(0, 0, ClientPrefs.charOverrides[2]);
		pet.x += pet.positionArray[0];
		pet.y += pet.positionArray[1];
		pet.alpha = 0.001;
		if (curStage.toLowerCase() != 'alpha' && curStage.toLowerCase() != 'defeat'  && curStage.toLowerCase() != 'who' && !SONG.allowPet)
		{
			pet.alpha = 1;
			boyfriendGroup.add(pet);
		}
		else if (ClientPrefs.overRidepetDebug && Main.debugBuild && SONG.allowPet)
		{
			pet.alpha = 1;
			boyfriendGroup.add(pet);
		}

		switch (curStage){
			case 'starved':
				// boyfriend.x -= 500;
				boyfriend.y += 75;
				dad.x += 300;
				dad.y -= 350;
		}

		add(loBlack);

		switch(curStage)
		{
			case 'limo':
				resetFastCar();
				insert(members.indexOf(gfGroup) - 1, fastCar);
			
			case 'schoolEvil':
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069); //nice
				insert(members.indexOf(dadGroup) - 1, evilTrail);
		}

		var file:String = Paths.json(songName + '/dialogue'); //Checks for json/Psych Engine dialogue
		if (OpenFlAssets.exists(file)) {
			dialogueJson = DialogueBoxPsych.parseDialogue(file);
		}

		var file:String = Paths.txt(songName + '/' + songName + 'Dialogue'); //Checks for vanilla/Senpai dialogue
		if (OpenFlAssets.exists(file)) {
			dialogue = CoolUtil.coolTextFile(file);
		}
		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;
		doof.nextDialogueThing = startNextDialogue;
		doof.skipDialogueThing = skipDialogue;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, 50).makeGraphic(FlxG.width, 10);
		if(ClientPrefs.downScroll) strumLine.y = FlxG.height - 150;
		strumLine.scrollFactor.set();

		if(SONG.player1 == 'bf-running')
			{
				bfLegs.x = boyfriend.x;
				bfLegs.y = boyfriend.y;
				bfLegsmiss.x = boyfriend.x;
				bfLegsmiss.y = boyfriend.y;
			}

			bfAnchorPoint[0] = boyfriend.x;
			bfAnchorPoint[1] = boyfriend.y;
			dadAnchorPoint[0] = boyfriend.x;
			dadAnchorPoint[1] = boyfriend.y;

		timeTxt = new FlxText(STRUM_X + (FlxG.width / 2) - 248, 20, 400, "", 32);
		timeTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;
		timeTxt.visible = !ClientPrefs.hideTime;
		timeTxt.y -= 16;
		timeTxt.x -= 350;
		if(ClientPrefs.downScroll) timeTxt.y = FlxG.height - 45;

		timeTxt2 = new FlxText(STRUM_X + (FlxG.width / 2) - 585, 20, 400, "", 32);
		timeTxt2.setFormat(Paths.font("vcr.ttf"), 14, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt2.scrollFactor.set();
		timeTxt2.alpha = 0;
		timeTxt2.borderSize = 1;
		timeTxt2.visible = !ClientPrefs.hideTime;
		if (ClientPrefs.downScroll)
			timeTxt2.y = FlxG.height - 45;

		vt_light = new FlxSprite(0, 0).loadGraphic(Paths.image('airship/light_voting', 'impostor'));
		vt_light.updateHitbox();
		vt_light.antialiasing = true;
		vt_light.scrollFactor.set(1, 1);
		vt_light.active = false;
		vt_light.blend = 'add';
		vt_light.alpha = 0.46;

		timeBarBG = new AttachedSprite('timeBar');
		timeBarBG.x = timeTxt2.x;
		timeBarBG.y = timeTxt2.y + (timeTxt2.height / 4);
		timeBarBG.scrollFactor.set();
		timeBarBG.alpha = 0;
		timeBarBG.visible = !ClientPrefs.hideTime;
		// timeBarBG.color = FlxColor.BLACK;
		timeBarBG.antialiasing = false;
		timeBarBG.xAdd = -4;
		timeBarBG.yAdd = -4;
		add(timeBarBG);
		

		timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this,
			'songPercent', 0, 1);
		timeBar.scrollFactor.set();
		timeBar.createFilledBar(0xFF2e412e, 0xFF44d844);
		timeBar.numDivisions = 800; // How much lag this causes?? Should i tone it down to idk, 400 or 200?
		timeBar.alpha = 0;
		timeBar.visible = !ClientPrefs.hideTime;
		add(timeBar);
		add(timeTxt);
		timeBarBG.sprTracker = timeBar;
		timeTxt2.x += 10;
		timeTxt2.y += 4;

		bars = new FlxSprite(0, 0).loadGraphic(Paths.image('bars'));
		bars.scrollFactor.set();
		bars.screenCenter();

		bars2 = new FlxSprite(0, 0).loadGraphic(Paths.image('bars'));
		bars2.scrollFactor.set();
		bars2.screenCenter();

		if(curStage.toLowerCase() == 'voting')
		{
			add(vt_light);
			add(bars);
		}

		votingnotes = new FlxTypedGroup<Note>();
		add(votingnotes);

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);
		add(grpNoteSplashes);

		var splash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(splash);
		splash.alpha = 0.0;

		opponentStrums = new FlxTypedGroup<StrumNote>();
		playerStrums = new FlxTypedGroup<StrumNote>();

		// startCountdown();

		generateSong(SONG.song);
		#if LUA_ALLOWED
		for (notetype in noteTypeMap.keys()) {
			var luaToLoad:String = Paths.modFolders('custom_notetypes/' + notetype + '.lua');
			if(FileSystem.exists(luaToLoad)) {
				luaArray.push(new FunkinLua(luaToLoad));
			}
		}
		for (event in eventPushedMap.keys()) {
			var luaToLoad:String = Paths.modFolders('custom_events/' + event + '.lua');
			if(FileSystem.exists(luaToLoad)) {
				luaArray.push(new FunkinLua(luaToLoad));
			}
		}
		#end
		noteTypeMap.clear();
		noteTypeMap = null;
		eventPushedMap.clear();
		eventPushedMap = null;

		if (Assets.exists(Paths.txt(SONG.song.toLowerCase().replace(' ', '-') + "/info")))
		{
			trace('it exists');
			task = new TaskSong(0, 200, SONG.song.toLowerCase().replace(' ', '-'));
			task.cameras = [camOther];
			add(task);
		}

		// After all characters being loaded, it makes then invisible 0.01s later so that the player won't freeze when you change characters
		// add(strumLine);

		camFollow = new FlxPoint();
		camFollowPos = new FlxObject(0, 0, 1, 1);

		snapCamFollowToPos(camPos.x, camPos.y);
		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}
		if (prevCamFollowPos != null)
		{
			camFollowPos = prevCamFollowPos;
			prevCamFollowPos = null;
		}
		add(camFollowPos);

		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow);

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;
		moveCameraSection(0);

		healthBarBG = new AttachedSprite('healthBar');
		healthBarBG.y = FlxG.height * 0.89;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.visible = !ClientPrefs.hideHud;
		healthBarBG.xAdd = -4;
		healthBarBG.yAdd = -4;
		add(healthBarBG);
		if(ClientPrefs.downScroll) healthBarBG.y = 0.11 * FlxG.height;

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		// healthBar
		healthBar.visible = !ClientPrefs.hideHud;
		add(healthBar);
		healthBarBG.sprTracker = healthBar;

		healthBarOverlay = new FlxSprite().loadGraphic(Paths.image('healthBarOverlay'));
		healthBarOverlay.y = FlxG.height * 0.89;
		healthBarOverlay.screenCenter(X);
		healthBarOverlay.scrollFactor.set();
		healthBarOverlay.visible = !ClientPrefs.hideHud;
        healthBarOverlay.color = FlxColor.BLACK;
		healthBarOverlay.x = healthBarBG.x-1.9;
		healthBarOverlay.antialiasing = ClientPrefs.globalAntialiasing;
		add(healthBarOverlay);
		if(ClientPrefs.downScroll) healthBarOverlay.y = 0.11 * FlxG.height;

		// Add Kade Engine watermark
		vifsWatermark = new FlxText(4,healthBarBG.y + 50,0,SONG.song + ' - VIFS', 16);
		vifsWatermark.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		vifsWatermark.scrollFactor.set();
		vifsWatermark.visible = !ClientPrefs.watermark;
		add(vifsWatermark);

		if (ClientPrefs.downScroll)
			vifsWatermark.y = FlxG.height * 0.9 + 45;

		iconP1 = new HealthIcon(boyfriend.healthIcon, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		iconP1.visible = !ClientPrefs.hideiconp1;

		iconP2 = new HealthIcon(dad.healthIcon, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		iconP2.visible = !ClientPrefs.hideiconp2;

		add(iconP1);

		add(iconP2);
		
		reloadHealthBarColors();
		reloadTimeBarColors();
		if (!simplescore)
		{
			{
				scoreTxt = new FlxText(0, healthBarBG.y + 35, FlxG.width, "", 20);
				scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				scoreTxt.scrollFactor.set();
				scoreTxt.screenCenter(X);
			}
		}
		else
		{
			if (ClientPrefs.middleScroll && ClientPrefs.fof)
			{
				scoreTxt = new FlxText(0, healthBarBG.y + 35, FlxG.width, "", 20);
				scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				scoreTxt.scrollFactor.set();
				scoreTxt.screenCenter(X);
			}
			else
			{
				scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width - 190, healthBarBG.y + 25, 0, "", 20);
				scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				scoreTxt.scrollFactor.set();
			}
		}
		scoreTxt.borderSize = 1.25;
		scoreTxt.visible = !ClientPrefs.hidescoretxt;
		add(scoreTxt);

		judgementCounter = new FlxText(20, 0, 0, "", 20);
		judgementCounter.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		judgementCounter.scrollFactor.set();
		judgementCounter.cameras = [camHUD];
		judgementCounter.screenCenter(Y);
		add(judgementCounter);
		if (ClientPrefs.judgementCounter)
			judgementCounter.visible = true;
		else
			judgementCounter.visible = false;

		botplayTxt = new FlxText(400, healthBarBG.y - 55, FlxG.width - 800, "BOTPLAY", 32);
		botplayTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]), CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botplayTxt.scrollFactor.set();
		botplayTxt.borderSize = 1.25;
		botplayTxt.visible = cpuControlled;
		add(botplayTxt);
		if(ClientPrefs.downScroll) {
			botplayTxt.y = timeBarBG.y - 78;
		}

				// nabbed this code from starlight lmao
				if (dad.curCharacter == 'starved')
					{
						fearUi = new FlxSprite().loadGraphic(Paths.image('fearbar'));
						fearUi.scrollFactor.set();
						fearUi.screenCenter();
						fearUi.x += 580;
						fearUi.y -= 50;
			
						fearUiBg = new FlxSprite(fearUi.x, fearUi.y).loadGraphic(Paths.image('fearbarBG'));
						fearUiBg.scrollFactor.set();
						fearUiBg.screenCenter();
						fearUiBg.x += 580;
						fearUiBg.y -= 50;
						add(fearUiBg);
			
						fearBar = new FlxBar(fearUi.x + 30, fearUi.y + 5, BOTTOM_TO_TOP, 21, 275, this, 'fearNo', 0, 100);
						fearBar.scrollFactor.set();
						fearBar.visible = true;
						fearBar.numDivisions = 1000;
						fearBar.createFilledBar(0x00000000, 0xFFFF0000);
						trace('bar added.');
			
						add(fearBar);
						add(fearUi);
					}
			

		strumLineNotes.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		botplayTxt.cameras = [camHUD];
		timeBar.cameras = [camHUD];
		timeBarBG.cameras = [camHUD];
		timeTxt.cameras = [camHUD];
		judgementCounter.cameras = [camHUD];
		healthBarOverlay.cameras = [camHUD];
		vifsWatermark.cameras = [camHUD];
		if (dad.curCharacter == 'starved')
			{
				fearUiBg.cameras = [camHUD];
				fearBar.cameras = [camHUD];
				fearUi.cameras = [camHUD];
			}
		//Ratings.cameras = [camHUD];
		doof.cameras = [camHUD];
		votingnotes.cameras = [camHUD];
		if(curStage.toLowerCase() == 'voting'){
			vt_light.cameras = [camHUD];
			bars.cameras = [camHUD];
			bars2.cameras = [camOther];
		}

		if (curStage == 'victory'){
			healthBar.alpha = 0;
			healthBarBG.alpha = 0;
			healthBarOverlay.alpha = 0;
			iconP1.alpha = 0;
			iconP2.alpha = 0;
		}

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		updateTime = true;

		#if (MODS_ALLOWED && LUA_ALLOWED)
		var doPush:Bool = false;
		var luaFile:String = 'data/' + Paths.formatToSongPath(SONG.song) + '/script.lua';
		if(FileSystem.exists(Paths.modFolders(luaFile))) {
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}
		
		if(doPush) 
			luaArray.push(new FunkinLua(luaFile));
		#end
		
		var daSong:String = Paths.formatToSongPath(curSong);
		if (isStoryMode && !seenCutscene || loadedmenu3 && !seenCutscene || loadedmenu && !seenCutscene)
		{
			switch (daSong)
			{
				case "monster":
					var whiteScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
					add(whiteScreen);
					whiteScreen.scrollFactor.set();
					whiteScreen.blend = ADD;
					camHUD.visible = false;
					snapCamFollowToPos(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
					inCutscene = true;

					FlxTween.tween(whiteScreen, {alpha: 0}, 1, {
						startDelay: 0.1,
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween)
						{
							camHUD.visible = true;
							remove(whiteScreen);
							startCountdown();
						}
					});
					FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
					gf.playAnim('scared', true);
					boyfriend.playAnim('scared', true);

				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;
					inCutscene = true;

					FlxTween.tween(blackScreen, {alpha: 0}, 0.7, {
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween) {
							remove(blackScreen);
						}
					});
					FlxG.sound.play(Paths.sound('Lights_Turn_On'));
					snapCamFollowToPos(400, -2050);
					FlxG.camera.focusOn(camFollow);
					FlxG.camera.zoom = 1.5;

					new FlxTimer().start(0.8, function(tmr:FlxTimer)
					{
						camHUD.visible = true;
						remove(blackScreen);
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
							ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween)
							{
								startCountdown();
							}
						});
					});
				case 'senpai' | 'roses' | 'thorns':
					if(daSong == 'roses') FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				default:
					startCountdown();
			}
			seenCutscene = true;
		} else {
			startCountdown();
		}
		RecalculateRating();

		//PRECACHING MISS SOUNDS BECAUSE I THINK THEY CAN LAG PEOPLE AND FUCK THEM UP IDK HOW HAXE WORKS
		CoolUtil.precacheSound('missnote1');
		CoolUtil.precacheSound('missnote2');
		CoolUtil.precacheSound('missnote3');

		#if desktop
		// Updating Discord Rich Presence.
		if (ratingString == '?'){
			DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString, iconP2.getCharacter(), false, "");
		}else if (songMisses > 0 && ratingString != '?'){
			DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString + " (" + ((Math.floor(ratingPercent * 10000) / 100)) + "%)", iconP2.getCharacter(), false, "RatingFC: " + ratingAcc);
		}else{
			DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString + " (" + ((Math.floor(ratingPercent * 10000) / 100)) + "%)", iconP2.getCharacter(), false, "");
		}
		#end
		super.create();
		if ((SONG.song.toLowerCase() == 'mando' || SONG.song.toLowerCase() == 'dlow') && isStoryMode){
			FlxG.mouse.visible = true;
		}else{
			FlxG.mouse.visible = false;
		}
	}

	public function addTextToDebug(text:String) {
		#if LUA_ALLOWED
		luaDebugGroup.forEachAlive(function(spr:DebugLuaText) {
			spr.y += 20;
		});
		luaDebugGroup.add(new DebugLuaText(text, luaDebugGroup));
		#end
	}

	public function reloadHealthBarColors() {
		if (opponent2sing || bothOpponentSing){
			if (bothOpponentSing){
				healthBar.createFilledBar(FlxColor.fromRGB(mom.healthColorArray[0], dad.healthColorArray[1] + mom.healthColorArray[1], dad.healthColorArray[2]),
				FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));		
			}else{
				healthBar.createFilledBar(FlxColor.fromRGB(mom.healthColorArray[0], mom.healthColorArray[1], mom.healthColorArray[2]),
				FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
			}
			healthBar.updateBar();
		}else{
			healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
			FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
			healthBar.updateBar();
		}
	}

	public function reloadTimeBarColors() {
		if (opponent2sing || bothOpponentSing){
			if (bothOpponentSing){
				timeBar.createFilledBar(FlxColor.fromRGB(mom.healthColorArray[0], dad.healthColorArray[1] + mom.healthColorArray[1], dad.healthColorArray[2]),
				FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
			}else{
				timeBar.createFilledBar(FlxColor.fromRGB(mom.healthColorArray[0], mom.healthColorArray[1], mom.healthColorArray[2]),
				FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
			}
			timeBar.updateBar();
		}else{
			timeBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
			FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
			timeBar.updateBar();
		}
	}

	public function addCharacterToList(newCharacter:String, type:Int) {
		switch(type) {
			case 0:
				if(!boyfriendMap.exists(newCharacter)) {
					var newBoyfriend:Boyfriend = new Boyfriend(0, 0, newCharacter);
					boyfriendMap.set(newCharacter, newBoyfriend);
					boyfriendGroup.add(newBoyfriend);
					startCharacterPos(newBoyfriend);
					newBoyfriend.alpha = 0.00001;
					newBoyfriend.alreadyLoaded = false;
				}

			case 1:
				if(!dadMap.exists(newCharacter)) {
					var newDad:Character = new Character(0, 0, newCharacter);
					dadMap.set(newCharacter, newDad);
					dadGroup.add(newDad);
					startCharacterPos(newDad, true);
					newDad.alpha = 0.00001;
					newDad.alreadyLoaded = false;
				}

			case 2:
				if(!gfMap.exists(newCharacter)) {
					var newGf:Character = new Character(0, 0, newCharacter);
					newGf.scrollFactor.set(0.95, 0.95);
					gfMap.set(newCharacter, newGf);
					gfGroup.add(newGf);
					startCharacterPos(newGf);
					newGf.alpha = 0.00001;
					newGf.alreadyLoaded = false;
				}
			case 3:
				if (!momMap.exists(newCharacter))
				{
					var newMom:Character = new Character(0, 0, newCharacter);
					newMom.scrollFactor.set(0.95, 0.95);
					momMap.set(newCharacter, newMom);
					momGroup.add(newMom);
					startCharacterPos(newMom);
					newMom.alpha = 0.00001;
					newMom.alreadyLoaded = false;
				}
		}
	}
	function startCharacterPos(char:Character, ?gfCheck:Bool = false) {
		if(gfCheck && char.curCharacter.startsWith('gf')) { //IF DAD IS GIRLFRIEND, HE GOES TO HER POSITION
			char.setPosition(GF_X, GF_Y);
			char.scrollFactor.set(0.95, 0.95);
		}
		char.x += char.positionArray[0];
		char.y += char.positionArray[1];
	}

	public function startVideo(name:String):Void {
		#if VIDEOS_ALLOWED
		var foundFile:Bool = false;
		var fileName:String = #if MODS_ALLOWED Paths.modFolders('videos/' + name + '.' + Paths.VIDEO_EXT); #else ''; #end
		#if sys
		if(FileSystem.exists(fileName)) {
			foundFile = true;
		}
		#end

		if(!foundFile) {
			fileName = Paths.video(name);
			#if sys
			if(FileSystem.exists(fileName)) {
			#else
			if(OpenFlAssets.exists(fileName)) {
			#end
				foundFile = true;
			}
		}

		if(foundFile) {
			inCutscene = true;
			var bg = new FlxSprite(-FlxG.width, -FlxG.height).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
			bg.scrollFactor.set();
			bg.cameras = [camHUD];
			add(bg);

			(new FlxVideo(fileName)).finishCallback = function() {
				remove(bg);
				if(endingSong) {
					endSong();
				} else {
					canPause = true;
					camGame.visible = true;
					camHUD.visible = true;
					startCountdown();
				}
			}
			return;
		} else {
			FlxG.log.warn('Couldnt find video file: ' + fileName);
		}
		#end
		if(endingSong) {
			endSong();
		} else {
			startCountdown();
		}
	}

	var dialogueCount:Int = 0;
	//You don't have to add a song, just saying. You can just do "startDialogue(dialogueJson);" and it should work
	public function startDialogue(dialogueFile:DialogueFile, ?song:String = null):Void
	{
		// TO DO: Make this more flexible, maybe?
		if(dialogueFile.dialogue.length > 0) {
			inCutscene = true;
			CoolUtil.precacheSound('dialogue');
			CoolUtil.precacheSound('dialogueClose');
			var doof:DialogueBoxPsych = new DialogueBoxPsych(dialogueFile, song);
			doof.scrollFactor.set();
			if(endingSong) {
				doof.finishThing = endSong;
			} else {
				doof.finishThing = startCountdown;
			}
			doof.nextDialogueThing = startNextDialogue;
			doof.skipDialogueThing = skipDialogue;
			doof.cameras = [camHUD];
			add(doof);
		} else {
			FlxG.log.warn('Your dialogue file is badly formatted!');
			if(endingSong) {
				endSong();
			} else {
				startCountdown();
			}
		}
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		inCutscene = true;
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();
		senpaiEvil.x += 300;

		var songName:String = Paths.formatToSongPath(SONG.song);
		if (songName == 'roses' || songName == 'thorns')
		{
			remove(black);

			if (songName == 'thorns')
			{
				add(red);
				camHUD.visible = false;
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					if (Paths.formatToSongPath(SONG.song) == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
										camHUD.visible = true;
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	/*function tankIntro()
		{
			var songName:String = Paths.formatToSongPath(SONG.song);
			dadGroup.alpha = 0.00001;
			camHUD.visible = false;
			//inCutscene = true; //this would stop the camera movement, oops
	
			var tankman:FlxSprite = new FlxSprite(-20, 320);
			tankman.frames = Paths.getSparrowAtlas('cutscenes/' + songName);
			tankman.antialiasing = ClientPrefs.globalAntialiasing;
			addBehindDad(tankman);
	
			var gfDance:FlxSprite = new FlxSprite(gf.x - 107, gf.y + 140);
			gfDance.antialiasing = ClientPrefs.globalAntialiasing;
			var gfCutscene:FlxSprite = new FlxSprite(gf.x - 104, gf.y + 122);
			gfCutscene.antialiasing = ClientPrefs.globalAntialiasing;
			var boyfriendCutscene:FlxSprite = new FlxSprite(boyfriend.x + 5, boyfriend.y + 20);
			boyfriendCutscene.antialiasing = ClientPrefs.globalAntialiasing;
	
			var tankmanEnd:Void->Void = function()
			{
				var timeForStuff:Float = Conductor.crochet / 1000 * 5;
				FlxG.sound.music.fadeOut(timeForStuff);
				FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, timeForStuff, {ease: FlxEase.quadInOut});
				moveCamera(true);
				startCountdown();
	
				dadGroup.alpha = 1;
				camHUD.visible = true;
	
				var stuff:Array<FlxSprite> = [tankman, gfDance, gfCutscene, boyfriendCutscene];
				for (char in stuff)
				{
					char.kill();
					remove(char);
					char.destroy();
				}
			};
	
			camFollow.set(dad.x + 280, dad.y + 170);
			switch(songName)
			{
				case 'ugh':
					precacheList.set('wellWellWell', 'sound');
					precacheList.set('killYou', 'sound');
					precacheList.set('bfBeep', 'sound');
	
					var wellWellWell:FlxSound = new FlxSound().loadEmbedded(Paths.sound('wellWellWell'));
					FlxG.sound.list.add(wellWellWell);
	
					FlxG.sound.playMusic(Paths.music('DISTORTO'), 0, false);
					FlxG.sound.music.fadeIn();
	
					tankman.animation.addByPrefix('wellWell', 'TANK TALK 1 P1', 24, false);
					tankman.animation.addByPrefix('killYou', 'TANK TALK 1 P2', 24, false);
					tankman.animation.play('wellWell', true);
					FlxG.camera.zoom *= 1.2;
	
					// Well well well, what do we got here?
					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						wellWellWell.play(true);
					});
	
					// Move camera to BF
					new FlxTimer().start(3, function(tmr:FlxTimer)
					{
						camFollow.x += 750;
						camFollow.y += 100;
	
						// Beep!
						new FlxTimer().start(1.5, function(tmr:FlxTimer)
						{
							boyfriend.playAnim('singUP', true);
							boyfriend.specialAnim = true;
							FlxG.sound.play(Paths.sound('bfBeep'));
						});
	
						// Move camera to Tankman
						new FlxTimer().start(3, function(tmr:FlxTimer)
						{
							camFollow.x -= 750;
							camFollow.y -= 100;
	
							tankman.animation.play('killYou', true);
							FlxG.sound.play(Paths.sound('killYou'));
	
							// We should just kill you but... what the hell, it's been a boring day... let's see what you've got!
							new FlxTimer().start(6.1, function(tmr:FlxTimer)
							{
								tankmanEnd();
							});
						});
					});
	
				case 'guns':
					tankman.x += 40;
					tankman.y += 10;
					precacheList.set('tankSong2', 'sound');
	
					var tightBars:FlxSound = new FlxSound().loadEmbedded(Paths.sound('tankSong2'));
					FlxG.sound.list.add(tightBars);
	
					FlxG.sound.playMusic(Paths.music('DISTORTO'), 0, false);
					FlxG.sound.music.fadeIn();
	
					new FlxTimer().start(0.01, function(tmr:FlxTimer) //Fixes sync????
					{
						tightBars.play(true);
					});
	
					tankman.animation.addByPrefix('tightBars', 'TANK TALK 2', 24, false);
					tankman.animation.play('tightBars', true);
					boyfriend.animation.curAnim.finish();
	
					FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.2}, 4, {ease: FlxEase.quadInOut});
					FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.2 * 1.2}, 0.5, {ease: FlxEase.quadInOut, startDelay: 4});
					FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.2}, 1, {ease: FlxEase.quadInOut, startDelay: 4.5});
					new FlxTimer().start(4, function(tmr:FlxTimer)
					{
						gf.playAnim('sad', true);
						gf.animation.finishCallback = function(name:String)
						{
							gf.playAnim('sad', true);
						};
					});
	
					new FlxTimer().start(11.6, function(tmr:FlxTimer)
					{
						tankmanEnd();
	
						gf.dance();
						gf.animation.finishCallback = null;
					});
	
				case 'stress':
					tankman.x -= 54;
					tankman.y -= 14;
					gfGroup.alpha = 0.00001;
					boyfriendGroup.alpha = 0.00001;
					camFollow.set(dad.x + 400, dad.y + 170);
					FlxTween.tween(FlxG.camera, {zoom: 0.9 * 1.2}, 1, {ease: FlxEase.quadInOut});
					foregroundSprites.forEach(function(spr:BGSprite)
					{
						spr.y += 100;
					});
					precacheList.set('stressCutscene', 'sound');
	
					var tankman2 = Paths.getSparrowAtlas('cutscenes/stress2');
					precacheList.set('cutscenes/stress2', 'image');
	
					if (!ClientPrefs.lowQuality)
					{
						gfDance.frames = Paths.getSparrowAtlas('characters/gfTankmen');
						gfDance.animation.addByPrefix('dance', 'GF Dancing at Gunpoint', 24, true);
						gfDance.animation.play('dance', true);
						addBehindGF(gfDance);
					}
	
					gfCutscene.frames = Paths.getSparrowAtlas('cutscenes/stressGF');
					gfCutscene.animation.addByPrefix('dieBitch', 'GF STARTS TO TURN PART 1', 24, false);
					gfCutscene.animation.addByPrefix('getRektLmao', 'GF STARTS TO TURN PART 2', 24, false);
					gfCutscene.animation.play('dieBitch', true);
					gfCutscene.animation.pause();
					addBehindGF(gfCutscene);
					if (!ClientPrefs.lowQuality)
					{
						gfCutscene.alpha = 0.00001;
					}
	
					boyfriendCutscene.frames = Paths.getSparrowAtlas('characters/BOYFRIEND');
					boyfriendCutscene.animation.addByPrefix('idle', 'BF idle dance', 24, false);
					boyfriendCutscene.animation.play('idle', true);
					boyfriendCutscene.animation.curAnim.finish();
					addBehindBF(boyfriendCutscene);
	
					var cutsceneSnd:FlxSound = new FlxSound().loadEmbedded(Paths.sound('stressCutscene'));
					FlxG.sound.list.add(cutsceneSnd);
	
					tankman.animation.addByPrefix('godEffingDamnIt', 'TANK TALK 3', 24, false);
					tankman.animation.play('godEffingDamnIt', true);
	
					var calledTimes:Int = 0;
					var zoomBack:Void->Void = function()
					{
						var camPosX:Float = 630;
						var camPosY:Float = 425;
						camFollow.set(camPosX, camPosY);
						camFollowPos.setPosition(camPosX, camPosY);
						FlxG.camera.zoom = 0.8;
						cameraSpeed = 1;
	
						calledTimes++;
						if (calledTimes > 1)
						{
							foregroundSprites.forEach(function(spr:BGSprite)
							{
								spr.y -= 100;
							});
						}
					}
	
					new FlxTimer().start(0.01, function(tmr:FlxTimer) //Fixes sync????
					{
						cutsceneSnd.play(true);
					});
	
					new FlxTimer().start(15.2, function(tmr:FlxTimer)
					{
						FlxTween.tween(camFollow, {x: 650, y: 300}, 1, {ease: FlxEase.sineOut});
						FlxTween.tween(FlxG.camera, {zoom: 0.9 * 1.2 * 1.2}, 2.25, {ease: FlxEase.quadInOut});
						new FlxTimer().start(2.3, function(tmr:FlxTimer)
						{
							zoomBack();
						});
	
						gfDance.visible = false;
						gfCutscene.alpha = 1;
						gfCutscene.animation.play('dieBitch', true);
						gfCutscene.animation.finishCallback = function(name:String)
						{
							if(name == 'dieBitch') //Next part
							{
								gfCutscene.animation.play('getRektLmao', true);
								gfCutscene.offset.set(224, 445);
							}
							else
							{
								gfCutscene.visible = false;
	
								boyfriendGroup.alpha = 1;
								boyfriendCutscene.visible = false;
								boyfriend.playAnim('bfCatch', true);
								boyfriend.animation.finishCallback = function(name:String)
								{
									if(name != 'idle')
									{
										boyfriend.playAnim('idle', true);
										boyfriend.animation.curAnim.finish(); //Instantly goes to last frame
									}
								};
								gfCutscene.animation.finishCallback = null;
							}
						};
					});
	
					new FlxTimer().start(19.5, function(tmr:FlxTimer)
					{
						tankman.frames = tankman2;
						tankman.animation.addByPrefix('lookWhoItIs', 'TANK TALK 3', 24, false);
						tankman.animation.play('lookWhoItIs', true);
						tankman.x += 90;
						tankman.y += 6;
	
						new FlxTimer().start(0.5, function(tmr:FlxTimer)
						{
							camFollow.set(dad.x + 500, dad.y + 170);
						});
					});
	
					new FlxTimer().start(31.2, function(tmr:FlxTimer)
					{
						boyfriend.playAnim('singUPmiss', true);
						boyfriend.animation.finishCallback = function(name:String)
						{
							if (name == 'singUPmiss')
							{
								boyfriend.playAnim('idle', true);
								boyfriend.animation.curAnim.finish(); //Instantly goes to last frame
							}
						};
	
						camFollow.set(boyfriend.x + 280, boyfriend.y + 200);
						cameraSpeed = 12;
						FlxTween.tween(FlxG.camera, {zoom: 0.9 * 1.2 * 1.2}, 0.25, {ease: FlxEase.elasticOut});
	
						new FlxTimer().start(1, function(tmr:FlxTimer)
						{
							zoomBack();
						});
					});
	
					new FlxTimer().start(35.5, function(tmr:FlxTimer)
					{
						tankmanEnd();
						boyfriend.animation.finishCallback = null;
					});
			}
		}*/

	var startTimer:FlxTimer;
	var finishTimer:FlxTimer = null;

	// For being able to mess with the sprites on Lua
	public var countDownSprites:Array<FlxSprite> = [];

	public function startCountdown():Void
	{
		if(startedCountdown) {
			callOnLuas('onStartCountdown', []);
			return;
		}

		inCutscene = false;
		var ret:Dynamic = callOnLuas('onStartCountdown', []);
		if(ret != FunkinLua.Function_Stop) {
			generateStaticArrows(0);
			generateStaticArrows(1);
			if (ClientPrefs.middleScroll && ClientPrefs.fof)
				{
					if (SONG.song.toLowerCase() != 'double trouble' || SONG.song.toLowerCase() != 'ejected'){
						healthBar.angle += 90;
						healthBar.screenCenter();
						healthBar.x += 500;
						iconP1.x += 1050;
						iconP2.x += 1050;
						iconP2.flipX = true;
						healthBarBG.angle += 90;
						healthBarBG.x += 500;
						healthBar.alpha = 0.75;
						healthBarBG.alpha = 0.75;
						healthBarOverlay.angle += 90;
						healthBarOverlay.x += 500;
						healthBarOverlay.y = healthBarBG.y - 295;
					}
					if (curStage == 'nuzzus' || SONG.song.toLowerCase() == 'double trouble' || SONG.song.toLowerCase() == 'ejected'){
						if (SONG.song.toLowerCase() != 'double trouble' || SONG.song.toLowerCase() != 'ejected'){
							healthBar.visible = false;
							healthBarBG.visible = false;
							healthBarOverlay.visible = false;
						}
						if (SONG.song.toLowerCase() == 'double trouble' || SONG.song.toLowerCase() == 'ejected'){
							//iconP1.visible = false;
							//iconP2.visible = false;
							timeBar.visible = false;
							timeBarBG.visible = false;
							timeTxt.visible = false;
							/*healthBar.alpha = 0.50;
							healthBarBG.alpha = 0.50;
							healthBarOverlay.alpha = 0.50;
							iconP1.alpha = 0.50;
							iconP2.alpha = 0.50;*/
							//scoreTxt.visible = false;
							scoreTxt.y = timeTxt.y;
						}
					}
				}
				if (fofStages.contains(curStage) && !ClientPrefs.middleScroll && !ClientPrefs.fof || curStage == 'ejected' && SONG.song.toLowerCase() == 'double trouble' && !ClientPrefs.middleScroll && !ClientPrefs.fof || curStage == 'ejected' && SONG.song.toLowerCase() == 'ejected' && !ClientPrefs.middleScroll && !ClientPrefs.fof)
					{
						if (SONG.song.toLowerCase() != 'double trouble' && SONG.song.toLowerCase() != 'ejected'){
							healthBar.angle += 90;
							healthBar.screenCenter();
							healthBar.x += 500;
							iconP1.x += 1050;
							iconP2.x += 1050;
							iconP2.flipX = true;
							healthBarBG.angle += 90;
							healthBarBG.x += 500;
							healthBar.alpha = 0.75;
							healthBarBG.alpha = 0.75;
							healthBarOverlay.angle += 90;
							healthBarOverlay.x += 500;
							healthBarOverlay.y = healthBarBG.y - 295;
							if (curStage == 'starved')
								{
									if (!ClientPrefs.middleScroll)
										{
											playerStrums.forEach(function(spr:FlxSprite)
											{
												spr.x -= 332;
												spr.y -= 35;
											});
										}
								}
						}
						if (curStage == 'nuzzus' || SONG.song.toLowerCase() == 'double trouble' || SONG.song.toLowerCase() == 'ejected'){
							if (SONG.song.toLowerCase() != 'double trouble' && SONG.song.toLowerCase() != 'ejected'){
								healthBar.visible = false;
								healthBarBG.visible = false;
								healthBarOverlay.visible = false;
							}
							if (SONG.song.toLowerCase() == 'double trouble' || SONG.song.toLowerCase() == 'ejected'){
								//iconP1.visible = false;
								//iconP2.visible = false;
								timeBar.visible = false;
								timeBarBG.visible = false;
								timeTxt.visible = false;
								/*healthBar.alpha = 0.50;
								healthBarBG.alpha = 0.50;
								healthBarOverlay.alpha = 0.50;
								iconP1.alpha = 0.50;
								iconP2.alpha = 0.50;*/
								//scoreTxt.visible = false;
								scoreTxt.y = timeTxt.y;
							}
						}
						if (!ClientPrefs.middleScroll && !ClientPrefs.fof)
						{
							playerStrums.forEach(function(spr:FlxSprite)
							{
								if (curStage != 'nuzzus'){
									spr.x -= 322;
									spr.y -= 35;
								}
								if (curStage == 'nuzzus'){
									spr.alpha = 0.65;
								}
							});
							opponentStrums.forEach(function(spr:FlxSprite)
							{
								spr.x += 99999;
								spr.alpha = 0;
							});
						}
					}
				if (ClientPrefs.tst)
					scoreTxt.alpha = 0.75;
				else
					scoreTxt.alpha = 1;
			for (i in 0...playerStrums.length) {
				setOnLuas('defaultPlayerStrumX' + i, playerStrums.members[i].x);
				setOnLuas('defaultPlayerStrumY' + i, playerStrums.members[i].y);
			}
			for (i in 0...opponentStrums.length) {
				setOnLuas('defaultOpponentStrumX' + i, opponentStrums.members[i].x);
				setOnLuas('defaultOpponentStrumY' + i, opponentStrums.members[i].y);
				if(ClientPrefs.middleScroll && ClientPrefs.fof || ClientPrefs.nop) opponentStrums.members[i].visible = false;
			}

			startedCountdown = true;
			Conductor.songPosition = 0;
			Conductor.songPosition -= Conductor.crochet * 5;
			setOnLuas('startedCountdown', true);

			var swagCounter:Int = 0;

			startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
			{
				/*if (curSong == 'Ejected'){
					startVideo('ejected');
				}*/
				if (tmr.loopsLeft % gfSpeed == 0 && !gf.stunned && gf.animation.curAnim.name != null && !gf.animation.curAnim.name.startsWith("sing"))
				{
					gf.dance();
				}
				if(tmr.loopsLeft % 2 == 0) {
					if (boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing'))
					{
						boyfriend.dance();
						pet.dance();
					}
					if (dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
					{
						dad.dance();
					}
					if (mom.animation.curAnim != null && !mom.animation.curAnim.name.startsWith('sing') && !mom.stunned)
					{
							mom.dance();
					}
				}
					else if (dad.danceIdle
						&& dad.animation.curAnim != null
						&& !dad.stunned
						&& !dad.curCharacter.startsWith('gf')
						&& !dad.animation.curAnim.name.startsWith("sing"))
					{
						dad.dance();
					}
					else if (mom.danceIdle
						&& mom.animation.curAnim != null
						&& !mom.stunned
						&& !mom.curCharacter.startsWith('gf')
						&& !mom.animation.curAnim.name.startsWith("sing"))
					{
						mom.dance();
					}

				var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
				introAssets.set('default', ['ready', 'set', 'go']);
				introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);

				var introAlts:Array<String> = introAssets.get('default');
				var antialias:Bool = ClientPrefs.globalAntialiasing;
				if(isPixelStage) {
					introAlts = introAssets.get('pixel');
					antialias = false;
				}

				// head bopping for bg characters on Mall
				if(curStage == 'mall') {
					if(!ClientPrefs.lowQuality)
						upperBoppers.dance(true);
	
					bottomBoppers.dance(true);
					santa.dance(true);
				}

				switch (swagCounter)
				{
					case 0:
						Main.unPaused = false;
						FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0.6);
						Main.unPaused = false;
					case 1:
						Main.unPaused = false;
						var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
						ready.scrollFactor.set();
						ready.updateHitbox();

						if (PlayState.isPixelStage)
							ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

						ready.screenCenter();
						ready.antialiasing = antialias;
						add(ready);
						countDownSprites.push(ready);
						FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								countDownSprites.remove(ready);
								remove(ready);
								ready.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0.6);
						Main.unPaused = false;
					case 2:
						Main.unPaused = false;
						var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
						set.scrollFactor.set();

						if (PlayState.isPixelStage)
							set.setGraphicSize(Std.int(set.width * daPixelZoom));

						set.screenCenter();
						set.antialiasing = antialias;
						add(set);
						countDownSprites.push(set);
						FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								countDownSprites.remove(set);
								remove(set);
								set.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0.6);
						Main.unPaused = false;
					case 3:
						Main.unPaused = false;
						var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
						go.scrollFactor.set();

						if (PlayState.isPixelStage)
							go.setGraphicSize(Std.int(go.width * daPixelZoom));

						go.updateHitbox();

						go.screenCenter();
						go.antialiasing = antialias;
						add(go);
						countDownSprites.push(go);
						FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								countDownSprites.remove(go);
								remove(go);
								go.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0.6);
						Main.unPaused = false;
					case 4:
						Main.unPaused = false;
				}

				notes.forEachAlive(function(note:Note) {
					note.copyAlpha = false;
					note.alpha = 1 * note.multAlpha;
				});
				callOnLuas('onCountdownTick', [swagCounter]);

				if (generatedMusic)
				{
					notes.sort(FlxSort.byY, ClientPrefs.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
					votingnotes.sort(FlxSort.byY, ClientPrefs.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
				}

				swagCounter += 1;
				// generateSong('fresh');
			}, 5);
		}
	}
	
	public function addBehindGF(obj:FlxObject)
		{
			insert(members.indexOf(gfGroup), obj);
		}
		public function addBehindBF(obj:FlxObject)
		{
			insert(members.indexOf(boyfriendGroup), obj);
		}
		public function addBehindDad (obj:FlxObject)
		{
			insert(members.indexOf(dadGroup), obj);
		}

	function startNextDialogue() {
		dialogueCount++;
		callOnLuas('onNextDialogue', [dialogueCount]);
	}

	function skipDialogue() {
		callOnLuas('onSkipDialogue', [dialogueCount]);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = finishSong;
		vocals.play();

		if(paused) {
			//trace('Oopsie doopsie! Paused sound');
			FlxG.sound.music.pause();
			vocals.pause();
		}

		creditsText = new FlxTypedGroup<FlxText>();
		//in here, specify your song name and then its credits, then go to the next switch
		if (curStage == 'starved')
		{
				box = new FlxSprite(0, -1000).loadGraphic(Paths.image("box"));
				box.cameras = [camHUD];
				box.setGraphicSize(Std.int(box.height * 0.8));
				box.screenCenter(X);
				add(box);

				var texti:String;
				var size:String;

				texti = "CREDITS\norignal by the vs sonic.exe team\ncover by jkcrz\ncoded to be harder by emerald";
				size = '28';

				creditoText = new FlxText(0, -1000, 0, texti, 28);
				creditoText.cameras = [camHUD];
				creditoText.setFormat(Paths.font("PressStart2P.ttf"), Std.parseInt(size), FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				creditoText.setGraphicSize(Std.int(creditoText.width * 0.8));
				creditoText.updateHitbox();
				creditoText.x += 515;
				creditsText.add(creditoText);
				add(creditsText);
		}

		//this is the timing of the box coming in, specify your song and IF NEEDED, change the amount of time it takes to come in
		//if you want to add it to start at the beginning of the song, type " | ", then add your song name
		//poop fart ahahahahahah
		if (curStage == 'starved')
		{
				var timei:String;

				timei = "2.35";

				FlxG.log.add('BTW THE TIME IS ' + Std.parseFloat(timei));

				new FlxTimer().start(Std.parseFloat(timei), function(tmr:FlxTimer)
					{
						tweencredits();
					});
		}

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;
		FlxTween.tween(timeBar, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		switch(curStage)
		{
			case 'tank':
				if(!ClientPrefs.lowQuality) tankWatchtower.dance();
				foregroundSprites.forEach(function(spr:BGSprite)
				{
					spr.dance();
				});
		}
		#if desktop
		// Updating Discord Rich Presence (with Time Left)
		if (ratingString == '?'){
			DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString, iconP2.getCharacter(), false, "");
		}else if (songMisses > 0 && ratingString != '?'){
			DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString + " (" + ((Math.floor(ratingPercent * 10000) / 100)) + "%)", iconP2.getCharacter(), false, "RatingFC: " + ratingAcc);
		}else{
			DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString + " (" + ((Math.floor(ratingPercent * 10000) / 100)) + "%)", iconP2.getCharacter(), false, "");
		}
		#end
		setOnLuas('songLength', songLength);
		callOnLuas('onSongStart', []);
	}

	function tweencredits()
		{
			FlxTween.tween(creditoText, {y: FlxG.height - 625}, 0.5, {ease: FlxEase.circOut});
			FlxTween.tween(box, {y: 0}, 0.5, {ease: FlxEase.circOut});
			//tween away
			new FlxTimer().start(3, function(tmr:FlxTimer)
				{
					FlxTween.tween(creditoText, {y: -1000}, 0.5, {ease: FlxEase.circOut});
					FlxTween.tween(box, {y: -1000}, 0.5, {ease: FlxEase.circOut});
					//removal
					new FlxTimer().start(0.5, function(tmr:FlxTimer)
						{
							remove(creditsText);
							remove(box);
						});
				});
		}

	var debugNum:Int = 0;
	private var noteTypeMap:Map<String, Bool> = new Map<String, Bool>();
	private var eventPushedMap:Map<String, Bool> = new Map<String, Bool>();

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);
		FlxG.sound.list.add(new FlxSound().loadEmbedded(Paths.inst(PlayState.SONG.song)));

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;
		var rmtjData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var otherChartData:String = 'voting-time';
		if(curSong.toLowerCase() == 'monotone attack'){
			otherChartData = 'monotone-attack';
		}
		rmtjData = Song.loadFromJson(otherChartData + '-other', otherChartData).notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		var songName:String = Paths.formatToSongPath(SONG.song);
		var file:String = Paths.json(songName + '/events');
		#if sys
		if (FileSystem.exists(Paths.modsJson(songName + '/events')) || FileSystem.exists(file)) {
		#else
		if (OpenFlAssets.exists(file)) {
		#end
			var eventsData:Array<SwagSection> = Song.loadFromJson('events', songName).notes;
			for (section in eventsData)
			{
				for (songNotes in section.sectionNotes)
				{
					if(songNotes[1] < 0) {
						eventNotes.push([songNotes[0], songNotes[1], songNotes[2], songNotes[3], songNotes[4]]);
						eventPushed(songNotes);
					}
				}
			}
		}

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				if(songNotes[1] > -1) { //Real notes
					var daStrumTime:Float = songNotes[0];
					var daNoteData:Int = Std.int(songNotes[1] % 4);

					var gottaHitNote:Bool = section.mustHitSection;

					if (songNotes[1] > 3)
					{
						gottaHitNote = !section.mustHitSection;
					}

					var oldNote:Note;
					if (unspawnNotes.length > 0)
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
					else
						oldNote = null;

					var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
					swagNote.mustPress = gottaHitNote;
					swagNote.sustainLength = songNotes[2];
					swagNote.noteType = songNotes[3];
					if(!Std.isOfType(songNotes[3], String)) swagNote.noteType = editors.ChartingState.noteTypeList[songNotes[3]]; //Backward compatibility + compatibility with Week 7 charts
					swagNote.scrollFactor.set();

					if (dad.curCharacter == 'ziffy' && !gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(swagNote.noteType))
						swagNote.texture = "ziffyNotes";

					if (boyfriend.curCharacter == 'ziffy' && gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(swagNote.noteType))
						swagNote.texture = "ziffyNotes";

					if (dad.curCharacter == 'ziffytorture' && !gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(swagNote.noteType))
						swagNote.texture = "ziffyNotes";

					if (boyfriend.curCharacter == 'ziffytorture' && gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(swagNote.noteType))
						swagNote.texture = "ziffyNotes";
					
					if (monotoneChars.contains(SONG.player2) && !gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(swagNote.noteType))
						swagNote.texture = "monotone_notes";

					if (blackChars.contains(SONG.player2) && !gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(swagNote.noteType))
						swagNote.texture = "BHURTNOTE_assets";

					if (whiteChars.contains(SONG.player2) && !gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(swagNote.noteType))
						swagNote.texture = "WHURTNOTE_assets";

					if (SONG.player1 == 'Victory_BF' && gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(swagNote.noteType)){
						swagNote.texture = "NOTE_assets_DEFAULT_COLOR2";
					}

					if (SONG.player1 == 'Victory_BF' && gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(swagNote.noteType)){
						swagNote.color = FlxColor.CYAN;
					}

					if (SONG.player1 == 'amongbf2' && gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(swagNote.noteType)){
						swagNote.texture = "NOTE_assets_DEFAULT_COLOR2";
					}

					if (SONG.player1 == 'amongbf2' && gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(swagNote.noteType)){
						swagNote.color = FlxColor.YELLOW;
					}


					var susLength:Float = swagNote.sustainLength;

					susLength = susLength / Conductor.stepCrochet;
					unspawnNotes.push(swagNote);

					var floorSus:Int = Math.floor(susLength);
					if(floorSus > 0) {
						for (susNote in 0...floorSus+1)
						{
							oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

							var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + (Conductor.stepCrochet / FlxMath.roundDecimal(curSpeed, 2)), daNoteData, oldNote, true);
							sustainNote.mustPress = gottaHitNote;
							sustainNote.noteType = swagNote.noteType;
							sustainNote.scrollFactor.set();
							unspawnNotes.push(sustainNote);

							if (dad.curCharacter == 'ziffy' && !gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(sustainNote.noteType))
								sustainNote.texture = "ziffyNotes";
		
							if (boyfriend.curCharacter == 'ziffy' && gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(sustainNote.noteType))
								sustainNote.texture = "ziffyNotes";
		
							if (dad.curCharacter == 'ziffytorture' && !gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(sustainNote.noteType))
								sustainNote.texture = "ziffyNotes";
		
							if (boyfriend.curCharacter == 'ziffytorture' && gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(sustainNote.noteType))
								sustainNote.texture = "ziffyNotes";

							if (monotoneChars.contains(SONG.player2) && !gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(sustainNote.noteType))
								sustainNote.texture = "monotone_notes";

							if (blackChars.contains(SONG.player2) && !gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(sustainNote.noteType))
								sustainNote.texture = "BHURTNOTE_assets";

							if (whiteChars.contains(SONG.player2) && !gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(sustainNote.noteType))
								sustainNote.texture = "WHURTNOTE_assets";

							if (SONG.player1 == 'Victory_BF' && gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(sustainNote.noteType)){
								sustainNote.texture = "NOTE_assets_DEFAULT_COLOR2";
							}
		
							if (SONG.player1 == 'Victory_BF' && gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(sustainNote.noteType)){
								sustainNote.color = FlxColor.CYAN;
							}
			
							if (SONG.player1 == 'amongbf2' && gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(sustainNote.noteType)){
								sustainNote.texture = "NOTE_assets_DEFAULT_COLOR2";
							}
		
							if (SONG.player1 == 'amongbf2' && gottaHitNote && !isPixelStage && !dontoverwritenotetextures.contains(sustainNote.noteType)){
								sustainNote.color = FlxColor.YELLOW;
							}

							if (sustainNote.mustPress)
							{
								sustainNote.x += FlxG.width / 2; // general offset
							}
							else if(ClientPrefs.middleScroll)
								{
									sustainNote.x += 310;
									if(daNoteData > 1)
									{ //Up and Right
										sustainNote.x += FlxG.width / 2 + 25;
									}
								}
						}
					}

					if (swagNote.mustPress)
					{
						swagNote.x += FlxG.width / 2; // general offset
					}
					else if(ClientPrefs.middleScroll)
						{
							swagNote.x += 310;
							if(daNoteData > 1) //Up and Right
							{
								swagNote.x += FlxG.width / 2 + 25;
							}
						}

					if(!noteTypeMap.exists(swagNote.noteType)) {
						noteTypeMap.set(swagNote.noteType, true);
					}
				} else { //Event Notes
					eventNotes.push([songNotes[0], songNotes[1], songNotes[2], songNotes[3], songNotes[4]]);
					eventPushed(songNotes);
				}
			}
			daBeats += 1;
		}
		if(curStage.toLowerCase() == 'voting' || curStage.toLowerCase() == 'attack'){
			for (section in rmtjData)
			{
				for (songNotes in section.sectionNotes)
				{
					if (songNotes[1] > -1)
					{ // Real notes
						var daStrumTime:Float = songNotes[0];
						var daNoteData:Int = Std.int(songNotes[1] % 4);

						var gottaHitNote:Bool = section.mustHitSection;

						if (songNotes[1] > 3)
						{
							gottaHitNote = !section.mustHitSection;
						}
						var oldNote:Note;

						if (unspawnVotingNotes.length > 0)
							oldNote = unspawnVotingNotes[Std.int(unspawnVotingNotes.length - 1)];
						else
							oldNote = null;
						var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
						swagNote.row = Conductor.secsToRow(daStrumTime);
						if(votingnoteRows[gottaHitNote?0:1][swagNote.row]==null)
							votingnoteRows[gottaHitNote?0:1][swagNote.row]=[];
						votingnoteRows[gottaHitNote ? 0 : 1][swagNote.row].push(swagNote);

						swagNote.mustPress = gottaHitNote;
						swagNote.sustainLength = songNotes[2];
						swagNote.noteType = songNotes[3];
						swagNote.noteType = 'Behind Note';
						swagNote.scrollFactor.set();
						var susLength:Float = swagNote.sustainLength;

						susLength = susLength / Conductor.stepCrochet;
						unspawnVotingNotes.push(swagNote);
						var floorSus:Int = Math.floor(susLength);

						if (floorSus > 0)
						{
							for (susNote in 0...floorSus + 1)
							{
								oldNote = unspawnVotingNotes[Std.int(unspawnVotingNotes.length - 1)];
								var sustainNote:Note = new Note(daStrumTime
									+ (Conductor.stepCrochet * susNote)
									+ (Conductor.stepCrochet / FlxMath.roundDecimal(SONG.speed, 2)), daNoteData,
									oldNote, true);
								sustainNote.mustPress = gottaHitNote;
								sustainNote.noteType = swagNote.noteType;
								sustainNote.scrollFactor.set();
								unspawnVotingNotes.push(sustainNote);
								if (sustainNote.mustPress)
								{
									sustainNote.x += FlxG.width / 2; // general offset
								}
							}
						}
						if (swagNote.mustPress)
						{
							swagNote.x += FlxG.width / 2; // general offset
						}
						else
						{
						}
						if (!noteTypeMap.exists(swagNote.noteType))
						{
							noteTypeMap.set(swagNote.noteType, true);
						}
					}
					else
					{ // Event Notes
						eventNotes.push([songNotes[0], songNotes[1], songNotes[2], songNotes[3], songNotes[4]]);
						eventPushed(songNotes);
					}
				}
				daBeats += 1;
			}
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);
		if(eventNotes.length > 1) { //No need to sort if there's a single one or none at all
			eventNotes.sort(sortByTime);
		}
		checkEventNote();
		generatedMusic = true;
	}

	function eventPushed(event:Array<Dynamic>) {
		switch(event[2]) {
			case 'Change Character':
				var charType:Int = 0;
				switch(event[3].toLowerCase()) {
					case 'mom' | 'opponent2':
						charType = 3;
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(event[3]);
						if(Math.isNaN(charType)) charType = 0;
				}

				var newCharacter:String = event[4];
				addCharacterToList(newCharacter, charType);
		}

		if(!eventPushedMap.exists(event[2])) {
			eventPushedMap.set(event[2], true);
		}
	}

	function eventNoteEarlyTrigger(event:Array<Dynamic>):Float {
		var returnedValue:Float = callOnLuas('eventEarlyTrigger', [event[2]]);
		if(returnedValue != 0) {
			return returnedValue;
		}

		switch(event[2]) {
			case 'Kill Henchmen': //Better timing so that the kill sound matches the beat intended
				return 280; //Plays 280ms before the actual position
		}
		return 0;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function sortByTime(Obj1:Array<Dynamic>, Obj2:Array<Dynamic>):Int
	{
		var earlyTime1:Float = eventNoteEarlyTrigger(Obj1);
		var earlyTime2:Float = eventNoteEarlyTrigger(Obj2);
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1[0] - earlyTime1, Obj2[0] - earlyTime2);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:StrumNote = new StrumNote(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, strumLine.y, i, player);
			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				if (ClientPrefs.TDN)
				{
					if (player == 0)
						FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 0.65}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
					else
						FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
				}
				else
					FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			if (player == 0 && ClientPrefs.TDN)
				babyArrow.alpha = 0.50;

			if (SONG.player1 == 'Victory_BF' && player == 1){
				babyArrow.color = FlxColor.CYAN;
			}

			if (SONG.player1 == 'amongbf2' && player == 1){
				babyArrow.color = FlxColor.YELLOW;
			}

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				if(ClientPrefs.middleScroll)
					{
						babyArrow.x += 310;
						if(i > 1) { //Up and Right
							babyArrow.x += FlxG.width / 2 + 25;
						}
					}
				opponentStrums.add(babyArrow);
			}
			if (ClientPrefs.aFlipY)
				babyArrow.flipY = true;
			if (ClientPrefs.aFlipX)
				babyArrow.flipX = true;
			strumLineNotes.add(babyArrow);
			babyArrow.postAddedToGroup();
		}
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = false;

			if(blammedLightsBlackTween != null)
				blammedLightsBlackTween.active = false;
			if(phillyCityLightsEventTween != null)
				phillyCityLightsEventTween.active = false;

			if(carTimer != null) carTimer.active = false;

			var chars:Array<Character> = [boyfriend, gf, dad, mom];
			for (i in 0...chars.length) {
				if(chars[i].colorTween != null) {
					chars[i].colorTween.active = false;
				}
			}

			for (tween in modchartTweens) {
				tween.active = false;
			}
			for (timer in modchartTimers) {
				timer.active = false;
			}
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = true;

			if(blammedLightsBlackTween != null)
				blammedLightsBlackTween.active = true;
			if(phillyCityLightsEventTween != null)
				phillyCityLightsEventTween.active = true;
			
			if(carTimer != null) carTimer.active = true;

			var chars:Array<Character> = [boyfriend, gf, dad, mom];
			for (i in 0...chars.length) {
				if(chars[i].colorTween != null) {
					chars[i].colorTween.active = true;
				}
			}
			
			for (tween in modchartTweens) {
				tween.active = true;
			}
			for (timer in modchartTimers) {
				timer.active = true;
			}
			paused = false;
			callOnLuas('onResume', []);

			#if desktop
			if (startTimer.finished)
			{
				if (ratingString == '?'){
					DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString, iconP2.getCharacter(), false, "");
				}else if (songMisses > 0 && ratingString != '?'){
					DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString + " (" + ((Math.floor(ratingPercent * 10000) / 100)) + "%)", iconP2.getCharacter(), false, "RatingFC: " + ratingAcc);
				}else{
					DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString + " (" + ((Math.floor(ratingPercent * 10000) / 100)) + "%)", iconP2.getCharacter(), false, "");
				}
			}
			else
			{
				if (ratingString == '?'){
					DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString, iconP2.getCharacter(), false, "");
				}else if (songMisses > 0 && ratingString != '?'){
					DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString + " (" + ((Math.floor(ratingPercent * 10000) / 100)) + "%)", iconP2.getCharacter(), false, "RatingFC: " + ratingAcc);
				}else{
					DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString + " (" + ((Math.floor(ratingPercent * 10000) / 100)) + "%)", iconP2.getCharacter(), false, "");
				}
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				if (ratingString == '?'){
					DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString, iconP2.getCharacter(), false, "");
				}else if (songMisses > 0 && ratingString != '?'){
					DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString + " (" + ((Math.floor(ratingPercent * 10000) / 100)) + "%)", iconP2.getCharacter(), false, "RatingFC: " + ratingAcc);
				}else{
					DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString + " (" + ((Math.floor(ratingPercent * 10000) / 100)) + "%)", iconP2.getCharacter(), false, "");
				}
			}
			else
			{
				if (ratingString == '?'){
					DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString, iconP2.getCharacter(), false, "");
				}else if (songMisses > 0 && ratingString != '?'){
					DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString + " (" + ((Math.floor(ratingPercent * 10000) / 100)) + "%)", iconP2.getCharacter(), false, "RatingFC: " + ratingAcc);
				}else{
					DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString + " (" + ((Math.floor(ratingPercent * 10000) / 100)) + "%)", iconP2.getCharacter(), false, "");
				}
			}
		}
		#end

		super.onFocus();
	}
	
	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (ratingString == '?'){
				DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString, iconP2.getCharacter(), false, "");
			}else if (songMisses > 0 && ratingString != '?'){
				DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString + " (" + ((Math.floor(ratingPercent * 10000) / 100)) + "%)", iconP2.getCharacter(), false, "RatingFC: " + ratingAcc);
			}else{
				DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString + " (" + ((Math.floor(ratingPercent * 10000) / 100)) + "%)", iconP2.getCharacter(), false, "");
			}
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		if(finishTimer != null) return;

		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	function henryTeleport()
		{
			canPause = false;
			
			vocals.volume = 0;
			vocals.pause();
			KillNotes();
			FlxTween.tween(FlxG.sound.music, {volume: 0}, 5, {ease: FlxEase.expoOut});
	
			var colorShader:ColorShader = new ColorShader(0);
			boyfriend.shader = colorShader.shader;
	
			FlxTween.tween(camHUD, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
	
			triggerEventNote('Camera Follow Pos', '750', '500');
			triggerEventNote('Change Character', '1', 'reaction');
			dad.setPosition(-240, 175);
			dad.animation.play('first', true);
			dad.specialAnim = true;
			stopEvents = true;
	
			FlxG.sound.play(Paths.sound('teleport_sound'), 1);
	
			new FlxTimer().start(0.45, function(tmr:FlxTimer)
			{
				colorShader.amount = 1;
				FlxTween.tween(colorShader, {amount: 0}, 0.73, {ease: FlxEase.expoOut});
				// dad.stunned = true;
			});
	
			new FlxTimer().start(1.28, function(tmr:FlxTimer)
			{
				colorShader.amount = 1;
				gf.shader = colorShader.shader;
				pet.shader = colorShader.shader;
				FlxTween.tween(colorShader, {amount: 0.1}, 0.55, {ease: FlxEase.expoOut});
			});
	
			new FlxTimer().start(1.93, function(tmr:FlxTimer)
			{
				colorShader.amount = 1;
				FlxTween.tween(colorShader, {amount: 0.2}, 0.2, {ease: FlxEase.expoOut});
				dad.animation.play('second', true);
				dad.specialAnim = true;
			});
	
			new FlxTimer().start(2.23, function(tmr:FlxTimer)
			{
				colorShader.amount = 1;
				FlxTween.tween(colorShader, {amount: 0.4}, 0.22, {ease: FlxEase.expoOut});
			});
			new FlxTimer().start(2.55, function(tmr:FlxTimer)
			{
				colorShader.amount = 1;
				FlxTween.tween(colorShader, {amount: 0.8}, 0.05, {ease: FlxEase.expoOut});
			});
	
			/*new FlxTimer().start(1.25, function(tmr:FlxTimer) {
			FlxTween.tween(colorShader, {amount: 1}, 2.25, {ease: FlxEase.expoOut});
		});*/
	
			new FlxTimer().start(2.7, function(tmr:FlxTimer)
			{
				colorShader.amount = 1;
				FlxTween.tween(boyfriend, {"scale.y": 0}, 0.7, {ease: FlxEase.expoOut});
				FlxTween.tween(boyfriend, {"scale.x": 3.5}, 0.7, {ease: FlxEase.expoOut});
			});
	
			new FlxTimer().start(2.8, function(tmr:FlxTimer)
			{
				FlxTween.tween(gf, {"scale.y": 0}, 0.7, {ease: FlxEase.expoOut});
				FlxTween.tween(gf, {"scale.x": 3.5}, 0.7, {ease: FlxEase.expoOut});
			});
	
			new FlxTimer().start(2.75, function(tmr:FlxTimer)
			{
				FlxTween.tween(pet, {"scale.y": 0}, 0.7, {ease: FlxEase.expoOut});
				FlxTween.tween(pet, {"scale.x": 3.5}, 0.7, {ease: FlxEase.expoOut});
			});
	
			new FlxTimer().start(2.9, function(tmr:FlxTimer)
			{
				whiteAwkward.animation.play('stare');
				dad.animation.play('third', true);
				dad.specialAnim = true;
			});
	
			new FlxTimer().start(4.5, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 1.4, false, function()
				{
					MusicBeatState.switchState(new HenryState());
				}, true);
			});
		}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var limoSpeed:Float = 0;
	public var camDisplaceX:Float = 0;
	public var camDisplaceY:Float = 0;
	var lastSection:Int = 0;

	var nps:Int = 0;
	var maxNPS:Int = 0;

	function updateCamFollow(?elapsed:Float){
		if(elapsed==null)elapsed=FlxG.elapsed;
		if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
		{
			var char = dad;

			var getCenterX = char.getMidpoint().x + 150;
			var getCenterY = char.getMidpoint().y - 100;

			camFollow.set(getCenterX + camDisplaceX + char.cameraPosition[0], getCenterY + camDisplaceY + char.cameraPosition[1]);

			switch (char.curCharacter)
			{
				case "starved":
					FlxG.camera.zoom = FlxMath.lerp(1.35, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
					camFollow.x += 20;
					camFollow.y -= 70;
				default:
					FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
			}

		}
		else
		{
			var char = boyfriend;

			var getCenterX = char.getMidpoint().x - 100;
			var getCenterY = char.getMidpoint().y - 100;

			camFollow.set(getCenterX + camDisplaceX - char.cameraPosition[0], getCenterY + camDisplaceY + char.cameraPosition[1]);

			switch (char.curCharacter)
			{
				default:
					FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
			}
		}
	}

	override public function update(elapsed:Float)
	{
					// fear shit for starved
					if (dad.curCharacter == 'starved')
						{
							isFear = true;
							fearBar.visible = true;
							fearBar.filledCallback = function()
							{
								health = 0;
							}
							// this is such a shitcan method i really should come up with something better tbf
							if (fearNo >= 10 && fearNo < 19)
								health -= 0.1 * elapsed;
							else if (fearNo >= 60 && fearNo < 69)
								health -= 0.30 * elapsed;
							else if (fearNo >= 70 && fearNo < 79)
								health -= 0.50 * elapsed;
							else if (fearNo >= 80 && fearNo < 89)
								health -= 0.70 * elapsed;
							else if (fearNo >= 90 && fearNo < 99)
								health -= 0.99 * elapsed;
				
							if (health <= 0.01)
							{
								health = 0.01;
							}
						}

						if (fearNo >= 70){
							fearNo += 0.0056;
						}else{
							fearNo += 0.006;
						}

						if (dad.curCharacter == 'starved' && starvedFearBarReduce >= 20 && fearNo > 30){
							fearNo -= 3.50;
							if (fearNo <= 30){
								starvedFearBarReduce = 0;
							}
						}

		#if desktop
		// Updating Discord Rich Presence (with Time Left)
		if (ratingString == '?'){
			DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString, iconP2.getCharacter(), false, "");
		}else if (songMisses > 0 && ratingString != '?'){
			DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString + " (" + ((Math.floor(ratingPercent * 10000) / 100)) + "%)", iconP2.getCharacter(), false, "RatingFC: " + ratingAcc);
		}else{
			DiscordClient.changePresence(detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString + " (" + ((Math.floor(ratingPercent * 10000) / 100)) + "%)", iconP2.getCharacter(), false, "");
		}
		#end

		if (curStage == 'victory'){
			healthBar.alpha = 0;
			healthBarBG.alpha = 0;
			healthBarOverlay.alpha = 0;
			iconP1.alpha = 0;
			iconP2.alpha = 0;
		}

		if (curStage == 'plantroom' || curStage == 'pretender')
			{
				cloud1.x = FlxMath.lerp(cloud1.x, cloud1.x - 1, CoolUtil.boundTo(elapsed * 9, 0, 1));
				cloud2.x = FlxMath.lerp(cloud2.x, cloud2.x - 3, CoolUtil.boundTo(elapsed * 9, 0, 1));
				cloud3.x = FlxMath.lerp(cloud3.x, cloud3.x - 2, CoolUtil.boundTo(elapsed * 9, 0, 1));
				cloud4.x = FlxMath.lerp(cloud4.x, cloud4.x - 0.1, CoolUtil.boundTo(elapsed * 9, 0, 1));
				cloudbig.x = FlxMath.lerp(cloudbig.x, cloudbig.x - 0.5, CoolUtil.boundTo(elapsed * 9, 0, 1));
			}

			var legPosY = [13, 7, -3, -1, -1, 2, 7, 9, 7, 2, 0, 0, 3, 1, 3, 7, 13];
			var legPosX = [3, 4, 4, 5, 5, 4, 3, 2, 0, 0, -3, -4, -4, -5, -5, -4, -3];

			if (boyfriend.curCharacter == 'bf-running')
				{
					if (boyfriend.animation.curAnim.name.startsWith("sing"))
					{
						bfLegs.alpha = 1;
						boyfriend.y = bfAnchorPoint[1] + legPosY[bfLegs.animation.curAnim.curFrame];
					}
					else
						bfLegs.alpha = 1;
				}
		
				if (boyfriend.curCharacter == 'bf-running')
					{
						if (boyfriend.animation.curAnim.name.endsWith("miss"))
						{
							bfLegsmiss.alpha = 1;
							boyfriend.y = bfAnchorPoint[1] + legPosY[bfLegsmiss.animation.curAnim.curFrame];
						}
						else
							bfLegsmiss.alpha = 0;
					}
		
					if (boyfriend.curCharacter == 'bf-running')
						{
							if (boyfriend.animation.curAnim.name.endsWith("miss"))
							{
								bfLegs.alpha = 0;
								boyfriend.y = bfAnchorPoint[1] + legPosY[bfLegs.animation.curAnim.curFrame];
							}
							else
								bfLegs.alpha = 1;
						}
				
		
				if (dad.curCharacter == 'black-run')
				{
					dad.y = dadAnchorPoint[1] + legPosY[dadlegs.animation.curAnim.curFrame];
				}

		if (ClientPrefs.tst)
			scoreTxt.alpha = 0.75;
		else
			scoreTxt.alpha = 1;

		if (!ClientPrefs.hss){
			curSpeed = SONG.speed;
		}

		if (ClientPrefs.hss){
			curSpeed = ClientPrefs.speed;
		}

		if (PlayState.SONG.stage.toLowerCase() == 'victory'){
			health = 1;
		}

		/*if (FlxG.keys.justPressed.NINE)
		{
			iconP1.swapOldIcon();
		}*/

		callOnLuas('onUpdate', [elapsed]);
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}
		if (curStage == 'toogus')
		{
			saxguy.x = FlxMath.lerp(saxguy.x, saxguy.x + 15, CoolUtil.boundTo(elapsed * 9, 0, 1));
		}
		if (curStage == "ejected")
			{
				if (!inCutscene)
					camGame.shake(0.002, 0.1);
	
				if (!tweeningChar && !inCutscene)
				{
					tweeningChar = true;
					FlxTween.tween(boyfriendGroup,
						{x: FlxG.random.float(bfStartpos.x - 15, bfStartpos.x + 15), y: FlxG.random.float(bfStartpos.y - 15, bfStartpos.y + 15)}, 0.4, {
							ease: FlxEase.smoothStepInOut,
							onComplete: function(twn:FlxTween)
							{
								tweeningChar = false;
							}
						});
					FlxTween.tween(gfGroup, {
						x: FlxG.random.float(gfStartpos.x - 10, gfStartpos.x + 10),
						y: FlxG.random.float(gfStartpos.y - 10, gfStartpos.y + 10)
					}, 0.4, {
						ease: FlxEase.smoothStepInOut
					});
					FlxTween.tween(dadGroup,
						{x: FlxG.random.float(dadStartpos.x - 15, dadStartpos.x + 15), y: FlxG.random.float(dadStartpos.y - 15, dadStartpos.y + 15)}, 0.4, {
							ease: FlxEase.smoothStepInOut
						});
				}
	
				/*if (boyfriend.platformPos != null)
				{
					plat.setPosition(boyfriend.x + boyfriend.platformPos[0], boyfriend.y + boyfriend.platformPos[1]);
				}*/
			}
		switch (curStage)
		{
			case 'grey':
				if(curBeat % chromFreq == 0){
					if(chromTween != null) chromTween.cancel();
					caShader.amount = chromAmount;
					chromTween = FlxTween.tween(caShader, {amount: 0}, 0.45, {ease: FlxEase.sineOut});
				}
				if (curBeat % 2 == 0)
				{
					crowd.animation.play('bop');
				}
			case 'polus':
				if (curBeat % 1 == 0)
				{
					speaker.animation.play('bop');
				}
				if (curBeat % 2 == 0)
				{
					crowd2.animation.play('bop');
				}
			case 'polus2':
				if (curBeat % 2 == 0)
				{
					crowd.animation.play('bop');
				}
			case 'pretender':
				if(curBeat % 2 == 0){	
					bluemira.animation.play('bop');
				}
				if (curBeat % 1 == 0)
				{
					gfDeadPretender.animation.play('bop');
				}	
			case 'defeat':
				if (curBeat % 4 == 0)
				{
					defeatthing.animation.play('bop', true);
				}
			case 'toogus':
				if (curBeat % 2 == 0)
				{
					if (SONG.song.toLowerCase() == 'lights-down')
					{
						toogusblue.animation.play('bop', true);
						toogusorange.animation.play('bop', true);
						tooguswhite.animation.play('bop', true);
					}
				}
			case 'reactor2':
				if (curBeat % 4 == 0)
				{
					toogusorange.animation.play('bop', true);
					toogusblue.animation.play('bop', true);
					tooguswhite.animation.play('bop', true);
				}
				case 'airship':
				camGame.shake(0.0008, 0.01);
				camGame.y = Math.sin((Conductor.songPosition / 280) * (Conductor.bpm / 60) * 1.0) * 2 - 100;
				camHUD.y = Math.sin((Conductor.songPosition / 300) * (Conductor.bpm / 60) * 1.0) * 0.6;
				camHUD.angle = Math.sin((Conductor.songPosition / 350) * (Conductor.bpm / 60) * -1.0) * 0.6;
				if (airCloseClouds.members.length > 0)
				{
					for (i in 0...airCloseClouds.members.length)
					{
						airCloseClouds.members[i].x = FlxMath.lerp(airCloseClouds.members[i].x, airCloseClouds.members[i].x - 50,
							CoolUtil.boundTo(elapsed * 9, 0, 1));
						if (airCloseClouds.members[i].x < -10400.2)
						{
							airCloseClouds.members[i].x = 5582.2;
						}
					}
				}
				if (airMidClouds.members.length > 0)
				{
					for (i in 0...airMidClouds.members.length)
					{
						airMidClouds.members[i].x = FlxMath.lerp(airMidClouds.members[i].x, airMidClouds.members[i].x - 13, CoolUtil.boundTo(elapsed * 9, 0, 1));
						if (airMidClouds.members[i].x < -6153.4)
						{
							airMidClouds.members[i].x = 2852.4;
						}
					}
				}
				if (airSpeedlines.members.length > 0)
				{
					for (i in 0...airSpeedlines.members.length)
					{
						airSpeedlines.members[i].x = FlxMath.lerp(airSpeedlines.members[i].x, airSpeedlines.members[i].x - 350,
							CoolUtil.boundTo(elapsed * 9, 0, 1));
						if (airSpeedlines.members[i].x < -5140.05)
						{
							airSpeedlines.members[i].x = 3352.1;
						}
					}
				}
				if (airFarClouds.members.length > 0)
				{
					for (i in 0...airFarClouds.members.length)
					{
						airFarClouds.members[i].x = FlxMath.lerp(airFarClouds.members[i].x, airFarClouds.members[i].x - 7, CoolUtil.boundTo(elapsed * 9, 0, 1));
						if (airFarClouds.members[i].x < -6178.95)
						{
							airFarClouds.members[i].x = 2874.95;
						}
					}
				}
				if (airshipPlatform.members.length > 0)
				{
					for (i in 0...airshipPlatform.members.length)
					{
						airshipPlatform.members[i].x = FlxMath.lerp(airshipPlatform.members[i].x, airshipPlatform.members[i].x - 300,
							CoolUtil.boundTo(elapsed * 9, 0, 1));
						if (airshipPlatform.members[i].x < -7184.8)
						{
							airshipPlatform.members[i].x = 4275.15;
						}
					}
				}
				if (airBigCloud != null)
				{
					airBigCloud.x = FlxMath.lerp(airBigCloud.x, airBigCloud.x - bigCloudSpeed, CoolUtil.boundTo(elapsed * 9, 0, 1));
					if (airBigCloud.x < -4163.7)
					{
						airBigCloud.x = FlxG.random.float(3931.5, 4824.05);
						airBigCloud.y = FlxG.random.float(-1087.5, -307.35);
						bigCloudSpeed = FlxG.random.float(7, 15);
					}
				}
				case 'ejected':
					camHUD.y = Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * 1.0) * 15;
					camHUD.angle = Math.sin((Conductor.songPosition / 1200) * (Conductor.bpm / 60) * -1.0) * 1.2;
					// make sure that the clouds exist
					if (cloudScroll.members.length == 3)
					{
						for (i in 0...cloudScroll.members.length)
						{
							cloudScroll.members[i].y = FlxMath.lerp(cloudScroll.members[i].y, cloudScroll.members[i].y - speedPass[i],
								CoolUtil.boundTo(elapsed * 9, 0, 1));
							if (cloudScroll.members[i].y < -1789.65)
							{
								// im not using flxbackdrops so this is how we're doing things today
								var randomScale = FlxG.random.float(1.5, 2.2);
								var randomScroll = FlxG.random.float(1, 1.3);
	
								speedPass[i] = FlxG.random.float(1100, 1300);
	
								cloudScroll.members[i].scale.set(randomScale, randomScale);
								cloudScroll.members[i].scrollFactor.set(randomScroll, randomScroll);
								cloudScroll.members[i].x = FlxG.random.float(-3578.95, 3259.6);
								cloudScroll.members[i].y = 2196.15;
							}
						}
					}
					if (farClouds.members.length == 7)
					{
						for (i in 0...farClouds.members.length)
						{
							farClouds.members[i].y = FlxMath.lerp(farClouds.members[i].y, farClouds.members[i].y - farSpeedPass[i],
								CoolUtil.boundTo(elapsed * 9, 0, 1));
							if (farClouds.members[i].y < -1614)
							{
								var randomScale = FlxG.random.float(0.2, 0.5);
								var randomScroll = FlxG.random.float(0.2, 0.4);
	
								farSpeedPass[i] = FlxG.random.float(1100, 1300);
	
								farClouds.members[i].scale.set(randomScale, randomScale);
								farClouds.members[i].scrollFactor.set(randomScroll, randomScroll);
								farClouds.members[i].x = FlxG.random.float(-2737.85, 3485.4);
								farClouds.members[i].y = 1738.6;
							}
						}
					}
					// AAAAAAAAAAAAAAAAAAAA
					if (leftBuildings.length > 0)
					{
						for (i in 0...leftBuildings.length)
						{
							leftBuildings[i].y = middleBuildings[i].y + 5888;
						}
					}
					if (middleBuildings.length > 0)
					{
						for (i in 0...middleBuildings.length)
						{
							if (middleBuildings[i].y < -11759.9)
							{
								middleBuildings[i].y = 3190.5;
								middleBuildings[i].animation.play(FlxG.random.bool(50) ? '1' : '2');
							}
							middleBuildings[i].y = FlxMath.lerp(middleBuildings[i].y, middleBuildings[i].y - 1300, CoolUtil.boundTo(elapsed * 9, 0, 1));
						}
					}
					if (rightBuildings.length > 0)
					{
						for (i in 0...rightBuildings.length)
						{
							rightBuildings[i].y = leftBuildings[i].y;
						}
					}
					speedLines.y = FlxMath.lerp(speedLines.y, speedLines.y - 1350, CoolUtil.boundTo(elapsed * 9, 0, 1));
	
					if (fgCloud != null)
					{
						fgCloud.y = FlxMath.lerp(fgCloud.y, fgCloud.y - 0.01, CoolUtil.boundTo(elapsed * 9, 0, 1));
					}

					case 'turbulence':
						if (curBeat % 2 == 0)
							{
								clawshands.animation.play('squeeze', true);
							}
						camHUD.y = Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * 1.0) * 15;
						camHUD.angle = Math.sin((Conductor.songPosition / 1200) * (Conductor.bpm / 60) * -1.0) * 1.2;
		
						boyfriend.y = (Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * 1.0) * 15) + 770;
						hookarm.y = (Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * 1.0) * 15) + 850;
						clawshands.y = (Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * 1.0) * 15) + 650;
		
						midderclouds.x = FlxMath.lerp(midderclouds.x, midderclouds.x + 175 * turbSpeed,
							CoolUtil.boundTo(elapsed * 9, 0, 1));
						if (midderclouds.x > 5140.05)
						{
							midderclouds.x = -3352.1;
						}
		
						hotairballoon.x = FlxMath.lerp(hotairballoon.x, hotairballoon.x + 75 * turbSpeed,
							CoolUtil.boundTo(elapsed * 9, 0, 1));
						if (hotairballoon.x > 3140.05)
						{
							hotairballoon.x = -1352.1;
						}
		
						backerclouds.x = FlxMath.lerp(backerclouds.x, backerclouds.x + 55 * turbSpeed,
							CoolUtil.boundTo(elapsed * 9, 0, 1));
						if (backerclouds.x > 5140.05)
						{
							backerclouds.x = -1352.1;
						}
		
						if (airSpeedlines.members.length > 0)
						{
							for (i in 0...airSpeedlines.members.length)
							{
								airSpeedlines.members[i].x = FlxMath.lerp(airSpeedlines.members[i].x, airSpeedlines.members[i].x + 350 * turbSpeed,
									CoolUtil.boundTo(elapsed * 9, 0, 1));
		
								if (airSpeedlines.members[i].x > 5140.05)
								{
									airSpeedlines.members[i].x = -3352.1;
								}
							}
						}
		
						if (turbFrontCloud.members.length > 0)
						{
							for (i in 0...turbFrontCloud.members.length)
							{
								turbFrontCloud.members[i].x = FlxMath.lerp(turbFrontCloud.members[i].x, turbFrontCloud.members[i].x + 400 * turbSpeed,
									CoolUtil.boundTo(elapsed * 9, 0, 1));
								if (turbFrontCloud.members[i].x > 5140.05)
								{
									turbFrontCloud.members[i].x = -4352.1;
								}
							}
						}
		
						if(turbEnding){
							dad.x = FlxMath.lerp(dad.x, dad.x + 650,
								CoolUtil.boundTo(elapsed * 9, 0, 1));
							dad.y = FlxMath.lerp(dad.y, dad.y + 200,
								CoolUtil.boundTo(elapsed * 9, 0, 1));
							dad.angle = FlxMath.lerp(dad.angle, dad.angle + 120,
								CoolUtil.boundTo(elapsed * 9, 0, 1));
						}
		}

		if(!inCutscene) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 2.4 * cameraSpeed, 0, 1);
			if (!cameraLocked)
				camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
			if(!startingSong && !endingSong && boyfriend.animation.curAnim.name.startsWith('idle')) {
				boyfriendIdleTime += elapsed;
				if(boyfriendIdleTime >= 0.15) { // Kind of a mercy thing for making the achievement easier to get as it's apparently frustrating to some playerss
					boyfriendIdled = true;
				}
			} else {
				boyfriendIdleTime = 0;
			}
		}

		super.update(elapsed);

		missLimitManager();

		if (simplescore)
		{
			scoreTxt.text = 'Score: ';
			if (PlayState.SONG.stage.toLowerCase() == 'victory'){
				scoreTxt.text += "Who cares? You already won!";
			}else{
				scoreTxt.text += songScore;
			}
			scoreTxt.text += ' ';
			if (ratingString != '?')
			{
				if (PlayState.SONG.stage.toLowerCase() == 'victory'){
					scoreTxt.text += '(100%)';
				}else{
					if (ClientPrefs.full)
						scoreTxt.text += '(' + ((Math.floor(ratingPercent * 10000) / 100)) + '%)';
					else
						scoreTxt.text += '(' + Math.floor(ratingPercent * 100) + '%)';
				}
			}
			else
				scoreTxt.text += '(0%)';
		}
		else if (epicscore)
		{
			scoreTxt.text = 'Score: ';
			if (PlayState.SONG.stage.toLowerCase() == 'victory'){
				scoreTxt.text += "Who cares? You already won!";
			}else{
				scoreTxt.text += songScore;
			}
			if (PlayState.SONG.stage.toLowerCase() != 'victory'){
				scoreTxt.text += ' | Misses: ';
				scoreTxt.text += songMisses;
				if (missLimited)
					scoreTxt.text += ' / $missLimitCount';
			}
			scoreTxt.text += ' | Accuracy: ';
			if (ratingString != '?')
			{
				if (PlayState.SONG.stage.toLowerCase() == 'victory'){
					scoreTxt.text += '100%';
				}else{
					if (ClientPrefs.full)
						scoreTxt.text += '' + ((Math.floor(ratingPercent * 10000) / 100)) + '%';
					else
						scoreTxt.text += '' + Math.floor(ratingPercent * 100) + '%';
				}
			}
			if (ratingString == '?'){
				scoreTxt.text += ratingString;
			}
		}
		else
		{
			scoreTxt.text = 'Score: ';
			if (PlayState.SONG.stage.toLowerCase() == 'victory'){
				scoreTxt.text += "Who cares? You already won!";
			}else{
				scoreTxt.text += songScore;
			}
			if (PlayState.SONG.stage.toLowerCase() != 'victory'){
				scoreTxt.text += ' | Misses: ';
				scoreTxt.text += songMisses;
				if (missLimited)
					scoreTxt.text += ' / $missLimitCount';
			}
			scoreTxt.text += ' | Rating: ';
			if (PlayState.SONG.stage.toLowerCase() == 'victory' && ratingString != '?'){
				scoreTxt.text += 'WINNER';
			}else if (ratingString != '?' && funnimode){
				scoreTxt.text += "Aomg";
			}else{
				scoreTxt.text += ratingString;
			}
			//scoreTxt.text += '[' + ratingAAAA + "]";
			if (ratingString != '?'){
				scoreTxt.text += ' ';
			}
			if (ratingString != '?')
				{
					if (PlayState.SONG.stage.toLowerCase() == 'victory'){
						scoreTxt.text += '(100%)';
					}else if (funnimode){
						if (ClientPrefs.full)
							scoreTxt.text += '(Sus%)';
						else
							scoreTxt.text += '(Sus%)';
					}else{
						if (ClientPrefs.full)
							scoreTxt.text += '(' + ((Math.floor(ratingPercent * 10000) / 100)) + '%)';
						else
							scoreTxt.text += '(' + Math.floor(ratingPercent * 100) + '%)';
					}
				}
		}

		if (PlayState.SONG.stage.toLowerCase() != 'victory'){
			if (epicscore)
				{
					if (songMisses <= 0 && earlys <= 0 && ratingString != '?' && ClientPrefs.ratingfc2)
						scoreTxt.text += " [" + ratingAcc + "]";
				}
				else
				{
					if (songMisses <= 0 && ratingString != '?' && ClientPrefs.ratingfc2)
						scoreTxt.text += " " + ratingAcc;
				}
		}else{
			if (epicscore)
				{
					if (songMisses <= 0 && earlys <= 0 && ratingString != '?' && ClientPrefs.ratingfc2)
						scoreTxt.text += " [Beans]";
				}
				else
				{
					if (songMisses <= 0 && ratingString != '?' && ClientPrefs.ratingfc2)
						scoreTxt.text += " Beans";
				}
		}

		if (funnimode)
			scoreTxt.text += " / FUNNI MODE: ON";

		/*if (ratingString != '?')
			scoreTxt.text += ratingAcc2;
			scoreTxt.text += '' + ((Math.floor(ratingPercent * 10000) / 100)) + '%';
		if (ratingString != '?')
			scoreTxt.text += ' |';*/

		if (!simplejudge)
			judgementCounter.text = '[' + ratingAAAA + "]" + '\nSicks: ' + sicks + '\nGoods: ' + goods + '\nBads: ' + bads + '\nShits: ' + shits + '\nCombo: ' + combo + " (" + highestCombo + ')\nBreaks: ' + FunctionHandler.combobreaks +'\nHits: ' + hits2 + '\nNPS: ' + nps + "\nMax: " + maxNPS + "\nHealth: " +  Math.round(health * 50) + "%\n" + MyOwnCodeTypedWithMyOwnHands.bisexual + "." + MyOwnCodeTypedWithMyOwnHands.lesbian + "%\n";
		else
			judgementCounter.text = 'Sicks: ' + sicks + '\nGoods: ' + goods + '\nBads: ' + bads + '\nShits: ' + shits + '\nCombo: ' + combo + '\nBreaks: ' + FunctionHandler.combobreaks +'\nHits: ' + hits2 + "\n" + MyOwnCodeTypedWithMyOwnHands.bisexual + "." + MyOwnCodeTypedWithMyOwnHands.lesbian + "%\n";

		if (ClientPrefs.antim)
			judgementCounter.text += '\nEarlys: ' + earlys;

		if (dad.curCharacter == 'starved'){
			scoreTxt.text = 'Score: ' + songScore;
			scoreTxt.text += ' | Sacrifices: ';
			scoreTxt.text += songMisses;
			scoreTxt.text += ' (' + starvedFearBarReduce + ')';
			scoreTxt.text += ' | Rating: ' + MyOwnCodeTypedWithMyOwnHands.bisexual + "." + MyOwnCodeTypedWithMyOwnHands.lesbian + '%';
			judgementCounter.text = '';
		}

		if(cpuControlled) {
			botplaySine += 180 * elapsed;
			botplayTxt.alpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		}
		
		botplayTxt.visible = cpuControlled;

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			var ret:Dynamic = callOnLuas('onPause', []);
			if(ret != FunkinLua.Function_Stop) {
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;{
				if(FlxG.sound.music != null) {
					FlxG.sound.music.pause();
					vocals.pause();
				}
				PauseSubState.transCamera = camOther;
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			}
			
				#if desktop
				if (ratingString == '?'){
					DiscordClient.changePresence(detailsPausedText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString, iconP2.getCharacter(), false, "");
				}else if (songMisses > 0 && ratingString != '?'){
					DiscordClient.changePresence(detailsPausedText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString + " (" + ((Math.floor(ratingPercent * 10000) / 100)) + "%)", iconP2.getCharacter(), false, "RatingFC: " + ratingAcc);
				}else{
					DiscordClient.changePresence(detailsPausedText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString + " (" + ((Math.floor(ratingPercent * 10000) / 100)) + "%)", iconP2.getCharacter(), false, "");
				}
				#end
			}
		}

		if (Main.debugBuild){
			if (FlxG.keys.justPressed.SEVEN && !endingSong)
				{
					persistentUpdate = false;
					paused = true;
					cancelFadeTween();
					CustomFadeTransition.nextCamera = camOther;
					MusicBeatState.switchState(new ChartingState());
		
					#if desktop
					DiscordClient.changePresence("Chart Editor", null, null, true);
					#end
				}
		
				if (FlxG.keys.justPressed.SIX && !endingSong)
				{
					cpuControlled = !cpuControlled;
					ClientPrefs.saveSettings();
				}

				if (FlxG.keys.justPressed.THREE && !endingSong){
					camHUD.visible = !camHUD.visible;
				}

				if (FlxG.keys.justPressed.NINE){
					var beansValue:Int = Std.int(1000000);
					add(new BeansPopup(beansValue, camOther));
				}
		}

		if (FlxG.keys.justPressed.SPACE)
		{
			if (boyfriend.animation.getByName("hey") != null)
				boyfriend.playAnim('hey');
		}	
		if (FlxG.keys.justPressed.FOUR && !endingSong && !inCutscene)
		{
			if (funnimode)
				trace("disabling funni mode");
			else
				trace("found funni mode");
			FlxG.save.data.funnimode = !FlxG.save.data.funnimode;
			health = 0;
		}
		/*if (FlxG.keys.justPressed.TWO && !endingSong && !inCutscene)
			{
				var ret:Dynamic = callOnLuas('onPause', []);
				if(ret != FunkinLua.Function_Stop) {
					persistentUpdate = false;
					persistentDraw = true;
					paused = true;
				if(FlxG.sound.music != null) {
					FlxG.sound.music.pause();
					vocals.pause();
					}
				}
				openSubState(new OptionsState.PreferencesSubstate());
			}

			if (FlxG.keys.justPressed.THREE && !endingSong && !inCutscene)
				{
					var ret:Dynamic = callOnLuas('onPause', []);
					if(ret != FunkinLua.Function_Stop) {
						persistentUpdate = false;
						persistentDraw = true;
						paused = true;
					if(FlxG.sound.music != null) {
						FlxG.sound.music.pause();
						vocals.pause();
						}
					}
					openSubState(new OptionsState.ControlsSubstate());
				}

				if (FlxG.keys.justPressed.FOUR && !endingSong && !inCutscene)
					{
						var ret:Dynamic = callOnLuas('onPause', []);
						if(ret != FunkinLua.Function_Stop) {
							persistentUpdate = false;
							persistentDraw = true;
							paused = true;
						if(FlxG.sound.music != null) {
							FlxG.sound.music.pause();
							vocals.pause();
							}
						}
						openSubState(new OptionsState.NotesSubstate());
					}*/

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, CoolUtil.boundTo(1 - (elapsed * 30), 0, 1))));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, CoolUtil.boundTo(1 - (elapsed * 30), 0, 1))));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % 1 == 0)
			{
				if (boyfriend.curCharacter == 'bf-running')
					bfLegs.dance();
				if (boyfriend.animation.curAnim.name != null
					&& !boyfriend.animation.curAnim.name.startsWith("sing")
					&& boyfriend.curCharacter == 'bf-running')
				{
					boyfriend.dance();
				}
			}
	
			if (curBeat % 1 == 0)
				{
					if (boyfriend.curCharacter == 'bf-running')
						bfLegsmiss.dance();
				}

		var iconOffset:Int;

		if (ClientPrefs.middleScroll && ClientPrefs.fof)
			iconOffset = 270;
		else if (fofStages.contains(curStage)){
			iconOffset = 320;
		}else{
			iconOffset = 26;
		}

		if (ClientPrefs.middleScroll && ClientPrefs.fof)
		{
			iconP1.y = healthBar.y
			+ (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01))
			+ (150 * iconP1.scale.x - 150) / 2
			- iconOffset;
				iconP2.y = healthBar.y
			+ (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01))
			- (150 * iconP2.scale.x) / 2
			- iconOffset;
		}
		else if (fofStages.contains(curStage))
		{
			iconP1.y = healthBar.y
			+ (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01))
			+ (150 * iconP1.scale.x - 150) / 2
			- iconOffset;
				iconP2.y = healthBar.y
			+ (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01))
			- (150 * iconP2.scale.x) / 2
			- iconOffset;
		}
		else
		{
			iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
			iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing") && boyfriend.color == 0xFF000084)
		{
			boyfriend.color = FlxColor.WHITE;
		}

		if (health > 2)
			health = 2;
		if (health < 0)
			health = 0;

		if (starvedFearBarReduce > 20)
			starvedFearBarReduce = 20;
		if (starvedFearBarReduce < 0)
			starvedFearBarReduce = 0;

		if (dad.curCharacter == 'starved' && songMisses > 20){
			songMisses = 20;
		}

		if (goods == 0 && bads == 0 && shits == 0 && songMisses == 0){
			if (MyOwnCodeTypedWithMyOwnHands.bisexual > 100)
				MyOwnCodeTypedWithMyOwnHands.bisexual = 100;
		}else{
			if (MyOwnCodeTypedWithMyOwnHands.bisexual > 99)
				MyOwnCodeTypedWithMyOwnHands.bisexual = 99;
		}
		if (MyOwnCodeTypedWithMyOwnHands.lesbian > 99)
			MyOwnCodeTypedWithMyOwnHands.lesbian = 99;
		if (goods == 0 && bads == 0 && shits == 0 && songMisses == 0){
			if (MyOwnCodeTypedWithMyOwnHands.pansexual > 100)
				MyOwnCodeTypedWithMyOwnHands.pansexual = 100;
		}else{
			if (MyOwnCodeTypedWithMyOwnHands.pansexual > 99.99)
				MyOwnCodeTypedWithMyOwnHands.pansexual = 99.99;
		}
		if (MyOwnCodeTypedWithMyOwnHands.lmfao > 99.99)
			MyOwnCodeTypedWithMyOwnHands.lmfao = 99.99;	

		if (MyOwnCodeTypedWithMyOwnHands.bisexual < 0)
			MyOwnCodeTypedWithMyOwnHands.bisexual = 0;
		if (MyOwnCodeTypedWithMyOwnHands.lesbian < 0)
			MyOwnCodeTypedWithMyOwnHands.lesbian = 0;
		if (MyOwnCodeTypedWithMyOwnHands.pansexual < 0)
			MyOwnCodeTypedWithMyOwnHands.pansexual = 0;
		if (MyOwnCodeTypedWithMyOwnHands.lmfao < 0)
			MyOwnCodeTypedWithMyOwnHands.lmfao = 0;	

		if (songScore < 0)
			songScore = 0;	
		if (songScore2 < 0)
			songScore2 = 0;	
		if (songScore > 999999999)
			songScore = 999999999;	
		if (songScore2 > 999999999)
			songScore2 = 999999999;	

		if (boyfriend.healthIcon != 'nuzzles' && boyfriend.healthIcon != 'votingtime' && boyfriend.healthIcon != 'whoguys' && boyfriend.healthIcon != 'o2' && boyfriend.healthIcon != 'cvp'){
			if (healthBar.percent <= 20)
				iconP1.animation.curAnim.curFrame = 1;
			else
				iconP1.animation.curAnim.curFrame = 0;
		}

		if (dad.healthIcon != 'nuzzles' && dad.healthIcon != 'votingtime' && dad.healthIcon != 'whoguys' && dad.healthIcon != 'o2' && dad.healthIcon != 'cvp'){
			if (healthBar.percent >= 80)
				iconP2.animation.play('mad');
			else
				iconP2.animation.play('calm');
		}

		if (Main.debugBuild){
			if (FlxG.keys.justPressed.EIGHT && !endingSong && !inCutscene) {
				persistentUpdate = false;
				paused = true;
				cancelFadeTween();
				CustomFadeTransition.nextCamera = camOther;
				CharacterEditorState.amongUs = true;
				MusicBeatState.switchState(new CharacterEditorState(SONG.player2));
			}
		}

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}

				if(updateTime) {
					/*var curTime:Float = FlxG.sound.music.time - ClientPrefs.noteOffset;
					if(curTime < 0) curTime = 0;
					songPercent = (curTime / songLength);

					var secondsTotal:Int = Math.floor((songLength - curTime) / 1000);
					if(secondsTotal < 0) secondsTotal = 0;

					var minutesRemaining:Int = Math.floor(secondsTotal / 60);
					var secondsRemaining:String = '' + secondsTotal % 60;
					if(secondsRemaining.length < 2) secondsRemaining = '0' + secondsRemaining; //Dunno how to make it display a zero first in Haxe lol
					timeTxt.text = minutesRemaining + ':' + secondsRemaining;*/
					var curTime:Float = Conductor.songPosition;
					if(curTime < 0) curTime = 0;
					songPercent = (curTime / songLength);

					var songCalc:Float = (songLength - curTime);
					songCalc = curTime;

					var songCalc2:Float = (songLength - curTime);

					var secondsTotal:Int = Math.floor(songCalc / 1000);
					if(secondsTotal < 0) secondsTotal = 0;
					var secondsTotal2:Int = Math.floor(songCalc2 / 1000);
					if(secondsTotal2 < 0) secondsTotal2 = 0;

					timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false) + " / " + FlxStringUtil.formatTime(Math.floor(songLength / 1000), false) + " / " + FlxStringUtil.formatTime(secondsTotal2, false);
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
			{
				var curSection = Std.int(curStep / 16);
				if (curSection != lastSection)
				{
					// section reset stuff
					var lastMustHit:Bool = PlayState.SONG.notes[lastSection].mustHitSection;
					if (PlayState.SONG.notes[curSection].mustHitSection != lastMustHit)
					{
						camDisplaceX = 0;
						camDisplaceY = 0;
					}
					lastSection = Std.int(curStep / 16);
				}
	
				updateCamFollow(elapsed);
			}

		if (camZooming && !cameraLocked)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		// RESET = Quick Game Over Screen
		if (controls.RESET && !inCutscene && !endingSong)
		{
			health = 0;
			trace("RESET = True");
		}
		doDeathCheck();

		var roundedSpeed:Float = FlxMath.roundDecimal(curSpeed, 2);
		if (unspawnNotes[0] != null)
		{
			var time:Float = 1500;
			if(roundedSpeed < 1) time /= roundedSpeed;

			while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < time)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}
		if (unspawnVotingNotes[0] != null)
			{
				var time:Float = 3000;
				if (roundedSpeed < 1)
					time /= roundedSpeed;
	
				while (unspawnVotingNotes.length > 0 && unspawnVotingNotes[0].strumTime - Conductor.songPosition < time)
				{
					var dunceNote:Note = unspawnVotingNotes[0];
					votingnotes.add(dunceNote);
	
					var index:Int = unspawnVotingNotes.indexOf(dunceNote);
					unspawnVotingNotes.splice(index, 1);
				}
			}

			var downscrollMultiplier = (ClientPrefs.downScroll ? -1 : 1);
		if (generatedMusic)
		{
			var fakeCrochet:Float = (60 / SONG.bpm) * 1000;
			notes.forEachAlive(function(daNote:Note)
			{
				if(!daNote.mustPress && ClientPrefs.middleScroll && ClientPrefs.fof || !daNote.mustPress && ClientPrefs.nop)
				{
					daNote.active = true;
					daNote.visible = false;
				}
				else if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				// i am so fucking sorry for this if condition
				var strumX:Float = 0;
				var strumY:Float = 0;
				var strumAngle:Float = 0;
				var strumAlpha:Float = 0;
				if(daNote.mustPress) {
					strumX = playerStrums.members[daNote.noteData].x;
					strumY = playerStrums.members[daNote.noteData].y;
					strumAngle = playerStrums.members[daNote.noteData].angle;
					strumAlpha = playerStrums.members[daNote.noteData].alpha;
				} else {
					strumX = opponentStrums.members[daNote.noteData].x;
					strumY = opponentStrums.members[daNote.noteData].y;
					strumAngle = opponentStrums.members[daNote.noteData].angle;
					strumAlpha = opponentStrums.members[daNote.noteData].alpha;
				}

				strumX += daNote.offsetX;
				strumY += daNote.offsetY;
				strumAngle += daNote.offsetAngle;
				strumAlpha *= daNote.multAlpha;
				var center:Float = strumY + Note.swagWidth / 2;

				if(daNote.copyX) {
					daNote.x = strumX;
				}
				if(daNote.copyAngle) {
					daNote.angle = strumAngle;
				}
				if(daNote.copyAlpha) {
					daNote.alpha = strumAlpha;
				}
				if(daNote.copyY) {
					if (ClientPrefs.downScroll) {
						daNote.y = (strumY + 0.45 * (Conductor.songPosition - daNote.strumTime) * roundedSpeed);
						if (daNote.isSustainNote) {
							//Jesus fuck this took me so much mother fucking time AAAAAAAAAA
							if (daNote.animation.curAnim.name.endsWith('end')) {
								daNote.y += 10.5 * (fakeCrochet / 400) * 1.5 * roundedSpeed + (46 * (roundedSpeed - 1));
								daNote.y -= 46 * (1 - (fakeCrochet / 600)) * roundedSpeed;
								if(PlayState.isPixelStage) {
									daNote.y += 8;
								} else {
									daNote.y -= 19;
								}
							} 
							daNote.y += (Note.swagWidth / 2) - (60.5 * (roundedSpeed - 1));
							daNote.y += 27.5 * ((SONG.bpm / 100) - 1) * (roundedSpeed - 1);

							if(daNote.mustPress || !daNote.ignoreNote)
							{
								if(daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center
									&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
								{
									var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
									swagRect.height = (center - daNote.y) / daNote.scale.y;
									swagRect.y = daNote.frameHeight - swagRect.height;

									daNote.clipRect = swagRect;
								}
							}
						}
					} else {
						daNote.y = (strumY - 0.45 * (Conductor.songPosition - daNote.strumTime) * roundedSpeed);

						if(daNote.mustPress || !daNote.ignoreNote)
						{
							if (daNote.isSustainNote
								&& daNote.y + daNote.offset.y * daNote.scale.y <= center
								&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
							{
								var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
								swagRect.y = (center - daNote.y) / daNote.scale.y;
								swagRect.height -= swagRect.y;

								daNote.clipRect = swagRect;
							}
						}
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit && !daNote.hitByOpponent && !daNote.ignoreNote)
				{
					if (Paths.formatToSongPath(SONG.song) != 'tutorial')
						camZooming = true;

					if(daNote.noteType == 'Hey!' && dad.animOffsets.exists('hey')) {
						dad.playAnim('hey', true);
						dad.specialAnim = true;
						dad.heyTimer = 0.6;
					} else if(!daNote.noAnimation) {
						var altAnim:String = "";

						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim || daNote.noteType == 'Alt Animation') {
								altAnim = '-alt';
							}
						}

						var animToPlay:String = '';
						switch (Math.abs(daNote.noteData))
						{
							case 0:
								animToPlay = 'singLEFT';
							case 1:
								animToPlay = 'singDOWN';
							case 2:
								animToPlay = 'singUP';
							case 3:
								animToPlay = 'singRIGHT';
						}
						if(daNote.noteType == 'GF Sing') {
							gf.playAnim(animToPlay + altAnim, true);
							gf.holdTimer = 0;
							bothOpponentSing = false;
							opponent2sing = false;
							if (curStage == 'cargo'){
								reloadHealthBarColors();
								reloadTimeBarColors();
								iconP2.changeIcon(gf.healthIcon);
							}
						} else if (daNote.noteType == 'Both Opponents Sing') {
							mom.playAnim(animToPlay + altAnim, true);
							mom.holdTimer = 0;
							dad.playAnim(animToPlay + altAnim, true);
							dad.holdTimer = 0;
							bothOpponentSing = true;
							opponent2sing = false;
							if (curStage == 'cargo'){
								reloadHealthBarColors();
								reloadTimeBarColors();
								if (dad.curCharacter == 'whitedk' && mom.curCharacter == 'blackdk'){
									iconP2.changeIcon('whiteblack');	
								}else{
									iconP2.changeIcon(dad.healthIcon);
								}
							}
						} else if (daNote.noteType == 'Opponent 2 Sing') {
							mom.playAnim(animToPlay + altAnim, true);
							mom.holdTimer = 0;
							opponent2sing = true;
							bothOpponentSing = false;
							if (curStage == 'cargo'){
								reloadHealthBarColors();
								reloadTimeBarColors();
								iconP2.changeIcon(mom.healthIcon);
							}
						} else {
							dad.playAnim(animToPlay + altAnim, true);
							dad.holdTimer = 0;
							bothOpponentSing = false;
							opponent2sing = false;
							if (curStage == 'cargo'){
								reloadHealthBarColors();
								reloadTimeBarColors();
								iconP2.changeIcon(dad.healthIcon);
							}
						}
					}

					if (SONG.needsVoices)
						vocals.volume = ClientPrefs.vocalsVolume;

					var time:Float = 0.10;
					if (ClientPrefs.fastBotcaFrames2){
						time = 0.05;
					}
					if(daNote.isSustainNote && !daNote.animation.curAnim.name.endsWith('end')) {
						time += 0.15;
						if (ClientPrefs.fastBotcaFrames2){
							time = 0.05;
						}
					}
					if (curStage != 'alpha') {
						if (daNote.isSustainNote){
							StrumPlayAnim2(true, Std.int(Math.abs(daNote.noteData)) % 4, time);
						}else{
							StrumPlayAnim(true, Std.int(Math.abs(daNote.noteData)) % 4, time);
						}
                    }
					daNote.hitByOpponent = true;

					if (health > 0.05 && !daNote.isSustainNote && dad.curCharacter == 'ziffy'){
						health -= 0.025;
					}

					if (health > 0.05 && !daNote.isSustainNote && blackChars.contains(dad.curCharacter) || health > 0.05 && !daNote.isSustainNote && mom.curCharacter == 'blackdk' && opponent2sing || health > 0.05 && !daNote.isSustainNote && mom.curCharacter == 'blackdk' && bothOpponentSing){
						health -= 0.025;
					}

					if (health > 0.05 && !daNote.isSustainNote && dtChars.contains(dad.curCharacter)){
						health -= 0.025;
					}

					if (dad.curCharacter == 'starved' && daNote.hitByOpponent && fearNo <= 70)
						{
							fearNo += 0.56;
							// trace(fearNo);
						}

					callOnLuas('opponentNoteHit', [notes.members.indexOf(daNote), Math.abs(daNote.noteData), daNote.noteType, daNote.isSustainNote]);

					if (!daNote.isSustainNote)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
						if (!ClientPrefs.nop && !ClientPrefs.middleScroll && !ClientPrefs.fof){
							if (curStage.toLowerCase() != 'finalem' && curStage.toLowerCase() != 'finale' && curStage.toLowerCase() != 'defeat' && SONG.stage.toLowerCase() != 'defeat' && SONG.stage.toLowerCase() != 'defeat' && curStage.toLowerCase() != 'defeatOld' && curStage != 'monochrome' && curStage != 'esculent' && curSong != 'Final Showdown' && !fofStages.contains(curStage) && dad.curCharacter != 'monotone'){
								spawnNoteSplashOnNote2(daNote);
							}
						}	
					}
				}

				if(daNote.mustPress && cpuControlled) {
					if(daNote.isSustainNote) {
						if(daNote.canBeHit) {
							goodNoteHit(daNote);
						}
					} else if(daNote.strumTime <= Conductor.songPosition || (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress)) {
						goodNoteHit(daNote);
					}
				}

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				var doKill:Bool = daNote.y < -daNote.height;
				if(ClientPrefs.downScroll) doKill = daNote.y > FlxG.height;

				if (doKill)
				{
					if (daNote.mustPress && !daNote.isSustainNote && !daNote.ignoreNote && !endingSong && (daNote.tooLate || !daNote.wasGoodHit)) {
						if (cpuControlled || practiceMode || PlayState.SONG.stage.toLowerCase() == 'victory')
							goodNoteHit(daNote);
						else
							noteMiss(daNote);
					}
					
					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
			if(curStage.toLowerCase() == 'voting' || curStage.toLowerCase() == 'attack'){
				votingnotes.forEachAlive(function(daNote:Note)
				{
					if (!daNote.mustPress && ClientPrefs.middleScroll)
					{
						daNote.active = true;
						daNote.visible = false;
					}
					else if (daNote.y > FlxG.height)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}

					var strumX:Float = 0;
					var strumY:Float = 0;
					var strumAngle:Float = 0;
					var strumAlpha:Float = 0;
					if (daNote.mustPress)
					{
						strumX = playerStrums.members[daNote.noteData].x;
						strumY = playerStrums.members[daNote.noteData].y;
						strumAngle = playerStrums.members[daNote.noteData].angle;
						strumAlpha = playerStrums.members[daNote.noteData].alpha;
					}
					else
					{
						strumX = opponentStrums.members[daNote.noteData].x;
						strumY = opponentStrums.members[daNote.noteData].y;
						strumAngle = opponentStrums.members[daNote.noteData].angle;
						strumAlpha = opponentStrums.members[daNote.noteData].alpha;
					}

					strumX += daNote.offsetX;
					strumY += daNote.offsetY;
					strumAngle += daNote.offsetAngle;
					strumAlpha *= daNote.multAlpha;

					if (daNote.copyX)
						daNote.x = strumX;
					if (daNote.copyAngle)
						daNote.angle = strumAngle;
					if (daNote.copyAlpha)
						daNote.alpha = strumAlpha;

					daNote.alpha = 0.3;

					if (daNote.copyY)
					{
						var receptors:FlxTypedGroup<StrumNote> = (daNote.mustPress ? playerStrums : opponentStrums);
						var receptorPosY:Float = receptors.members[Math.floor(daNote.noteData)].y;
						var psuedoY:Float = (downscrollMultiplier * -((Conductor.songPosition - daNote.strumTime) * (0.45 * roundedSpeed)));
						daNote.y = receptorPosY + psuedoY + daNote.offsetY;
						daNote.x = receptors.members[Math.floor(daNote.noteData)].x + daNote.offsetX;

						// shitty note hack I hate it so much
						var center:Float = receptorPosY + Note.swagWidth / 2;
						if (daNote.isSustainNote)
						{
							if ((daNote.animation.curAnim.name.endsWith('holdend')) && (daNote.prevNote != null))
							{
								daNote.y -= ((daNote.prevNote.height / 2) * downscrollMultiplier);
								if (downscrollMultiplier < 0)
								{
									daNote.y += (daNote.height * 2);
									if (daNote.endHoldOffset == Math.NEGATIVE_INFINITY)
										daNote.endHoldOffset = (daNote.prevNote.y - (daNote.y + daNote.height));
									else
										daNote.y += daNote.endHoldOffset;
								}
								else // this system is funny like that
									daNote.y += ((daNote.height / 2) * downscrollMultiplier);
							}

							if (downscrollMultiplier < 0)
							{
								daNote.flipY = true;
								if ((daNote.parentNote != null && daNote.parentNote.wasGoodHit)
									&& daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center
									&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
								{
									var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
									swagRect.height = (center - daNote.y) / daNote.scale.y;
									swagRect.y = daNote.frameHeight - swagRect.height;
									daNote.clipRect = swagRect;
								}
							}
							else
							{
								daNote.flipY = false;
								if ((daNote.parentNote != null && daNote.parentNote.wasGoodHit)
									&& daNote.y + daNote.offset.y * daNote.scale.y <= center
									&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
								{
									var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
									swagRect.y = (center - daNote.y) / daNote.scale.y;
									swagRect.height -= swagRect.y;
									daNote.clipRect = swagRect;
								}
							}
						}
					}

					if (daNote.wasGoodHit && !daNote.ignoreNote)
					{
						if (!daNote.noAnimation)
						{
							var animToPlay:String = '';
							switch (Math.abs(daNote.noteData))
							{
								case 0:
									animToPlay = 'singLEFT';
								case 1:
									animToPlay = 'singDOWN';
								case 2:
									animToPlay = 'singUP';
								case 3:
									animToPlay = 'singRIGHT';
							}
							if (daNote.mustPress)
							{
								mom.holdTimer = 0;						
								mom.playAnim(animToPlay, true);
							}
							else
							{
								gf.holdTimer = 0;
								gf.playAnim(animToPlay, true);
										// dad.angle = 0;
								/*if (!daNote.isSustainNote) //&& votingnoteRows[daNote.mustPress?0:1][daNote.row].length > 1)
									{
										trace("worked 5780");
										// potentially have jump anims?
										var chord = votingnoteRows[daNote.mustPress?0:1][daNote.row];
										var animNote = chord[0];
										var realAnim = singAnimations[Std.int(Math.abs(animNote.noteData))];
										if (gf.mostRecentRow != daNote.row)
										{
											gf.playAnim(realAnim, true);
										}
					
										// if (daNote != animNote)
										// dad.playGhostAnim(chord.indexOf(daNote)-1, animToPlay, true);
					
										gf.mostRecentRow = daNote.row;
										// dad.angle += 15; lmaooooo
										if (!daNote.noAnimation)
										{
											doGhostAnim('gf', animToPlay);
										}
									}
									else{
										gf.playAnim(animToPlay, true);
										// dad.angle = 0;
									}*/
							}
						}


						var time:Float = 0.15;
						if (daNote.isSustainNote && !daNote.animation.curAnim.name.endsWith('end'))
						{
							time += 0.15;
						}
						
						daNote.hitByOpponent = true;

						if (!daNote.isSustainNote)
						{
							daNote.kill();
							votingnotes.remove(daNote, true);
							daNote.destroy();
						}
					}

				
					if (daNote.mustPress)
					{
						if (daNote.isSustainNote)
						{
							if (daNote.canBeHit)
							{
								goodVotingNoteHit(daNote);
							}
						}
						else if (daNote.strumTime <= Conductor.songPosition || (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress))
						{
							goodVotingNoteHit(daNote);
						}
					}

					var doKill:Bool = daNote.y < -daNote.height;
					if (ClientPrefs.downScroll)
						doKill = daNote.y > FlxG.height;

					if ((((downscrollMultiplier > 0) && (daNote.y < -daNote.height))
						|| ((downscrollMultiplier < 0) && (daNote.y > (FlxG.height + daNote.height)))
						|| (daNote.isSustainNote && daNote.strumTime - Conductor.songPosition < -350))
						&& (daNote.tooLate || daNote.wasGoodHit))
					{
						daNote.active = false;
						daNote.visible = false;
						daNote.kill();
						votingnotes.remove(daNote, true);
						daNote.destroy();
					}
				});
			}
		}
		checkEventNote();

		if (!inCutscene) {
			if(!cpuControlled) {
				keyShit();
			} else if(boyfriend.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss')) {
				boyfriend.dance();
			}
		}
		
		if (Main.debugBuild){		
			if(!endingSong && !startingSong) {
				if (FlxG.keys.justPressed.ONE) {
					KillNotes();
					FlxG.sound.music.onComplete();
				}
				if(FlxG.keys.justPressed.TWO) { //Go 10 seconds into the future :O
					FlxG.sound.music.pause();
					vocals.pause();
					Conductor.songPosition += 10000;
					notes.forEachAlive(function(daNote:Note)
					{
						if(daNote.strumTime + 800 < Conductor.songPosition) {
							daNote.active = false;
							daNote.visible = false;

							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}
					});
					for (i in 0...unspawnNotes.length) {
						var daNote:Note = unspawnNotes[0];
						if(daNote.strumTime + 800 >= Conductor.songPosition) {
							break;
						}

						daNote.active = false;
						daNote.visible = false;

						daNote.kill();
						unspawnNotes.splice(unspawnNotes.indexOf(daNote), 1);
						daNote.destroy();
					}

					FlxG.sound.music.time = Conductor.songPosition;
					FlxG.sound.music.play();

					vocals.time = Conductor.songPosition;
					vocals.play();
				}
			}
			if (!cameraLocked){
				setOnLuas('cameraX', camFollowPos.x);
				setOnLuas('cameraY', camFollowPos.y);
			}
			setOnLuas('botPlay', PlayState.cpuControlled);
			callOnLuas('onUpdatePost', [elapsed]);
		}

	}
	public function openPreferences()
		{
			var ret:Dynamic = callOnLuas('onPause', []);
			if(ret != FunkinLua.Function_Stop) {
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;
			if(FlxG.sound.music != null) {
				FlxG.sound.music.pause();
				vocals.pause();
				}
			}
			openSubState(new OptionsState.PreferencesSubstate());
		}
	var isDead:Bool = false;
	function doDeathCheck() {
		if (health <= 0 && !practiceMode && !isDead && curSong != 'Final Showdown')
		{
			var ret:Dynamic = callOnLuas('onGameOver', []);
			if(ret != FunkinLua.Function_Stop) {
				boyfriend.stunned = true;
				deathCounter++;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;

				vocals.stop();
				FlxG.sound.music.stop();

				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, camFollowPos.x, camFollowPos.y, this));
				for (tween in modchartTweens) {
					tween.active = true;
				}
				for (timer in modchartTimers) {
					timer.active = true;
				}

				// MusicBeatState.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				
				#if desktop
				// Game Over doesn't get his own variable because it's only used here
				if (ratingString == '?'){
					DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString, iconP2.getCharacter(), false, "");
				}else if (songMisses > 0 && ratingString != '?'){
					DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString + " (" + ((Math.floor(ratingPercent * 10000) / 100)) + "%)", iconP2.getCharacter(), false, "RatingFC: " + ratingAcc);
				}else{
					DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " | Score: " + songScore + " | Misses: " + songMisses + " | Rating: " + ratingString + " (" + ((Math.floor(ratingPercent * 10000) / 100)) + "%)", iconP2.getCharacter(), false, "");
				}
				#end
				isDead = true;
				return true;
			}
		}
		return false;
	}

	public function checkEventNote() {
		while(eventNotes.length > 0) {
			var early:Float = eventNoteEarlyTrigger(eventNotes[0]);
			var leStrumTime:Float = eventNotes[0][0];
			if(Conductor.songPosition < leStrumTime - early) {
				break;
			}

			var value1:String = '';
			if(eventNotes[0][3] != null)
				value1 = eventNotes[0][3];

			var value2:String = '';
			if(eventNotes[0][4] != null)
				value2 = eventNotes[0][4];

			triggerEventNote(eventNotes[0][2], value1, value2);
			eventNotes.shift();
		}
	}

	public function getControl(key:String) {
		var pressed:Bool = Reflect.getProperty(controls, key);
		//trace('Control result: ' + pressed);
		return pressed;
	}

	public function triggerEventNote(eventName:String, value1:String, value2:String) {
		switch(eventName) {
			case 'Hey!':
				var value:Int = 2;
				switch(value1.toLowerCase().trim()) {
					case 'bf' | 'boyfriend' | '0':
						value = 0;
					case 'gf' | 'girlfriend' | '1':
						value = 1;
				}

				var time:Float = Std.parseFloat(value2);
				if(Math.isNaN(time) || time <= 0) time = 0.6;

				if(value != 0) {
					if(dad.curCharacter.startsWith('gf')) { //Tutorial GF is actually Dad! The GF is an imposter!! ding ding ding ding ding ding ding, dindinding, end my suffering
						dad.playAnim('cheer', true);
						dad.specialAnim = true;
						dad.heyTimer = time;
					} else {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = time;
					}

					if(curStage == 'mall') {
						bottomBoppers.animation.play('hey', true);
						heyTimer = time;
					}
				}
				if(value != 1) {
					boyfriend.playAnim('hey', true);
					boyfriend.specialAnim = true;
					boyfriend.heyTimer = time;
				}

			case 'Toogus Sax':
				saxguy.setPosition(-550, 275);		
				add(saxguy);

				case 'Lights out':
					camGame.flash(FlxColor.WHITE, 0.35);
					if (boyfriend.curCharacter == 'bf')
					{
						addCharacterToList("whitebf", 0);
						triggerEventNote('Change Character', '0', 'whitebf');
					}
					if (dad.curCharacter == 'impostor3')
					{
						addCharacterToList('whitegreen', 1);
						triggerEventNote('Change Character', '1', 'whitegreen');
					}
					loBlack.alpha = 1;
					/*if (!ClientPrefs.hideHud)*/{
						healthBar.visible = false;
						healthBarBG.visible = false;
						healthBarOverlay.visible = false;
						scoreTxt.visible = false;
						iconP1.visible = false;
						iconP2.visible = false;
					}
					if (!ClientPrefs.hideTime){
						timeTxt.visible = false;
						timeBar.visible = false;
						timeBarBG.visible = false;
					}
					healthBar.createFilledBar(FlxColor.BLACK, FlxColor.WHITE);
					healthBar.updateBar();

				case 'Lights on':
					camGame.flash(FlxColor.BLACK, 0.35);
					if (boyfriend.curCharacter == 'whitebf')
					{
						triggerEventNote('Change Character', '0', 'bf');
					}
					if (dad.curCharacter == 'whitegreen')
					{
						triggerEventNote('Change Character', '1', 'impostor3');
					}
					loBlack.alpha = 0;
					if (!ClientPrefs.hideHud){
						healthBar.visible = true;
						healthBarBG.visible = true;
						healthBarOverlay.visible = true;
						scoreTxt.visible = true;
						iconP1.visible = true;
						iconP2.visible = true;
					}
					if (!ClientPrefs.hideTime){
						timeTxt.visible = true;
						timeBar.visible = true;
						timeBarBG.visible = true;
					}

				case 'Lights on Ending':
					if (boyfriend.curCharacter == 'whitebf')
					{
						triggerEventNote('Change Character', '0', 'bf');
					}
					if (dad.curCharacter == 'whitegreen')
					{
						triggerEventNote('Change Character', '1', 'impostor3');
					}
					loBlack.alpha = 0;

					boyfriend.visible = false;
					gf.visible = false;
					camHUD.visible = false;

					triggerEventNote('Play Animation', 'liveReaction', 'dad');
					bfvent.animation.play('vent');
					bfvent.alpha = 1;
					ldSpeaker.animation.play('boom');
					ldSpeaker.visible = true;

					case 'Defeat Fade':
						var charType:Int = Std.parseInt(value1);
						if (Math.isNaN(charType))
							charType = 0;
	
						switch (charType)
						{
							case 0:
								FlxTween.tween(bodies, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
								FlxTween.tween(bodies2, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
								FlxTween.tween(bodiesfront, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
							case 1:
								FlxTween.tween(bodies, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
								FlxTween.tween(bodies2, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
								FlxTween.tween(bodiesfront, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
						}
					case 'Defeat Retro':
						var charType:Int = Std.parseInt(value1);
						if (Math.isNaN(charType))
							charType = 0;
	
						switch (charType)
						{
							case 0:
								bodiesfront.alpha = 0;
								lightoverlay.alpha = 0;
								mainoverlayDK.alpha = 1;
							case 1:
								triggerEventNote('Change Character', '0', 'bf-defeat-scared');
								triggerEventNote('Change Character', '1', 'black');
								bodiesfront.alpha = 1;
								lightoverlay.alpha = 1;
								mainoverlayDK.alpha = 0;
						}

						case 'DefeatDark':
							var charType:Int = Std.parseInt(value1);
							if (Math.isNaN(charType))
								charType = 0;
		
							switch (charType)
							{
								case 0:
									defeatblack.alpha = 0;
									defeatDark = false;
									iconP1.visible = true;
									iconP2.visible = true;
									scoreTxt.visible = true;
								case 1:
									defeatblack.alpha += 1;
									defeatDark = true;
									iconP1.visible = false;
									iconP2.visible = false;
									scoreTxt.visible = false;
							}

							case 'Cam lock in Who':
								if (value1 == 'in')
								{
									defaultCamZoom = 1.2;
									camGame.camera.zoom = 1.2;
									cameraLocked = true;
									if (value2 == 'dad')
									{
										camFollowPos.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y + 150);
										FlxG.camera.focusOn(camFollowPos.getPosition());
									}
									else
									{
										camFollowPos.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y + 150);
										FlxG.camera.focusOn(camFollowPos.getPosition());
									}
								}
								else
								{
									cameraLocked = true;
									defaultCamZoom = 0.7;
									FlxG.camera.zoom = 0.7;
									camFollowPos.setPosition(1100, 1150);
									FlxG.camera.focusOn(camFollowPos.getPosition());
								}

					case 'Cam lock in Voting Time':
					if (value1 == 'in')
					{
						defaultCamZoom = 1.2;
						camGame.camera.zoom = 1.2;
						cameraLocked = true;
						if (value2 == 'dad')
						{
							camFollowPos.setPosition(460, 700);
							FlxG.camera.focusOn(camFollowPos.getPosition());
							iconP2.changeIcon(dad.healthIcon);
							healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
							FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
							healthBar.updateBar();
						}
						else
						{
							camFollowPos.setPosition(1470, 700);
							FlxG.camera.focusOn(camFollowPos.getPosition());
						}
					}
					else if (value1 == 'close')
					{
						defaultCamZoom = 1.25;
						camGame.camera.zoom = 1.25;
						cameraLocked = true;
						if (value2 == 'dad')
						{
							camFollowPos.setPosition(480, 680);
							FlxG.camera.focusOn(camFollowPos.getPosition());
							iconP2.changeIcon(gf.healthIcon);
							healthBar.createFilledBar(FlxColor.fromRGB(gf.healthColorArray[0], gf.healthColorArray[1], gf.healthColorArray[2]),
							FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
							healthBar.updateBar();
						}
						else
						{
							camFollowPos.setPosition(1450, 680);
							FlxG.camera.focusOn(camFollowPos.getPosition());
							iconP2.changeIcon(mom.healthIcon);
							healthBar.createFilledBar(FlxColor.fromRGB(mom.healthColorArray[0], mom.healthColorArray[1], mom.healthColorArray[2]),
							FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
							healthBar.updateBar();
						}
					}
					else
					{
						cameraLocked = true;
						defaultCamZoom = 0.7;
						FlxG.camera.zoom = 0.7;
						camFollowPos.setPosition(960, 540);
						FlxG.camera.focusOn(camFollowPos.getPosition());
					}
				
				case 'Lights Down OFF':
					camGame.visible = false;

					case 'Turbulence Ending':
						turbEnding = true;	
	
					case 'Turbulence Speed':
						turbSpeed = Std.parseFloat(value1);

						case 'Ellie Drop':
							add(momGroup);
							dad.playAnim('shock', false);
							dad.specialAnim = true;
							mom.playAnim('enter', false);
							mom.specialAnim = true;
							iconP2.changeIcon('ellie');

						case 'chromToggle':
							var theAmount:Float = Std.parseFloat(value1);
							if (Math.isNaN(theAmount))
								theAmount = 0;
							var theAmount2:Int = Std.parseInt(value2);
							if (Math.isNaN(theAmount2))
								theAmount2 = 0;
							
							if(theAmount != 0){
								isChrom = true;
								chromAmount = theAmount;
								chromFreq = theAmount2;
								return;
							}else{
								isChrom = false;
								chromAmount = 0;
								return;
							}

							case 'Double Kill Events':
					switch(value1.toLowerCase()){
						case 'darken':
							cargoDarken = true;
							camGame.flash(FlxColor.BLACK, 0.55);
						case 'airship':
							showDlowDK = true;
						case 'brighten':
							showDlowDK = false;
							cargoDarken = false;
							cargoAirsip.alpha = 0.001;
							cargoDark.alpha = 0.001;
							dad.alpha = 1;
							mom.alpha = 1;
							lightoverlayDK.alpha = 0.51;
							mainoverlayDK.alpha = 0.6;
						
						case 'gonnakill':
							cargoReadyKill = true;
						case 'readykill':
							camGame.flash(FlxColor.BLACK, 2.75);
							triggerEventNote('Change Character', '0', 'bf-defeat-normal');
							defeatDKoverlay.alpha = 1;
							lightoverlayDK.alpha = 0;
							mainoverlayDK.alpha = 0;
							cargoDarkFG.alpha = 0;
							cargoDark.alpha = 1;
							cargoReadyKill = false;
							dad.alpha = 0;
							timeBar.alpha = 0;
							timeBarBG.alpha = 0;
							timeTxt.alpha = 0;
							healthBar.alpha = 0;
							healthBarBG.alpha = 0;
							iconP1.alpha = 0;
							iconP2.alpha = 0;
						case 'kill':
							camGame.flash(FlxColor.RED, 2.75);
							mom.alpha = 0;
							boyfriend.alpha = 0;
							pet.alpha = 0;
							camHUD.visible = false;
							defeatDKoverlay.alpha = 0;
					}

					case 'Start Video':
						startVideo(value1);
						canPause = false;
						if (value2 == 'a'){
							camHUD.visible = false;
						}else if (value2 == 'b'){
							camGame.visible = false;
						}else if (value2 == 'c'){
							camHUD.visible = false;
							camGame.visible = false;
						}else if (value2 == null){
							trace("MY ASS");
						}else{
							trace("MY ASS");
						}

						case 'Ejected Start':
							camGame.flash(FlxColor.WHITE, 0.35);
							camHUD.visible = true;
							camGame.visible = true;

							case 'Old Dt':
								camGame.flash(FlxColor.WHITE, 0.35);
								addCharacterToList('dt', 1);
								addCharacterToList('bf-fall1', 0);
								addCharacterToList('gf-fall1', 2);
								triggerEventNote('Change Character', '1', 'dt');
								triggerEventNote('Change Character', '0', 'bf-fall1');

							case 'New Dt':
								camGame.flash(FlxColor.WHITE, 0.35);
								addCharacterToList('double-trouble', 1);
								addCharacterToList('bf-fall', 0);
								addCharacterToList('gf-fall', 2);
								triggerEventNote('Change Character', '1', 'double-trouble');
								triggerEventNote('Change Character', '0', 'bf-fall');

								case 'maroon flashback':
									camGame.flash(FlxColor.WHITE, 0.35);
									sky3.visible = true;
									ground3.visible = true;
									rocksbg.visible = true;
									rocks3.visible = true;

									addCharacterToList('maroon_flashback', 1);
									triggerEventNote('Change Character', '1', 'maroon_flashback');
									addCharacterToList('bf', 0);
									triggerEventNote('Change Character', '0', 'bf');

									case 'maroon normal':
										camGame.flash(FlxColor.WHITE, 0.35);
										sky3.visible = false;
										ground3.visible = false;
										rocksbg.visible = false;
										rocks3.visible = false;
	
										addCharacterToList('maroonp', 1);
										triggerEventNote('Change Character', '1', 'maroonp');
										addCharacterToList('bf-lava', 0);
										triggerEventNote('Change Character', '0', 'bf-lava');


					case 'Victory Darkness': //prolly could be done easier but who cares brah
					if (value1 == 'on')
						{
							victoryDarkness.alpha = 1;
							FlxG.sound.play(Paths.sound('playerdisconnect'));
						}
					else
						{
							victoryDarkness.alpha = 0;
						}

				case 'Show Victory Guy': //makes bg dudes appear (this is annoying)
					if (value1 == 'jor')
						{
							if (value2 == 'show')
								{
									bg_jor.alpha = 1;
								}
							else
								{
									bg_jor.alpha = 0;
								}
						}
					else if (value1 == 'war')
						{
							if (value2 == 'show')
								{
									bg_war.alpha = 1;
									bg_war.x = (693.7);
									bg_war.y = (421.9);
								}
							else
								{
									bg_war.alpha = 0;
								}
						}
					else if (value1 == 'warMid')
						{
							if (value2 == 'show')
								{
									bg_war.alpha = 1;
									bg_war.x = (853.3);
									bg_war.y = (421.9);
								}
							else
								{
									bg_war.alpha = 0;
								}
						}
					else if (value1 == 'jelqLeft')
						{
							if (value2 == 'show')
								{
									bg_jelq.alpha = 1;
									bg_jelq.x = (676.05);
									bg_jelq.y = (458.3);
								}
							else
								{
									bg_jelq.alpha = 0;
								}
						}
					else if (value1 == 'jelqMid')
						{
							if (value2 == 'show')
								{
									bg_jelq.alpha = 1;
									bg_jelq.x = (835.65);
									bg_jelq.y = (458.3);
								}
							else
								{
									bg_jelq.alpha = 0;
								}
						}
					else if (value1 == 'jelqRight')
						{
							if (value2 == 'show')
								{
									bg_jelq.alpha = 1;
									bg_jelq.x = (982.75);
									bg_jelq.y = (458.3);
								}
							else
								{
									bg_jelq.alpha = 0;
								}
						}
					else
						{
							bg_jelq.alpha = 0;
							bg_war.alpha = 0;
							bg_jor.alpha = 0;
						}

			case 'Set GF Speed':
				var value:Int = Std.parseInt(value1);
				if(Math.isNaN(value)) value = 1;
				gfSpeed = value;

			case 'Blammed Lights':
				var lightId:Int = Std.parseInt(value1);
				if(Math.isNaN(lightId)) lightId = 0;

				if(lightId > 0 && curLightEvent != lightId) {
					if(lightId > 5) lightId = FlxG.random.int(1, 5, [curLightEvent]);

					var color:Int = 0xffffffff;
					switch(lightId) {
						case 1: //Blue
							color = 0xff31a2fd;
						case 2: //Green
							color = 0xff31fd8c;
						case 3: //Pink
							color = 0xfff794f7;
						case 4: //Red
							color = 0xfff96d63;
						case 5: //Orange
							color = 0xfffba633;
					}
					curLightEvent = lightId;

					if(blammedLightsBlack.alpha == 0) {
						if(blammedLightsBlackTween != null) {
							blammedLightsBlackTween.cancel();
						}
						blammedLightsBlackTween = FlxTween.tween(blammedLightsBlack, {alpha: 1}, 1, {ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween) {
								blammedLightsBlackTween = null;
							}
						});

						var chars:Array<Character> = [boyfriend, gf, dad];
						for (i in 0...chars.length) {
							if(chars[i].colorTween != null) {
								chars[i].colorTween.cancel();
							}
							chars[i].colorTween = FlxTween.color(chars[i], 1, FlxColor.WHITE, color, {onComplete: function(twn:FlxTween) {
								chars[i].colorTween = null;
							}, ease: FlxEase.quadInOut});
						}
					} else {
						if(blammedLightsBlackTween != null) {
							blammedLightsBlackTween.cancel();
						}
						blammedLightsBlackTween = null;
						blammedLightsBlack.alpha = 1;

						var chars:Array<Character> = [boyfriend, gf, dad];
						for (i in 0...chars.length) {
							if(chars[i].colorTween != null) {
								chars[i].colorTween.cancel();
							}
							chars[i].colorTween = null;
						}
						dad.color = color;
						boyfriend.color = color;
						gf.color = color;
					}
					
					if(curStage == 'philly') {
						if(phillyCityLightsEvent != null) {
							phillyCityLightsEvent.forEach(function(spr:BGSprite) {
								spr.visible = false;
							});
							phillyCityLightsEvent.members[lightId - 1].visible = true;
							phillyCityLightsEvent.members[lightId - 1].alpha = 1;
						}
					}
				} else {
					if(blammedLightsBlack.alpha != 0) {
						if(blammedLightsBlackTween != null) {
							blammedLightsBlackTween.cancel();
						}
						blammedLightsBlackTween = FlxTween.tween(blammedLightsBlack, {alpha: 0}, 1, {ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween) {
								blammedLightsBlackTween = null;
							}
						});
					}

					if(curStage == 'philly') {
						phillyCityLights.forEach(function(spr:BGSprite) {
							spr.visible = false;
						});
						phillyCityLightsEvent.forEach(function(spr:BGSprite) {
							spr.visible = false;
						});

						var memb:FlxSprite = phillyCityLightsEvent.members[curLightEvent - 1];
						if(memb != null) {
							memb.visible = true;
							memb.alpha = 1;
							if(phillyCityLightsEventTween != null)
								phillyCityLightsEventTween.cancel();

							phillyCityLightsEventTween = FlxTween.tween(memb, {alpha: 0}, 1, {onComplete: function(twn:FlxTween) {
								phillyCityLightsEventTween = null;
							}, ease: FlxEase.quadInOut});
						}
					}

					var chars:Array<Character> = [boyfriend, gf, dad];
					for (i in 0...chars.length) {
						if(chars[i].colorTween != null) {
							chars[i].colorTween.cancel();
						}
						chars[i].colorTween = FlxTween.color(chars[i], 1, chars[i].color, FlxColor.WHITE, {onComplete: function(twn:FlxTween) {
							chars[i].colorTween = null;
						}, ease: FlxEase.quadInOut});
					}

					curLight = 0;
					curLightEvent = 0;
				}

			case 'Kill Henchmen':
				killHenchmen();

			case 'Add Camera Zoom':
				if(ClientPrefs.camZooms && FlxG.camera.zoom < 1.35) {
					var camZoom:Float = Std.parseFloat(value1);
					var hudZoom:Float = Std.parseFloat(value2);
					if(Math.isNaN(camZoom)) camZoom = 0.015;
					if(Math.isNaN(hudZoom)) hudZoom = 0.03;

					FlxG.camera.zoom += camZoom;
					camHUD.zoom += hudZoom;
				}

			case 'Trigger BG Ghouls':
				if(curStage == 'schoolEvil' && !ClientPrefs.lowQuality) {
					bgGhouls.dance(true);
					bgGhouls.visible = true;
				}

			case 'Play Animation':
				//trace('Anim to play: ' + value1);
				var char:Character = dad;
				switch(value2.toLowerCase().trim()) {
					case 'bf' | 'boyfriend':
						char = boyfriend;
					case 'gf' | 'girlfriend':
						char = gf;
					default:
						var val2:Int = Std.parseInt(value2);
						if(Math.isNaN(val2)) val2 = 0;
		
						switch(val2) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}
				char.playAnim(value1, true);
				char.specialAnim = true;

			case 'Camera Follow Pos':
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1)) val1 = 0;
				if(Math.isNaN(val2)) val2 = 0;

				isCameraOnForcedPos = false;
				if(!Math.isNaN(Std.parseFloat(value1)) || !Math.isNaN(Std.parseFloat(value2))) {
					camFollow.x = val1;
					camFollow.y = val2;
					isCameraOnForcedPos = true;
				}

			case 'Alt Idle Animation':
				var char:Character = dad;
				switch(value1.toLowerCase()) {
					case 'gf' | 'girlfriend':
						char = gf;
					case 'boyfriend' | 'bf':
						char = boyfriend;
					default:
						var val:Int = Std.parseInt(value1);
						if(Math.isNaN(val)) val = 0;

						switch(val) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}
				char.idleSuffix = value2;
				char.recalculateDanceIdle();

			case 'Screen Shake':
				var valuesArray:Array<String> = [value1, value2];
				var targetsArray:Array<FlxCamera> = [camGame, camHUD];
				for (i in 0...targetsArray.length) {
					var split:Array<String> = valuesArray[i].split(',');
					var duration:Float = Std.parseFloat(split[0].trim());
					var intensity:Float = Std.parseFloat(split[1].trim());
					if(Math.isNaN(duration)) duration = 0;
					if(Math.isNaN(intensity)) intensity = 0;

					if(duration > 0 && intensity != 0) {
						targetsArray[i].shake(intensity, duration);
					}
				}

			case 'Change Character':
				var charType:Int = Std.parseInt(value1);
				if(Math.isNaN(charType)) charType = 0;

				switch(charType) {
					case 0:
						if(boyfriend.curCharacter != value2) {
							if(!boyfriendMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							boyfriend.visible = false;
							boyfriend = boyfriendMap.get(value2);
							if(!boyfriend.alreadyLoaded) {
								boyfriend.alpha = 1;
								boyfriend.alreadyLoaded = true;
							}
							boyfriend.visible = true;
							iconP1.changeIcon(boyfriend.healthIcon);
						}

					case 1:
						if(dad.curCharacter != value2) {
							if(!dadMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var wasGf:Bool = dad.curCharacter.startsWith('gf');
							dad.visible = false;
							dad = dadMap.get(value2);
							if(!dad.curCharacter.startsWith('gf')) {
								if(wasGf) {
									gf.visible = true;
								}
							} else {
								gf.visible = false;
							}
							if(!dad.alreadyLoaded) {
								dad.alpha = 1;
								dad.alreadyLoaded = true;
							}
							dad.visible = true;
							iconP2.changeIcon(dad.healthIcon);
						}

					case 2:
						if(gf.curCharacter != value2) {
							if(!gfMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							gf.visible = false;
							gf = gfMap.get(value2);
							if(!gf.alreadyLoaded) {
								gf.alpha = 1;
								gf.alreadyLoaded = true;
							}
						}

					case 3:
						if(mom.curCharacter != value2) {
							if(!momMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}
	
							mom.visible = false;
							mom = momMap.get(value2);
							if(!mom.alreadyLoaded) {
								mom.alpha = 1;
								mom.alreadyLoaded = true;
							}
						}
				}
				reloadHealthBarColors();
				reloadTimeBarColors();
			
			case 'BG Freaks Expression':
				if(bgGirls != null) bgGirls.swapDanceType();
		}
		callOnLuas('onEvent', [eventName, value1, value2]);
	}

	function moveCameraSection(?id:Int = 0):Void {
		if(SONG.notes[id] == null) return;

		if (!SONG.notes[id].mustHitSection)
		{
			moveCamera(true);
			callOnLuas('onMoveCamera', ['dad']);
		}
		else
		{
			moveCamera(false);
			callOnLuas('onMoveCamera', ['boyfriend']);
		}
	}

	var cameraTwn:FlxTween;
	public function moveCamera(isDad:Bool) {
		if(isDad) {
			camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			camFollow.x += dad.cameraPosition[0];
			camFollow.y += dad.cameraPosition[1];
			tweenCamIn();
		} else {
			camFollow.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

			switch (curStage)
			{
				case 'limo':
					camFollow.x = boyfriend.getMidpoint().x - 300;
				case 'mall':
					camFollow.y = boyfriend.getMidpoint().y - 200;
				case 'school' | 'schoolEvil':
					camFollow.x = boyfriend.getMidpoint().x - 200;
					camFollow.y = boyfriend.getMidpoint().y - 200;
			}
			camFollow.x -= boyfriend.cameraPosition[0];
			camFollow.y += boyfriend.cameraPosition[1];

			if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1) {
				cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
					function (twn:FlxTween) {
						cameraTwn = null;
					}
				});
			}
		}
	}

	function tweenCamIn() {
		if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1.3) {
			cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
				function (twn:FlxTween) {
					cameraTwn = null;
				}
			});
		}
	}

	function snapCamFollowToPos(x:Float, y:Float) {
		camFollow.set(x, y);
		camFollowPos.setPosition(x, y);
	}

	function finishSong():Void
	{
		var finishCallback:Void->Void = endSong; //In case you want to change it in a specific song.

		updateTime = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		vocals.pause();
		if(ClientPrefs.noteOffset <= 0) {
			finishCallback();
		} else {
			finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer) {
				finishCallback();
			});
		}
	}


	var transitioning = false;
	public function endSong():Void
	{
		if (usedPractice || cpuControlled || practiceMode)
		{
			songScore = 0;
			songMisses = 0;
			ratingPercent = 0;
		}
		//Should kill you if you tried to cheat
		if(!startingSong) {
			notes.forEach(function(daNote:Note) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 0.0475;
				}
			});
			for (daNote in unspawnNotes) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 0.0475;
				}
			}

			if(doDeathCheck()) {
				return;
			}
		}
		
		timeBarBG.visible = false;
		timeBar.visible = false;
		timeTxt.visible = false;
		canPause = false;
		endingSong = true;
		camZooming = false;
		inCutscene = false;
		updateTime = false;

		deathCounter = 0;
		seenCutscene = false;

		#if ACHIEVEMENTS_ALLOWED
		if(achievementObj != null) {
			return;
		} else {
			var achieve:Int = checkForAchievement([1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 13, 14, 15]);
			if(achieve > -1) {
				startAchievement(achieve);
				return;
			}
		}
		#end

		
		#if LUA_ALLOWED
		var ret:Dynamic = callOnLuas('onEndSong', []);
		#else
		var ret:Dynamic = FunkinLua.Function_Continue;
		#end

		if(ret != FunkinLua.Function_Stop && !transitioning) {
			if (SONG.validScore)
			{
				#if !switch
				var percent:Float = ratingPercent;
				if(Math.isNaN(percent)) percent = 0;
				Highscore.saveScore(SONG.song, songScore, storyDifficulty, percent);
				#end
			}

			if (isStoryMode)
			{

				var beansValue:Int = Std.int(campaignScore / 300);
				if (songScore != 0){
					add(new BeansPopup(beansValue, camOther));
				}

				campaignScore += songScore;
				campaignMisses += songMisses;

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{

					cancelFadeTween();
					CustomFadeTransition.nextCamera = camOther;
					if(FlxTransitionableState.skipNextTransIn) {
						CustomFadeTransition.nextCamera = null;
					}
					new FlxTimer().start(4, function(tmr:FlxTimer){
						MusicBeatState.switchState(new StoryMenuState());
						FlxG.sound.playMusic(Paths.music('freakyMenu'));
					});

					// if ()
					if(!usedPractice) {
						StoryMenuState.weekCompleted.set(WeekData.weeksList[storyWeek], true);

						if (SONG.validScore)
						{
							Highscore.saveWeekScore(WeekData.getWeekFileName(), campaignScore, storyDifficulty);
						}

						FlxG.save.data.weekCompleted = StoryMenuState.weekCompleted;
						FlxG.save.flush();
					}
					usedPractice = false;
					changedDifficulty = false;
				}
				else
				{
					var difficulty:String = '' + CoolUtil.difficultyStuff[storyDifficulty][1];

					trace('LOADING NEXT SONG');
					trace(Paths.formatToSongPath(PlayState.storyPlaylist[0]) + difficulty);

					var winterHorrorlandNext = (Paths.formatToSongPath(SONG.song) == "eggnog");
					if (winterHorrorlandNext)
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;

					prevCamFollow = camFollow;
					prevCamFollowPos = camFollowPos;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0] + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					if(winterHorrorlandNext) {
						new FlxTimer().start(1.5, function(tmr:FlxTimer) {
							cancelFadeTween();
							//resetSpriteCache = true;
							LoadingState.loadAndSwitchState(new PlayState());
						});
					} else {
						cancelFadeTween();
						//resetSpriteCache = true;
						LoadingState.loadAndSwitchState(new PlayState());
					}
				}
			}
			else if (loadedmenu)
			{
				var beansValue:Int = Std.int(songScore / 300);
				if (songScore != 0){
					add(new BeansPopup(beansValue, camOther));
				}
				new FlxTimer().start(4, function(tmr:FlxTimer){
					if (ClientPrefs.loopsong)
						MusicBeatState.switchState(new PlayState());
					else
						MusicBeatState.switchState(new MainMenuState());	
					if (!ClientPrefs.loopsong)
						{
							FlxG.sound.playMusic(Paths.music('freakyMenu'));
							usedPractice = false;
							changedDifficulty = false;
						}		
				});
					
				loadedmenu = false;		
			}
			else if (loadedmenu2)
			{
				var beansValue:Int = Std.int(songScore / 300);
				if (songScore != 0){
					add(new BeansPopup(beansValue, camOther));
				}
				new FlxTimer().start(4, function(tmr:FlxTimer){
					if (ClientPrefs.loopsong)
						MusicBeatState.switchState(new PlayState());
					else
						MusicBeatState.switchState(new FreeplayMenuState());
					if (!ClientPrefs.loopsong)
						{
							FlxG.sound.playMusic(Paths.music('freakyMenu'));
							usedPractice = false;
							changedDifficulty = false;
						}	
				});
				

				loadedmenu2 = false;		
			}
			else if (loadedmenu3)
			{
				var beansValue:Int = Std.int(songScore / 300);
				if (songScore != 0){
					add(new BeansPopup(beansValue, camOther));
				}
				new FlxTimer().start(4, function(tmr:FlxTimer){
					MusicBeatState.switchState(new MainMenuState());	
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					usedPractice = false;
					changedDifficulty = false;	
				});
			

				loadedmenu3 = false;		
			}
			else
			{
				var beansValue:Int = Std.int(songScore / 300);
				if (songScore != 0){
					add(new BeansPopup(beansValue, camOther));
				}
				if (!ClientPrefs.loopsong)
					trace('WENT BACK TO FREEPLAY??');
				cancelFadeTween();
				CustomFadeTransition.nextCamera = camOther;
				if(FlxTransitionableState.skipNextTransIn) {
					CustomFadeTransition.nextCamera = null;
				}

				new FlxTimer().start(4, function(tmr:FlxTimer){
					if (ClientPrefs.loopsong)
						MusicBeatState.switchState(new PlayState());
					else{
						if(PlayState.skinnyNuts) {
							MusicBeatState.switchState(new MainMenuState());
							PlayState.skinnyNuts = false;
						} else {
							MusicBeatState.switchState(new FreeplayState());
						}
					}
					if (!ClientPrefs.loopsong)
						{
							FlxG.sound.playMusic(Paths.music('freakyMenu'));
							usedPractice = false;
							changedDifficulty = false;
						}
				});
			}
			transitioning = true;
		}
	}

	#if ACHIEVEMENTS_ALLOWED
	var achievementObj:AchievementObject = null;
	function startAchievement(achieve:Int) {
		achievementObj = new AchievementObject(achieve, camOther);
		achievementObj.onFinish = achievementEnd;
		add(achievementObj);
		trace('Giving achievement ' + achieve);
	}
	function achievementEnd():Void
	{
		achievementObj = null;
		if(endingSong && !inCutscene) {
			endSong();
		}
	}
	#end

	public function KillNotes() {
		while(notes.length > 0) {
			var daNote:Note = notes.members[0];
			daNote.active = false;
			daNote.visible = false;

			daNote.kill();
			notes.remove(daNote, true);
			daNote.destroy();
		}
		unspawnNotes = [];
		eventNotes = [];
	}

	public var ratingIndexArray:Array<String> = ["sick", "good", "bad", "shit"];
	public var returnArray:Array<String> = ["SFC", "GFC", "FC", "FC"];
	public var ratingIndexArray2:Array<String> = ["sick", "good", "bad", "shit"];
	public var returnArray2:Array<String> = ["AAAA", "AAA", "AA", "A"];
	public var smallestRating:String;

	private function popUpScore(note:Note = null):Void
	{
		if (ClientPrefs.ratingfc)
			returnArray = ["MFC", "SFC", "GFC", "FC"];

		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition + 8); 

		// boyfriend.playAnim('hey');
		vocals.volume = ClientPrefs.vocalsVolume;

		var placement:String = "";

		var coolText:FlxText = new FlxText(0, 0, 0, "", 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 500;
		var score2:Int = 350;

		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 0.75)
			{
				if (cpuControlled || practiceMode || PlayState.SONG.stage.toLowerCase() == 'victory')
				{
					daRating = 'sick';
					sicks += 1;
					if (funnimode){
						songScore = 69420;
						songScore2 = 350;
					}
					spawnNoteSplashOnNote(note);	
					scoreTxt.color = FlxColor.CYAN;		
					vifsWatermark.color = FlxColor.CYAN;	
					MyOwnCodeTypedWithMyOwnHands.ratingUpdate(9,6,0,0);
					if (dad.curCharacter == 'starved'){
						starvedFearBarReduce += 1;
						fearNo -= 0.056;
					}
				}
				else
				{
					daRating = 'shit';
					score -= 500;
					if (dad.curCharacter == 'starved'){
						starvedFearBarReduce = 0;
						fearNo += 0.056;
						songMisses++;
					}
					if (ClientPrefs.antim)
						score2 -= 500;
					else
						score2 = 50;
					shits += 1;
					if (funnimode){
						songScore = 0;
						songScore2 = 0;
					}
					MyOwnCodeTypedWithMyOwnHands.ratingUpdate(-25,-13,0,0);
					if (ClientPrefs.antim)
					{
						//noteMiss(note);
						noteMiss2(note);
						if (ClientPrefs.hploss || curStage == 'starved')
							{
								health -= note.missHealth2 * 2; //For testing purposes
								trace(note.missHealth2);
							}
							else if (curStage != 'starved')
							{
								health -= note.missHealth * 2; //For testing purposes
								trace(note.missHealth);
							}
					}else{
						if (!holdnotehp)
							{
								if (ClientPrefs.hpgain && curStage != 'starved')
								{
										health += note.hitHealth2;
									//trace(note.hitHealth2);
								}
								else
								{
										health += note.hitHealth;
									//trace(note.hitHealth);
								}
							}
					}
					scoreTxt.color = FlxColor.RED;
					vifsWatermark.color = FlxColor.RED;
				}
			}
			else if (noteDiff > Conductor.safeZoneOffset * 0.5)
			{
				if (cpuControlled || practiceMode || PlayState.SONG.stage.toLowerCase() == 'victory')
				{
					daRating = 'sick';
					sicks += 1;
					if (funnimode){
						songScore = 69420;
						songScore2 = 350;
					}
					spawnNoteSplashOnNote(note);	
					scoreTxt.color = FlxColor.CYAN;	
					vifsWatermark.color = FlxColor.CYAN;
					MyOwnCodeTypedWithMyOwnHands.ratingUpdate(9,6,0,0);
					if (dad.curCharacter == 'starved'){
						starvedFearBarReduce += 1;
						fearNo -= 0.056;
					}
				}
				else
				{
					daRating = 'bad';
					score -= 250;
					score2 = 100;
					if (dad.curCharacter == 'starved'){
						starvedFearBarReduce -= 2;
						fearNo -= 0.020;
						songMisses++;
					}
					bads += 1;
					if (funnimode){
						songScore = 69;
						songScore2 = 350;
					}
					scoreTxt.color = FlxColor.ORANGE;
					vifsWatermark.color = FlxColor.ORANGE;
					MyOwnCodeTypedWithMyOwnHands.ratingUpdate(5,2,0,0);
					if (!holdnotehp)
						{
							if (ClientPrefs.hpgain && curStage != 'starved')
							{
									health += note.hitHealth2;
								//trace(note.hitHealth2);
							}
							else
							{
									health += note.hitHealth;
								//trace(note.hitHealth);
							}
						}
				}
			}
			else if (noteDiff > Conductor.safeZoneOffset * 0.25)
			{
				if (cpuControlled || practiceMode || PlayState.SONG.stage.toLowerCase() == 'victory')
				{
					daRating = 'sick';
					sicks += 1;
					if (funnimode){
						songScore = 69420;
						songScore2 = 350;
					}
					spawnNoteSplashOnNote(note);	
					scoreTxt.color = FlxColor.CYAN;		
					vifsWatermark.color = FlxColor.CYAN;
					MyOwnCodeTypedWithMyOwnHands.ratingUpdate(9,6,0,0);
					if (dad.curCharacter == 'starved'){
						starvedFearBarReduce += 1;
						fearNo -= 0.056;
					}
				}
				else
				{
					daRating = 'good';
					score = 250;
					score2 = 200;
					goods += 1;
					if (dad.curCharacter == 'starved'){
						starvedFearBarReduce -= 3;
						fearNo -= 0.034;
					}
					if (funnimode){
						songScore = 420;
						songScore2 = 350;
					}
					scoreTxt.color = FlxColor.LIME;
					vifsWatermark.color = FlxColor.LIME;
					MyOwnCodeTypedWithMyOwnHands.ratingUpdate(8,5,0,0);
					if (!holdnotehp)
						{
							if (ClientPrefs.hpgain && curStage != 'starved')
							{
									health += note.hitHealth2 * 1;
								//trace(note.hitHealth2);
							}
							else
							{
									health += note.hitHealth * 1;
								//trace(note.hitHealth);
							}
						}
				}
			}
	
			if(daRating == 'sick' && !note.noteSplashDisabled)
			{
				sicks += 1;
				if (funnimode){
					songScore = 69420;
					songScore2 = 350;
				}
				spawnNoteSplashOnNote(note);
				scoreTxt.color = FlxColor.CYAN;
				vifsWatermark.color = FlxColor.CYAN;
				MyOwnCodeTypedWithMyOwnHands.ratingUpdate(9,6,0,0);
				if (dad.curCharacter == 'starved'){
					starvedFearBarReduce += 1;
					fearNo -= 0.056;
				}
				if (!holdnotehp)
					{
						if (ClientPrefs.hpgain && curStage != 'starved')
						{
								health += note.hitHealth2 * 2;
							//trace(note.hitHealth2);
						}
						else
						{
								health += note.hitHealth * 2;
							//trace(note.hitHealth);
						}
					}
			}
		if (songMisses <= 0)
			{
				if (ratingIndexArray.indexOf(daRating) > ratingIndexArray.indexOf(smallestRating))
					smallestRating = daRating;
				ratingAcc = returnArray[ratingIndexArray.indexOf(smallestRating)];
			}
		{
			if (ratingIndexArray2.indexOf(daRating) > ratingIndexArray2.indexOf(smallestRating))
				smallestRating = daRating;
			ratingAcc2 = returnArray2[ratingIndexArray2.indexOf(smallestRating)];
		}
		//if(!practiceMode && !cpuControlled) {
			if (!funnimode)
			{
				if (songScore < 999999999 && songScore != 999999999){
					songScore += score;
					songScore2 += score2;
				}
			}
			songHits++;
			RecalculateRating();
			if (ClientPrefs.camZooms2)
				{
					if(scoreTxtTween != null) {
						scoreTxtTween.cancel();
					}
					scoreTxt.scale.x = 1.1;
					scoreTxt.scale.y = 1.1;
					scoreTxtTween = FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.2, {
						onComplete: function(twn:FlxTween) {
							scoreTxtTween = null;
						}
					});
				}
		//}

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (daRating != 'sick'){
			pixelShitPart1 = 'Nums/';
		}

		if (PlayState.isPixelStage)
		{
			pixelShitPart1 = 'pixelUI/';
			if (daRating != 'sick'){
				pixelShitPart1 = 'pixelUI/Nums/';
			}
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);
		rating.visible = !ClientPrefs.hideHud;

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;
		comboSpr.visible = !ClientPrefs.hideHud;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		if (!ClientPrefs.hideHud) add(rating);
		if (combo >= 5)
		{
			if (!ClientPrefs.hideHud) add(comboSpr);
		}
		if (!PlayState.isPixelStage)
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = ClientPrefs.globalAntialiasing;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = ClientPrefs.globalAntialiasing;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		if(combo >= 1000) {
			seperatedScore.push(Math.floor(combo / 1000) % 10);
		}
		seperatedScore.push(Math.floor(combo / 100) % 10);
		seperatedScore.push(Math.floor(combo / 10) % 10);
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			if (!PlayState.isPixelStage)
			{
				numScore.antialiasing = ClientPrefs.globalAntialiasing;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);
			numScore.visible = !ClientPrefs.hideHud;

			if (combo >= 10 || combo == 0)
				add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});
	}

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.NOTE_UP;
		var right = controls.NOTE_RIGHT;
		var down = controls.NOTE_DOWN;
		var left = controls.NOTE_LEFT;

		var upP = controls.NOTE_UP_P;
		var rightP = controls.NOTE_RIGHT_P;
		var downP = controls.NOTE_DOWN_P;
		var leftP = controls.NOTE_LEFT_P;

		var upR = controls.NOTE_UP_R;
		var rightR = controls.NOTE_RIGHT_R;
		var downR = controls.NOTE_DOWN_R;
		var leftR = controls.NOTE_LEFT_R;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];
		var controlReleaseArray:Array<Bool> = [leftR, downR, upR, rightR];
		var controlHoldArray:Array<Bool> = [left, down, up, right];

		// FlxG.watch.addQuick('asdfa', upP);
		if (!boyfriend.stunned && generatedMusic)
		{
			// rewritten inputs???
			notes.forEachAlive(function(daNote:Note)
			{
				// hold note functions
				if (daNote.isSustainNote && controlHoldArray[daNote.noteData] && daNote.canBeHit 
				&& daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit) {
					goodNoteHit(daNote);
				}
			});

			if ((controlHoldArray.contains(true) || controlArray.contains(true)) && !endingSong) {
				var canMiss:Bool = !ClientPrefs.ghostTapping;
				if (controlArray.contains(true)) {
					for (i in 0...controlArray.length) {
						// heavily based on my own code LOL if it aint broke dont fix it
						var pressNotes:Array<Note> = [];
						var notesDatas:Array<Int> = [];
						var notesStopped:Bool = false;

						var sortedNotesList:Array<Note> = [];
						notes.forEachAlive(function(daNote:Note)
						{
							if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate 
							&& !daNote.wasGoodHit && daNote.noteData == i) {
								sortedNotesList.push(daNote);
								notesDatas.push(daNote.noteData);
								canMiss = true;
							}
						});
						sortedNotesList.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

						if (sortedNotesList.length > 0) {
							for (epicNote in sortedNotesList)
							{
								for (doubleNote in pressNotes) {
									if (Math.abs(doubleNote.strumTime - epicNote.strumTime) < 10) {
										doubleNote.kill();
										notes.remove(doubleNote, true);
										doubleNote.destroy();
									} else
										notesStopped = true;
								}
									
								// eee jack detection before was not super good
								if (controlArray[epicNote.noteData] && !notesStopped) {
									goodNoteHit(epicNote);
									pressNotes.push(epicNote);
								}

							}
						}
						else if (canMiss) 
							ghostMiss(controlArray[i], i, true);

						// I dunno what you need this for but here you go
						//									- Shubs

						// Shubs, this is for the "Just the Two of Us" achievement lol
						//									- Shadow Mario
						if (!keysPressed[i] && controlArray[i]) 
							keysPressed[i] = true;
					}
				}

				#if ACHIEVEMENTS_ALLOWED
				var achieve:Int = checkForAchievement([11]);
				if (achieve > -1) {
					startAchievement(achieve);
				}
				#end
			} else if (boyfriend.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing')
			&& !boyfriend.animation.curAnim.name.endsWith('miss'))
				boyfriend.dance();
		}

		playerStrums.forEach(function(spr:StrumNote)
		{
			if(controlArray[spr.ID] && spr.animation.curAnim.name != 'confirm' && spr.animation.curAnim.name != 'confirm2') {
				spr.playAnim('pressed');
				spr.resetAnim = 0;
			}
			if(controlReleaseArray[spr.ID]) {
				spr.playAnim('static');
				spr.resetAnim = 0;
			}
		});
	}

	function ghostMiss(statement:Bool = false, direction:Int = 0, ?ghostMiss:Bool = false) {
		if (statement) {
			if (ClientPrefs.ghostTapping && ClientPrefs.antim)
			{
				noteMissPress2(direction, ghostMiss);
				callOnLuas('noteMissPress', [direction]);				
			}
			else if (!ClientPrefs.ghostTapping)
			{
				noteMissPress(direction, ghostMiss);
				callOnLuas('noteMissPress', [direction]);
			}
		}
	}

	function noteMiss(daNote:Note):Void { //You didn't hit the key and let it go offscreen, also used by Hurt Notes
		if (PlayState.SONG.stage.toLowerCase() != 'victory'){
			//Dupe note remove
		notes.forEachAlive(function(note:Note) {
			if (daNote != note && daNote.mustPress && daNote.noteData == note.noteData && daNote.isSustainNote == note.isSustainNote && Math.abs(daNote.strumTime - note.strumTime) < 10) {
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		});

		if (combo > 5)
			FunctionHandler.combobreak();

		combo = 0;
		if (ClientPrefs.hploss || curStage == 'starved')
		{
			health -= daNote.missHealth2; //For testing purposes
			trace(daNote.missHealth2);
		}
		else if (curStage != 'starved')
		{
			health -= daNote.missHealth; //For testing purposes
			trace(daNote.missHealth);
		}
		songMisses++;

		if (dad.curCharacter == 'starved' && songMisses > 20){
			health = 0;
			fearNo = 999999;
		}

		if (dad.curCharacter == 'starved'){
			starvedFearBarReduce = 0;
			fearNo += 0.056;
		}

		MyOwnCodeTypedWithMyOwnHands.ratingUpdate(-25,-13,0,0);

		scoreTxt.color = FlxColor.fromRGB(82,35,47);
		vifsWatermark.color = FlxColor.fromRGB(82,35,47);

		if (ClientPrefs.misss)
			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));

		if (dad.animation.curAnim.name.startsWith('sing') || gf.animation.curAnim.name.startsWith('sing') || mom.animation.curAnim.name.startsWith('sing'))
			vocals.volume = ClientPrefs.vocalsVolume;
		else if (dad.animation.curAnim.name.startsWith('hey') || gf.animation.curAnim.name.startsWith('hey'))
			vocals.volume = ClientPrefs.vocalsVolume;
		else
			vocals.volume = 0;

		RecalculateRating();

		if (funnimode)
			songScore = 0;
		else if (songScore > 0 || songScore2 > 0){
			songScore -= 500;
		}

		var animToPlay:String = '';
		if (boyfriend.animation.getByName("singLEFTmiss") != null && boyfriend.animation.getByName("singUPmiss") != null && boyfriend.animation.getByName("singDOWNmiss") != null && boyfriend.animation.getByName("singRIGHTmiss") != null)
		{
			switch (Math.abs(daNote.noteData) % 4)
			{
				case 0:
					animToPlay = 'singLEFTmiss';
				case 1:
					animToPlay = 'singDOWNmiss';
				case 2:
					animToPlay = 'singUPmiss';
				case 3:
					animToPlay = 'singRIGHTmiss';
			}
		}
		else
		{
			boyfriend.color = 0xFF000084;
			if (noMissBf.contains(SONG.player1)){
				switch (Math.abs(daNote.noteData) % 4)
				{
					case 0:
						animToPlay = 'singLEFT';
					case 1:
						animToPlay = 'singDOWN';
					case 2:
						animToPlay = 'singUP';
					case 3:
						animToPlay = 'singRIGHT';
				}
			}else{
				switch (Math.abs(daNote.noteData) % 4)
				{
					case 0:
						animToPlay = 'singRIGHT';
					case 1:
						animToPlay = 'singDOWN';
					case 2:
						animToPlay = 'singUP';
					case 3:
						animToPlay = 'singLEFT';
				}
			}
		}

		if(daNote.noteType == 'GF Sing') {
			gf.playAnim(animToPlay, true);
		} else {
			var daAlt = '';
			if(daNote.noteType == 'Alt Animation') daAlt = '-alt';

			boyfriend.playAnim(animToPlay + daAlt, true);
		}
		callOnLuas('noteMiss', [notes.members.indexOf(daNote), daNote.noteData, daNote.noteType, daNote.isSustainNote]);
		}
	}

	function noteMissPress(direction:Int = 1, ?ghostMiss:Bool = false):Void //You pressed a key when there was no notes to press for this key
	{
		if (PlayState.SONG.stage.toLowerCase() != 'victory'){
			if (!boyfriend.stunned)
				{
					if (health > 0.05)
					{
						health -= 0.04;
						if (boyfriend.animation.getByName("singLEFTmiss") != null && boyfriend.animation.getByName("singUPmiss") != null && boyfriend.animation.getByName("singDOWNmiss") != null && boyfriend.animation.getByName("singRIGHTmiss") != null)
						{
							switch (direction)
							{
								case 0:
									boyfriend.playAnim('singLEFTmiss', true);
								case 1:
									boyfriend.playAnim('singDOWNmiss', true);
								case 2:
									boyfriend.playAnim('singUPmiss', true);
								case 3:
									boyfriend.playAnim('singRIGHTmiss', true);
							}
						}
						else
						{
							boyfriend.color = 0xFF000084;
							if (noMissBf.contains(SONG.player1)){
								switch (direction)
								{
									case 0:
										boyfriend.playAnim('singLEFT', true);
									case 1:
										boyfriend.playAnim('singDOWN', true);
									case 2:
										boyfriend.playAnim('singUP', true);
									case 3:
										boyfriend.playAnim('singRIGHT', true);
								}
							}else{
								switch (direction)
								{
									case 0:
										boyfriend.playAnim('singRIGHT', true);
									case 1:
										boyfriend.playAnim('singDOWN', true);
									case 2:
										boyfriend.playAnim('singUP', true);
									case 3:
										boyfriend.playAnim('singLEFT', true);
								}
							}
						}
					}
				}
		}
	}

	function noteMiss2(daNote:Note):Void //You pressed a key when there was no notes to press for this key
		{
			if (PlayState.SONG.stage.toLowerCase() != 'victory'){
				if (!boyfriend.stunned)
					{
						var animToPlay:String = '';
						if (boyfriend.animation.getByName("singLEFTmiss") != null && boyfriend.animation.getByName("singUPmiss") != null && boyfriend.animation.getByName("singDOWNmiss") != null && boyfriend.animation.getByName("singRIGHTmiss") != null)
							{
								switch (Math.abs(daNote.noteData) % 4)
								{
									case 0:
										animToPlay = 'singLEFTmiss';
									case 1:
										animToPlay = 'singDOWNmiss';
									case 2:
										animToPlay = 'singUPmiss';
									case 3:
										animToPlay = 'singRIGHTmiss';
								}
							}
							else
							{
								boyfriend.color = 0xFF000084;
								if (noMissBf.contains(SONG.player1)){
									switch (Math.abs(daNote.noteData) % 4)
									{
										case 0:
											animToPlay = 'singLEFT';
										case 1:
											animToPlay = 'singDOWN';
										case 2:
											animToPlay = 'singUP';
										case 3:
											animToPlay = 'singRIGHT';
									}
								}else{
									switch (Math.abs(daNote.noteData) % 4)
									{
										case 0:
											animToPlay = 'singRIGHT';
										case 1:
											animToPlay = 'singDOWN';
										case 2:
											animToPlay = 'singUP';
										case 3:
											animToPlay = 'singLEFT';
									}
								}
							}
					}
			}
		}

	function noteMissPress2(direction:Int = 1, ?ghostMiss:Bool = false):Void //used for antimash
		{
			if (PlayState.SONG.stage.toLowerCase() != 'victory'){
				var missHealth:Float = 0.023;
				var missHealth2:Float = 0.0475;
				if (!boyfriend.stunned)
				{
					{
						if (ClientPrefs.hploss || curStage == 'starved')
							health -= missHealth2;
						else if (curStage != 'starved')
							health -= missHealth;
	
						if (ClientPrefs.hploss || curStage == 'starved')
							trace(missHealth2);
						else if (curStage != 'starved')
							trace(missHealth);
	
						earlys += 1;
	
						/*songMisses += 1;
						combo = 0;
						songScore -= 100;
						
						RecalculateRating();
	
						if (dad.animation.curAnim.name.startsWith('sing'))
							vocals.volume = ClientPrefs.vocalsVolume;
						else if (gf.animation.curAnim.name.startsWith('sing'))
							vocals.volume = ClientPrefs.vocalsVolume;
						else
							vocals.volume = 0;*/
						
						if (boyfriend.animation.getByName("singLEFTmiss") != null && boyfriend.animation.getByName("singUPmiss") != null && boyfriend.animation.getByName("singDOWNmiss") != null && boyfriend.animation.getByName("singRIGHTmiss") != null)
						{
							switch (direction)
							{
								case 0:
									boyfriend.playAnim('singLEFTmiss', true);
								case 1:
									boyfriend.playAnim('singDOWNmiss', true);
								case 2:
									boyfriend.playAnim('singUPmiss', true);
								case 3:
									boyfriend.playAnim('singRIGHTmiss', true);
							}
						}
						else
						{
							boyfriend.color = 0xFF000084;
							if (noMissBf.contains(SONG.player1)){
								switch (direction)
								{
									case 0:
										boyfriend.playAnim('singLEFT', true);
									case 1:
										boyfriend.playAnim('singDOWN', true);
									case 2:
										boyfriend.playAnim('singUP', true);
									case 3:
										boyfriend.playAnim('singRIGHT', true);
								}
							}else{
								switch (direction)
								{
									case 0:
										boyfriend.playAnim('singRIGHT', true);
									case 1:
										boyfriend.playAnim('singDOWN', true);
									case 2:
										boyfriend.playAnim('singUP', true);
									case 3:
										boyfriend.playAnim('singLEFT', true);
								}
							}
						}
					}
				}
			}
		}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if(cpuControlled && (note.ignoreNote || note.hitCausesMiss)) return;

			if(note.hitCausesMiss) {
				noteMiss(note);
				if(!note.noteSplashDisabled && !note.isSustainNote) {
					spawnNoteSplashOnNote(note);
				}

				switch(note.noteType) {
					case 'Hurt Note': //Hurt note
						if(boyfriend.animation.getByName('hurt') != null) {
							boyfriend.playAnim('hurt', true);
							boyfriend.specialAnim = true;
						}
				}
				
				note.wasGoodHit = true;
				if (!note.isSustainNote)
				{
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}
				return;
			}
				
			if (!note.isSustainNote)
					notesHitArray.unshift(Date.now());

			if (!note.isSustainNote)
			{			
				if (ClientPrefs.hitss)
				{
					FlxG.sound.play(Paths.sound('note_click'));
				}
				popUpScore(note);
				combo += 1;
				hits2 += 1;
				if(combo>highestCombo)
					highestCombo=combo;
			}

			if (holdnotehp)
			{
				if (ClientPrefs.hpgain)
				{
					health += note.hitHealth2;
					//trace(note.hitHealth2);
				}
				else
				{
					health += note.hitHealth;
					//trace(note.hitHealth);
				}
			}
			
			if (dad.curCharacter == 'starved' && note.isSustainNote){
				fearNo -= 0.020;
			}

			if (boyfriend.color == 0xFF000084)
				boyfriend.color = FlxColor.WHITE;

			if(!note.noAnimation) {
				var daAlt = '';
				if(note.noteType == 'Alt Animation') daAlt = '-alt';
	
				var animToPlay:String = '';
				if (boyfriend.animation.getByName("singLEFTmiss") != null && boyfriend.animation.getByName("singUPmiss") != null && boyfriend.animation.getByName("singDOWNmiss") != null && boyfriend.animation.getByName("singRIGHTmiss") != null){
					switch (Std.int(Math.abs(note.noteData)))
					{
						case 0:
							animToPlay = 'singLEFT';
						case 1:
							animToPlay = 'singDOWN';
						case 2:
							animToPlay = 'singUP';
						case 3:
							animToPlay = 'singRIGHT';
					}
				}else{
					if (noMissBf.contains(SONG.player1)){
						switch (Std.int(Math.abs(note.noteData)))
						{
							case 0:
								animToPlay = 'singLEFT';
							case 1:
								animToPlay = 'singDOWN';
							case 2:
								animToPlay = 'singUP';
							case 3:
								animToPlay = 'singRIGHT';
						}
					}else{
						switch (Std.int(Math.abs(note.noteData)))
						{
							case 0:
								animToPlay = 'singRIGHT';
							case 1:
								animToPlay = 'singDOWN';
							case 2:
								animToPlay = 'singUP';
							case 3:
								animToPlay = 'singLEFT';
						}
					}
				}

				if(note.noteType == 'GF Sing') {
					gf.playAnim(animToPlay + daAlt, true);
					gf.holdTimer = 0;
				} else {
					boyfriend.playAnim(animToPlay + daAlt, true);
					boyfriend.holdTimer = 0;
				}

				if(note.noteType == 'Hey!') {
					if(boyfriend.animOffsets.exists('hey')) {
						boyfriend.playAnim('hey', true);
						boyfriend.specialAnim = true;
						boyfriend.heyTimer = 0.6;
					}
	
					if(gf.animOffsets.exists('cheer')) {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = 0.6;
					}
				}
			}

			if(cpuControlled && ClientPrefs.botca) {
				var time:Float = 0.10;
				if (ClientPrefs.fastBotcaFrames){
					time = 0.05;
				}
				if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
					time += 0.15;
					if (ClientPrefs.fastBotcaFrames){
						time = 0.05;
					}
				}
				if (curStage != 'alpha'){
					if (note.isSustainNote){
						StrumPlayAnim2(false, Std.int(Math.abs(note.noteData)) % 4, time);
					}else{
						StrumPlayAnim(false, Std.int(Math.abs(note.noteData)) % 4, time);
					}
				}
			} else {
				if(!cpuControlled)
				{
					var time:Float = 0.10;
					if (ClientPrefs.fastBotcaFrames23){
						time = 0.05;
					}
					if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
						time += 0.15;
						if (ClientPrefs.fastBotcaFrames23){
							time = 0.05;
						}
					}
					{
						if (note.isSustainNote){
							StrumPlayAnim2(false, Std.int(Math.abs(note.noteData)) % 4, time);
						}else{
							StrumPlayAnim(false, Std.int(Math.abs(note.noteData)) % 4, time);
						}
					}
				}
			}
			note.wasGoodHit = true;
			vocals.volume = ClientPrefs.vocalsVolume;

			var isSus:Bool = note.isSustainNote; //GET OUT OF MY HEAD, GET OUT OF MY HEAD, GET OUT OF MY HEAD
			var leData:Int = Math.round(Math.abs(note.noteData));
			var leType:String = note.noteType;
			callOnLuas('goodNoteHit', [notes.members.indexOf(note), leData, leType, isSus]);

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	
	function goodVotingNoteHit(note:Note):Void
		{
			if (cpuControlled && (note.ignoreNote || note.hitCausesMiss))
				return;
	
			trace('function gvnh called');
			if (!note.ignoreNote)
			{
				if (!note.noAnimation)
				{
					var animToPlay:String = '';
					switch (Math.abs(note.noteData))
					{
						case 0:
							animToPlay = 'singLEFT';
						case 1:
							animToPlay = 'singDOWN';
						case 2:
							animToPlay = 'singUP';
						case 3:
							animToPlay = 'singRIGHT';
					}
					if (note.mustPress)
					{
						mom.holdTimer = 0;						
						mom.playAnim(animToPlay, true);
					}
				}
			}
	
			note.wasGoodHit = true;
			vocals.volume = 1;
				
			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}

	function spawnNoteSplashOnNote(note:Note) {
		if(ClientPrefs.noteSplashes && note != null) {
			var strum:StrumNote = playerStrums.members[note.noteData];
			if(strum != null) {
				spawnNoteSplash(strum.x, strum.y, note.noteData, note);
			}
		}
	}

	function spawnNoteSplashOnNote2(note:Note) {
		if(ClientPrefs.noteSplashes2 && note != null) {
			var strum:StrumNote = opponentStrums.members[note.noteData];
			if(strum != null) {
				spawnNoteSplash(strum.x, strum.y, note.noteData, note);
			}
		}
	}

	public function spawnNoteSplash(x:Float, y:Float, data:Int, ?note:Note = null) {
		var skin:String = 'noteSplashes';
		if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) skin = PlayState.SONG.splashSkin;
		
		var hue:Float = ClientPrefs.arrowHSV[data % 4][0] / 360;
		var sat:Float = ClientPrefs.arrowHSV[data % 4][1] / 100;
		var brt:Float = ClientPrefs.arrowHSV[data % 4][2] / 100;
		if(note != null) {
			skin = note.noteSplashTexture;
			hue = note.noteSplashHue;
			sat = note.noteSplashSat;
			brt = note.noteSplashBrt;
		}

		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		splash.setupNoteSplash(x, y, data, skin, hue, sat, brt);
		grpNoteSplashes.add(splash);
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	var carTimer:FlxTimer;
	function fastCarDrive()
	{
		//trace('Car drive');
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		carTimer = new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
			carTimer = null;
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
			gf.specialAnim = true;
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.danced = false; //Sets head to the correct position once the animation ends
		gf.playAnim('hairFall');
		gf.specialAnim = true;
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		if(!ClientPrefs.lowQuality) halloweenBG.animation.play('halloweem bg lightning strike');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		if(boyfriend.animOffsets.exists('scared')) {
			boyfriend.playAnim('scared', true);
		}
		if(gf.animOffsets.exists('scared')) {
			gf.playAnim('scared', true);
		}

		if(ClientPrefs.camZooms) {
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;

			if(!camZooming) { //Just a way for preventing it to be permanently zoomed until Skid & Pump hits a note
				FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.5);
				FlxTween.tween(camHUD, {zoom: 1}, 0.5);
			}
		}

		if(ClientPrefs.flashing) {
			halloweenWhite.alpha = 0.4;
			FlxTween.tween(halloweenWhite, {alpha: 0.5}, 0.075);
			FlxTween.tween(halloweenWhite, {alpha: 0}, 0.25, {startDelay: 0.15});
		}
	}

	function killHenchmen():Void
	{
		if(!ClientPrefs.lowQuality && ClientPrefs.violence && curStage == 'limo') {
			if(limoKillingState < 1) {
				limoMetalPole.x = -400;
				limoMetalPole.visible = true;
				limoLight.visible = true;
				limoCorpse.visible = false;
				limoCorpseTwo.visible = false;
				limoKillingState = 1;

				#if ACHIEVEMENTS_ALLOWED
				Achievements.henchmenDeath++;
				var achieve:Int = checkForAchievement([10]);
				if(achieve > -1) {
					startAchievement(achieve);
				} else {
					FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;
					FlxG.save.flush();
				}
				FlxG.log.add('Deaths: ' + Achievements.henchmenDeath);
				#end
			}
		}
	}

	function resetLimoKill():Void
	{
		if(curStage == 'limo') {
			limoMetalPole.x = -500;
			limoMetalPole.visible = false;
			limoLight.x = -500;
			limoLight.visible = false;
			limoCorpse.x = -500;
			limoCorpse.visible = false;
			limoCorpseTwo.x = -500;
			limoCorpseTwo.visible = false;
		}
	}

	var tankX:Float = 400;
	var tankSpeed:Float = FlxG.random.float(5, 7);
	var tankAngle:Float = FlxG.random.int(-90, 45);

	function moveTank(?elapsed:Float = 0):Void
	{
		if(!inCutscene)
		{
			tankAngle += elapsed * tankSpeed;
			tankGround.angle = tankAngle - 90 + 15;
			tankGround.x = tankX + 1500 * Math.cos(Math.PI / 180 * (1 * tankAngle + 180));
			tankGround.y = 1300 + 1100 * Math.sin(Math.PI / 180 * (1 * tankAngle + 180));
		}
	}

	private var preventLuaRemove:Bool = false;
	override function destroy() {
		preventLuaRemove = true;
		for (i in 0...luaArray.length) {
			luaArray[i].call('onDestroy', []);
			luaArray[i].stop();
		}
		luaArray = [];
		super.destroy();
	}

	public function cancelFadeTween() {
		if(FlxG.sound.music.fadeTween != null) {
			FlxG.sound.music.fadeTween.cancel();
		}
		FlxG.sound.music.fadeTween = null;
	}

	public function removeLua(lua:FunkinLua) {
		if(luaArray != null && !preventLuaRemove) {
			luaArray.remove(lua);
		}
	}

	var lastStepHit:Int = -1;
	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if(curStep == lastStepHit) {
			return;
		}

		if (SONG.song.toLowerCase() == 'fight or flight')
			{
				switch (curStep)
				{
					case 1:
						timeBar.createFilledBar(FlxColor.RED, 0xFF000000);
						timeBar.updateBar();
					case 1184, 1471:
						starvedLights();
					case 1439, 1728:
						starvedLightsFinale();
				}
			}

		lastStepHit = curStep;
		setOnLuas('curStep', curStep);
		callOnLuas('onStepHit', []);
	}

	public static var missLimited:Bool = false;
	public static var missLimitCount:Int = 5;

	public function missLimitManager()
	{
		if (missLimited)
		{
			healthBar.visible = false;
			healthBarBG.visible = false;
			healthBarOverlay.visible = false;
			health = 1;
			if (songMisses > missLimitCount)
				health = 0;
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	
	function starvedLights()
		{
			//i fucking love that BLAMMED LIGHTS !! !!
			FlxTween.tween(healthBarBG, {alpha: 0}, 1);
			FlxTween.tween(healthBarOverlay, {alpha: 0}, 1);
			FlxTween.tween(healthBar, {alpha: 0}, 1);
			FlxTween.tween(fearUiBg, {alpha: 0}, 1);
			FlxTween.tween(fearUi, {alpha: 0}, 1);
			FlxTween.tween(fearBar, {alpha: 0}, 1);
			FlxTween.tween(iconP1, {alpha: 0}, 1);
			FlxTween.tween(iconP2, {alpha: 0}, 1);
			FlxTween.tween(timeBar, {alpha: 0}, 1);
			FlxTween.tween(timeBarBG, {alpha: 0}, 1);
			FlxTween.tween(timeTxt, {alpha: 0}, 1);
			FlxTween.tween(scoreTxt, {alpha: 0}, 1);
			FlxTween.tween(burgerKingCities, {alpha: 0}, 1);
			FlxTween.tween(mcdonaldTowers, {alpha: 0}, 1);
			FlxTween.tween(pizzaHutStage, {alpha: 0}, 1);
			FlxTween.color(deadHedgehog, 1, FlxColor.WHITE, FlxColor.RED);
			FlxTween.color(boyfriend, 1, FlxColor.WHITE, FlxColor.RED);
		}

	function starvedLightsFinale()
		{
			//i fucking HATE those BLAMMED LIGHTS !! !!
			FlxTween.tween(healthBarBG, {alpha: 1}, 1.5);
			FlxTween.tween(healthBarOverlay, {alpha: 1}, 1.5);
			FlxTween.tween(healthBar, {alpha: 1}, 1.5);
			FlxTween.tween(fearUiBg, {alpha: 1}, 1.5);
			FlxTween.tween(fearUi, {alpha: 1}, 1.5);
			FlxTween.tween(fearBar, {alpha: 1}, 1.5);
			FlxTween.tween(iconP1, {alpha: 1}, 1.5);
			FlxTween.tween(iconP2, {alpha: 1}, 1.5);
			FlxTween.tween(timeBar, {alpha: 1}, 1.5);
			FlxTween.tween(timeBarBG, {alpha: 1}, 1.5);
			FlxTween.tween(timeTxt, {alpha: 1}, 1.5);
			FlxTween.tween(scoreTxt, {alpha: 1}, 1.5);
			FlxTween.tween(burgerKingCities, {alpha: 1}, 1.5);
			FlxTween.tween(mcdonaldTowers, {alpha: 1}, 1.5);
			FlxTween.tween(pizzaHutStage, {alpha: 1}, 1.5);
			FlxTween.color(deadHedgehog, 1, FlxColor.RED, FlxColor.WHITE);
			FlxTween.color(boyfriend, 1, FlxColor.RED, FlxColor.WHITE); //????? will it work lol? (update it totally worked :DDDD)
		}

	var lastBeatHit:Int = -1;
	override function beatHit()
	{
		super.beatHit();

		if(lastBeatHit >= curBeat) {
			trace('BEAT HIT: ' + curBeat + ', LAST HIT: ' + lastBeatHit);
			return;
		}

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, ClientPrefs.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				//FlxG.log.add('CHANGED BPM!');
				setOnLuas('curBpm', Conductor.bpm);
				setOnLuas('crochet', Conductor.crochet);
				setOnLuas('stepCrochet', Conductor.stepCrochet);
			}
			setOnLuas('mustHitSection', SONG.notes[Math.floor(curStep / 16)].mustHitSection);
			// else
			// Conductor.changeBPM(SONG.bpm);
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null && !endingSong && !isCameraOnForcedPos)
		{
			moveCameraSection(Std.int(curStep / 16));
		}
		if (camZooming && FlxG.camera.zoom < 1.35 && ClientPrefs.camZooms && curBeat % 4 == 0 && !cameraLocked)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0 && !gf.stunned && gf.animation.curAnim.name != null && !gf.animation.curAnim.name.startsWith("sing"))
		{
			gf.dance();
		}

		/*if (curBeat % 1 == 0)
		{
			if (boyfriend.curCharacter == 'bf-running')
				bfLegs.dance();
			if (boyfriend.animation.curAnim.name != null
				&& !boyfriend.animation.curAnim.name.startsWith("sing")
				&& boyfriend.curCharacter == 'bf-running')
			{
				boyfriend.dance();
			}
		}
		if (curBeat % 1 == 0)
		{
			if (boyfriend.curCharacter == 'bf-running')
				bfLegsmiss.dance();
		}*/
		if (curBeat % 1 == 0)
		{
			if (dad.curCharacter == 'black-run')
				dadlegs.dance();
		}
		if (curBeat % 1 == 0)
		{
			if (dad.curCharacter == 'blackalt')
				dadlegs.dance();
		}

		if(curBeat % 2 == 0) {
			if (boyfriend.animation.curAnim.name != null && !boyfriend.animation.curAnim.name.startsWith("sing") && boyfriend.curCharacter != 'bf-running')
			{
				boyfriend.dance();
			}
			if (dad.animation.curAnim.name != null && !dad.animation.curAnim.name.startsWith("sing") && !dad.stunned)
			{
				dad.dance();
			}
		} else if(dad.danceIdle && dad.animation.curAnim.name != null && !dad.curCharacter.startsWith('gf') && !dad.animation.curAnim.name.startsWith("sing") && !dad.stunned) {
			dad.dance();
		}

		switch (curStage)
		{
			case 'school':
				if(!ClientPrefs.lowQuality) {
					bgGirls.dance();
				}

			case 'mall':
				if(!ClientPrefs.lowQuality) {
					upperBoppers.dance(true);
				}

				if(heyTimer <= 0) bottomBoppers.dance(true);
				santa.dance(true);

			case 'limo':
				if(!ClientPrefs.lowQuality) {
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
					{
						dancer.dance();
					});
				}

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:BGSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1, [curLight]);

					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
			case 'chef':
				if (curBeat % 2 == 0)
				{
					gray.animation.play('bop');
					saster.animation.play('bop');
				}

				case 'victory':
					if (curBeat % 2 == 0)
					{
						VICTORY_TEXT.animation.play('expand', true);
						bg_war.animation.play('bop', true);
						bg_jor.animation.play('bop', true);
					}
					if (curBeat % 1 == 0)
					{
						bg_vic.animation.play('bop', true);
						vicPulse.animation.play('pulsate', true);
						bg_jelq.animation.play('bop', true);
					}
		}

		if (curStage == 'spooky' && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
		lastBeatHit = curBeat;

		setOnLuas('curBeat', curBeat);
		callOnLuas('onBeatHit', []);
	}

	public function callOnLuas(event:String, args:Array<Dynamic>):Dynamic {
		var returnVal:Dynamic = FunkinLua.Function_Continue;
		#if LUA_ALLOWED
		for (i in 0...luaArray.length) {
			var ret:Dynamic = luaArray[i].call(event, args);
			if(ret != FunkinLua.Function_Continue) {
				returnVal = ret;
			}
		}
		#end
		return returnVal;
	}

	public function setOnLuas(variable:String, arg:Dynamic) {
		#if LUA_ALLOWED
		for (i in 0...luaArray.length) {
			luaArray[i].set(variable, arg);
		}
		#end
	}

	function StrumPlayAnim(isDad:Bool, id:Int, time:Float) {
		var spr:StrumNote = null;
		if(isDad) {
			spr = strumLineNotes.members[id];
		} else {
			spr = playerStrums.members[id];
		}

		if(spr != null) {
			spr.playAnim('confirm', true);
			spr.resetAnim = time;
		}
	}

	function StrumPlayAnim2(isDad:Bool, id:Int, time:Float)
		{
			var spr:StrumNote = null;
			if (isDad)
			{
				spr = strumLineNotes.members[id];
			}
			else
			{
				spr = playerStrums.members[id];
			}
		
			if (spr != null)
			{
				spr.playAnim('confirm2', true);
				spr.resetAnim = time;
			}
		}

	public var ratingString:String;
	public var ratingString2:String;
	public var ratingPercent:Float;
	public var ratingAcc:String;
	public var ratingAcc2:String = "N/A";
	public var ratingAAAA:String;
	public function RecalculateRating() {
		setOnLuas('score', songScore2);
		setOnLuas('misses', songMisses);
		setOnLuas('ghostMisses', songMisses);
		setOnLuas('hits', songHits);

		var ret:Dynamic = callOnLuas('onRecalculateRating', []);
		if(ret != FunkinLua.Function_Stop) {
			ratingPercent = songScore2 / ((songHits + songMisses - ghostMisses) * 350);
			if(!Math.isNaN(ratingPercent) && ratingPercent < 0) ratingPercent = 0;

			if(Math.isNaN(ratingPercent)) {
				ratingString = '?';
			} else if(ratingPercent >= 1) {
				ratingPercent = 1;
				ratingString = ratingStuff[ratingStuff.length-1][0]; //Uses last string
			} else {
				for (i in 0...ratingStuff.length-1) {
					if(ratingPercent < ratingStuff[i][1]) {
						ratingString = ratingStuff[i][0];
						break;
					}
				}
			}

			if(Math.isNaN(ratingPercent)) {
				ratingAAAA = '?';
			} else if(ratingPercent >= 1) {
				ratingPercent = 1;
				ratingAAAA = ratingAA2AA[ratingAA2AA.length-1][0]; //Uses last string
			} else {
				for (i in 0...ratingAA2AA.length-1) {
					if(ratingPercent < ratingAA2AA[i][1]) {
						ratingAAAA = ratingAA2AA[i][0];
						break;
					}
				}
			}
			/*if (ratingPercent >= 1)
			{
				remove(Ratings);
				Ratings = new AttachedSprite('ratings/SPlus');
				Ratings.scrollFactor.set();
				Ratings.y = 560;
				Ratings.x = 1100;
				add(Ratings);
			}
			else if (ratingPercent >= 0.98 && ratingPercent != 1)
			{
				remove(Ratings);
				Ratings = new AttachedSprite('ratings/S');
				Ratings.scrollFactor.set();
				Ratings.y = 560;
				Ratings.x = 1100;
				add(Ratings);
			}
			else if (ratingPercent >= 0.90 && ratingPercent != 0.98 && ratingPercent != 0.99 && ratingPercent != 1)
			{
				remove(Ratings);
				Ratings = new AttachedSprite('ratings/S');
				Ratings.scrollFactor.set();
				Ratings.y = 560;
				Ratings.x = 1100;
				add(Ratings);
			}*/

			setOnLuas('rating', ratingPercent);
			setOnLuas('ratingName', ratingString);
			setOnLuas('ratingAAAA', ratingAAAA);
		}
	}

	#if ACHIEVEMENTS_ALLOWED
	private function checkForAchievement(arrayIDs:Array<Int>):Int {
		for (i in 0...arrayIDs.length) {
			if(!Achievements.achievementsUnlocked[arrayIDs[i]][1]) {
				switch(arrayIDs[i]) {
					case 1 | 2 | 3 | 4 | 5 | 6 | 7:
						if(isStoryMode && campaignMisses + songMisses < 1 && CoolUtil.difficultyString() == 'HARD' &&
						storyPlaylist.length <= 1 && WeekData.getWeekFileName() == ('week' + arrayIDs[i]) && !changedDifficulty && !usedPractice) {
							Achievements.unlockAchievement(arrayIDs[i]);
							return arrayIDs[i];
						}
					case 8:
						if(ratingPercent < 0.2 && !practiceMode && !cpuControlled) {
							Achievements.unlockAchievement(arrayIDs[i]);
							return arrayIDs[i];
						}
					case 9:
						if(ratingPercent >= 1 && !usedPractice && !cpuControlled) {
							Achievements.unlockAchievement(arrayIDs[i]);
							return arrayIDs[i];
						}
					case 10:
						if(Achievements.henchmenDeath >= 100) {
							Achievements.unlockAchievement(arrayIDs[i]);
							return arrayIDs[i];
						}
					case 11:
						if(boyfriend.holdTimer >= 20 && !usedPractice) {
							Achievements.unlockAchievement(arrayIDs[i]);
							return arrayIDs[i];
						}
					case 12:
						if(!boyfriendIdled && !usedPractice) {
							Achievements.unlockAchievement(arrayIDs[i]);
							return arrayIDs[i];
						}
					case 13:
						if(!usedPractice) {
							var howManyPresses:Int = 0;
							for (j in 0...keysPressed.length) {
								if(keysPressed[j]) howManyPresses++;
							}

							if(howManyPresses <= 2) {
								Achievements.unlockAchievement(arrayIDs[i]);
								return arrayIDs[i];
							}
						}
					case 14:
						if(/*ClientPrefs.framerate <= 60 &&*/ ClientPrefs.lowQuality && !ClientPrefs.globalAntialiasing && !ClientPrefs.imagesPersist) {
							Achievements.unlockAchievement(arrayIDs[i]);
							return arrayIDs[i];
						}
					case 15:
						if(Paths.formatToSongPath(SONG.song) == 'test' && !usedPractice) {
							Achievements.unlockAchievement(arrayIDs[i]);
							return arrayIDs[i];
						}
				}
			}
		}
		return -1;
	}
	#end

	var curLight:Int = 0;
	var curLightEvent:Int = 0;
}
