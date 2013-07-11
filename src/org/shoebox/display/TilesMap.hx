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
package org.shoebox.display;

import flash.display.BitmapData;
import openfl.display.Tilesheet;
import flash.geom.Point;
import flash.geom.Rectangle;
import org.shoebox.core.interfaces.IDispose;
import org.shoebox.geom.FPoint;

/**
 * ...
 * @author shoe[box]
 */

class TilesMap extends Tilesheet  implements IDispose{

	private var _hCycles  : Map<String,Int>;
	private var _hNames   : Map<String,Int>;
	private var _hCenters : Map<String,Point>;
	private var _hBounds  : Map<String,Rectangle>;
	private var _iInc     : Int;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( bmp : BitmapData ) {
			super( bmp );	
			_hNames   = new Map<String,Int>( );
			_hBounds  = new Map<String,Rectangle>( );
			_hCenters = new Map<String,Point>( );
			_iInc     = 0;
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function dispose( ) : Void {
			
			_hCycles  = null;
			_hNames   = null;
			_hBounds  = null;
			_hCenters = null;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function addByName( sName : String , rec : Rectangle , pt : Point ) : Int {
			addTileRect( rec , pt );
			_hCenters.set( Std.string( _iInc ) , pt ); 
			_hBounds.set( Std.string( _iInc ) , rec );
			_hNames.set( sName , _iInc );
			return _iInc++;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getIdByFrame( sCycle : String , iFrame : Int ) : Void {
			
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getIdByName( s : String ) : Int {

			if( !_hNames.exists( s ) )
				throw new flash.errors.Error('Unknow id');

			return _hNames.get( s );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function contains( s : String ) : Bool {
			return _hNames.exists( s );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getCenter( id : Int ) : Point {
			return _hCenters.get( Std.string( id ) );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getRectById( id : Int ) : Rectangle{
			return _hBounds.get( Std.string( id ) );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getTileArray( ) : Array<Float> {
			return [ 0.0 ];
		}

	// -------o protected
	
	// -------o misc
	
}