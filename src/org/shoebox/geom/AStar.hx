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
package org.shoebox.geom;

import org.shoebox.collections.Array2D;
import org.shoebox.core.BoxArray;

/**
 * ...
 * @author shoe[box]
 */

class AStar{

	public var isClosed : Int->Int->Bool;
	
	private var _aContent   : Array2D<AStarNode>;
	private var _bAllowDiag : Bool;
	private var _iWidth : Int;
	private var _iHeight : Int;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( w : Int , h : Int , b : Bool = true ) {
			_aContent	= new Array2D<AStarNode>( w , h );
			_bAllowDiag	= b;
			_iWidth		= w;
			_iHeight	= h;
			
			//{ dx : dx , dy : dy , f : 0.0 , g : 0.0 , h : 0.0 , value : true , parent : null , travelCost: 0.0} );
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function solve( dx1 : Int , dy1 : Int , dx2 : Int , dy2 : Int ) : Array<Int> {
			trace("solve ::: "+dx1+" || "+dy1+" || "+dx2+" || "+dy2);
			if( !_aContent.validate( dx1 , dy1 ) || !_aContent.validate( dx2 , dy2 ) )
				return null;

			_reset( );
			//trace("solve");

			var aClosed  : Array<AStarNode> = new Array<AStarNode>( );
			var aNear    : Array<AStarNode>;
			var aOpened  : Array<AStarNode> = [ _aContent.get( dx1 , dy1 ) ];
			var best     : AStarNode;
			var oCurrent : AStarNode;
			var oEnd     : AStarNode = _aContent.get( dx2 , dy2 );
			var b        : Bool;
			var g        : Float;
			
			var iLen : Int = aOpened.length;
			while( iLen > 0 ){

				best = null;

				aOpened.sort( _sort );
				oCurrent = aOpened[ 0 ];
				//trace( oCurrent.dx+" | "+oCurrent.dy);
				if( oCurrent == oEnd ){
					var res : Array<Int> = new Array<Int>( );
					var node = oEnd;
					while( node.parent != null ){
						res.unshift( node.dy );
						res.unshift( node.dx );
						node = node.parent;
					}
					return res;
				}

				aOpened.remove( oCurrent );
				aClosed.push( oCurrent );

				aNear = _getNeightbors( oCurrent );
				for( node in aNear ){

					if( aClosed.copy( ).remove( node ) )
						continue;
					
					g = oCurrent.g + node.travelCost;

					if( !aOpened.copy( ).remove( node ) ){
						aOpened.push( node );
						node.h = distManhattan( node.dx , node.dy , oEnd.dx , oEnd.dy );
						b = true;
					}else if( g < node.g ) 
						b = true;
					else
						b = false;

					if( b ){
						node.parent = oCurrent;
						node.g      = g;
						node.f      = node.g + node.h;
						best        = node;
					}
				}
				iLen = aOpened.length;
			}

			return null;
			
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function close( dx : Int , dy : Int ) : Void {
			_aContent.get( dx , dy ).value = false;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		inline public function distManhattan( dx1 : Int , dy1 : Int , dx2 : Int , dy2 : Int ) : Float {
			return Math.abs( dx1 - dx2 + dy1 - dy2 );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		inline public function distEuclidian( dx1 : Int , dy1 : Int , dx2 : Int , dy2 : Int ) : Float {
			return Math.sqrt( Math.pow( ( dx1 - dx2 ) , 2 ) + Math.pow( ( dy1 - dy2 ) , 2 ) );
		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _sort( node1 : AStarNode , node2 : AStarNode ) : Int{

			if( node1.f > node2.f )
				return 1;
			else if( node1.f < node2.f )
				return -1;
			else
				return 0;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		inline private function _getNeightbors( oNode : AStarNode ) : Array<AStarNode>{
			
			var res : Array<AStarNode> = new Array<AStarNode>( );

			var posX : Int;
			var posY : Int;
			var node : AStarNode;

			for( dy in -1...2 ){
				for( dx in -1...2 ){

					if( ( dx == 0 && dy == 0 ) || ( !_bAllowDiag && dx != 0 && dy != 0 ) )
						continue;

					posX = dx + oNode.dx;
					posY = dy + oNode.dy;
					if( !_aContent.validate( posX , posY ) )
						continue;

					node = _aContent.get( posX , posY );
					if( isClosed( posX , posY ) )
						continue;
					
					node.travelCost = 10;
					res.push( node );
				}
			}

			return res;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _reset( ) : Void{
			for( dy in 0..._iHeight )
				for( dx in 0..._iWidth )
					_aContent.set( dx , dy , new AStarNode( dx , dy ) );
		}

	// -------o misc
	
}

/**
 * ...
 * @author shoe[box]
 */

class AStarNode{

	public var parent     : AStarNode;
	public var value      : Bool;
	public var f          : Float;
	public var g          : Float;
	public var h          : Float;
	public var travelCost : Float;
	public var dx         : Int;
	public var dy         : Int;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( dx : Int , dy : Int , value : Bool = true ) {
			this.dx    = dx;
			this.dy    = dy;
			this.value = value;
			f          = 0.0;
			g          = 0.0;
			h          = 0.0;
			travelCost = 0.0;
		}
	
	// -------o public
		
	// -------o protected
	
	// -------o misc
	
}
