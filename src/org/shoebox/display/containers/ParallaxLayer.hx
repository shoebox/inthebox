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
package org.shoebox.display.containers;

	import nme.display.DisplayObject;
	import nme.display.BitmapData;
	import nme.display.Bitmap;
	import nme.display.IBitmapDrawable;
	import nme.display.Sprite;
	import nme.filters.BitmapFilter;
	import nme.filters.BlurFilter;
	import nme.geom.Matrix;
	import nme.geom.Point;
	import nme.geom.Rectangle;
	import nme.Lib;
	
	import org.shoebox.geom.AABB;
	import org.shoebox.core.BoxMath;
	import org.shoebox.core.Vector2D;
	import org.shoebox.geom.FPoint;
	
	/**
	* ParallaxLayer
	* @author shoebox
	*/
	class ParallaxLayer extends Bitmap{
		
		public var bLoop    : Bool;
		public var position : FPoint;

		private var _oLimits    : AABB;
		private var _bmpPattern : BitmapData;
		private var _fDx        : Float;
		private var _fDy        : Float;
		private var _fRefWidth  : Float;
		private var _fRefHeight : Float;
		private var _fSpeed     : Float;
		private var _tmpPos     : FPoint;

		// -------o constructor
		
			/**
			* Constructor of the ParallaxLayer class
			*
			* @public
			* @return	void
			*/
			public function new( 
									bRef   : BitmapData,
									fSpeed : Float = 1.0, 
									bLoop  : Bool 	= true,
									limits : AABB	= null								
								) : Void {
				super( );
				this.bLoop = bLoop;
				
				_fSpeed     = fSpeed;
				_fRefWidth  = bRef.width;
				_fRefHeight = bRef.height;
				if( limits != null ){
					_oLimits = limits;
					_tmpPos  = { x : 0.0 , y : 0.0 };
				}

				if( bLoop ){
					bitmapData = _updatePattern( bRef );
					bRef.dispose( );
				}else
					bitmapData = bRef;
			}

		// -------o public
			
			
			/**
			* 
			* 
			* @public
			* @return	void
			*/
			public function applyFilter( sType : String , value : Dynamic ) : Void {
				
				var filter : BitmapFilter = null;

				switch( sType ){
					
					case 'blur':
						filter = new BlurFilter( value , value , 2 );

				}

				if( filter != null )
					bitmapData.applyFilter( bitmapData , bitmapData.rect , new Point( 0 , 0 ) , filter );

			}


			public function setTransform( dx : Float = 0.0 , dy : Float = 0.0 , fScaleX : Float = 1.0 , fScaleY : Float = 1.0 ) : Void{
				
				position = { x : dx , y : dy };
				_fDx = x = dx;
				_fDy = y = dy;
				scaleX = fScaleX;
				scaleY = fScaleY;
			}
			
			/**
			* dispose function
			* @public
			* @param 
			* @return
			*/
			public function dispose() : Void {
				trace('dispose');
				bitmapData = null;
				_bmpPattern = null;
			}
			
			/**
			* translate function
			* @public
			* @param 
			* @return
			*/
			public function translate( dx : Float , dy : Float ) : Bool{
				
				if( _oLimits != null ){
					_tmpPos.x = position.x + dx * _fSpeed;
					_tmpPos.y = position.y + dy * _fSpeed;
					
					if( !_oLimits.containPoint( _tmpPos.x , _tmpPos.y ) )
						return false;
				}

				position.x += dx * _fSpeed;
				position.y += dy * _fSpeed;
				
				if( bLoop ){
					position.x = _modulate( position.x , _fRefWidth );
					position.y = _modulate( position.y , _fRefHeight );
				}
				
				x = position.x;
				y = position.y;
				return true;
			}
			
		// -------o protected
			
			private function _updatePattern( bRef : BitmapData ) : BitmapData {
				
				var fWidth 	: Float = _fRefWidth;
				var fHeight	: Float = _fRefHeight;
				var iBlocW	: Int = 1;
				var iBlocH 	: Int = 1;
				if( _fRefWidth < Lib.current.stage.stageWidth ){
					
					iBlocW = Math.ceil( Lib.current.stage.stageWidth * 1.5 / _fRefWidth );
					fHeight = iBlocW * _fRefWidth;
				}
				
				
				var bRes 	: BitmapData = new BitmapData( Std.int( fWidth ) * iBlocW , Std.int( fHeight ) * iBlocH , true , 0xFF0000 );
				var ptDes	: Point = new Point( );
				
				for( dx in 0...iBlocW ){
					for( dy in 0...iBlocH ){
						ptDes.x = dx * fWidth;
						ptDes.y = dy * fHeight;
						
						bRes.copyPixels( bRef , bRef.rect , ptDes , null , null , true );
					}
				}
				
				return bRes;				
			}
			
			private function _modulate( fValue : Float , fModulo : Float ) : Float{
				
				#if iphone
					var b : Bool = false;
					var diff : Float = fValue - fModulo;
					if( diff < 0 )
						b = true;
					
					fValue = Math.abs(diff) % fModulo;
					if( b )
						fValue = -fValue;
					
					return fValue;
					
				#else
				return ( fValue - fModulo ) % fModulo;
				#end
			}
			
		// -------o misc

	}
