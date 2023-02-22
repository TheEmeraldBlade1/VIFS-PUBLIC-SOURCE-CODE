package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import flash.system.System;
import flixel.util.FlxStringUtil;
import Controls;

using StringTools;

// TO DO: Redo the menu creation system for not being as dumb
class OptionsState extends MusicBeatState
{
	var options:Array<String> = [''];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		options = CoolUtil.coolTextFile(Paths.txt('optionsmenu'));

		menuBG = new FlxSprite().loadGraphic(Paths.image('spacep'));
		menuBG.color = FlxColor.GRAY;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(menuBG);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true, false);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}
		changeSelection();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
		changeSelection();
	}

	override function update(elapsed:Float) {
		if (FlxG.keys.justPressed.THREE)
			{
				FlxG.mouse.visible = !FlxG.mouse.visible;
			}
		super.update(elapsed);

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.ACCEPT) {
			for (item in grpOptions.members) {
				item.alpha = 0;
			}

			switch(options[curSelected]) {
				case 'Notes':
					openSubState(new NotesSubstate());
				case 'Controls':
					openSubState(new ControlsSubstate());
				case 'Preferences':
					openSubState(new PreferencesSubstate());
				case 'Close Game':
					System.exit(0);
				default:
					trace("ERROR: CODE NOT FOUND!!!!");
			}
		}
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
			}
		}
	}
}



class NotesSubstate extends MusicBeatSubstate
{
	private static var curSelected:Int = 0;
	private static var typeSelected:Int = 0;
	private var grpNumbers:FlxTypedGroup<Alphabet>;
	private var grpNotes:FlxTypedGroup<FlxSprite>;
	private var shaderArray:Array<ColorSwap> = [];
	var curValue:Float = 0;
	var holdTime:Float = 0;
	var hsvText:Alphabet;
	var nextAccept:Int = 5;

