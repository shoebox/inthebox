package;

import haxe.Log;
import nme.display.Tilesheet;
import nme.display.StageAlign;
import nme.events.Event;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.Lib;
import nme.display.Sprite;

import org.shoebox.display.particles.ParticleEmitter;
import org.shoebox.utils.frak.Frak;
import org.shoebox.utils.Perf;
import org.shoebox.utils.system.Signal;

/**
 * ...
 * @author shoe[box]
 */

class Test extends Sprite{

	public var iValue : Int;

	private var _oParticle : ParticleEmitter;
	private var _iCount : Int;
	private var _iPrevTimer : Int;
	private var _oSignal : Signal;

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
			//_run( );

			_oSignal = new Signal( );
			_oSignal.connect( _onSignal4 , 'toto' , 20 , false );
			_oSignal.connect( _onSignal3 , 'toto' , 20 , false );
			_oSignal.connect( _onSignal2 , 'toto' , 10 , false );
			_oSignal.connect( _onSignal1 , 'toto' , 30 , true );
			_oSignal.disconnect( _onSignal4 , 'toto');
			trace('----- true : '+_oSignal.isRegistered( _onSignal1 , 'toto'));
			trace('emit');
			trace('---------------- 1 - 3 - 2');
			_oSignal.emit( 'toto' , ['toto'] );
			trace('----- false : '+_oSignal.isRegistered( _onSignal1 , 'toto'));
			trace('---------------- 3 - 2');
			_oSignal.emit( 'toto' , ['toto'] );
		}
	
	// -------o public
			
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onSignal4( s : String ) : Void{
			trace('onSignal4'+s);
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onSignal1( s : String ) : Void{
			trace('_onSignal1 ::: '+s);
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onSignal2( s : String ) : Void{
			trace('_onSignal2 ::: '+s);
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onSignal3( s : String ) : Void{
			trace('_onSignal3 ::: '+s);
		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _run( ) : Void{
			
			var p : Tilesheet = new Tilesheet( ApplicationMain.getAsset( 'assets/smoke.png' ) );
				p.addTileRect( new Rectangle( 0 , 0 , 32 , 32  ) , new Point( 16 , 16 ) );

			_oParticle = new ParticleEmitter( p , this.graphics );
			
			scrollRect = new Rectangle( 0 , 0 , Lib.current.stage.stageWidth , Lib.current.stage.stageHeight );
			

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
			
			_oParticle.emit( 0 , 400 , 300 , 0.1 , 0.0 , 2500 , 4.0 , Math.random( ) * 360 , Math.random( ) * 2 + 0.5 , 0 );
			
			var iDelay : Int = Lib.getTimer( ) - _iPrevTimer;
			_oParticle.update( iDelay );
			_iPrevTimer = Lib.getTimer( );
		}

	// -------o misc
		
		public static function main () {
			Lib.current.addChild ( new Test() );		
		}
}