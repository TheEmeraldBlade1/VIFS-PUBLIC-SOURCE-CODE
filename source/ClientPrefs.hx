package;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

class ClientPrefs {
	//TO DO: Redo ClientPrefs in a way that isn't too stupid
	public static var downScroll:Bool = false;
	public static var middleScroll:Bool = false;
	public static var showFPS:Bool = true;
	public static var flashing:Bool = true;
	public static var globalAntialiasing:Bool = true;
	public static var noteSplashes:Bool = true;
	public static var noteSplashes2:Bool = true;
	public static var lowQuality:Bool = false;
	public static var framerate:Int = 60;
	public static var cursing:Bool = true;
	public static var violence:Bool = true;
	public static var camZooms:Bool = true;
	public static var camZooms2:Bool = true;
	public static var hideHud:Bool = false;
	public static var noteOffset:Int = 0;
	public static var arrowHSV:Array<Array<Int>> = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
	public static var imagesPersist:Bool = false;
	public static var fof:Bool = false;
	public static var ghostTapping:Bool = true;
	public static var hideTime:Bool = false;
	public static var hss:Bool = false;
	public static var tst:Bool = false;
	public static var ratingfc:Bool = false;
	public static var ratingfc2:Bool = true;
	public static var full:Bool = false;
	public static var judgementCounter:Bool = false;
	public static var TDN:Bool = false;
	public static var hitss:Bool = false;
	public static var misss:Bool = false;
	public static var nop:Bool = false;
	public static var speed:Float = 2;
	public static var vocalsVolume:Float = 1;
	public static var scoretxttype:Int = 0;
	public static var noteSize:Float = 0.7;
	public static var antim:Bool = true;
	public static var hploss:Bool = true;
	public static var hpgain:Bool = false;
	public static var aFlipY:Bool = false;
	public static var aFlipX:Bool = false;
	public static var botca:Bool = true;
	public static var fastBotcaFrames:Bool = false;
	public static var fastBotcaFrames2:Bool = false;
	public static var fastBotcaFrames23:Bool = false;
	public static var overRidebfDebug:Bool = false;
	public static var overRidegfDebug:Bool = false;
	public static var overRidepetDebug:Bool = false;
	public static var safeFrame:Int = 8;

	public static var watermark:Bool = false;
	public static var hidescoretxt:Bool = false;
	public static var hideiconp1:Bool = false;
	public static var hideiconp2:Bool = false;

	public static var charOverrides:Array<String> = ['', '', ''];
	public static var beans:Int = 0;
	public static var boughtArray:Array<Bool> = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

	// SONG MODS
	public static var loopsong:Bool = false;

	public static var defaultKeys:Array<FlxKey> = [
		A, LEFT,			//Note Left
		S, DOWN,			//Note Down
		W, UP,				//Note Up
		D, RIGHT,			//Note Right

		A, LEFT,			//UI Left
		S, DOWN,			//UI Down
		W, UP,				//UI Up
		D, RIGHT,			//UI Right

		R, NONE,			//Reset
		SPACE, ENTER,		//Accept
		BACKSPACE, ESCAPE,	//Back
		ENTER, ESCAPE		//Pause
	];
	//Every key has two binds, these binds are defined on defaultKeys! If you want your control to be changeable, you have to add it on ControlsSubState (inside OptionsState)'s list
	public static var keyBinds:Array<Dynamic> = [
		//Key Bind, Name for ControlsSubState
		[Control.NOTE_LEFT, 'Left'],
		[Control.NOTE_DOWN, 'Down'],
		[Control.NOTE_UP, 'Up'],
		[Control.NOTE_RIGHT, 'Right'],

		[Control.UI_LEFT, 'Left '],		//Added a space for not conflicting on ControlsSubState
		[Control.UI_DOWN, 'Down '],		//Added a space for not conflicting on ControlsSubState
		[Control.UI_UP, 'Up '],			//Added a space for not conflicting on ControlsSubState
		[Control.UI_RIGHT, 'Right '],	//Added a space for not conflicting on ControlsSubState

		[Control.RESET, 'Reset'],
		[Control.ACCEPT, 'Accept'],
		[Control.BACK, 'Back'],
		[Control.PAUSE, 'Pause']
	];
	public static var lastControls:Array<FlxKey> = defaultKeys.copy();

