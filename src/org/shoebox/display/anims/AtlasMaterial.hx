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
package org.shoebox.display.anims;
import nme.display.BitmapData;
import nme.display.Tilesheet;
import nme.geom.Point;
import nme.geom.Rectangle;

/**
 * ...
 * @author shoe[box]
 */

class AtlasMaterial extends Tilesheet{

	public var sDefaultCycle				: String;
	public var name (_getName , _setName ) 	: String;
	
	private var _bmpMap						: BitmapData;
	private var _hIsLoop					: Hash<Bool>;
	private var _hFrames					: Hash<AtlasFrame>;
	private var _hLens						: Hash<Int>;
	private var _iTileInc					: Int;
	private var _sName						: String;
	
	private static inline var SEPARATOR : String = ' --0-- ';
	private static inline var POINT     : Point = new Point( 0 , 0 );
	
	// -------o constructor
		
		/**
		* AtlasMaterial constructor method
		* 
		* @public
		* @return	void
		*/
		public function new( bmp : BitmapData ) {
			super( bmp );
			
			#if flash
			_bmpMap = bmp;
			#end
			
			_hFrames 	= new Hash<AtlasFrame>( );
			_hIsLoop 	= new Hash<Bool>( );
			_hLens 		= new Hash<Int>( );
			_iTileInc	= 0;
		}
	
	// -------o public
			
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function dispose( ) : Void {
			//TODO:
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function parseXML( sDesc : String , bmp : BitmapData , sMatName : String = null , fDecalX : Float = 0 , fDecalY : Float = 0 ) : AtlasMaterial {
			
			var oMat : AtlasMaterial = new AtlasMaterial( bmp );
				oMat.name = sMatName;
			
			var x : Xml = Xml.parse( sDesc ).firstElement( );
			var a : Array<String>;
			var h : Hash<Int> = new Hash<Int>( );
			var i : Int;
			var s : String;
			
			//Testing for cycles
				var sName : String;
				for ( item in x.elementsNamed('SubTexture') ) {
					
					sName = item.get('name');
					if ( sName.indexOf('/') == -1 )
						continue;
					
					a = sName.split('/');
					
					s = a[ 0 ];
					i = 0;
						
					if ( h.exists( s ) )
						i = h.get( s );
					
					i++;
					h.set( s , i );

				}
			
			//Parsing
				for ( k in h.keys( ) ) {
					oMat._setCycleLen( k , h.get( k ) );
				}
				
			//
				for ( item in x.elementsNamed('SubTexture') ) {
					sName = item.get('name');
					if ( sName.indexOf('/') == -1 )
						continue;
					
					a = sName.split('/');
					s = a[ 0 ];
					i = Std.parseInt( a[ 1 ] );
					oMat._addFrame( s , i , toRec( item , fDecalX , fDecalY ) );
				}
			
			return oMat;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function toRec( x : Xml , fDecalX : Float = 0 , fDecalY : Float = 0 ) : Rectangle {
			
			return new Rectangle( 
									Std.parseInt( x.get('x') ) + fDecalX,
									Std.parseInt( x.get('y') ) + fDecalY,
									Std.parseInt( x.get('width') ),
									Std.parseInt( x.get('height') )
								);
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getBitmapData( sCycle : String , iFrame : Int  ) : BitmapData {
			
			var f : AtlasFrame = _hFrames.get( sCycle + SEPARATOR + iFrame);
			if ( f == null )
				return null;
				
			if ( f.bitmapData == null )
				_cropBitmapData( f );
			
			return f.bitmapData;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getFrameRec( sCycle : String , iFrame : Int ) : Rectangle {
			var f : AtlasFrame = _hFrames.get( sCycle + SEPARATOR + iFrame);
			return f.rec;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getTileId( sCycle : String , iFrame : Int ) : Int {
			var f : AtlasFrame = _hFrames.get( sCycle + SEPARATOR + iFrame );
			if ( f == null )
				return -1;
				
			return f.tileId;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function hasCycle( s : String ) : Bool {
			return _hLens.exists( s );
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getCycleLen( s : String ) : Int {
			return _hLens.get( s );
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function setIsLoop( sCycle : String , b : Bool ) : Void {
			_hIsLoop.set( sCycle , b );
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getIsLoop( sCycle : String ) : Bool {
			return _hIsLoop.get( sCycle );
		}
		
// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		inline function _setCycleLen( s : String , i : Int ) : Void {
			
			if ( sDefaultCycle == null )
				sDefaultCycle = s;
			
			_hLens.set( s , i );
			_hIsLoop.set( s , true );
		}
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		inline function _addFrame( s : String , i : Int , r : Rectangle ) : Void {
		
			addTileRect( r , new Point( 0 , 0 ) );
			_hFrames.set( s + SEPARATOR + i , new AtlasFrame( s , i , r , _iTileInc ) );
			_iTileInc++;
			
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setName( s : String ) : String {
			return _sName = s;
		}
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getName( ) : String {
			return _sName;
		}
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _cropBitmapData( f : AtlasFrame ) : Void {
			
			f.bitmapData = new BitmapData( Std.int( f.rec.width ) , Std.int( f.rec.height ) , true , 0 );
			f.bitmapData.copyPixels( _bmpMap , f.rec , POINT );
			
		}

	// -------o misc
	
	
}

import nme.Lib;
import nme.display.Sprite;

/**
 * ...
 * @author shoe[box]
 */

class AtlasFrame{

	public var bitmapData		: BitmapData;
	public var iFrame			: Int;
	public var rec				: Rectangle;
	public var sCycle			: String;
	public var tileId			: Int;
	
	// -------o constructor
		
		/**
		* AtlasFrame constructor method
		* 
		* @public
		* @return	void
		*/
		public function new( sCycle : String , iFrame : Int , rec : Rectangle , tileId : Int ) {
			this.sCycle 	= sCycle;
			this.iFrame 	= iFrame;
			this.rec		= rec;
			this.tileId		= tileId;
		}
	
	// -------o public
				
				

	// -------o protected
	
		

	// -------o misc
	
	
}