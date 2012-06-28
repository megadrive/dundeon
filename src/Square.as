package
{
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
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
		public var lastSelectedByCursor:Boolean = false;
		
		public var DEFAULT_SPRITE_ALPHA:Number = 0.3;
		public var MEDIUM_SPRITE_ALPHA:Number = 0.6;
		public var MAXIMUM_SPRITE_ALPHA:Number = 0.8;
		public var DEFAULT_SPRITE_SELECTED_COLOR:uint = 0xAAAAFF;
		public var MEDIUM_SPRITE_SELECTED_COLOR:uint = 0x8888FF;
		public var MAXIMUM_SPRITE_SELECTED_COLOR:uint = 0x4040FF;
		public var BLINKING_SPRITE_COLOR:uint = 0xAFAFFF;
		public var DEFAULT_SPRITE_COLOR:uint = 0xFFFFFF;
		
		public var lastColor:uint; 									// Used for blinking animation
		
		public var grid:Grid = null;
		public var gridX:int = 0;
		public var gridY:int = 0;
		
		private var animatedBlinkingTimer:Timer = new Timer(500);	// Timer to alternate blinking during an animation
		
		public function Square(X:Number = 0, Y:Number = 0, Width:Number = 0, Height:Number = 0)
		{			
			super(X, Y, SQUARE_GFX);
			
			this.alpha = DEFAULT_SPRITE_ALPHA;
			animatedBlinkingTimer.addEventListener(TimerEvent.TIMER, blink);
		}
		
		override public function update():void
		{
			// Simply checks if this square is selected, and being hovered over.
			// If so, do a little blinking animation.
			if(this.lastSelectedByCursor)
			{
				// Square is selected and not blinking, turn ON blinking
				if(this.selectedByCursor && !animatedBlinkingTimer.running)
				{
					lastColor = this.color;
					animatedBlinkingTimer.start(); // Start the timer to animate blinking
				}
				
				// Square is not selected and blinking, turn OFF blinking
				if(!this.selectedByCursor && animatedBlinkingTimer.running)
				{
					setColor(lastColor); // oh and also reset the color manually if not already
					animatedBlinkingTimer.stop();
				}
			}
			// Square is not being hovered over, but is still blinking. Turn OFF blinking.
			else if(animatedBlinkingTimer.running)
			{
				setColor(lastColor); // Reset the color manually
				animatedBlinkingTimer.stop();
			}
		}
		
		/**
		 * Alternate sprite colours and alpha to appear blinking
		 */
		public function blink(Event:TimerEvent):void
		{
			if(this.color != BLINKING_SPRITE_COLOR)
			{
				lastColor = this.color;
				setColor(BLINKING_SPRITE_COLOR);
			}
			else
				setColor(lastColor);
		}
		
		/**
		 * Slowly fades sprite color to white (0xFFFFFF)
		 */
		public function fadeSpriteToWhite():void
		{
			// This is the worst code ever, I am sorry. To myself. Not to you, mega.
			// Don't worry, it's okay. It's not your fault you don't know how to use bitwise operators. :)
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
		
		/**
		 * Flag this Square as being the newest selected square
		 */
		public function setLastSelected(newSelection:Boolean):void
		{
			this.lastSelectedByCursor = newSelection;
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