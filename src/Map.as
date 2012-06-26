package
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Andrew Simeon
	 */
	public class Map extends FlxTilemap
	{
		private var _collidables:FlxGroup = new FlxGroup();
		public function get Collidables():FlxGroup { return _collidables; }

		public var playerEntryPoint:FlxPoint;

		public function Map()
		{
			super();
			onInit();
		}

		/**
		 * This should be overridden with a call to loadLevel with appropriate assets.
		 */
		public function onInit():void
		{
			
		}
		
		/**
		 * Loads a level.
		 * @param	map
		 * @param	graphic
		 */
		public function loadLevel(map:Class, graphic:Class):void
		{
			var xml:XML = Utilities.getXML(map);
			
			var tiles:XML = xml.General[0];
			this.loadMap(tiles, graphic, 16, 16, OFF, 0, 0, 1);
			loadCollision(xml.Collidables[0]);
		}
		
		/**
		 * Loads the collision into collidables.
		 * @param	xml
		 */
		public function loadCollision(xml:XML):void
		{
			if (xml)
			{
				var rows:Array = xml.toString().split('\n');
				var rowNum:int = 0;
				for each( var row:String in rows )
				{
					var rowLength:int = row.length;
					for (var col:int = 0; col < rowLength; col++)
					{
						if (int(row.charAt(col)) > 0)
						{
							var obj:FlxObject = new FlxObject(col * 16, rowNum * 16, 16, 16);
							obj.immovable = true;
							_collidables.add(obj);
						}
					}
					rowNum++;
				}
			}
		}
	}
}