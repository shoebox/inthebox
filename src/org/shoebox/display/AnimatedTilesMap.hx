package org.shoebox.display;

import haxe.xml.Fast;
import nme.display.BitmapData;
import nme.geom.Point;
import nme.geom.Rectangle;
import org.shoebox.core.interfaces.IDispose;
import org.shoebox.geom.IPosition;

/**
 * ...
 * @author shoe[box]
 */

class AnimatedTilesMap extends TilesMap , implements IDispose{

	public var name( default , default ) : String;

	private var _hCustomCenter : Hash<Point>;
	private var _hCyclesFrames : Hash<Array<Int>>;
	private var _hCyclesLen    : Hash<Int>;
	private var _hFrameSize    : Hash<IPosition>;
	#if flash
	private var _bmpRef : BitmapData;
	private var _hCache         : Hash<BitmapData>;
	private var _hIds           : Hash<Int>;
	private var _hFramesCenters : Hash<Point>;
	private static inline var POINT : Point = new Point( );
	#end

	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		public function new( bmp : BitmapData ) {
			super( bmp );
			_hCustomCenter = new Hash<Point>( );
			_hCyclesFrames = new Hash<Array<Int>>( );
			_hCyclesLen    = new Hash<Int>( );
			_hFrameSize    = new Hash<IPosition>( );

			#if flash
			_bmpRef = bmp;
			_hCache         = new Hash<BitmapData>( );
			_hIds           = new Hash<Int>();
			_hFramesCenters = new Hash<Point>();
			#end

		}

	// -------o public

		/**
		*
		*
		* @public
		* @return	void
		*/
		override public function dispose( ) : Void {
			super.dispose( );

			_hCustomCenter = null;
			_hCyclesFrames = null;
			_hCyclesLen    = null;
			_hFrameSize    = null;

			#if flash

				if( _hCache != null ){
					for( bmp in _hCache ){
						if( bmp != null )
							bmp.dispose( );
					}
				}

				_hCache         = null;
				_hFramesCenters = null;
				_hIds           = null;

			#end
		}

		#if flash

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function getBitmapData( sCat : String , sSubCat : String , frameId : Int ) : BitmapData {
			var s = _getCode( sCat , sSubCat , frameId );

			//Check Cache
				var bmp : BitmapData = null;
				if( _hCache.exists( s ) ){
					return _hCache.get( s );
				}

			//Not
				var frameId = _hIds.get( s );
				var rec = getRectById( frameId );
				var center = getCenter( frameId );

			//
				bmp = new BitmapData( Std.int( rec.width ) , Std.int( rec.height ) , true );
				bmp.copyPixels( _bmpRef , rec , POINT );
				_hCache.set( s , bmp );

			return bmp;
		}


		/**
		*
		*
		* @public
		* @return	void
		*/
		public function getFrameCenter( sCat : String , sSubCat : String , frameId : Int ) : Point {
			return _hFramesCenters.get( _getCode( sCat , sSubCat , frameId ) );
		}