	public static function saveSettings() {
		FlxG.save.data.watermark = watermark;
		FlxG.save.data.hidescoretxt = hidescoretxt;
		FlxG.save.data.hideiconp1 = hideiconp1;
		FlxG.save.data.hideiconp2 = hideiconp2;

		FlxG.save.data.overRidebfDebug = overRidebfDebug;
		FlxG.save.data.overRidegfDebug = overRidegfDebug;
		FlxG.save.data.overRidepetDebug = overRidepetDebug;
		FlxG.save.data.fastBotcaFrames = fastBotcaFrames;
		FlxG.save.data.fastBotcaFrames2 = fastBotcaFrames2;
		FlxG.save.data.fastBotcaFrames23 = fastBotcaFrames23;
		FlxG.save.data.charOverrides = charOverrides;
		FlxG.save.data.boughtArray = boughtArray;
		FlxG.save.data.beans = beans;
		FlxG.save.data.speed = speed;
		FlxG.save.data.downScroll = downScroll;
		FlxG.save.data.middleScroll = middleScroll;
		FlxG.save.data.showFPS = showFPS;
		FlxG.save.data.flashing = flashing;
		FlxG.save.data.globalAntialiasing = globalAntialiasing;
		FlxG.save.data.noteSplashes = noteSplashes;
		FlxG.save.data.noteSplashes2 = noteSplashes2;
		FlxG.save.data.lowQuality = lowQuality;
		FlxG.save.data.framerate = framerate;
		FlxG.save.data.cursing = cursing;
		FlxG.save.data.violence = violence;
		FlxG.save.data.camZooms = camZooms;
		FlxG.save.data.camZooms2 = camZooms2;
		FlxG.save.data.noteOffset = noteOffset;
		FlxG.save.data.hideHud = hideHud;
		FlxG.save.data.arrowHSV = arrowHSV;
		FlxG.save.data.imagesPersist = imagesPersist;
		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.hideTime = hideTime;
		FlxG.save.data.noteSize = noteSize;
		FlxG.save.data.full = full;
		FlxG.save.data.hss = hss;
		FlxG.save.data.fof = fof;
		FlxG.save.data.tst = tst;
		FlxG.save.data.fc = ratingfc;
		FlxG.save.data.fc2 = ratingfc2;
		FlxG.save.data.bot = PlayState.cpuControlled;
		FlxG.save.data.ppm = PlayState.practiceMode;
		FlxG.save.data.judgementCounter =judgementCounter;
		FlxG.save.data.TDN =TDN;
		FlxG.save.data.hitss =hitss;
		FlxG.save.data.misss =misss;
		FlxG.save.data.nop =nop;
		FlxG.save.data.vocals =vocalsVolume;
		FlxG.save.data.antim = antim;
		FlxG.save.data.hploss = hploss;
		FlxG.save.data.hpgain = hpgain;
		FlxG.save.data.aFlipY = aFlipY;
		FlxG.save.data.aFlipX = aFlipX;
		FlxG.save.data.botca = botca;
		FlxG.save.data.scoretxttype = scoretxttype;
		FlxG.save.data.safeFrames = Conductor.safeFrames;
		FlxG.save.data.safeFrame = safeFrame;
		FlxG.save.data.HHHHH = FlxG.fullscreen;

		// SONG MODS
		FlxG.save.data.loopsong = loopsong;

		var achieves:Array<String> = [];
		for (i in 0...Achievements.achievementsUnlocked.length) {
			if(Achievements.achievementsUnlocked[i][1]) {
				achieves.push(Achievements.achievementsUnlocked[i][0]);
			}
		}
		FlxG.save.data.achievementsUnlocked = achieves;
		FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;
		FlxG.save.flush();

		var save:FlxSave = new FlxSave();
		save.bind('controls', 'ninjamuffin99'); //Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		save.data.customControls = lastControls;
		save.flush();
		FlxG.log.add("Settings saved!");
	}
	//FlxG.save.data.watermark = watermark;
	//FlxG.save.data.hidescoretxt = hidescoretxt;
	//FlxG.save.data.hideiconp1 = hideiconp1;
	//FlxG.save.data.hideiconp2 = hideiconp2;
	public static function loadPrefs() {
		if(FlxG.save.data.watermark != null) {
			watermark = FlxG.save.data.watermark;
		}
		if(FlxG.save.data.hidescoretxt != null) {
			hidescoretxt = FlxG.save.data.hidescoretxt;
		}
		if(FlxG.save.data.hideiconp1 != null) {
			hideiconp1 = FlxG.save.data.hideiconp1;
		}
		if(FlxG.save.data.hideiconp2 != null) {
			hideiconp2 = FlxG.save.data.hideiconp2;
		}
		
		if(FlxG.save.data.overRidebfDebug != null) {
			overRidebfDebug = FlxG.save.data.overRidebfDebug;
		}
		if(FlxG.save.data.overRidegfDebug != null) {
			overRidegfDebug = FlxG.save.data.overRidegfDebug;
		}
		if(FlxG.save.data.overRidepetDebug != null) {
			overRidepetDebug = FlxG.save.data.overRidepetDebug;
		}
		if(FlxG.save.data.fastBotcaFrames != null) {
			fastBotcaFrames = FlxG.save.data.fastBotcaFrames;
		}
		if(FlxG.save.data.fastBotcaFrames2 != null) {
			fastBotcaFrames2 = FlxG.save.data.fastBotcaFrames2;
		}
		if(FlxG.save.data.fastBotcaFrames23 != null) {
			fastBotcaFrames23 = FlxG.save.data.fastBotcaFrames23;
		}
		if(FlxG.save.data.charOverrides != null) {
			charOverrides = FlxG.save.data.charOverrides;
		}
		if(FlxG.save.data.boughtArray != null){
			boughtArray = FlxG.save.data.boughtArray;
		}
		if(FlxG.save.data.beans != null){
			beans = FlxG.save.data.beans;
		}
		if(FlxG.save.data.HHHHH != null) {
			FlxG.fullscreen = FlxG.save.data.HHHHH;
		}
		if(FlxG.save.data.downScroll != null) {
			downScroll = FlxG.save.data.downScroll;
		}
		if(FlxG.save.data.middleScroll != null) {
			middleScroll = FlxG.save.data.middleScroll;
		}
		if(FlxG.save.data.hss != null) {
			hss = FlxG.save.data.hss;
		}
		if(FlxG.save.data.safeFrame != null) {
			safeFrame = FlxG.save.data.safeFrame;
		}
		if(FlxG.save.data.scoretxttype != null) {
			scoretxttype = FlxG.save.data.scoretxttype;
		}
		if(FlxG.save.data.fc != null) {
			ratingfc = FlxG.save.data.fc;
		}
		if(FlxG.save.data.fc2 != null) {
			ratingfc2 = FlxG.save.data.fc2;
		}
		if(FlxG.save.data.speed != null) {
			speed = FlxG.save.data.speed;
		}
		if(FlxG.save.data.botca != null) {
			botca = FlxG.save.data.botca;
		}
		if(FlxG.save.data.safeFrames != null) {
			Conductor.safeFrames = FlxG.save.data.safeFrames;
		}
		if(FlxG.save.data.full != null) {
			full = FlxG.save.data.full;
		}
		if(FlxG.save.data.hitss != null) {
			hitss = FlxG.save.data.hitss;
		}
		if(FlxG.save.data.hploss != null) {
			hploss = FlxG.save.data.hploss;
		}
		if(FlxG.save.data.hpgain != null) {
			hpgain = FlxG.save.data.hpgain;
		}
		if(FlxG.save.data.aFlipY != null) {
			aFlipY = FlxG.save.data.aFlipY;
		}
		if(FlxG.save.data.aFlipX != null) {
			aFlipX = FlxG.save.data.aFlipX;
		}
		if(FlxG.save.data.nop != null) {
			nop = FlxG.save.data.nop;
		}
		if(FlxG.save.data.antim != null) {
			antim = FlxG.save.data.antim;
		}
		if(FlxG.save.data.noteSize != null) {
			noteSize = FlxG.save.data.noteSize;
		}
		if(FlxG.save.data.judgementCounter != null) {
			judgementCounter = FlxG.save.data.judgementCounter;
		}
		if(FlxG.save.data.bot != null) {
			PlayState.cpuControlled = FlxG.save.data.bot;
		}
		if(FlxG.save.data.ppm != null) {
			PlayState.practiceMode = FlxG.save.data.ppm;
		}
		if(FlxG.save.data.vocals != null) {
			vocalsVolume = FlxG.save.data.vocals;
		}
		if(FlxG.save.data.TDN != null) {
			TDN = FlxG.save.data.TDN;
		}
		if(FlxG.save.data.showFPS != null) {
			showFPS = FlxG.save.data.showFPS;
			if(Main.fpsVar != null) {
				Main.fpsVar.visible = showFPS;
			}
		}
		if(FlxG.save.data.flashing != null) {
			flashing = FlxG.save.data.flashing;
		}
		if(FlxG.save.data.globalAntialiasing != null) {
			globalAntialiasing = FlxG.save.data.globalAntialiasing;
		}
		if(FlxG.save.data.noteSplashes != null) {
			noteSplashes = FlxG.save.data.noteSplashes;
		}
		if(FlxG.save.data.noteSplashes2 != null) {
			noteSplashes2 = FlxG.save.data.noteSplashes2;
		}
		if(FlxG.save.data.lowQuality != null) {
			lowQuality = FlxG.save.data.lowQuality;
		}
		if(FlxG.save.data.framerate != null) {
			framerate = FlxG.save.data.framerate;
			if(framerate > FlxG.drawFramerate) {
				FlxG.updateFramerate = framerate;
				FlxG.drawFramerate = framerate;
			} else {
				FlxG.drawFramerate = framerate;
				FlxG.updateFramerate = framerate;
			}
		}
		/*if(FlxG.save.data.cursing != null) {
			cursing = FlxG.save.data.cursing;
		}
		if(FlxG.save.data.violence != null) {
			violence = FlxG.save.data.violence;
		}*/
		if(FlxG.save.data.camZooms != null) {
			camZooms = FlxG.save.data.camZooms;
		}
		if(FlxG.save.data.camZooms2 != null) {
			camZooms2 = FlxG.save.data.camZooms2;
		}
		if(FlxG.save.data.hideHud != null) {
			hideHud = FlxG.save.data.hideHud;
		}
		if(FlxG.save.data.noteOffset != null) {
			noteOffset = FlxG.save.data.noteOffset;
		}
		if(FlxG.save.data.arrowHSV != null) {
			arrowHSV = FlxG.save.data.arrowHSV;
		}
		if(FlxG.save.data.imagesPersist != null) {
			imagesPersist = FlxG.save.data.imagesPersist;
			FlxGraphic.defaultPersist = ClientPrefs.imagesPersist;
		}
		if(FlxG.save.data.ghostTapping != null) {
			ghostTapping = FlxG.save.data.ghostTapping;
		}
		if(FlxG.save.data.hideTime != null) {
			hideTime = FlxG.save.data.hideTime;
		}
		if(FlxG.save.data.fof != null) {
			fof = FlxG.save.data.fof;
		}
		if(FlxG.save.data.tst != null) {
			tst = FlxG.save.data.tst;
		}

		// SONG MODS
		if(FlxG.save.data.loopsong != null) {
			loopsong = FlxG.save.data.loopsong;
		}

		var save:FlxSave = new FlxSave();
		save.bind('controls', 'ninjamuffin99');
		if(save != null && save.data.customControls != null) {
			reloadControls(save.data.customControls);
		}
	}

