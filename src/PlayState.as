package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		public var player:TestSprite = new TestSprite();

		private var _map:Map = new Map();
		private var _grid:Grid;	

		override public function create():void
		{
			super.create();

			_map.loadLevel(Assets.DUNGEON_01_MAP, Assets.DUNGEON_01_GFX);
			add(_map);
			
			_grid = new Grid(0, 0, 100, 100);
			_grid.addNestedArrayToFlxG();

			player.x = FlxG.width / 2;
			player.y = FlxG.height / 2;
			player.currentMap = _map;
			add(player);
			_grid.addUnit(player);
		}

		override public function update():void
		{
			super.update();
			FlxG.collide(player, _map.Collidables);
		}
	}
}