package
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import org.flixel.*;
	import org.flixel.FlxObject;
	
	public class Grid extends FlxObject
	{
		public var grid:Array; 								// This is the grid for the game board. It is a grid.
		public var squaresHoveredOver:Array = new Array(); 	// Squares that the mouse has hovered over
		public var squaresInGrid:int = 11;					// Squares in the grid
		public var squareSize:int = 16;						// The pixel size of the square's bitmap image
		public var selected:Array = new Array();			// List of Squares selected by the mouse cursor
		
		public function Grid(X:Number = 0, Y:Number = 0, Width:Number = 0, Height:Number = 0)
		{
			super(X, Y, Width, Height);
			
			FlxG.state.add(this);			
			grid = new Array( new Array() );
			
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
						if(FlxG.mouse.justPressed())
						{
							square.setColor(square.MAXIMUM_SPRITE_SELECTED_COLOR);
							square.setAlpha(square.MAXIMUM_SPRITE_ALPHA);
							square.setSelected(true);
						}
						// CONTINUE SELECTION - User is dragging from a previously selected square
						else if(FlxG.mouse.pressed() && !square.selectedByCursor && isCellParallelToLatest(square))
						{
							square.setColor(square.MEDIUM_SPRITE_SELECTED_COLOR);
							square.setAlpha(square.MEDIUM_SPRITE_ALPHA);
							square.setSelected(true);
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
		 * Populates "selected" array with a list of
		 * all currently selected Squares in the grid
		 */
		public function populateSelected():void
		{
			// truncate selected
			selected.length = 0;
			
			for each(var x:Array in grid)
			{
				for each(var y:Square in x)
				{
					if (y.selectedByCursor)
					{
						selected.push(y);
					}
				}
			}
		}
		
		/**
		 * Checks if newly selected Square is parallel to the last selected Square
		 */
		public function isCellParallelToLatest(square:Square):Boolean
		{
			populateSelected();
			var last:Square = selected[selected.length - 1];
			var rv:Boolean = false;
			
			if(square.gridY == last.gridY)
			{
				// New Square is one square left or right of the current Square
				if( square.gridX == last.gridX - 1 || square.gridX == last.gridX + 1) rv = true;
			}
			else if(square.gridX == last.gridX)
			{
				// New Square is one square above or below of the current Square
				if( square.gridY == last.gridY - 1 || square.gridY == last.gridY + 1) rv = true;
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
	}
}