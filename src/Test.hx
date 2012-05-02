package;

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.display.Tilesheet;
import nme.events.Event;
import nme.events.TouchEvent;
import nme.geom.Rectangle;
import nme.installer.Assets;
import nme.Lib;
import org.shoebox.display.particles.ParticleEmitter;
import org.shoebox.ui.gestures.TapGesture;
import org.shoebox.ui.gestures.TwoFingersSwipeGesture;

import org.shoebox.libs.nevermind.entity.SteeringEntity;
import org.shoebox.libs.nevermind.behaviors.Arrive;
import org.shoebox.libs.nevermind.behaviors.Seek;
import org.shoebox.libs.nevermind.behaviors.Wander;
import org.shoebox.libs.nevermind.behaviors.AvoidCicles;
import org.shoebox.core.Vector2D;
using org.shoebox.utils.system.flashevents.InteractiveObjectEv;

/**
 * ...
 * @author shoe[box]
 */

class Test extends Sprite{

	private var _iPrev : Int;
	private var _aParticles : Array<CustomParticle>;
	private var _oSheet : Tilesheet;
	private var _sp : Sprite;
	private var _bmpPion : Bitmap;
	private var _oCircle : AvoidCicles;

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


			var q = new org.shoebox.net.LoadingQueue( );
				q.add( 0 , 'https://www.google.com/images/srpr/logo3w.png' );
				q.add( 1 , 'https://www.google.com/images/srpr/logo3w.png' );
				q.add( 2 , 'https://www.google.com/images/srpr/logo3w.png' );
				q.add( 3 , 'https://www.google.com/images/srpr/logo3w.png' );
				q.run( );

			return;
			nme.ui.Mouse.hide( );
			var spMain = new Sprite( );
				//spMain.scaleX = spMain.scaleY = 0.5;
			addChild( spMain );

			spMain.addChild( new Bitmap( nme.installer.Assets.getBitmapData('assets/plateau.png') ) );
			spMain.addChild( _sp = new Sprite( ) );
			_oSheet = new Tilesheet( nme.installer.Assets.getBitmapData('assets/sheet.png'));
			_oSheet.addTileRect( new nme.geom.Rectangle( 0 , 0 , 128 , 128 ) , new nme.geom.Point( 64 , 64 ) );
			_aParticles = [ ];
			var p;
			var v = new Vector2D( Lib.current.stage.mouseX , Lib.current.stage.mouseY );
			_oCircle = new AvoidCicles( );
			_oCircle.addCircle( Lib.current.stage.mouseX , Lib.current.stage.mouseY , 20 );
			for( i in 0...50 ){
				p = new CustomParticle( );
				p.position.x = Lib.current.stage.mouseX + Math.random( ) * 100;
				p.position.y = Lib.current.stage.mouseY + Math.random( ) * 100;
				p.oSeek.toPosition( v );
				p.oArrive.toPosition( v );
				//p.addBehavior( _oCircle );
				_aParticles.push( p );
			}

			onFrame( ).connect( _onFrame );
			_bmpPion = new Bitmap( Assets.getBitmapData( 'assets/pion.png') );
			spMain.addChild( _bmpPion );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onFrame( _ ) : Void{
			
			var a : Array<Float> = [ ];
			_oCircle.getCircle( 0 ).position.x = Lib.current.stage.mouseX;
			_oCircle.getCircle( 0 ).position.y = Lib.current.stage.mouseY;
			var v = new Vector2D( Lib.current.stage.mouseX , Lib.current.stage.mouseY );
			var i : Int = 0;
			for( p in _aParticles ){
				p.oSeek.toPosition( v );
				p.oArrive.toPosition( v );
				p.update( );
				//graphics.drawCircle( p.position.x , p.position.y , 10 );

				a[ i++ ] = p.position.x;
				a[ i++ ] = p.position.y;
				a[ i++ ] = 0;
				a[ i++ ] = p.rotation;
				a[ i++ ] = 0.1;
			}
			_bmpPion.x = v.x - 90;
			_bmpPion.y = v.y - 111;
			_sp.graphics.clear( );
			_oSheet.drawTiles( _sp.graphics , a , false , Tilesheet.TILE_ALPHA | Tilesheet.TILE_ROTATION );
		}

	// -------o misc
		
		public static function main () {
			Lib.current.addChild ( new Test() );		
		}
}

/**
 * ...
 * @author shoe[box]
 */

class CustomParticle extends SteeringEntity{

	public var oArrive : Arrive;
	public var oSeek : Seek;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			super( );
			maxForce = 5000;
			addBehavior( oSeek = new Seek( ) );
			addBehavior( oArrive = new Arrive( ) );
			addBehavior( new Wander( 3.5 , 1 ) );
		}
	
	// -------o public
		
	// -------o protected
	
	// -------o misc
	
}
