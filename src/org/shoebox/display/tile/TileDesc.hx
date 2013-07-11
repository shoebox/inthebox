package org.shoebox.display.tile;

import flash.display.Graphics;
import openfl.display.Tilesheet;

/**
 * ...
 * @author shoe[box]
 */

class TileDesc{

	public var r ( default , set_r )				: Float;
	public var g ( default , set_g )				: Float;
	public var b ( default , set_b )				: Float;
	public var x ( default , set_x )				: Float;
	public var y ( default , set_y )				: Float;
	public var matrixA ( default , set_matrixA )	: Float;
	public var matrixB ( default , set_matrixB )	: Float;
	public var matrixC ( default , set_matrixC )	: Float;
	public var matrixD ( default , set_matrixD )	: Float;
	public var alpha( default , set_alpha )			: Float;
	public var format( default, set_format )		: Int;
	public var rotation( default , set_rotation )	: Float;
	public var scale( default , set_scale )			: Float;
	public var scaleX( default , set_scaleX )		: Float;
	public var tileId ( default , set_tileId )		: Int;

	private var _aDesc			: Array<Float>;
	private var _bInvalidate	: Bool;
	private var _bUseAlpha		: Bool;
	private var _bUseMatrix		: Bool;
	private var _bUseRGB		: Bool;
	private var _bUseRot		: Bool;
	private var _bUseScale		: Bool;


	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		public function new( dx : Float = 0.0 , dy : Float = 0.0 , id : Int = 0 , iFlags : Int = 0 ) {
			_aDesc			= [ ];
			_bInvalidate	= true;
			this.alpha		= 1.0;
			this.b			= 1.0;
			this.format		= iFlags;
			this.g			= 1.0;
			this.matrixA	= 1.0;
			this.matrixD	= 1.0;
			this.r			= 1.0;
			this.rotation	= 0.0;
			this.scale		= 1.0;
			this.scaleX		= 1.0;
			//this.scaleY		= 1.0;
			this.tileId		= id;
			this.x			= dx;
			this.y			= dy;
		}

	// -------o public

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function toString( ) : String {

			var s = '[ '+x+' | '+y+' | '+tileId;
			if( _bUseScale )
				s = s +' | scl :' + scale;

			if( _bUseRot )
				s = s +' | rot : ' + rotation;

			if( _bUseRGB ){
				s = s +' | r : ' + r;
				s = s +' | g : ' + g;
				s = s +' | b : ' + b;
			}

			if( _bUseAlpha )
				s = s +' | a :' + alpha;

			return s+' ]';
			//return getArray( ).join('|');
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function getArray( ) : Array<Float> {

			if( _bInvalidate )
				_invalidate( );

			return _aDesc;
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function getArray2( a : Array<Float> = null ) : Array<Float> {

			if( a == null )
				a = [ ];

			return _invalidateArray( a );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function get_offset_array( fx : Float , fy : Float ) : Array<Float> {

			if( _bInvalidate )
				_invalidate( );

			var a = _aDesc.slice( 0 , _aDesc.length );
				a[ 0 ] += fx;
				a[ 1 ] += fy;
			return a;
		}

	// -------o protected

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function set_r( f : Float ) : Float{
			_bInvalidate = true;
			return this.r = f;
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function set_g( f : Float ) : Float{
			_bInvalidate = true;
			return this.g = f;
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function set_b( f : Float ) : Float{
			_bInvalidate = true;
			return this.b = f;
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function set_x( f : Float ) : Float{
			_bInvalidate = true;
			return this.x = f;
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function set_y( f : Float ) : Float{
			_bInvalidate = true;
			return this.y = f;
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function set_format( i : Int ) : Int{

			if( this.format == i )
				return i;

			_bInvalidate = true;
			#if cpp
			_bUseAlpha   = ( i & Graphics.TILE_ALPHA) > 0;
			_bUseRGB     = ( i & Graphics.TILE_RGB) > 0;
			_bUseRot     = ( i & Graphics.TILE_ROTATION) > 0;
			_bUseScale   = ( i & Graphics.TILE_SCALE) > 0;
			_bUseMatrix  = ( i & Graphics.TILE_TRANS_2x2) > 0;
			#else
			_bUseAlpha   = ( i & Tilesheet.TILE_ALPHA) > 0;
			_bUseRGB     = ( i & Tilesheet.TILE_RGB) > 0;
			_bUseRot     = ( i & Tilesheet.TILE_ROTATION) > 0;
			_bUseScale   = ( i & Tilesheet.TILE_SCALE) > 0;
			_bUseMatrix  = false;
			#end
			return this.format = i;
		}


		/**
		*
		*
		* @private
		* @return	void
		*/
		private function set_scale( f : Float ) : Float{
			_bInvalidate = true;
			return this.scale = f;
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function set_scaleX( f : Float ) : Float{
			_bInvalidate = true;
			return this.scaleX = f;
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function set_matrixB( f : Float ) : Float{
			_bInvalidate = true;
			return this.matrixB = f;
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function set_matrixC( f : Float ) : Float{
			_bInvalidate = true;
			return this.matrixC = f;
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function set_matrixD( f : Float ) : Float{
			_bInvalidate = true;
			return this.matrixD = f;
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function set_matrixA( f : Float ) : Float{
			_bInvalidate = true;
			return this.matrixA = f;
		}



		/**
		*
		*
		* @private
		* @return	void
		*/
		private function set_rotation( f : Float = 0.0 ) : Float{
			_bInvalidate = true;
			return this.rotation = f;
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function set_alpha( f : Float ) : Float{
			_bInvalidate = true;
			return this.alpha = f;
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function set_tileId( i : Int ) : Int{
			_bInvalidate = true;
			return this.tileId = i;
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _invalidate( ) : Void{
			_aDesc = _invalidateArray( );
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _invalidateArray( a : Array<Float> = null ) : Array<Float>{

			if( a == null )
				a = [ ];

			var id = a.length;
			a[ id++ ] = x;
			a[ id++ ] = y;
			a[ id++ ] = tileId;

			if( _bUseScale )
				a[ id++ ] = scale;

			if( _bUseRot ){
				if( Math.isNaN( rotation ) )
					a[ id++ ] = 0.0;
				else
					a[ id++ ] = rotation;
			}

			if( _bUseMatrix ){
				a[ id++ ] = matrixA * -scaleX * scale;
				a[ id++ ] = matrixB * scale;
				a[ id++ ] = matrixC * scale;
				a[ id++ ] = matrixD * scale;
			}

			if( _bUseRGB ){
				a[ id++ ] = r;
				a[ id++ ] = g;
				a[ id++ ] = b;
			}

			if( _bUseAlpha )
				a[ id++ ] = alpha;

			_bInvalidate = false;
			return a;
		}

	// -------o misc

}