/**
*  HomeMade by shoe[box]
*
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are
*  met:
*
* Redistributions of source code must retain the above copyright notice, 
*   this list of conditions and the following disclaimer.
*  
* Redistributions in binary form must reproduce the above copyright
*    notice, this list of conditions and the following disclaimer in the 
*    documentation and/or other materials provided with the distribution.
*  
* Neither the name of shoe[box] nor the names of its 
* contributors may be used to endorse or promote products derived from 
* this software without specific prior written permission.
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
* IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
* THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
* PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
* EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
* PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
* PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
* LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package org.shoebox.collections;

import nme.Lib;
import nme.display.Sprite;
import org.shoebox.geom.IPosition;

/**
 * ...
 * @author shoe[box]
 */

private typedef Array2DDef<T> = {
	private var _aContent : Array<T>;
	private var _iWidth   : Int;
	private var _iHeight  : Int;
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
		inline public function set( dx : Int , dy : Int , value : T ) : Bool{
			return _set( dx , dy , value );
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		inline public function get( dx : Int , dy : Int ) : T{
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

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		inline public function hasContentAt( dx : Int , dy : Int ) : Bool {
			return _aContent[getIndex( dx , dy )] != null;
		}

		/**
		* Getting a region of the Array with the default concat
		* 
		* @public
		* @return	void
		*/
		public function getRegion( min : IPosition , max : IPosition , res : Array<T> = null ) : Array<T> {

			var res : Array<T> = res!=null ? res : new Array<T>( );
			for( dy in min.y...max.y ){
				res = res.concat( _aContent.slice( getIndex( min.x , dy ) , getIndex( max.x , dy ) ) );
			}

			return res;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getRegionCustom<B>( min : IPosition , max : IPosition , res : Array<B> , fConcat : Array<T> -> Array<B> -> Array<B> = null ) : Array<B> {
			
			for( dy in min.y...max.y )
				res = fConcat( _aContent.slice( getIndex( min.x , dy ) , getIndex( max.x , dy ) ) , res );
			
			return res;
		}	
	
	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		inline private function _getLength( ) : Int{
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
