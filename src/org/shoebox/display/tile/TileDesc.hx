package org.shoebox.display.tile;

import nme.display.Tilesheet;

/**
 * ...
 * @author shoe[box]
 */

class TileDesc{

	public var r ( default , _setColR )           : Float;
	public var g ( default , _setColG )           : Float;
	public var b ( default , _setColB )           : Float;
	public var x ( default , _setPosX )           : Float;
	public var y ( default , _setPosY )           : Float;
	public var format( default, _setFormat )      : Int;
	public var alpha( default , _setAlpha )       : Float;
	public var rotation( default , _setRotation ) : Float;
	public var scale( default , _setScale )       : Float;
	public var tileId ( default , _setTileId )    : Int;

	private var _aDesc       : Array<Float>;
	private var _bInvalidate : Bool;
	private var _bUseAlpha   : Bool;
	private var _bUseRGB     : Bool;
	private var _bUseRot     : Bool;
	private var _bUseScale   : Bool;


	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( dx : Float = 0.0 , dy : Float = 0.0 , id : Int = 0 , iFlags : Int = 0 ) {
			this.format   = iFlags;
			this.x        = dx;
			this.y        = dy;
			this.tileId   = id;
			this.scale    = 1.0;
			this.alpha    = 1.0;
			this.rotation = 0.0;
			this.r        = 1.0;
			this.g        = 1.0;
			this.b        = 1.0;
			_aDesc        = [ ];
			_bInvalidate  = true;
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

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setColR( f : Float ) : Float{
			_bInvalidate = true;
			return this.r = f;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setColG( f : Float ) : Float{
			_bInvalidate = true;
			return this.g = f;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setColB( f : Float ) : Float{
			_bInvalidate = true;
			return this.b = f;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setPosX( f : Float ) : Float{
			_bInvalidate = true;
			return this.x = f;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setPosY( f : Float ) : Float{
			_bInvalidate = true;
			return this.y = f;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setFormat( i : Int ) : Int{
			_bInvalidate = true;
			_bUseAlpha   = ( i & Tilesheet.TILE_ALPHA) > 0;
			_bUseRGB     = ( i & Tilesheet.TILE_RGB) > 0;
			_bUseRot     = ( i & Tilesheet.TILE_ROTATION) > 0;
			_bUseScale   = ( i & Tilesheet.TILE_SCALE) > 0;
			return this.format = i;
		}


		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setScale( f : Float ) : Float{
			_bInvalidate = true;
			return this.scale = f;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setRotation( f : Float = 0.0 ) : Float{
			_bInvalidate = true;
			return this.rotation = f;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setAlpha( f : Float ) : Float{
			_bInvalidate = true;
			return this.alpha = f;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setTileId( i : Int ) : Int{
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
			
			_aDesc = [ x , y , tileId ];

			var id : Int = 3;
			if( _bUseScale )
				_aDesc[ id++ ] = scale;

			if( _bUseRot ){
				if( Math.isNaN( rotation ) )
					_aDesc[ id++ ] = 0.0;
				else
					_aDesc[ id++ ] = rotation;
			}

			if( _bUseRGB ){
				_aDesc[ id++ ] = r;
				_aDesc[ id++ ] = g;
				_aDesc[ id++ ] = b;
			}

			if( _bUseAlpha )
				_aDesc[ id++ ] = alpha;

			_bInvalidate = false;
		}
		
	// -------o misc
	
}