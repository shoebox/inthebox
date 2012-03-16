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
import org.shoebox.geom.AABB;
import org.shoebox.geom.FPoint;

class QuadTree<T> extends QuadTreeNode<T>{

	// -------o constructor
		
		/**
		* 
		* 
		* @public
		* @param 
		* @return	void
		*/
		public function new( bounds : AABB , iMax : Int = 10 , gDebug : Graphics = null ) : Void {
			
			super( bounds , 0 , iMax , gDebug );
		}
	
	// -------o public
		
	// -------o protected
	
	// -------o misc
		
}

/**
 * ...
 * @author shoe[box]
 */

class QuadTreeNode<T>{

	public var bounds : AABB;
	public var iDepth : Int;
	public var iMax   : Int;
	public var gDebug : Graphics;

	private var _aContent : Array<QuadTreeContent<T>>;
	private var _bMax  : Bool;
	private var _fHalf : FPoint;
	private var _aSubs : Array<QuadTreeNode<T>>;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( bounds : AABB , iDepth : Int , iMax : Int , gDebug : Graphics = null ) {
			
			this.bounds = bounds;
			this.iDepth = iDepth;
			this.iMax   = iMax;
			this.gDebug = gDebug;
			_bMax = iDepth >= iMax;
			_fHalf = { 
						x : bounds.min.x + ( bounds.max.x - bounds.min.x ) / 2,
						y : bounds.min.y + ( bounds.max.y - bounds.min.y ) / 2
					};
			//trace('constructor ::: '+gDebug);
			if( gDebug != null )
				gDebug.drawRect( bounds.min.x , bounds.min.y , bounds.width , bounds.height );
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function toString( ) : String {
			return _getIndent( )+'[ QuadTreeNode : '+bounds +' ]';
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function add( b : AABB , value : T ) : Void {

			//if( !bounds.containPoint( b.min.x , b.min.y ) )
			//	return;
				
			if( !_bMax ){

				var q = _getQuad( getQuadAt( b.min.x , b.min.y ) );
				if( q.bounds.containAABB( b ) )
					q.add( b , value );
				else
					_addContent( value , b );
			}else{
				_addContent( value , b );
			}

			
			

		}		

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function get( b : AABB , res : Array<T> = null ) : Array<T> {

			if( res == null )
				res = new Array<T>( );
			
			if( _aSubs != null ){
				for( sub in _aSubs ){

					if( sub == null )
						continue;
					
					if( sub.bounds.intersect( b ) )
						sub.get( b , res );
				}
			}

			
			if( _aContent != null ){

				for( c in _aContent )
					if( c.bounds.intersect( b ) )
						res.push( c.content );

			}

			return res;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function get2<B>( b : AABB , fConcat : T -> Array<B> -> Array<B> , res : Array<B> = null ) : Array<B> {
			
			 if( res == null )
			 	res = new Array<B>( );

			 

			if( _aContent != null ){
				
				for( c in _aContent ){
					if( c.bounds.intersect( b ) ){
						res = fConcat( c.content , res );
					}
				}
			
			}

			if( _aSubs != null ){
				for( sub in _aSubs ){

					if( sub == null )
						continue;
					
					if( sub.bounds.intersect( b ) )
						res = sub.get2( b , fConcat , res );
				}
			}

			return res;

		}
		

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getQuadAt( fx : Float , fy : Float ) : Quad {
			return 
				if ( fy <= _fHalf.y ) {
					if ( fx <= _fHalf.x )
						Quad.TL;
					else
						Quad.TR;
				} else {
					if ( fx <= _fHalf.x )
						Quad.BL;
					else
						Quad.BR;
				}
		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getQuad( q : Quad ) : QuadTreeNode<T>{
			
			if( _aSubs == null )
				_aSubs = new Array<QuadTreeNode<T>>( );

			return switch( q ) {

				case TL:
					if( _aSubs[ 0 ] == null )
						_aSubs[ 0 ] = new QuadTreeNode<T>( new AABB( bounds.min.x , bounds.min.y , _fHalf.x , _fHalf.y ) , iDepth + 1 , iMax , gDebug );

					_aSubs[ 0 ];

				case TR:
					if( _aSubs[ 1 ] == null )
						_aSubs[ 1 ] = new QuadTreeNode<T>( new AABB( _fHalf.x , bounds.min.y , bounds.max.x , _fHalf.y ) , iDepth + 1 , iMax , gDebug );

					_aSubs[ 1 ];

				case BL:
					if( _aSubs[ 2 ] == null )
						_aSubs[ 2 ] = new QuadTreeNode<T>( new AABB( bounds.min.x , _fHalf.y , _fHalf.x , bounds.max.y ) , iDepth + 1 , iMax , gDebug );
					_aSubs[ 2 ];

				case BR:
					if( _aSubs[ 3 ] == null )
						_aSubs[ 3 ] = new QuadTreeNode<T>( new AABB( _fHalf.x , _fHalf.y , bounds.max.x , bounds.max.y ) , iDepth + 1 , iMax , gDebug );
					_aSubs[ 3 ];

			}

		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getIndent( ) : String{
			var s = '';
			for( i in 0...iDepth )
				s+='\t';

			return s;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _addContent( value : T , b : AABB ) : Void{
			if( _aContent == null )
				_aContent = new Array<QuadTreeContent<T>>( );
				_aContent.push( { content : value , bounds : b } );
		}
		
	// -------o misc
	
}

typedef QuadTreeContent<T>={
	public var content : T;
	public var bounds : AABB;
}

enum Quad{
	TL;
	TR;
	BL;
	BR;
}