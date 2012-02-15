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
		* 
		* 
		* @public
		* @param maxDepth : Max tree depth ( Int )
		* @return	void
		*/
		public function new( bounds : AABB , maxDepth : Int = 5 , gDebug : Graphics = null ) : Void {
			super( bounds , 0 , maxDepth , gDebug );
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

	private var _bBounds     : AABB;
	private var _aContent    : Array<T>;
	private var _bMaxDepth   : Bool;
	private var _bInitialize : Bool;
	private var _fHalfX      : Float;
	private var _fHalfY      : Float;
	private var _gDebug      : Graphics;
	private var _iDepth      : Int;
	private var _iMaxDepth   : Int;
	private var _qTopL       : QuadTreeNode<T>;
	private var _qTopR       : QuadTreeNode<T>;
	private var _qBotL       : QuadTreeNode<T>;
	private var _qBotR       : QuadTreeNode<T>;
	
	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( bounds : AABB , depth : Int , maxDepth : Int = 10 , gDebug : Graphics = null ) {
			_bBounds   = bounds;
			_iDepth    = depth;
			_iMaxDepth = maxDepth;	
			_gDebug    = gDebug;
			_fHalfX    = (bounds.max.x - bounds.min.x ) / 2 ;
			_fHalfY    = (bounds.max.y - bounds.min.y ) / 2 ;
			_bMaxDepth = depth >= maxDepth;
		
			if( _gDebug != null ){
				bounds.debug( gDebug );
			}
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function put( t : T , bounds : AABB ) : Bool {
			
			if( !_bBounds.intersect( bounds ) )
				return false;
			
			if( _bMaxDepth ){
				_addContent( t );
				return false;
			}
			
			if( !_bInitialize )
				_init( );
			

			var q : QuadTreeNode<T> = _getQuad( _getQuadAt( bounds.min.x , bounds.min.y ) );
			var b : Bool = q.put( t , bounds );
			if( !b ){
				_addContent( t );
				b = true;
			}
			return b;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function putArray( a : Array<T> , bounds : AABB ) : Void {
			
			for( t in a )
				put( t , bounds );

		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function get( bounds : AABB , res : Array<T> = null ) : Array<T> {
			
			//
				if( res == null )
					res = new Array<T>( );

			//
				if( !bounds.intersect( _bBounds ) )
					return res;
			
			//
				if( _aContent != null ){
					
					res = res.concat( _aContent );
				}

			//
				if( _bInitialize ){
					res = _qTopL.get( bounds , res );
					res = _qTopR.get( bounds , res );
					res = _qBotL.get( bounds , res );
					res = _qBotR.get( bounds , res );
				}

			return res;
			
		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _addContent( t : T ) : Void{
			
			if( _aContent == null )
				_aContent = new Array<T>( );
				_aContent.push( t );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _init( ) : Void{
			
			_qTopL = new QuadTreeNode<T>( 	new AABB( 
														_bBounds.min.x , 
														_bBounds.min.y , 
														_bBounds.min.x + _fHalfX , 
														_bBounds.min.y + _fHalfY 
													) , _iDepth + 1 , _iMaxDepth , _gDebug );
			
			_qTopR = new QuadTreeNode<T>( 
											new AABB( 
														_bBounds.min.x + _fHalfX , 
														_bBounds.min.y , 
														_bBounds.max.x , 
														_bBounds.min.y + _fHalfY
													) , _iDepth + 1 , _iMaxDepth , _gDebug );									
			
			_qBotL = new QuadTreeNode<T>( 	new AABB( 
														_bBounds.min.x , 
														_bBounds.min.y + _fHalfY , 
														_bBounds.min.x + _fHalfX , 
														_bBounds.max.y
													) , _iDepth + 1 , _iMaxDepth , _gDebug );
			
			_qBotR = new QuadTreeNode<T>( 	new AABB( 
														_bBounds.min.x + _fHalfX , 
														_bBounds.min.y + _fHalfY , 
														_bBounds.max.x , 
														_bBounds.max.y
													) , _iDepth + 1 , _iMaxDepth , _gDebug );
			
			_bInitialize = true;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getQuad( q : Quad ) : QuadTreeNode<T>{
			
			return switch( q ){

				case TL : _qTopL;
					
				case TR : _qTopR;
				
				case BL : _qBotL;
				
				case BR : _qBotR;
				
			}

		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getQuadAt( x : Float , y : Float ) : Quad{

			var iMiddleX : Float = _bBounds.min.x + _fHalfX;
			var iMiddleY : Float = _bBounds.min.y + _fHalfY;
			return if( y <= iMiddleY){
						
						if( x <= iMiddleX )
							Quad.TL;
						else
							Quad.TR;

					}else{

						if( x <= iMiddleX )
							Quad.BL;
						else
							Quad.BR;	
												
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
			for( i in 0..._iDepth ){
				s += '\t';
				
			}

			return s;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function toString( ) : String {
			return 'QuadTreeNode ::: '+_bBounds;
		}

	// -------o misc
	
}

enum Quad{
	TL;
	TR;
	BL;
	BR;
}
