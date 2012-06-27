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
		public var selected:Array = new Array();
		
		public function Grid(X:Number = 0, Y:Number = 0, Width:Number = 0, Height:Number = 0)
		{
			super(X, Y, Width, Height);
			
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
		
		public function populateSelected():void
		{
			// truncate selected
			selected.length = 0;
			
			trace(' ');
			
			for each(var x:Array in grid)
			{
				for each(var y:Square in x)
				{
					if (y.selectedByCursor)
					{
						trace(y.gridX, y.gridY);
						selected.push(y);
					}
				}
			}
		}
		
		public function isCellParallelToLatest(square:Square):Boolean
		{
			populateSelected();
			var last:Square = selected[selected.length - 1];
			var rv:Boolean = false;
			
			if( square.gridX == last.gridX - 1 )
			{
				rv = true;
			}
			else if( square.gridX == last.gridX + 1 )
			{
				rv = true;
			}
			else if( square.gridY == last.gridY - 1 )
			{
				rv = true;
			}
			else if( square.gridY == last.gridY + 1 )
			{
				rv = true;
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