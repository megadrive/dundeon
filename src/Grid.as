package
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import org.flixel.*;
	import org.flixel.FlxObject;
	
	public class Grid extends FlxObject
	{
		public var grid:Array; 								// Grid for the game board.
		public var units:Array;								// List of all units on the game board.
		public var squaresHoveredOver:Array = new Array(); 	// Squares that the mouse has hovered over
		public var squaresInGrid:int = 11;					// Squares in the grid
		public var squareSize:int = 16;						// The pixel size of the square's bitmap image
		public var selected:Array = new Array();			// List of Squares selected by the mouse cursor
		
		public var cursorPreviousLocationX:Number = 0;
		public var cursorPreviousLocationY:Number = 0;
		public var cursorDirection:Number;				// Tracks direction of cursor movement
		
		public function Grid(X:Number = 0, Y:Number = 0, Width:Number = 0, Height:Number = 0)
		{
			super(X, Y, Width, Height);
			
			FlxG.state.add(this);			
			grid = new Array( new Array() );
			units = new Array();
			
			for(var x:int = 0; x<squaresInGrid - 1; x++)
			{
				for(var y:int = 0; y<squaresInGrid - 1; y++)
				{
					grid[x][y] = new Square(x * squareSize, y * squareSize, squareSize, squareSize);
					grid[x][y].gridX = x;
					grid[x][y].gridY = y;
					grid[x][y].grid = this;
				}

				grid.push(new Array());
			}
		}
		
		/**
		 * Handles most grid and square logic
		 * Primarily as it relates to mouse cursor movement and selection
		 */
		public override function update():void
		{
			var tmpSquare:Square // this does a very important thing don't question it
			
			// RELEASED SELECTION - Cursor has just stopped highlighting squares
			if(FlxG.mouse.justReleased())
			{				
				for each(var u:TestSprite in units)
				{
					// Give the unit told to move the list of moves to execute
					if(u.selectedByCursor) u.setMovementArray(selected);
				}
				
				selected.length = 0;
			}
			
			for each(var x:Array in grid)
			{
				for each(var square:Square in x)
				{
					// Unselect current square upon user releasing the mouse button, should the square be selected
					if(!FlxG.mouse.pressed() && square.selectedByCursor) square.selectedByCursor = false;
					
					// Check if cursor's position is over the current square
					if(FlxG.mouse.screenX >= square.x && FlxG.mouse.screenX < square.x + square.width
						&& FlxG.mouse.screenY >= square.y && FlxG.mouse.screenY < square.y + square.height)
					{					
						// NEW SELCTION - User has started selecting squares
						if(FlxG.mouse.justPressed() && !square.selectedByCursor)
						{
							square.setColor(square.MAXIMUM_SPRITE_SELECTED_COLOR);
							square.setAlpha(square.MAXIMUM_SPRITE_ALPHA);
							square.setSelected(true);
							selected.push(square);
							
							cursorPreviousLocationX = FlxG.mouse.x;
							cursorPreviousLocationY = FlxG.mouse.y;
						}
						// CONTINUE SELECTION - User is dragging from a previously selected square
						else if(FlxG.mouse.pressed() && !square.selectedByCursor)
						{
							// BLINKING LOGIC //
							tmpSquare = selected[selected.length - 1];	// Grab the square selected before this
							tmpSquare.setLastSelected(false);			// And make its last selected bool false
							square.setLastSelected(true);				// So the new square can be last selected
							
							if(!isCellParallelToLatest(square))
							{
								autocompletePath(selected[selected.length-1], square);
							}
							
							square.setColor(square.MEDIUM_SPRITE_SELECTED_COLOR);
							square.setAlpha(square.MEDIUM_SPRITE_ALPHA);
							square.setSelected(true);
							selected.push(square);
						}
						// OVERLAPPING SELECTION - User is dragging over an already selected square
						// for some ungodly reason
						else if(FlxG.mouse.pressed() && square.selectedByCursor && isCellParallelToLatest(square) && square!=selected[selected.length - 1])
						{
							// BLINKING LOGIC //
							tmpSquare = selected[selected.length - 1]; 	// Grab the square selected before this
							tmpSquare.setLastSelected(false);			// And make its last selected bool false
							square.setLastSelected(true);				// So the new square can be last selected
							
							square.setColor(square.MEDIUM_SPRITE_OVERLAP_COLOR);
							selected.push(square);							
						}
						// NO SELECTION - Square is being hovered over, but is not selected
						else if(!square.selectedByCursor)
						{
							square.setColor(square.DEFAULT_SPRITE_SELECTED_COLOR);
						}
					}
					// Square does not have the mouse cursor hovering over it,
					// so check if it has recently been hovered over
					else if(square.color!=square.DEFAULT_SPRITE_COLOR && !square.selectedByCursor)
					{
						// Fade cursor sprite colour to white (assumed defualt)
						square.fadeSpriteToWhite();
					}
					
					// If square has recently been selected, but is no longer selected,
					// reset the square sprite's alpha value to default.
					if(square.alpha != square.DEFAULT_SPRITE_ALPHA && !square.selectedByCursor)
					{
						square.setAlpha(square.DEFAULT_SPRITE_ALPHA);
					}
				}
			}
		}
		
		/**
		 * Auto-completes / auto-predicts the gap between the currently selected square,
		 * and the previously selected square. To be used when two squares aren't adjacent.
		 * Completion is done in a diagonal manner, and modifies the "selected" array,
		 * keeping order as it goes.
		 * Params:
		 * @previous - The last selected square parallel to another square
		 * @current - The square the cursor is currently over
		 */
		public function autocompletePath(previous:Square, current:Square):void
		{
			// Sets up initial varibles
			var diffX:int = current.gridX - previous.gridX; // Diff finds the distance between the previous and current grid
			var diffY:int = current.gridY - previous.gridY;
			var directionX:int=0;									// Two directional statements find which direction to autocomplete in.
			if(diffX != 0) directionX = diffX / Math.abs(diffX);	// -1 is up / left, 0 is no change in direction, 1 is down / right.
			var directionY:int=0;
			if(diffY != 0) directionY = diffY / Math.abs(diffY);
			// The square to be autocompleted
			var sq:Square;

			// The current position of "sq" / "previous" is not at the same position as the "current" square
			while(diffX != 0 || diffY != 0)
			{
				// Square is not in-line with the X axis
				if(diffX!=0)
				{
					directionX = diffX / Math.abs(diffX);						// Recalculate direction heading				
					sq = grid[(previous.gridX + directionX)][previous.gridY];	// Move square to next location
					// Update square on the board
					sq.setColor(sq.MEDIUM_SPRITE_SELECTED_COLOR);
					sq.setAlpha(sq.MEDIUM_SPRITE_ALPHA);
					sq.setSelected(true);
					selected.push(sq);											// Put square in array
					previous = sq;												// Update location of previously adjacent square
					diffX -= directionX;										// Update difference between previous and current on X axis
				}
				
				// Square is not in-line with the Y axis
				if(diffY!=0)
				{
					directionY = diffY / Math.abs(diffY);
					sq = grid[previous.gridX][previous.gridY + directionY];
					// Update square on the board
					sq.setColor(sq.MEDIUM_SPRITE_SELECTED_COLOR);
					sq.setAlpha(sq.MEDIUM_SPRITE_ALPHA);
					sq.setSelected(true);
					selected.push(sq);	
					previous = sq;
					diffY -= directionY;	
				}
			}
		}
		
		/**
		 * Checks if newly selected Square is parallel to the last selected Square
		 * Params:
		 * @square - The current square to check
		 * @margin - the distance away a parallel square can be (default is 1)
		 */
		public function isCellParallelToLatest(square:Square, margin:Number = 1):Boolean
		{
			var last:Square = selected[selected.length - 1];
			var rv:Boolean = false;
			
			if(square.gridY == last.gridY)
			{
				// New Square is one square left or right of the current Square
				if ( square.gridX == last.gridX - margin || square.gridX == last.gridX + margin)
				{
					rv = true;
				}
			}
			else if(square.gridX == last.gridX)
			{
				// New Square is one square above or below of the current Square
				if ( square.gridY == last.gridY - margin || square.gridY == last.gridY + margin)
				{
					rv = true;
				}
			}
			
			return rv;
		}
		
		/**
		 * Adds the nested array "grid" to FlxG's little party thing.
		 */
		public function addNestedArrayToFlxG():void
		{
			for(var x:int = 0; x<squaresInGrid - 1; x++)
			{
				for(var y:int = 0; y<squaresInGrid - 1; y++)
				{
					FlxG.state.add(grid[x][y]);
				}
			}
		}
		
		/**
		 * Adds a new unit into the units array
		 */
		public function addUnit(newUnit:TestSprite):void
		{
			units.push(newUnit);
		}
		
		/**
		 * Removes unit from array.
		 * NOTE: Order of the array is not kept!
		 */
		public function removeUnit(unitToRemove:TestSprite):void
		{
			for(var i:int=0; i<units.length-1; i++)
			{
				// Have found the element we want to remove
				if(units[i] == unitToRemove)
				{
					units[i] = units[i - 1];	// Duplicate the last element over the top of the current element
					units.pop();				// And remove the original of the duplicate
				}
			}
		}
	}
}