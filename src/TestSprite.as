package
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flixel.*;
	
	public class TestSprite extends FlxSprite
	{
		private var gridSize:int = 16; 			// Size of the pseudo-grid
		private var movementDelay:int = 40; 	// How often the player can move
		private var movementSpeed:int = 16;		// Speed of the unit
		private var dy:int,dx:int; 				// Movement speed in x and y
		private var timerVal:int = 0;			// Current timer value
		
		public var selectedByCursor:Boolean = false;	// The unit been selected to move
		private var movementTimer:Timer = new Timer(movementDelay);
		private var movementArray:Array = new Array();	// List of moves to execute during an action phase
		private var pixelsLeftToWalk:uint = 0;
		private var slack:int = 3; //px
		
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
			
			// OH SHIT WE GOTTA MOVE
			if(movementArray[0]!=null)
			{
				movementTimer.start();
			}			
		}
		
		/**
		 * Moves unit through movementArray
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