package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		private var _map:Map = new Map();
		private var _grid:Grid;	
		
		public var maxUnits:int = 6;

		override public function create():void
		{
			super.create();

			_map.loadLevel(Assets.DUNGEON_01_MAP, Assets.DUNGEON_01_GFX);
			add(_map);
			
			_grid = new Grid(0, 0, 100, 100);
			_grid.addNestedArrayToFlxG();

			for(var i:int=0; i<maxUnits; i++)
			{
				var unit:TestSprite = new TestSprite();
				unit.x = (Math.round(Math.random() * (i*2)) * _grid.squareSize) ;
				unit.y = (Math.round(Math.random() * (i*2)) * _grid.squareSize) ;
				unit.currentMap = _map;
				add(unit);
				_grid.addUnit(unit);
			}
		}

		override public function update():void
		{
			super.update();
			for each(var u:TestSprite in _grid.units)
			{
				FlxG.collide(u, _map.Collidables);
			}
		}
	}
}