package;

import haxe.Log;
import nme.display.StageAlign;
import nme.events.Event;
import nme.Lib;
import nme.display.Sprite;

import org.shoebox.display.particles.ParticleEmitter;
import org.shoebox.utils.frak.Frak;
import org.shoebox.utils.Perf;

/**
 * ...
 * @author shoe[box]
 */

class Test extends Sprite{

	public var iValue : Int;

	private var _oParticle : ParticleEmitter<SmokeParticle>;
	private var _iCount : Int;
	private var _iPrevTimer : Int;

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
			_run( );
		}
	
	// -------o public
				
			

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _run( ) : Void{
			_oParticle = new ParticleEmitter<SmokeParticle>( SmokeParticle , 100 , this , 3000 / 30 , true );
			_oParticle.setPosition( 200 , 200 );
			_oParticle.setVelocity( 2 , 0 );
			_oParticle.setWander( 0.5 );
			_oParticle.setTTL( 2000 );
			Lib.current.stage.addEventListener( Event.ENTER_FRAME , _onFrame , false );
			_iPrevTimer = Lib.getTimer( );

			addChild( new Perf( ) );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		private function _onFrame( e : Event ) : Void {
			var iDelay : Int = Lib.getTimer( ) - _iPrevTimer;
			_oParticle.update( iDelay );
			_iPrevTimer = Lib.getTimer( );
		}

	// -------o misc
		
		public static function main () {
			Lib.current.addChild ( new Test() );		
		}
}