	var posX = 250;
	public function new() {
		super();

		Circles.circles = FlxG.save.data.circles;

		grpNotes = new FlxTypedGroup<FlxSprite>();
		add(grpNotes);
		grpNumbers = new FlxTypedGroup<Alphabet>();
		add(grpNumbers);

		for (i in 0...ClientPrefs.arrowHSV.length) {
			var yPos:Float = (165 * i) + 35;
			for (j in 0...3) {
				var optionText:Alphabet = new Alphabet(0, yPos, Std.string(ClientPrefs.arrowHSV[i][j]));
				optionText.x = posX + (225 * j) + 100 - ((optionText.lettersArray.length * 90) / 2);
				grpNumbers.add(optionText);
			}

			var note:FlxSprite = new FlxSprite(posX - 70, yPos);
			if (Circles.circles)
				note.frames = Paths.getSparrowAtlas('circle/NOTE_assets');
			else
				note.frames = Paths.getSparrowAtlas('NOTE_assets');
			switch(i) {
				case 0:
					note.animation.addByPrefix('idle', 'purple0');
				case 1:
					note.animation.addByPrefix('idle', 'blue0');
				case 2:
					note.animation.addByPrefix('idle', 'green0');
				case 3:
					note.animation.addByPrefix('idle', 'red0');
			}
			note.animation.play('idle');
			note.antialiasing = ClientPrefs.globalAntialiasing;
			grpNotes.add(note);

			var newShader:ColorSwap = new ColorSwap();
			note.shader = newShader.shader;
			newShader.hue = ClientPrefs.arrowHSV[i][0] / 360;
			newShader.saturation = ClientPrefs.arrowHSV[i][1] / 100;
			newShader.brightness = ClientPrefs.arrowHSV[i][2] / 100;
			shaderArray.push(newShader);
		}
		hsvText = new Alphabet(0, 0, "Hue    Saturation  Brightness", false, false, 0, 0.65);
		add(hsvText);
		changeSelection();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	var changingNote:Bool = false;
	var hsvTextOffsets:Array<Float> = [240, 90];
	override function update(elapsed:Float) {
		if (FlxG.keys.justPressed.THREE)
			{
				FlxG.mouse.visible = !FlxG.mouse.visible;
			}
		if(changingNote) {
			if(holdTime < 0.5) {
				if(controls.UI_LEFT_P) {
					updateValue(-1);
					FlxG.sound.play(Paths.sound('scrollMenu'));
				} else if(controls.UI_RIGHT_P) {
					updateValue(1);
					FlxG.sound.play(Paths.sound('scrollMenu'));
				} else if(controls.RESET) {
					resetValue(curSelected, typeSelected);
					FlxG.sound.play(Paths.sound('scrollMenu'));
				}
				if(controls.UI_LEFT_R || controls.UI_RIGHT_R) {
					holdTime = 0;
				} else if(controls.UI_LEFT || controls.UI_RIGHT) {
					holdTime += elapsed;
				}
			} else {
				var add:Float = 90;
				switch(typeSelected) {
					case 1 | 2: add = 50;
				}
				if(controls.UI_LEFT) {
					updateValue(elapsed * -add);
				} else if(controls.UI_RIGHT) {
					updateValue(elapsed * add);
				}
				if(controls.UI_LEFT_R || controls.UI_RIGHT_R) {
					FlxG.sound.play(Paths.sound('scrollMenu'));
					holdTime = 0;
				}
			}
		} else {
			if (controls.UI_UP_P) {
				changeSelection(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.UI_DOWN_P) {
				changeSelection(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.UI_LEFT_P) {
				changeType(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.UI_RIGHT_P) {
				changeType(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if(controls.RESET) {
				for (i in 0...3) {
					resetValue(curSelected, i);
				}
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.ACCEPT && nextAccept <= 0) {
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changingNote = true;
				holdTime = 0;
				for (i in 0...grpNumbers.length) {
					var item = grpNumbers.members[i];
					item.alpha = 0;
					if ((curSelected * 3) + typeSelected == i) {
						item.alpha = 1;
					}
				}
				for (i in 0...grpNotes.length) {
					var item = grpNotes.members[i];
					item.alpha = 0;
					if (curSelected == i) {
						item.alpha = 1;
					}
				}
				super.update(elapsed);
				return;
			}
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
		for (i in 0...grpNotes.length) {
			var item = grpNotes.members[i];
			var intendedPos:Float = posX - 70;
			if (curSelected == i) {
				item.x = FlxMath.lerp(item.x, intendedPos + 100, lerpVal);
			} else {
				item.x = FlxMath.lerp(item.x, intendedPos, lerpVal);
			}
			for (j in 0...3) {
				var item2 = grpNumbers.members[(i * 3) + j];
				item2.x = item.x + 265 + (225 * (j % 3)) - (30 * item2.lettersArray.length) / 2;
				if(ClientPrefs.arrowHSV[i][j] < 0) {
					item2.x -= 20;
				}
			}

			if(curSelected == i) {
				hsvText.setPosition(item.x + hsvTextOffsets[0], item.y - hsvTextOffsets[1]);
			}
		}

		if (controls.BACK || (changingNote && controls.ACCEPT)) {
			ClientPrefs.saveSettings();
			changeSelection();
			if(!changingNote) {
				grpNumbers.forEachAlive(function(spr:Alphabet) {
					spr.alpha = 0;
				});
				grpNotes.forEachAlive(function(spr:FlxSprite) {
					spr.alpha = 0;
				});
				close();
			}
			changingNote = false;
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = ClientPrefs.arrowHSV.length-1;
		if (curSelected >= ClientPrefs.arrowHSV.length)
			curSelected = 0;

		curValue = ClientPrefs.arrowHSV[curSelected][typeSelected];
		updateValue();

		for (i in 0...grpNumbers.length) {
			var item = grpNumbers.members[i];
			item.alpha = 0.6;
			if ((curSelected * 3) + typeSelected == i) {
				item.alpha = 1;
			}
		}
		for (i in 0...grpNotes.length) {
			var item = grpNotes.members[i];
			item.alpha = 0.6;
			item.scale.set(1, 1);
			if (curSelected == i) {
				item.alpha = 1;
				item.scale.set(1.2, 1.2);
				hsvText.setPosition(item.x + hsvTextOffsets[0], item.y - hsvTextOffsets[1]);
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function changeType(change:Int = 0) {
		typeSelected += change;
		if (typeSelected < 0)
			typeSelected = 2;
		if (typeSelected > 2)
			typeSelected = 0;

		curValue = ClientPrefs.arrowHSV[curSelected][typeSelected];
		updateValue();

		for (i in 0...grpNumbers.length) {
			var item = grpNumbers.members[i];
			item.alpha = 0.6;
			if ((curSelected * 3) + typeSelected == i) {
				item.alpha = 1;
			}
		}
	}

	function resetValue(selected:Int, type:Int) {
		curValue = 0;
		ClientPrefs.arrowHSV[selected][type] = 0;
		switch(type) {
			case 0: shaderArray[selected].hue = 0;
			case 1: shaderArray[selected].saturation = 0;
			case 2: shaderArray[selected].brightness = 0;
		}
		grpNumbers.members[(selected * 3) + type].changeText('0');
	}
	function updateValue(change:Float = 0) {
		curValue += change;
		var roundedValue:Int = Math.round(curValue);
		var max:Float = 180;
		switch(typeSelected) {
			case 1 | 2: max = 100;
		}

		if(roundedValue < -max) {
			curValue = -max;
		} else if(roundedValue > max) {
			curValue = max;
		}
		roundedValue = Math.round(curValue);
		ClientPrefs.arrowHSV[curSelected][typeSelected] = roundedValue;

		switch(typeSelected) {
			case 0: shaderArray[curSelected].hue = roundedValue / 360;
			case 1: shaderArray[curSelected].saturation = roundedValue / 100;
			case 2: shaderArray[curSelected].brightness = roundedValue / 100;
		}
		grpNumbers.members[(curSelected * 3) + typeSelected].changeText(Std.string(roundedValue));
	}
}



class ControlsSubstate extends MusicBeatSubstate {
	private static var curSelected:Int = 1;
	private static var curAlt:Bool = false;

	private static var defaultKey:String = 'Reset to Default Keys';

	private static var backKey:String = 'Back To Options';

	var optionShit:Array<String> = [
		'NOTES',
		ClientPrefs.keyBinds[0][1],
		ClientPrefs.keyBinds[1][1],
		ClientPrefs.keyBinds[2][1],
		ClientPrefs.keyBinds[3][1],
		'',
		'UI',
		ClientPrefs.keyBinds[4][1],
		ClientPrefs.keyBinds[5][1],
		ClientPrefs.keyBinds[6][1],
		ClientPrefs.keyBinds[7][1],
		'',
		ClientPrefs.keyBinds[8][1],
		ClientPrefs.keyBinds[9][1],
		ClientPrefs.keyBinds[10][1],
		ClientPrefs.keyBinds[11][1],
		'',
		defaultKey,
		backKey];

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var grpInputs:Array<AttachedText> = [];
	private var controlArray:Array<FlxKey> = [];
	var rebindingKey:Int = -1;
	var nextAccept:Int = 5;

	public function new() {
		super();
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		controlArray = ClientPrefs.lastControls.copy();
		for (i in 0...optionShit.length) {
			var isCentered:Bool = false;
			var isDefaultKey:Bool = (optionShit[i] == defaultKey);
			if(unselectableCheck(i, true)) {
				isCentered = true;
			}

			var optionText:Alphabet = new Alphabet(0, (10 * i), optionShit[i], (!isCentered || isDefaultKey), false);
			optionText.isMenuItem = true;
			if(isCentered) {
				optionText.screenCenter(X);
				optionText.forceX = optionText.x;
				optionText.yAdd = -55;
			} else {
				optionText.forceX = 200;
			}
			optionText.yMult = 60;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(!isCentered) {
				addBindTexts(optionText);
			}
		}
		changeSelection();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	var leaving:Bool = false;
	var bindingTime:Float = 0;
	override function update(elapsed:Float) {
		if (FlxG.keys.justPressed.THREE)
			{
				FlxG.mouse.visible = !FlxG.mouse.visible;
			}
		if(rebindingKey < 0) {
			if (controls.UI_UP_P) {
				changeSelection(-1);
			}
			if (controls.UI_DOWN_P) {
				changeSelection(1);
			}
			if (controls.UI_LEFT_P || controls.UI_RIGHT_P) {
				changeAlt();
			}

			if (controls.BACK) {
				ClientPrefs.saveSettings();
				ClientPrefs.reloadControls(controlArray);
				grpOptions.forEachAlive(function(spr:Alphabet) {
					spr.alpha = 0;
				});
				for (i in 0...grpInputs.length) {
					var spr:AttachedText = grpInputs[i];
					if(spr != null) {
						spr.alpha = 0;
					}
				}
				close();
				FlxG.sound.play(Paths.sound('cancelMenu'));
			}

			if(controls.ACCEPT && nextAccept <= 0) {
				if(optionShit[curSelected] == defaultKey) {
					controlArray = ClientPrefs.defaultKeys.copy();
					reloadKeys();
					changeSelection();
					FlxG.sound.play(Paths.sound('confirmMenu'));
				}else if (optionShit[curSelected] == backKey) {
					ClientPrefs.saveSettings();
					ClientPrefs.reloadControls(controlArray);
					grpOptions.forEachAlive(function(spr:Alphabet) {
						spr.alpha = 0;
					});
					for (i in 0...grpInputs.length) {
						var spr:AttachedText = grpInputs[i];
						if(spr != null) {
							spr.alpha = 0;
						}
					}
					close();
					FlxG.sound.play(Paths.sound('cancelMenu'));
				} else {
					bindingTime = 0;
					rebindingKey = getSelectedKey();
					if(rebindingKey > -1) {
						grpInputs[rebindingKey].visible = false;
						FlxG.sound.play(Paths.sound('scrollMenu'));
					} else {
						FlxG.log.warn('Error! No input found/badly configured');
						FlxG.sound.play(Paths.sound('cancelMenu'));
					}
				}
			}
		} else {
			var keyPressed:Int = FlxG.keys.firstJustPressed();
			if (keyPressed > -1) {
				controlArray[rebindingKey] = keyPressed;
				var opposite:Int = rebindingKey + (rebindingKey % 2 == 1 ? -1 : 1);
				trace('Rebinded key with ID: ' + rebindingKey + ', Opposite is: ' + opposite);
				if(controlArray[opposite] == controlArray[rebindingKey]) {
					controlArray[opposite] = NONE;
				}

				reloadKeys();
				FlxG.sound.play(Paths.sound('confirmMenu'));
				rebindingKey = -1;
			}

			bindingTime += elapsed;
			if(bindingTime > 5) {
				grpInputs[rebindingKey].visible = true;
				FlxG.sound.play(Paths.sound('scrollMenu'));
				rebindingKey = -1;
				bindingTime = 0;
			}
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}
	
	function changeSelection(change:Int = 0) {
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = optionShit.length - 1;
			if (curSelected >= optionShit.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var bullShit:Int = 0;

		for (i in 0...grpInputs.length) {
			grpInputs[i].alpha = 0.6;
		}

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
					for (i in 0...grpInputs.length) {
						if(grpInputs[i].sprTracker == item && grpInputs[i].isAlt == curAlt) {
							grpInputs[i].alpha = 1;
						}
					}
				}
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function changeAlt() {
		curAlt = !curAlt;
		for (i in 0...grpInputs.length) {
			if(grpInputs[i].sprTracker == grpOptions.members[curSelected]) {
				grpInputs[i].alpha = 0.6;
				if(grpInputs[i].isAlt == curAlt) {
					grpInputs[i].alpha = 1;
				}
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	private function unselectableCheck(num:Int, ?checkDefaultKey:Bool = false):Bool {
		if(optionShit[num] == defaultKey) {
			return checkDefaultKey;
		}

		for (i in 0...ClientPrefs.keyBinds.length) {
			if(ClientPrefs.keyBinds[i][1] == optionShit[num]) {
				return false;
			}
		}
		return true;
	}

	private function getSelectedKey():Int {
		var altValue:Int = (curAlt ? 1 : 0);
		for (i in 0...ClientPrefs.keyBinds.length) {
			if(ClientPrefs.keyBinds[i][1] == optionShit[curSelected]) {
				return i*2 + altValue;
			}
		}
		return -1;
	}

	private function addBindTexts(optionText:Alphabet) {
		var text1 = new AttachedText(InputFormatter.getKeyName(controlArray[grpInputs.length]), 400, -55);
		text1.setPosition(optionText.x + 400, optionText.y - 55);
		text1.sprTracker = optionText;
		grpInputs.push(text1);
		add(text1);

		var text2 = new AttachedText(InputFormatter.getKeyName(controlArray[grpInputs.length]), 650, -55);
		text2.setPosition(optionText.x + 650, optionText.y - 55);
		text2.sprTracker = optionText;
		text2.isAlt = true;
		grpInputs.push(text2);
		add(text2);
	}

	function reloadKeys() {
		while(grpInputs.length > 0) {
			var item:AttachedText = grpInputs[0];
			grpInputs.remove(item);
			remove(item);
		}

		for (i in 0...grpOptions.length) {
			if(!unselectableCheck(i, true)) {
				addBindTexts(grpOptions.members[i]);
			}
		}


		var bullShit:Int = 0;
		for (i in 0...grpInputs.length) {
			grpInputs[i].alpha = 0.6;
		}

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
					for (i in 0...grpInputs.length) {
						if(grpInputs[i].sprTracker == item && grpInputs[i].isAlt == curAlt) {
							grpInputs[i].alpha = 1;
						}
					}
				}
			}
		}
	}
}



class PreferencesSubstate extends MusicBeatSubstate
{
	private static var curSelected:Int = 0;
	static var unselectableOptions:Array<String> = [
		'GRAPHICS',
		'GAMEPLAY',
		'HUD',
		'MODS',
		'SOUNDS',
		'GAME',
		'SCORE TEXT',
		'NOTE SPLASHES'
	];
	static var noCheckbox:Array<String> = [
		'Framerate',
		'Note Delay',
		'Scroll Speed',
		'Vocals Volume',
		'Note Size',
		'Safe Frames',
		'Score Text Type'
	];

	static var options:Array<String> = [
		'GRAPHICS',
		'Low Quality',
		'Anti-Aliasing',
		'Persistent Cached Data',
		#if !html5
		'Framerate', //Apparently 120FPS isn't correctly supported on Browser? Probably it has some V-Sync shit enabled by default, idk
		#end
		'GAMEPLAY',
		'Downscroll',
		'Middlescroll',
		'Fof Middlescroll',
		'Custom Scroll Speed',
		'Scroll Speed',
		'Ghost Tapping',
		'Note Delay',
		'Anti Mash',
		'More Hp Gain',
		'More Hp Loss',
		'Hold Hp Gain',
		'HUD',
		'Hide HUD',
		'Hide Song Length',
		'Flashing Lights',
		'Camera Zooms',
		'Transparent Enemy Notes',
		'Hide Enemy Notes',
		'Note Size',
		'Flip Arrow Y',
		'Flip Arrow X',
		'Circle Notes',
		#if !mobile
		'FPS Counter',
		#end
		'SCORE TEXT',
		'Score Zooms',
		'Transparent Score Text',
		'Acc Rating',
		'Full Accuracy',
		'judgement Counter',
		'Score Text Type',
		'Simple Judgement',
		'Rating Fc',
		'NOTE SPLASHES',
		'Note Splashes',
		'Enemy Note Splashes',
		'SOUNDS',
		'Hitsounds',
		'Miss sounds',
		'Vocals Volume',
		'GAME',
		'Fullscreen',
		'MODS',
		'Loop Song'
	];

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var checkboxArray:Array<CheckboxThingie> = [];
	private var checkboxNumber:Array<Int> = [];
	private var grpTexts:FlxTypedGroup<AttachedText>;
	private var textNumber:Array<Int> = [];

	private var showCharacter:Character = null;
	private var descText:FlxText;

	public function new()
	{
		super();
		// avoids lagspikes while scrolling through menus!
		showCharacter = new Character(840, 170, 'bf', true);
		showCharacter.setGraphicSize(Std.int(showCharacter.width * 0.8));
		showCharacter.updateHitbox();
		showCharacter.dance();
		add(showCharacter);
		showCharacter.visible = false;

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		grpTexts = new FlxTypedGroup<AttachedText>();
		add(grpTexts);

		/*if (OptionsState.ScoreTxt)
			{
				options = [
					'SCORE TEXT',
					'Score Zooms',
					'Transparent Score Text',
					'Acc Rating',
					'Full Accuracy',
					'judgement Counter',
					'Simple Score',
					'Simple Judgement',
					'Rating Fc'
				];
			}*/

		for (i in 0...options.length)
		{
			var isCentered:Bool = unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, options[i], false, false);
			optionText.isMenuItem = true;
			if(isCentered) {
				optionText.screenCenter(X);
				optionText.forceX = optionText.x;
			} else {
				optionText.x += 300;
				optionText.forceX = 300;
			}
			optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(!isCentered) {
				var useCheckbox:Bool = true;
				for (j in 0...noCheckbox.length) {
					if(options[i] == noCheckbox[j]) {
						useCheckbox = false;
						break;
					}
				}

				if(useCheckbox) {
					var checkbox:CheckboxThingie = new CheckboxThingie(optionText.x - 105, optionText.y, false);
					checkbox.sprTracker = optionText;
					checkboxArray.push(checkbox);
					checkboxNumber.push(i);
					add(checkbox);
				} else {
					var valueText:AttachedText = new AttachedText('0', optionText.width + 80);
					valueText.sprTracker = optionText;
					grpTexts.add(valueText);
					textNumber.push(i);
				}
			}
			cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		for (i in 0...options.length) {
			if(!unselectableCheck(i)) {
				curSelected = i;
				break;
			}
		}
		changeSelection();
		reloadValues();
	}

	var nextAccept:Int = 5;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.THREE)
			{
				FlxG.mouse.visible = !FlxG.mouse.visible;
			}
		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		if (controls.BACK) {
			grpOptions.forEachAlive(function(spr:Alphabet) {
				spr.alpha = 0;
			});
			grpTexts.forEachAlive(function(spr:AttachedText) {
				spr.alpha = 0;
			});
			for (i in 0...checkboxArray.length) {
				var spr:CheckboxThingie = checkboxArray[i];
				if(spr != null) {
					spr.alpha = 0;
				}
			}
			if(showCharacter != null) {
				showCharacter.alpha = 0;
			}
			descText.alpha = 0;
			close();
			ClientPrefs.saveSettings();
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		var usesCheckbox = true;
		for (i in 0...noCheckbox.length) {
			if(options[curSelected] == noCheckbox[i]) {
				usesCheckbox = false;
				break;
			}
		}

		if(usesCheckbox) {
			if(controls.ACCEPT && nextAccept <= 0) {
				switch(options[curSelected]) {
					case 'FPS Counter':
						ClientPrefs.showFPS = !ClientPrefs.showFPS;
						if(Main.fpsVar != null)
							Main.fpsVar.visible = ClientPrefs.showFPS;

					case 'Low Quality':
						ClientPrefs.lowQuality = !ClientPrefs.lowQuality;

					case 'Anti-Aliasing':
						ClientPrefs.globalAntialiasing = !ClientPrefs.globalAntialiasing;
						showCharacter.antialiasing = ClientPrefs.globalAntialiasing;
						for (item in grpOptions) {
							item.antialiasing = ClientPrefs.globalAntialiasing;
						}
						for (i in 0...checkboxArray.length) {
							var spr:CheckboxThingie = checkboxArray[i];
							if(spr != null) {
								spr.antialiasing = ClientPrefs.globalAntialiasing;
							}
						}
						OptionsState.menuBG.antialiasing = ClientPrefs.globalAntialiasing;

					case 'Note Splashes':
						ClientPrefs.noteSplashes = !ClientPrefs.noteSplashes;

					case 'Simple Score':
						FlxG.save.data.simplescore = !FlxG.save.data.simplescore;

					case 'Simple Judgement':
						FlxG.save.data.simplejudge = !FlxG.save.data.simplejudge;

					case 'Circle Notes':
						FlxG.save.data.circles = !FlxG.save.data.circles;

					case 'Enemy Note Splashes':
						ClientPrefs.noteSplashes2 = !ClientPrefs.noteSplashes2;

					case 'Fullscreen':
						FlxG.save.data.HHHHH = !FlxG.save.data.HHHHH;
						FlxG.fullscreen = !FlxG.fullscreen;

					case 'Hold Hp Gain':
						FlxG.save.data.holdnotehp = !FlxG.save.data.holdnotehp;

					case 'More Hp Gain':
						ClientPrefs.hpgain = !ClientPrefs.hpgain;

					case 'More Hp Loss':
						ClientPrefs.hploss = !ClientPrefs.hploss;

					case 'Flip Arrow Y':
						ClientPrefs.aFlipY = !ClientPrefs.aFlipY;
	
					case 'Flip Arrow X':
						ClientPrefs.aFlipX = !ClientPrefs.aFlipX;

					case 'Full Accuracy':
						ClientPrefs.full = !ClientPrefs.full;

					case 'Acc Rating':
						ClientPrefs.ratingfc = !ClientPrefs.ratingfc;

					case 'Rating Fc':
						ClientPrefs.ratingfc2 = !ClientPrefs.ratingfc2;

					case 'Hitsounds':
						ClientPrefs.hitss = !ClientPrefs.hitss;

					case 'Miss sounds':
						ClientPrefs.misss = !ClientPrefs.misss;

					case 'Custom Scroll Speed':
						ClientPrefs.hss = !ClientPrefs.hss;
			
					case 'judgement Counter':
						ClientPrefs.judgementCounter = !ClientPrefs.judgementCounter;

					case 'Flashing Lights':
						ClientPrefs.flashing = !ClientPrefs.flashing;

					case 'Violence':
						ClientPrefs.violence = !ClientPrefs.violence;

					case 'Swearing':
						ClientPrefs.cursing = !ClientPrefs.cursing;

					case 'Botplay Confirm Anims':
						ClientPrefs.botca = !ClientPrefs.botca;

					case 'Downscroll':
						ClientPrefs.downScroll = !ClientPrefs.downScroll;

					case 'Middlescroll':
						ClientPrefs.middleScroll = !ClientPrefs.middleScroll;

					case 'Anti Mash':
						ClientPrefs.antim = !ClientPrefs.antim;

					case 'Fof Middlescroll':
						ClientPrefs.fof = !ClientPrefs.fof;

					case 'Ghost Tapping':
						ClientPrefs.ghostTapping = !ClientPrefs.ghostTapping;

					case 'Camera Zooms':
						ClientPrefs.camZooms = !ClientPrefs.camZooms;

					case 'Score Zooms':
						ClientPrefs.camZooms2 = !ClientPrefs.camZooms2;

					case 'Hide HUD':
						ClientPrefs.hideHud = !ClientPrefs.hideHud;

					case 'Transparent Score Text':
						ClientPrefs.tst = !ClientPrefs.tst;

					case 'Persistent Cached Data':
						ClientPrefs.imagesPersist = !ClientPrefs.imagesPersist;
						FlxGraphic.defaultPersist = ClientPrefs.imagesPersist;
					
					case 'Hide Song Length':
						ClientPrefs.hideTime = !ClientPrefs.hideTime;

					case 'Transparent Enemy Notes':
						ClientPrefs.TDN = !ClientPrefs.TDN;

					case 'Hide Enemy Notes':
						ClientPrefs.nop = !ClientPrefs.nop;

					// SONG MODS

					case 'Botplay':
						PlayState.cpuControlled = !PlayState.cpuControlled;
						PlayState.usedPractice = true;
					case 'Practice Mode':
						PlayState.practiceMode = !PlayState.practiceMode;
						PlayState.usedPractice = true;
					case 'Loop Song':
						ClientPrefs.loopsong = !ClientPrefs.loopsong;
				}
				FlxG.sound.play(Paths.sound('scrollMenu'));
				reloadValues();
			}
		} else {
			if(controls.UI_LEFT || controls.UI_RIGHT) {
				var add:Int = controls.UI_LEFT ? -1 : 1;
				if(holdTime > 0.5 || controls.UI_LEFT_P || controls.UI_RIGHT_P)
				switch(options[curSelected]) {
					case 'Framerate':
						ClientPrefs.framerate += add;
						if(ClientPrefs.framerate < 30) ClientPrefs.framerate = 30;
						else if(ClientPrefs.framerate > 300) ClientPrefs.framerate = 300;

						if(ClientPrefs.framerate > FlxG.drawFramerate) {
							FlxG.updateFramerate = ClientPrefs.framerate;
							FlxG.drawFramerate = ClientPrefs.framerate;
						} else {
							FlxG.drawFramerate = ClientPrefs.framerate;
							FlxG.updateFramerate = ClientPrefs.framerate;
						}
					case 'Scroll Speed':
						//ClientPrefs.speed += add/10;
						if (controls.UI_RIGHT)
							ClientPrefs.speed += 0.1;
						else if (controls.UI_LEFT)
							ClientPrefs.speed -= 0.1;
						if(ClientPrefs.speed < 0.1) ClientPrefs.speed = 0.1;
						else if(ClientPrefs.speed > 10) ClientPrefs.speed = 10;
					case 'Vocals Volume':
						ClientPrefs.vocalsVolume += add/10;
						if(ClientPrefs.vocalsVolume < 0) ClientPrefs.vocalsVolume = 0;
						else if(ClientPrefs.vocalsVolume > 1) ClientPrefs.vocalsVolume = 1;
					case 'Note Size':
						ClientPrefs.noteSize += add/100;
						if(ClientPrefs.noteSize < 0.50) ClientPrefs.noteSize = 0.50;
						else if(ClientPrefs.noteSize > 1.0) ClientPrefs.noteSize = 1.0;
					case 'Score Text Type':
						if (controls.UI_RIGHT)
							ClientPrefs.scoretxttype += 1;
						else if (controls.UI_LEFT)
							ClientPrefs.scoretxttype -= 1;
						if(ClientPrefs.scoretxttype < 0) ClientPrefs.scoretxttype = 0;
						else if(ClientPrefs.scoretxttype > 2) ClientPrefs.scoretxttype = 2;
					case 'Safe Frames':
						if (controls.UI_RIGHT)
							ClientPrefs.safeFrame += 1;
						else if (controls.UI_LEFT)
							ClientPrefs.safeFrame -= 1;
						if(ClientPrefs.safeFrame < 8) ClientPrefs.safeFrame = 8;
						else if(ClientPrefs.safeFrame > 150) ClientPrefs.safeFrame = 150;
					case 'Note Delay':
						var mult:Int = 1;
						if(holdTime > 1.5) { //Double speed after 1.5 seconds holding
							mult = 2;
						}
						if (FlxG.keys.justPressed.R)
							ClientPrefs.noteOffset = 0;
						else
							ClientPrefs.noteOffset += add * mult;
						if(ClientPrefs.noteOffset < -1000) ClientPrefs.noteOffset = -1000;
						else if(ClientPrefs.noteOffset > 1000) ClientPrefs.noteOffset = 1000;
				}
				reloadValues();

				if(holdTime <= 0) FlxG.sound.play(Paths.sound('scrollMenu'));
				holdTime += elapsed;
			} else {
				holdTime = 0;
			}
		}

		if(showCharacter != null && showCharacter.animation.curAnim.finished) {
			showCharacter.dance();
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}
	
	function changeSelection(change:Int = 0)
	{
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = options.length - 1;
			if (curSelected >= options.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var daText:String = '';
		switch(options[curSelected]) {
			case 'Framerate':
				daText = "Pretty self explanatory, isn't it?\nDefault value is 60.";
			case 'Note Delay':
				daText = "Changes how late a note is spawned.\nUseful for preventing audio lag from wireless earphones.";
			case 'FPS Counter':
				daText = "If unchecked, hides FPS Counter.";
			case 'Low Quality':
				daText = "If checked, disables some background details,\ndecreases loading times and improves performance.";
			case 'Persistent Cached Data':
				daText = "If checked, images loaded will stay in memory\nuntil the game is closed, this increases memory usage,\nbut basically makes reloading times instant.";
			case 'Anti-Aliasing':
				daText = "If unchecked, disables anti-aliasing, increases performance\nat the cost of the graphics not looking as smooth.";
			case 'Downscroll':
				daText = "If checked, notes go Down instead of Up, simple enough.";
			case 'Middlescroll':
				daText = "If checked, hides Opponent's notes and your notes get centered.";
			case 'Fof Middlescroll':
				daText = "If checked, enables the middlescroll from fight or flight\nMIDDLESCROLL MUST BE ON!!";
			case 'Ghost Tapping':
				daText = "If checked, you won't get misses from pressing keys\nwhile there are no notes able to be hit.";
			case 'Swearing':
				daText = "If unchecked, your mom won't be angry at you.";
			case 'Violence':
				daText = "If unchecked, you won't get disgusted as frequently.";
			case 'Note Splashes':
				daText = "If unchecked, hitting \"Sick!\" notes won't show particles.";
			case 'Enemy Note Splashes':
				daText = "If unchecked, enemy notes won't show particles on hit.";
			case 'Flashing Lights':
				daText = "Uncheck this if you're sensitive to flashing lights!";
			case 'Camera Zooms':
				daText = "If unchecked, the camera won't zoom in on a beat hit.";
			case 'Score Zooms':
				daText = "If unchecked, the score text won't zoom on hit";
			case 'Hide HUD':
				daText = "If checked, hides most HUD elements.";
			case 'Acc Rating':
				daText = "If checked, the rating fc will go like MFC, SFC, GFC, FC\nif unchecked the rating fc will go like SFC, GFC, FC, FC";
			case 'Hide Song Length':
				daText = "If checked, the bar showing how much time is left\nwill be hidden.";
			case 'Custom Scroll Speed':
				daText = "If checked, you can customize your scroll speed";
			case 'Scroll Speed':
				daText = "changes how much scroll speed you want\n(Custom Scroll Speed Must Be On)";
			case 'Transparent Score Text':
				daText = "obvious isnt it?";
			case 'Full Accuracy':
				daText = "If checked, the accuracy will go like 0.00%\nif unchecked, the accuracy will go like 0%";
			case 'judgement Counter':
				daText = "If checked, the judgements will be shown in the ui";
			case 'Transparent Enemy Notes':
				daText = "obvious isnt it?";
			case 'Hide Enemy Notes':
				daText = "obvious isnt it?";
			case 'Vocals Volume':
				daText = "Changes The Volume Of Song Vocals";
			case 'Hitsounds':
				daText = "If checked, When you hit a note a sound plays";
			case 'Miss sounds':
				daText = "If checked, When you miss a note a sound plays";
			case 'Note Size':
				daText = "Size of notes and stuff (0.70 is Default)";
			case 'Anti Mash':
				daText = "If checked, Mashing Buttons Will Dran your hp\nif unchecked, spam at free will";
			case 'More Hp Gain':
				daText = "If checked, you will gain more hp on hit\nif unchecked, you will gain less hp on hit";
			case 'More Hp Loss':
				daText = "If checked, you will lose more hp on miss\nif unchecked, you will lose less hp on miss";
			case 'Flip Arrow Y':
				daText = "If checked, flips the y of the arrows";
			case 'Flip Arrow X':
				daText = "If checked, flips the x of the arrows";
			case 'Loop Song':
				daText = "FREEPLAY ONLY";
			case 'Botplay Confirm Anims':
				daText = "If checked, botplay will play an anim on hit";
			case 'Simple Score':
				daText = "If checked, makes the score rating only show score";
			case 'Fullscreen':
				daText = "obvious isnt it?";
			case 'Circle Notes':
				daText = "obvious isnt it?";
			case 'Rating Fc':
				daText = "If checked, enables the fc rating\nIf unchecked, rating fc will be hidden";
			case 'Safe Frames':
				daText = "changes how early or late you must hit a note\n(default is 6ms)";
			case 'Simple Judgement':
				daText = "If checked, makes the judgement counter becomes simple";
			case 'Hold Hp Gain':
				daText = "If checked, you will gain hp on hold notes";
			case 'Score Text Type':
				daText = "0 = default\n1 = epic \n2 = simple";
			default:
				daText = "";
		}
		descText.text = daText;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}

				for (j in 0...checkboxArray.length) {
					var tracker:FlxSprite = checkboxArray[j].sprTracker;
					if(tracker == item) {
						checkboxArray[j].alpha = item.alpha;
						break;
					}
				}
			}
		}
		for (i in 0...grpTexts.members.length) {
			var text:AttachedText = grpTexts.members[i];
			if(text != null) {
				text.alpha = 0.6;
				if(textNumber[i] == curSelected) {
					text.alpha = 1;
				}
			}
		}

		showCharacter.visible = (options[curSelected] == 'Anti-Aliasing');
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function reloadValues() {
		for (i in 0...checkboxArray.length) {
			var checkbox:CheckboxThingie = checkboxArray[i];
			if(checkbox != null) {
				var daValue:Bool = false;
				switch(options[checkboxNumber[i]]) {
					case 'FPS Counter':
						daValue = ClientPrefs.showFPS;
					case 'Low Quality':
						daValue = ClientPrefs.lowQuality;
					case 'Anti-Aliasing':
						daValue = ClientPrefs.globalAntialiasing;
					case 'Note Splashes':
						daValue = ClientPrefs.noteSplashes;
					case 'Enemy Note Splashes':
						daValue = ClientPrefs.noteSplashes2;
					case 'Flashing Lights':
						daValue = ClientPrefs.flashing;
					case 'Downscroll':
						daValue = ClientPrefs.downScroll;
					case 'Middlescroll':
						daValue = ClientPrefs.middleScroll;
					case 'Fof Middlescroll':
						daValue = ClientPrefs.fof;
					case 'Ghost Tapping':
						daValue = ClientPrefs.ghostTapping;
					case 'Swearing':
						daValue = ClientPrefs.cursing;
					case 'Violence':
						daValue = ClientPrefs.violence;
					case 'Camera Zooms':
						daValue = ClientPrefs.camZooms;
					case 'Score Zooms':
						daValue = ClientPrefs.camZooms2;
					case 'Hide HUD':
						daValue = ClientPrefs.hideHud;
					case 'Persistent Cached Data':
						daValue = ClientPrefs.imagesPersist;
					case 'Hide Song Length':
						daValue = ClientPrefs.hideTime;
					case 'Custom Scroll Speed':
						daValue = ClientPrefs.hss;
					case 'Transparent Score Text':
						daValue = ClientPrefs.tst;
					case 'Acc Rating':
						daValue = ClientPrefs.ratingfc;
					case 'Botplay':
						daValue = PlayState.cpuControlled;
					case 'Practice Mode':
						daValue = PlayState.practiceMode;
					case 'Full Accuracy':
						daValue = ClientPrefs.full;
					case 'judgement Counter':
						daValue = ClientPrefs.judgementCounter;
					case 'Transparent Enemy Notes':
						daValue = ClientPrefs.TDN;
					case 'Hide Enemy Notes':
						daValue = ClientPrefs.nop;
					case 'Hitsounds':
						daValue = ClientPrefs.hitss;
					case 'Miss sounds':
						daValue = ClientPrefs.misss;
					case 'Anti Mash':
						daValue = ClientPrefs.antim;
					case 'More Hp Gain':
						daValue = ClientPrefs.hpgain;
					case 'More Hp Loss':
						daValue = ClientPrefs.hploss;
					case 'Flip Arrow Y':
						daValue = ClientPrefs.aFlipY;
					case 'Flip Arrow X':
						daValue = ClientPrefs.aFlipX;
					case 'Loop Song':
						daValue = ClientPrefs.loopsong;
					case 'Botplay Confirm Anims':
						daValue = ClientPrefs.botca;
					case 'Simple Score':
						daValue = FlxG.save.data.simplescore;
					case 'Circle Notes':
						daValue = FlxG.save.data.circles;
					case 'Fullscreen':
						daValue = FlxG.fullscreen;
					case 'Rating Fc':
						daValue = ClientPrefs.ratingfc2;
					case 'Simple Judgement':
						daValue = FlxG.save.data.simplejudge;
					case 'Hold Hp Gain':
						daValue = FlxG.save.data.holdnotehp;
				}
				checkbox.daValue = daValue;
			}
		}
		for (i in 0...grpTexts.members.length) {
			var text:AttachedText = grpTexts.members[i];
			if(text != null) {
				var daText:String = '';
				switch(options[textNumber[i]]) {
					case 'Framerate':
						daText = '' + ClientPrefs.framerate;
					case 'Note Delay':
						daText = ClientPrefs.noteOffset + 'ms';
					case 'Scroll Speed':
						daText = ClientPrefs.speed+"";
					case 'Vocals Volume':
						daText = ClientPrefs.vocalsVolume+"";
					case 'Score Text Type':
						daText = ClientPrefs.scoretxttype+"";
					case 'Safe Frames':
						daText = ClientPrefs.safeFrame+"";
					case 'Note Size':
						daText = FlxStringUtil.formatMoney(ClientPrefs.noteSize) + 'x';
						if (ClientPrefs.noteSize == 0.7) daText += "";
				}
				var lastTracker:FlxSprite = text.sprTracker;
				text.sprTracker = null;
				text.changeText(daText);
				text.sprTracker = lastTracker;
			}
		}
	}

	private function unselectableCheck(num:Int):Bool {
		for (i in 0...unselectableOptions.length) {
			if(options[num] == unselectableOptions[i]) {
				return true;
			}
		}
		return options[num] == '';
	}
}
