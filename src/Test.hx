package;

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.BlendMode;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.display.Tilesheet;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.geom.Matrix;
import nme.geom.Rectangle;
import nme.installer.Assets;
import nme.Lib;
import org.shoebox.display.particles.ParticleEmitter;
import org.shoebox.ui.gestures.TapGesture;
import org.shoebox.ui.gestures.TwoFingersSwipeGesture;

import org.shoebox.display.AnimatedTile;
import org.shoebox.libs.nevermind.entity.SteeringEntity;
import org.shoebox.libs.nevermind.behaviors.Arrive;
import org.shoebox.libs.nevermind.behaviors.Seek;
import org.shoebox.libs.nevermind.behaviors.Wander;
import org.shoebox.libs.nevermind.behaviors.AvoidCicles;
import org.shoebox.core.Vector2D;
import org.shoebox.geom.FPoint;
import org.shoebox.net.Paths;
using org.shoebox.utils.system.flashevents.InteractiveObjectEv;
import nme.display.JointStyle;
import nme.display.CapsStyle;
import nme.display.LineScaleMode;
import org.shoebox.core.BoxMath;
import org.shoebox.display.containers.Parallax;
/**
 * ...
 * @author shoe[box]
 */

class Test extends Sprite{

	private var _aParticles  : Array<CustomParticle>;
	private var _aParticles2 : Array<CustomParticle2>;
	private var _bmpPion     : Bitmap;
	private var _bmpParticle : BitmapData;
	private var _bMouseDown  : Bool;
	private var _iPrev       : Int;
	private var _oCircle     : AvoidCicles;
	private var _oSheet      : Tilesheet;
	private var _sp          : Sprite;
	private var _spDragged   : Sprite;
	private var _spParticles : Sprite;
	private var _spTrail     : Sprite;
	private var _spTest      : Sprite;

	private var _fStart    : FPoint;
	private var _fPrev     : FPoint;
	private var _fDist     : FPoint;
	private var _iColor    : Int;
	private var _fSize     : Float;
	private var _fPrevDist : Float;
	private var _oMat : Matrix;
	private var _aColors : Array<Int>;

	public var MIN_MOVE : Float;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			super( );
			trace('nme.system.Capabilities.screenDPI ::: '+nme.system.Capabilities.screenDPI);
			Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
			Lib.current.stage.align     = StageAlign.TOP_LEFT;
			MIN_MOVE = 30 / 254 * nme.system.Capabilities.screenDPI;
			_aColors = [ 0x000000,0x691316,0x00743F,0x91BB35,0xFFD41F,0xEF9400,0xDF031C,0xEA9A6A,0xB8A7D1,0x03B3E4,0x044390,0x5A287F,0x9E9DA5,0x1FB9A1,0x6A9F13,0xDE8215,0xFDE648,0xE82D28,0xF9A5B5,0xE73E77,0xEA1081,0x80D6EF,0x04B5E9,0x1B58AB ];
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

			_oMat = new Matrix( );
			_fDist  = { x : 0.0 , y : 0.0 };
			_fPrev  = { x : 0.0 , y : 0.0 };
			_fStart = { x : 0.0 , y : 0.0 };
			_fSize = 10;

			
			var spMain = new Sprite( );
				//spMain.scaleX = spMain.scaleY = 0.5;
			addChild( spMain );
			_bmpParticle = nme.installer.Assets.getBitmapData('assets/line.png');
			spMain.addChild( new Bitmap( nme.installer.Assets.getBitmapData('assets/plateau.png') ) );
			spMain.addChild( _sp = new Sprite( ) );
			_oSheet = new Tilesheet( nme.installer.Assets.getBitmapData('assets/sheet.png'));
			_oSheet.addTileRect( new nme.geom.Rectangle( 0 , 0 , 128 , 128 ) , new nme.geom.Point( 64 , 64 ) );
			_aParticles = [ ];
			var p;
			var v = new Vector2D( Lib.current.stage.mouseX , Lib.current.stage.mouseY );
			
			#if !flash
			for( i in 0...50 ){
				p = new CustomParticle( );
				p.position.x = Lib.current.stage.mouseX + Math.random( ) * 100;
				p.position.y = Lib.current.stage.mouseY + Math.random( ) * 100;
				p.oSeek.toPosition( v );
				p.oArrive.toPosition( v );
				//p.addBehavior( _oCircle );
				_aParticles.push( p );
			}
			#end
			onFrame( ).connect( _onFrame );

			_spTrail = new Sprite( );
			_spTrail.graphics.beginFill( 0xff6600 );
			_spTrail.graphics.drawRect( 100 , 100 , 100 , 100 );
			addChild( _spTrail );

			_spTest = new Sprite( );
			addChild( _spTest );

			_spDragged = new Sprite( );
			addChild( _spDragged );

			_spParticles = new Sprite( );
			_spParticles.x = _spParticles.y = 0.75;
			_spParticles.scaleX = _spParticles.scaleY = 0.5;
			_spDragged.addChild( _spParticles );

			_bmpPion = new Bitmap( Assets.getBitmapData( 'assets/pion.png') );
			_bmpPion.scaleX = _bmpPion.scaleY = 0.5;
			_bmpPion.x = -90 * _bmpPion.scaleX;
			_bmpPion.y = -90 * _bmpPion.scaleX;
			_spDragged.addChild( _bmpPion );

			

			addChild( new org.shoebox.utils.Perf( ) );
			_aParticles2 = new Array<CustomParticle2>( );
			
			
			_spTest = new Sprite( );
			addChild( _spTest );
			Lib.current.stage.mouseDown( ).connect( _onMouseDown );
			Lib.current.stage.mouseUp( ).connect( _onMouseUp );

