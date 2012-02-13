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
	private var _oTree : QuadTree<Sprite>;

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
				sp.graphics.clear( );
				sp.graphics.lineStyle( 0.1 , 0xFFFFFF , 0.2 );
				
			addChild( sp );
			
			_oTree = new QuadTree<Sprite>( new AABB( 0 , 0 , 800 , 600 ) , 10 , sp.graphics );
			
			var o : AABB;
			var dx : Float;
			var dy : Float;
			var item : Sprite;
			for( i in 0...400 ){
				dx = Math.random( ) * 800;
				dy = Math.random( ) * 600;

				item = new Sprite( );
				item.graphics.beginFill( 0x00FF00 );
				item.graphics.drawRect( dx , dy , 10 , 10 );
				item.graphics.endFill( );
				item.alpha = 0.25;
				sp.addChild( item );

				o = new AABB( dx , dy , dx + 10 , dy + 10 );
				_oTree.putArray( [ item , item , item ] , o );
			}

			sp.graphics.lineStyle( 1 , 0xFF0000 , 0.5 );
			sp.graphics.drawRect( 500 , 100 , 200 , 200 );
			
			var n : Int = Lib.getTimer( );
			var res : Array<Sprite> = _oTree.get( new AABB( 500 , 100 , 700 , 300 ) );
			for( item in res ){
				item.alpha = 1;
			}

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