package
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	public class TestSprite extends FlxSprite
	{
		private static var GRIDMOVE:int = 16;	// Unit moves along a grid
		private static var FREEMOVE:int = 1;	// Unit moves freely
		
		private var movementStyle:int = FREEMOVE;	// Current movement mode	
		private var gridSize:int = 16;	// Size of the pseudo-grid
		private var movementDelay:int = 150;	// How often the player can move
		private var movementSpeed:int = movementStyle;	// Speed of the unit
		private var dy:int,dx:int;	// Movement speed in x and y
		private var timerVal:int = 0;	// Current timer value
		
		public var selectedByCursor:Boolean = false;	// The unit been selected to move
		private var movementTimer:Timer = new Timer(movementDelay);
		private var movementArray:Array = new Array();	// List of moves to execute during an action phase
		private var pixelsLeftToWalk:uint = 0;
		private var slack:int = 3;	//px
		
		public var currentMap:Map = null;
		
		public function TestSprite(X:Number = 0, Y:Number = 0, SimpleGraphic:Class = null)
		{
			super(X, Y);
			movementTimer.addEventListener(TimerEvent.TIMER, moveUnit);
		}
		
		/**
		 * Handles and order execution of units
		 */
		override public function update():void
		{
			if(FlxG.keys.justPressed("M"))
			{
				if(movementStyle == FREEMOVE) movementStyle = GRIDMOVE;
				else if(movementStyle == GRIDMOVE) movementStyle = FREEMOVE;
				
				movementSpeed = movementStyle;
				trace(movementStyle);
			}
			
			// The cursor is over this unit
			if(FlxG.mouse.screenX >= this.x && FlxG.mouse.screenX < this.x + this.width
				&& FlxG.mouse.screenY >= this.y && FlxG.mouse.screenY < this.y + this.height)
			{
				// The cursor has clicked this unit
				if(FlxG.mouse.justPressed())
				{
					this.selectedByCursor=true;
				}
			}
			
			if(FlxG.mouse.justReleased() && this.selectedByCursor)
				this.selectedByCursor=false;
			
			// OH SHIT WE GOTTA MOVE
			if(movementArray[0]!=null)
			{
				if(!movementTimer.running && movementStyle == GRIDMOVE)
				{
					movementTimer.start();
				}
				else if(movementStyle == FREEMOVE)
				{
					moveUnitFree();
				}
			}			
		}
		
		/**
		 * Moves unit through movementArray
		 * NOTE: For FREEMOVE only
		 */
		private function moveUnitFree():void
		{
			// There are no more movements left, kill the array
			if(movementArray.length == 0)
			{
				movementTimer.stop();
				movementArray.length = 0;
			}
			// There are movements left to execute
			else
			{				
				var sq:Square = movementArray[movementArray.length - 1];
				var diffX:int = sq.x - this.x;
				var diffY:int = sq.y - this.y;
				var mag:int = Math.sqrt(diffX * diffX + diffY * diffY);
				
				// unitise
				var unitX:int = diffX / mag;
				var unitY:int = diffY / mag;
				
				var velX:int;
				var velY:int;
				
				// attach speed, then add to pos
				velX = unitX * this.movementSpeed;
				velY = unitY * this.movementSpeed;
				
				this.x += velX;
				this.y += velY;
				
				if(this.x == sq.x && this.y == sq.y)
					movementArray.pop();
			}
		}
		
		/**
		 * Moves unit through movementArray
		 * NOTE: For GRIDMOVE only, called through movementTimer
		 */
		private function moveUnit(Event:TimerEvent):void
		{
			// There are no more movements left, kill the array
			if(movementArray.length == 0)
			{
				movementTimer.stop();
				movementArray.length = 0;
			}
			// There are movements left to execute
			else
			{				
				var sq:Square = movementArray[movementArray.length - 1];
				var diffX:int = sq.x - this.x;
				var diffY:int = sq.y - this.y;
				var mag:int = Math.sqrt(diffX * diffX + diffY * diffY);
				
				if( Math.abs(diffX) > slack || Math.abs(diffY) > slack )
				{
					// unitise
					var unitX:int = diffX / mag;
					var unitY:int = diffY / mag;
					
					// attach speed, then add to pos
					var velX:int = unitX * this.movementSpeed;
					var velY:int = unitY * this.movementSpeed;

					this.x += velX;
					this.y += velY;
				}
				
				movementArray.pop();
			}
		}
		
		/**
		 * Overwrites current movement array with the REVERSED list
		 * of moves to execute
		 */
		public function setMovementArray(newArray:Array):void
		{
			if(movementArray.length>0) movementArray.length = 0;
			
			for(var i:int = newArray.length - 1; i>0; i--)
			{
				movementArray.push(newArray[i]);
			}
		}
		
		private function checkCollisionInNextMovementStep(dx:int, dy:int):Boolean
		{
			var obj:FlxObject = new FlxObject(x + dx, y + dy, 16, 16);			
			return FlxG.overlap(obj, currentMap.Collidables);
		}
	}
}