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

import nme.display.Graphics;
import org.shoebox.display.AABB;

class QuadTree<T> extends QuadTreeNode<T>{

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( x : Float , y : Float , w : Float , h : Float , iMaxDepth : Int = 10 , gDebug : Graphics = null  ) {
			super( x , y , w , h , 0 , iMaxDepth , gDebug );
		}
	
	// -------o public
				
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function put( t : T , x : Float , y : Float , w : Float , h : Float ) : Bool {
			
			var o : Quad = new Quad( x , y , w , h );
				
			if( !bounds.intersect( o ) )
				return false;
			
			return addAt( t , o );
		}

	// -------o protected
	
		

	// -------o misc
		
}

/**
 * ...
 * @author shoe[box]
 */

class QuadTreeNode<T>{

	public var bounds : Quad;

	private var _aChilds      : Array<QuadTreeNode<T>>;
	private var _aContent     : Array<T>;
	private var _bInitialized : Bool;
	private var _bMaxDepth    : Bool;
	private var _gDebug       : Graphics;
	private var _iDepth       : Int ;
	private var _iMaxDepth    : Int;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( x : Float , y : Float , w : Float , h : Float , iDepth : Int , iMaxDepth : Int , gDebug : Graphics = null ) {
			
			bounds        = new Quad( );
			bounds.fromRec( x , y , w , h );
			
			_gDebug       = gDebug;
			_iDepth       = iDepth;
			_iMaxDepth    = iMaxDepth;
			_bMaxDepth    = _iDepth > _iMaxDepth;
			_bInitialized = false;
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function hasContent( ) : Bool {
			
			if( _aContent == null )
				return false;

			return _aContent.length > 0;

		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function addAt( value : T , a : Quad ) : Bool {
			

			if( !bounds.intersect( a ) )
				return false;
			
			if( !_bInitialized )
				_init( );

			if( _bMaxDepth ){
				trace('_bMaxDepth');
				return true;
			}
			var s = '';
			for( i in 0..._iDepth )
				s+='\t';

			trace(s+'addAtt ::: '+_aChilds);
			for( c in _aChilds ){
				trace(s+_iDepth+' c ::: '+c.addAt( value , a )+' ==== '+c.bounds);
				if( c.addAt( value , a ) ){
					//return true;
				}
			}

			return true;
		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _init( ) : Void{
			
			if( !_bMaxDepth ){
				
				var fHalfW : Float = bounds.w / 2;
				var fHalfH : Float = bounds.h / 2;
				
				var s = '';
			for( i in 0..._iDepth )
				s+='\t';

				var child : QuadTreeNode<T>;
				_aChilds = new Array<QuadTreeNode<T>>( );
				trace(s+'init ::: '+bounds);
				for( i in 0...4 ){
					
					child = new QuadTreeNode<T>( 
															( i % 2 ) * fHalfW , 
															( i - i % 2 ) / 2 * fHalfH , 
															fHalfW , 
															fHalfH , 
															_iDepth + 1, 
															_iMaxDepth ,
															_gDebug
														);
					
					if( _gDebug != null )
						child.bounds.debug( _gDebug );

					_aChilds.push( child );					
				}
				

			}

			_bInitialized = true;
			
		}

	// -------o misc
	
}

/**
 * ...
 * @author shoe[box]
 */

class Quad extends org.shoebox.display.AABB{

	public var w  : Float;
	public var h : Float;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( x : Float = 0.0 , y : Float = 0.0 , w : Float = 0.0 , h : Float = 0.0 ) {
			this.w = w;
			this.h = h;
			super( );
			fromRec( x , y , w , h );
		}
	
	// -------o public
				
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function fromRec( x : Float , y : Float , w : Float , h : Float ) : Void {
			super.fromRec( x , y , w , h );
			this.w = w;
			this.h = h;
		}

	// -------o protected
	
		

	// -------o misc
	
}