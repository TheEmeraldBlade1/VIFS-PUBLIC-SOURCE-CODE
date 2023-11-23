package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class StrumNote extends FlxSprite
{
	private var colorSwap:ColorSwap;
	public var resetAnim:Float = 0;
	private var noteData:Int = 0;

	private var player:Int;

	var monotoneChars:Array<String> = ['bfscary', 'monotone', 'attack'];

	public function new(x:Float, y:Float, leData:Int, player:Int) {
		Circles.circles = FlxG.save.data.circles;
		colorSwap = new ColorSwap();
		shader = colorSwap.shader;
		noteData = leData;
		this.player = player;
		this.noteData = leData;
		super(x, y);

		//alpha = 0.75;

		var skin:String = 'NOTE_assets';
		if(PlayState.SONG.arrowSkin != null && PlayState.SONG.arrowSkin.length > 1) skin = PlayState.SONG.arrowSkin;

		if(PlayState.isPixelStage)
		{
			loadGraphic(Paths.image('pixelUI/' + skin + 'STATIC'));
			if (Circles.circles) loadGraphic(Paths.image('pixelUI/circle/' + skin + 'STATIC'));
			width = width / 4;
			height = height / 5;
			loadGraphic(Paths.image('pixelUI/' + skin + 'STATIC'), true, Math.floor(width), Math.floor(height));
			if (Circles.circles) loadGraphic(Paths.image('pixelUI/circle/' + skin + 'STATIC'), true, Math.floor(width), Math.floor(height));
			animation.add('green', [6]);
			animation.add('red', [7]);
			animation.add('blue', [5]);
			animation.add('purple', [4]);

			antialiasing = false;
			setGraphicSize(Std.int(width * ClientPrefs.noteSize * PlayState.daPixelZoom * 1.5));

			switch (Math.abs(leData))
			{
				case 0:
					animation.add('static', [0]);
					animation.add('pressed', [4, 8], 12, false);
					animation.add('confirm', [12, 16], 24, false);
					animation.add('confirm2', [16], 24, false);
				case 1:
					animation.add('static', [1]);
					animation.add('pressed', [5, 9], 12, false);
					animation.add('confirm', [13, 17], 24, false);
					animation.add('confirm2', [17], 24, false);
				case 2:
					animation.add('static', [2]);
					animation.add('pressed', [6, 10], 12, false);
					animation.add('confirm', [14, 18], 12, false);
					animation.add('confirm2', [18], 24, false);
				case 3:
					animation.add('static', [3]);
					animation.add('pressed', [7, 11], 12, false);
					animation.add('confirm', [15, 19], 24, false);
					animation.add('confirm2', [19], 24, false);
			}
		}
		else
		{
			if (monotoneChars.contains(PlayState.SONG.player2) && player == 0){
				frames = Paths.getSparrowAtlas('monotone_notes');
			}else if (PlayState.SONG.player1 == 'Victory_BF' && player == 1){
				frames = Paths.getSparrowAtlas('NOTE_assets_DEFAULT_COLOR2');
			}else if (PlayState.SONG.player1 == 'amongbf2' && player == 1){
				frames = Paths.getSparrowAtlas('NOTE_assets_DEFAULT_COLOR2');
			}else{
				frames = Paths.getSparrowAtlas(skin);
				if (Circles.circles) frames = Paths.getSparrowAtlas('circle/' + skin);
			}
			animation.addByPrefix('green', 'arrowUP');
			animation.addByPrefix('blue', 'arrowDOWN');
			animation.addByPrefix('purple', 'arrowLEFT');
			animation.addByPrefix('red', 'arrowRIGHT');

			antialiasing = ClientPrefs.globalAntialiasing;
			setGraphicSize(Std.int(width * ClientPrefs.noteSize));

			switch (Math.abs(leData))
			{
				case 0:
					animation.addByPrefix('static', 'arrowLEFT');
					animation.addByPrefix('pressed', 'left press', 24, false);
					animation.addByPrefix('confirm', 'left confirm', 24, false);
					animation.addByPrefix('confirm2', 'left confirm0003', 24, false);
				case 1:
					animation.addByPrefix('static', 'arrowDOWN');
					animation.addByPrefix('pressed', 'down press', 24, false);
					animation.addByPrefix('confirm', 'down confirm', 24, false);
					animation.addByPrefix('confirm2', 'down confirm0003', 24, false);
				case 2:
					animation.addByPrefix('static', 'arrowUP');
					animation.addByPrefix('pressed', 'up press', 24, false);
					animation.addByPrefix('confirm', 'up confirm', 24, false);
					animation.addByPrefix('confirm2', 'up confirm0003', 24, false);
				case 3:
					animation.addByPrefix('static', 'arrowRIGHT');
					animation.addByPrefix('pressed', 'right press', 24, false);
					animation.addByPrefix('confirm', 'right confirm', 24, false);
					animation.addByPrefix('confirm2', 'right confirm0003', 24, false);
			}
		}

		updateHitbox();
		scrollFactor.set();
	}

	public function postAddedToGroup() {
		playAnim('static');
		x += Note.swagWidth * noteData;
		x += 50;
		x += ((FlxG.width / 2) * player);
		ID = noteData;
	}

	override function update(elapsed:Float) {
		if(resetAnim > 0) {
			resetAnim -= elapsed;
			if(resetAnim <= 0) {
				playAnim('static');
				resetAnim = 0;
			}
		}
		
		/*if(animation.curAnim.name == 'confirm' && !PlayState.isPixelStage) {
			updateConfirmOffset();
		}*/

		super.update(elapsed);
	}

	public function playAnim(anim:String, ?force:Bool = false) {
		animation.play(anim, force);
		centerOffsets();
		if(animation.curAnim == null || animation.curAnim.name == 'static') {
			colorSwap.hue = 0;
			colorSwap.saturation = 0;
			colorSwap.brightness = 0;
		} else {
			colorSwap.hue = ClientPrefs.arrowHSV[noteData % 4][0] / 360;
			colorSwap.saturation = ClientPrefs.arrowHSV[noteData % 4][1] / 100;
			colorSwap.brightness = ClientPrefs.arrowHSV[noteData % 4][2] / 100;

			if(animation.curAnim.name == 'confirm' && !PlayState.isPixelStage || animation.curAnim.name == 'confirm2' && !PlayState.isPixelStage) {
				updateConfirmOffset();
			}
		}
	}

	function updateConfirmOffset() { //TO DO: Find a calc to make the offset work fine on other angles
		centerOffsets();
		offset.x -= 13*(ClientPrefs.noteSize/0.7);
		offset.y -= 13*(ClientPrefs.noteSize/0.7);
	}
}
