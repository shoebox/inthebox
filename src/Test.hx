package;

import haxe.Log;
import nme.display.StageAlign;
import nme.events.Event;
import nme.Lib;
import nme.display.Sprite;

import org.shoebox.utils.frak.Frak;

/**
 * ...
 * @author shoe[box]
 */

class Test extends Sprite{

	public var iValue : Int;

	private var _iCount : Int;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			super( );
			iValue = 10;
			#if flash
			Log.setColor( 0xFFFFFF );
			#end
			Lib.current.stage.align = StageAlign.TOP_LEFT;
			Lib.current.stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;

			addChild( Frak.getInstance( ) ) ;

			Frak.registerAlias( 'Test' , TestCommand , 'test command' , false );
			Frak.registerVariable( 'varname' , this , 'iValue' );
			Frak.unRegisterVariable( 'varname' );
		}
	
	// -------o public
				
				

	// -------o protected
	
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onFrame( e : Event ) : Void{
			trace( iValue  );
		}

	// -------o misc
		
		public static function main () {
			Lib.current.addChild ( new Test() );		
		}
}