		#end

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function getDefaultCycle( ) : String {
			return _hCyclesFrames.keys( ).next( );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function getCycleId( sCycle : String , frame : Int  ) : Int {
			return _hCyclesFrames.get( sCycle )[ frame ];
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function getSubCycleId( sCat : String , sCycle : String , frame : Int ) : Int {
			return _hCyclesFrames.get( sCat+'|'+sCycle )[ frame ];
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function getCycleLen( sCycle : String ) : Int {
			return _hCyclesLen.get( sCycle );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function getSubCycleLen( sCat : String , sCycle : String ) : Int {
			return _hCyclesLen.get( sCat+'|'+sCycle );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function setCycleCenter( s : String , fx : Float , fy : Float ) : Void {
			_hCustomCenter.set( s , new Point( fx , fy ) );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function parseXML( sXml : String , fCenterX : Float = 0.0 , fCenterY : Float = 0.0 , fDecalX : Float = 0 , fDecalY : Float = 0 ) : Void {

			var x = Xml.parse( sXml );
			var f = new Fast( x.firstElement( ) );
			var a : Array<String>;

			var iLen   : Int;
			var iFrame : Int;
			var sCycle : String;
			var aIds   : Array<Int>;
			var rec    : Rectangle = new Rectangle( );
			var pt     : Point = new Point( fCenterX , fCenterY );
			for( s in f.nodes.SubTexture ){

				//
					a      = s.att.name.split('/');
					iFrame = Std.parseInt( a[ 1 ] );
					sCycle = a[ 0 ];

				//
					if( _hCyclesLen.exists( sCycle ) )
						iLen = _hCyclesLen.get( sCycle );
					else
						iLen = 0;
						iLen++;

					_hCyclesLen.set( sCycle , iLen );

				//
					rec.x      = Std.parseFloat( s.att.x ) + fDecalX;
					rec.y      = Std.parseFloat( s.att.y ) + fDecalY;
					rec.width  = Std.parseFloat( s.att.width );
					rec.height = Std.parseFloat( s.att.height );

				//
					if( _hCyclesFrames.exists( sCycle ) )
						aIds = _hCyclesFrames.get( sCycle );
					else
						aIds = new Array<Int>( );

					if( _hCustomCenter.exists( sCycle ) )
						aIds[ iFrame ] = addByName( s.att.name , rec.clone( ) , _hCustomCenter.get( sCycle ) );
					else
						aIds[ iFrame ] = addByName( s.att.name , rec.clone( ) , pt );

					_hCyclesFrames.set( sCycle , aIds );
			}

		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function parseJson( s : String , fDecalX : Float = 0.0 , fDecalY : Float = 0.0 ) : Void {

			var desc = haxe.Json.parse( s );
			var fields = Reflect.fields ( desc.frames );
			var entry : JSONEntry;


			var r1 = ~/([^\/]+)\/([^\/]+)\/([^.]+).([^\/]+)/;

			var aIds   : Array<Int>;
			var iFrame : Int = 0;
			var iLen    : Int;
			var pt      : Point = new Point( );
			var rec     : Rectangle = new Rectangle( );
			var sCat    : String = '';
			var sCycle  : String = '';
			var sSub    : String = '';
			var iEntryId : Int;
			for( s in fields ){
				entry = Reflect.field ( desc.frames , s );

				// Parsing file name & directory to cat / subcat

					if( r1.match( s ) ){
						sCat = r1.matched( 1 );
						sSub = r1.matched( 2 );
						iFrame = Std.parseInt( r1.matched( 3 ));
						sCycle = sCat+'|'+sSub;
					}

				// Cycle len inc
					if( _hCyclesLen.exists( sCycle ) )
						iLen = _hCyclesLen.get( sCycle );
					else
						iLen = 0;
						iLen++;
					_hCyclesLen.set( sCycle , iLen );

				//
					rec.x      = entry.frame.x + fDecalX;
					rec.y      = entry.frame.y + fDecalY;
					rec.width  = entry.frame.w;
					rec.height = entry.frame.h;

				//
					if( _hCyclesFrames.exists( sCycle ) )
						aIds = _hCyclesFrames.get( sCycle );
					else
						aIds = new Array<Int>( );

				//
					var ptCenter : Point = new Point(
															entry.sourceSize.w / 2 - entry.spriteSourceSize.x,
															entry.sourceSize.h / 2 - entry.spriteSourceSize.y
															) ;
					iEntryId = aIds[ iFrame ] = addByName( s , rec.clone( ) , ptCenter );
					#if flash
					_hIds.set( sCycle+'|'+iFrame , iEntryId );
					_hFramesCenters.set( _getCode( sCat , sSub , iFrame ) , ptCenter );
					#end
					_hCyclesFrames.set( sCycle , aIds );

				//
					if( !_hFrameSize.exists( sCat ) ){
						_hFrameSize.set( sCat , new IPosition( entry.sourceSize.w , entry.sourceSize.h ) );//{ x : entry.sourceSize.w , y : entry.sourceSize.h } );
					}
			}


		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function getFrameSize( sCat : String ) : IPosition {
			return _hFrameSize.get( sCat );
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _getCode( sCat : String , sSubCat : String , frameId : Int ) : String{
			return sCat+'|'+sSubCat+'|'+frameId;
		}

	// -------o protected

	// -------o misc

}
typedef JSONEntry={
	public var frame : JSONRec;
	public var rotated : Bool;
	public var trimmed : Bool;
	public var spriteSourceSize : JSONRec;
	public var sourceSize : JSONSize;
}
typedef JSONRec={
	public var x : Int;
	public var y : Int;
	public var w : Int;
	public var h : Int;
}
typedef JSONSize={
	public var w : Int;
	public var h : Int;
}