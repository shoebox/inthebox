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
			
			Log.setColor( 0xFFFFFF );
			Lib.current.stage.align = StageAlign.TOP_LEFT;
			Lib.current.stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
			addChild( Frak.getInstance( )) ;

			Lib.current.stage.addEventListener( Event.ENTER_FRAME , _onFrame , false );
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
			//trace('toto'+Lib.getTimer( ) );
		}

	// -------o misc
		
		public static function main () {
			Lib.current.addChild ( new Test() );		
		}
}