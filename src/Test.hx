package ;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import org.shoebox.datas.structures.MemGraph;
import org.shoebox.signals.Signal;

import org.shoebox.datas.structures.MemRange.MemoryIntTypes;
import org.shoebox.datas.structures.MemRange.MemoryInt;



import flash.Lib;
using org.shoebox.signals.flashevents.SignalsMouse;
using org.shoebox.signals.flashevents.SignalsStage;

/**
 * ...
 * @author shoe[box]
 */
class Test extends Sprite{

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			super( );
			trace("constructor");
			/*
			var m = new MemoryInt( MemoryIntTypes.BYTE , 100 );
				m.set( 10 , 255 );
				
			trace( m.get( 10 ) );
			m.set( 10 , 43 );
			trace( m.get( 10 ) );
			*/
			
			var g = new MemGraph( 50 , 6 );
				g.add( 10 , 66 );
				g.add( 10 , 67 );
				g.add( 10 , 68 );
				g.remove( 10 , 67 );
				
		}
	
	// -------o public
				
		

	// -------o protected
	
		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _onResize( e : Event ) : Void {
			trace("e ::: " + e);
		}
	
		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _onSignal_event( e : MouseEvent ) : Void {
			trace("_onSignal_event ::: " + e);
			trace( e.target );
		}
	
		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _onSignal( s : String , e : Event , i : Int ) : Void {
			trace('onSignal :: $s | $i | $e');		
		}

	// -------o misc
	
}


/**
 * ...
 * @author shoe[box]
 */
class SignalTest extends Signal<String->Event->Int->Void>{
}