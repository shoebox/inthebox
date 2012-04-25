package;

import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.events.TouchEvent;
import nme.Lib;
import org.shoebox.ui.gestures.TapGesture;
import org.shoebox.ui.gestures.TwoFingersSwipeGesture;

using org.shoebox.utils.system.flashevents.InteractiveObjectEv;

/**
 * ...
 * @author shoe[box]
 */

class Test extends Sprite{

	//private var _oTwix : TwoFingersSwipeGesture;
	private var _oTap : TapGesture;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			super( );
			
			Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
			Lib.current.stage.align     = StageAlign.TOP_LEFT;
			trace('constructor');

			/*
			_oTwix = new TwoFingersSwipeGesture( Lib.current.stage );
			_oTwix.mode = X;
			_oTwix.gDebug = graphics;
			_oTwix.onSwipe.connect( _onSwipe );
			_oTwix.execute( );
			*/

			_oTap = new TapGesture( Lib.current.stage );
			_oTap.onTap.connect( _onTap );
			_oTap.execute( );
		}

	
	// -------o public

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onSwipe( fx : Float , fy : Float ) : Void{
			trace('_onSwipe '+fx+' - '+fy+' = '+Lib.getTimer( ) );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onTap( e : TouchEvent ) : Void{
			trace('onTap ::: '+e);
		}

	// -------o misc
		
		public static function main () {
			Lib.current.addChild ( new Test() );		
		}
}

