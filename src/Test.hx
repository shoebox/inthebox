package;

import haxe.Log;
import nme.display.Tilesheet;
import nme.display.StageAlign;
import nme.events.Event;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.Lib;
import nme.display.Sprite;

import org.shoebox.collections.QuadTree;
import org.shoebox.display.AABB;
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
	private var _oTree : QuadTree<Int>;

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

			var sp : Sprite = new Sprite( );
				sp.graphics.lineStyle( 1 , 0x0000FF , 1.0 );
				sp.graphics.drawRect( 0 , 0 , 600 , 400 );
			//
				sp.graphics.lineStyle( 0.1 , 0x00FF00 , 1.0 );
				sp.graphics.drawRect( 10 , 100 , 100 , 100 );
				sp.graphics.drawRect( 10 , 390 , 100 , 100 );
				sp.graphics.drawRect( 10 , 401 , 100 , 100 );
			addChild( sp );
			
			_oTree = new QuadTree<Int>( 0 , 0 , 600, 400 , 10 , sp.graphics );
			trace( _oTree.put( 0 , 10 , 100 , 100 , 100 ) );
			return;
			trace( _oTree.put( 0 , 10 , 390 , 100 , 100 ) );
			trace( _oTree.put( 0 , 10 , 401 , 100 , 100 ) );
		
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