	public static function reloadControls(newKeys:Array<FlxKey>) {
		ClientPrefs.removeControls(ClientPrefs.lastControls);
		ClientPrefs.lastControls = newKeys.copy();
		ClientPrefs.loadControls(ClientPrefs.lastControls);
	}

	private static function removeControls(controlArray:Array<FlxKey>) {
		for (i in 0...keyBinds.length) {
			var controlValue:Int = i*2;
			var controlsToRemove:Array<FlxKey> = [];
			for (j in 0...2) {
				if(controlArray[controlValue+j] != NONE) {
					controlsToRemove.push(controlArray[controlValue+j]);
				}
			}
			if(controlsToRemove.length > 0) {
				PlayerSettings.player1.controls.unbindKeys(keyBinds[i][0], controlsToRemove);
			}
		}
	}
	private static function loadControls(controlArray:Array<FlxKey>) {
		for (i in 0...keyBinds.length) {
			var controlValue:Int = i*2;
			var controlsToAdd:Array<FlxKey> = [];
			for (j in 0...2) {
				if(controlArray[controlValue+j] != NONE) {
					controlsToAdd.push(controlArray[controlValue+j]);
				}
			}
			if(controlsToAdd.length > 0) {
				PlayerSettings.player1.controls.bindKeys(keyBinds[i][0], controlsToAdd);
			}
		}
	}
}