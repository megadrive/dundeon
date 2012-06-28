package
{
	import flash.display.Bitmap;
	import flash.ui.Mouse;
	
	import flashx.textLayout.formats.Float;
	
	import org.flixel.*;
	
	public class Square extends FlxSprite
	{
		[Embed(source = "../assets/grid.png")]
		public static var SQUARE_GFX:Class;
		public var squareImg:Bitmap = new SQUARE_GFX;
		public var squareImgOverlay:Bitmap = new SQUARE_GFX;
		private var hasBeenStamped:Boolean = false;
		public var selectedByCursor:Boolean = false;
		
		public var DEFAULT_SPRITE_ALPHA:Number = 0.3;
		public var MEDIUM_SPRITE_ALPHA:Number = 0.6;
		public var MAXIMUM_SPRITE_ALPHA:Number = 0.8;
		public var DEFAULT_SPRITE_SELECTED_COLOR:uint = 0xAAAAFF;
		public var MEDIUM_SPRITE_SELECTED_COLOR:uint = 0x8888FF;
		public var MAXIMUM_SPRITE_SELECTED_COLOR:uint = 0x4040FF;
		public var DEFAULT_SPRITE_COLOR:uint = 0xFFFFFF;
		
		public var grid:Grid = null;
		public var gridX:int = 0;
		public var gridY:int = 0;
		
		public function Square(X:Number = 0, Y:Number = 0, Width:Number = 0, Height:Number = 0)
		{			
			super(X, Y, SQUARE_GFX);
			
			this.alpha = DEFAULT_SPRITE_ALPHA;
		}
		
		override public function update():void
		{

		}
		
		/**
		 * Slowly fades sprite color to white (0xFFFFFF)
		 */
		public function fadeSpriteToWhite():void
		{
			// This is the worst code ever, I am sorry. To myself. Not to you, mega.
			var colorToAdd:uint = 0x000000;
			
			if(uint("0x" + this.color.toString(16).substr(0,1) + "00000") < 0xF00000)
			{
				colorToAdd += 0x100000;
			}
			
			if(uint("0x0" + this.color.toString(16).substr(1,1) + "0000") < 0x0F0000)
			{
				colorToAdd += 0x010000;
			}
			
			if(uint("0x00" + this.color.toString(16).substr(2,1) + "000") < 0x00F000)
			{
				colorToAdd += 0x001000;
			}
			
			if(uint("0x000" + this.color.toString(16).substr(3,1) + "00") < 0x000F00)
			{
				colorToAdd += 0x000100;
			}
			
			if(uint("0x0000" + this.color.toString(16).substr(4,1) + "0") < 0x0000F0)
			{
				colorToAdd += 0x000010;
			}
			
			if(uint("0x00000" + this.color.toString(16).substr(5,1)) < 0x00000F)
			{
				colorToAdd += 0x000001;
			}
			
			this.color += colorToAdd;
			// I would never feel sorry for you.
		}
		
		/**
		 * Flag this Square as being selected by the cursor
		 */
		public function setSelected(newSelection:Boolean):void
		{
			this.selectedByCursor = newSelection;
		}
		
		public function setColor(newColor:uint):void
		{
			this.color = newColor;
		}
		
		public function setAlpha(newAlpha:Number):void
		{
			this.alpha = newAlpha;
		}
		
		public function resetColor():void
		{
			this.color = DEFAULT_SPRITE_COLOR;
		}
		
		public function resetAlpha():void
		{
			this.alpha = DEFAULT_SPRITE_ALPHA;
		}
	}
}