package
{
	/**
	 * ...
	 * @author Andrew Simeon
	 */
	public class Assets
	{
		[Embed(source="../assets/test-overworld.oel", mimeType="application/octet-stream")]
		public static const DUNGEON_01_MAP:Class;
		
		[Embed(source = "../assets/overworldGrass.png")]
		public static const DUNGEON_01_GFX:Class;
	}
}