			var btnClear = new Sprite( );
				btnClear.x = btnClear.y = 10;
				btnClear.graphics.beginFill( 0xEAEAEA );
				btnClear.graphics.drawRect( 0 , 0 , 50 , 50 );
				btnClear.onClick( ).connect( _clear );
			addChild( btnClear );
			
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _clear( _ ) : Void{
			_spTest.graphics.clear( );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onMouseDown( e : MouseEvent ) : Void{
			//_spTest.graphics.clear( );
			/*
			_aParticles2 = [ ];
			_iColor   = _aColors[ Std.int( Math.random( ) * _aColors.length ) ];
			_fStart.x = e.stageX;
			_fPrev.x  = e.stageX;
			_fStart.y = e.stageY;
			_fPrev.y  = e.stageY;
			_fPrevDist = -1;
			_fSize = 10;
			Lib.current.stage.addEventListener( MouseEvent.MOUSE_MOVE , _onMouseMove , false );
			*/

			nme.ui.Mouse.hide( );
			_bMouseDown = true;
			_spDragged.x = Lib.current.stage.mouseX;
			_spDragged.y = Lib.current.stage.mouseY;
			_spDragged.startDrag( );
			//_onFrame( );

		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onMouseMove( e : MouseEvent ) : Void{
			/*
			
			var len = BoxMath.length( e.stageX - _fPrev.x , e.stageY - _fPrev.y );
			
			if( len < MIN_MOVE )
				return;

			var fDist = BoxMath.distance( e.stageX , e.stageY , _fStart.x , _fStart.y );
			var fAngle = fDist * ( Math.pow( Math.random( ) , 0.2 ) - 0.1 );
			var fR = Math.random( ) - 0.5;

			var diff = ( fDist / _fPrevDist );
			
			if( _fPrevDist != -1 && diff != Math.POSITIVE_INFINITY ){
				if ( len < 50 ) 
					_fSize *= 0.95;
				else
					_fSize *= 1.05;
					_fSize = BoxMath.clamp( _fSize , 1 , 30 );
			}

			_fPrevDist = fDist;

			_fDist.x = ( _fPrev.x - _fStart.x ) * Math.sin( 0.5 ) + _fStart.x;
			_fDist.y = ( _fPrev.y - _fStart.y ) * Math.cos( 0.5 ) + _fStart.y;

			_fStart.x = _fPrev.x;
			_fStart.y = _fPrev.y;

			_fPrev.x = e.stageX;
			_fPrev.y = e.stageY;
			
			_spTest.graphics.lineStyle( _fSize , _iColor , 1 , false, LineScaleMode.NONE , CapsStyle.ROUND , JointStyle.BEVEL , 10  );    
			_spTest.graphics.moveTo( _fStart.x , _fStart.y);
			//_spTest.graphics.curveTo( _fDist.x , _fDist.y , _fPrev.x , _fPrev.y );
			_spTest.graphics.lineTo( _fPrev.x , _fPrev.y );
			

			*/
			var p = { x : e.stageX , y : e.stageY , life : 30 };
			_aParticles2.push( p );

		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onMouseUp( _ ) : Void{
			Lib.current.stage.removeEventListener( MouseEvent.MOUSE_MOVE , _onMouseMove , false );
			nme.ui.Mouse.show( );
			_bMouseDown = false;
			_spDragged.stopDrag( );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onFrame( e: Event = null ) : Void{
			
			var a : Array<Float> = [ ];
			//_oCircle.getCircle( 0 ).position.x = Lib.current.stage.mouseX;
			//_oCircle.getCircle( 0 ).position.y = Lib.current.stage.mouseY;
			var v = new Vector2D( Lib.current.stage.mouseX , Lib.current.stage.mouseY );
			var i : Int = 0;
			for( p in _aParticles ){
				//p.oSeek.toPosition( v );
				//p.oArrive.toPosition( v );
				p.update( );
				//graphics.drawCircle( p.position.x , p.position.y , 10 );

				a[ i++ ] = p.position.x;
				a[ i++ ] = p.position.y;
				a[ i++ ] = 0;
				a[ i++ ] = p.rotation;
				a[ i++ ] = 0.1;
				
			}
			//_spDragged.x = v.x - 90;
			//_spDragged.y = v.y - 111;
			_spParticles.graphics.clear( );
			_oSheet.drawTiles( _spParticles.graphics , a , true , Tilesheet.TILE_ALPHA | Tilesheet.TILE_ROTATION );

			i = 0;
			var z = 0;
			var b : Array<Float> = [ ];
			for( p in _aParticles2 ){
				b[ i++ ] = p.x;
				b[ i++ ] = p.y;
				b[ i++ ] = 0;
				b[ i++ ] = Math.max( /*z / _aParticles2.length * 1.2 / 2*/ p.life / 30 , 0.15 ) ;
				b[ i++ ] = 0.2;
				p.life --;
				z++;
				if( p.life < 0 )
					_aParticles2.remove( p );
			} 

			//ID / scale / rot / g / b / b / a

			_spTrail.graphics.clear();
			#if !flash
			_oSheet.drawTiles( _spTrail.graphics , b , false , Tilesheet.TILE_ALPHA | Tilesheet.TILE_SCALE  | Tilesheet.TILE_BLEND_ADD );
			#end
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

typedef CustomParticle2={
	public var x : Float;
	public var y : Float;
	public var life : Int;
}