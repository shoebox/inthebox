package org.shoebox.collections;

import nme.Lib;
import nme.display.Sprite;

/**
 * ...
 * @author shoe[box]
 */

private typedef Array2DDef<T> = {
	private var _aContent	:Array<T>;
	private var _iWidth		:Int;
	private var _iHeight	:Int;
}

class Array2D<T>{

	public var length ( _getLength , null ) : Int;
	
	var _aContent				: Array<T>;
	var _iWidth					: Int;
	var _iHeight				: Int;	
	
	// -------o constructor
		
		/**
		* Array 2D constructor
		* 
		* @public
		* @param	container : optional container reference	( DisplayObjectContainer ) 
		* @return	void
		*/
		public function new( iW : Int , iH : Int ) {
			_aContent = new Array<T>( );
			_iWidth = iW;
			_iHeight = iH;
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		inline public function getIndex( dx : Int , dy : Int ) : Int{
			return dy * _iWidth + dx;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function set( dx : Int , dy : Int , value : T ) : Bool{
			return _set( dx , dy , value );
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function get( dx : Int , dy : Int ) : T{
			return _get( dx , dy );
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function iterator() : Array2DIterator<T>{
			return new Array2DIterator<T>( this );
		}
	
	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getLength( ) : Int{
			return _iWidth * _iHeight;
		}
	
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		inline private function _set( dx : Int , dy : Int , value : T ) : Bool{
			_aContent[getIndex( dx , dy )] = value;
			return true;
		}
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		inline private function _get( dx : Int , dy : Int ) : T{
			return _aContent [ getIndex( dx , dy ) ];
		}
	
	// -------o misc
	
}


class Array2DIterator<T>{
	
	private var _aRef			: Array2D<T>;
	private var _aContent		: Array<T>;
	
	private var _iInc			: Int;
	private var _iLen			: Int;
	
	// -------o constructor
		
		/**
		* Iterator constructor
		* 
		* @public
		* @return	void
		*/
		public function new( ref : Array2D<T> ) {
			_aRef = ref;
			reset( );
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		inline public function reset( ) : Array2DIterator<T>{
			_aContent = __a( _aRef );
			_iLen = __size( _aRef );
			_iInc = 0;
			return this;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		inline public function hasNext( ) : Bool{
			return _iInc <= _iLen;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		inline public function next( ) : T{
			return _aContent[_iInc++];
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		inline public function remove( ) : Void{
			_aContent[_iInc - 1] = null;
		}

	// -------o protected
	
		inline function __a<T>( ref : Array2DDef<T> ) return ref._aContent
		inline function __size<T>( ref : Array2DDef<T> ) return ref._iWidth * ref._iHeight

	// -------o misc
	
}
