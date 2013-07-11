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
package org.shoebox.core;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;

class BoxBitmapdata {

	/**
	* Resize a bitmapdata to fit in the w/h size
	*	
	* @param 	oSOURCE	: BitmapData source 		(BITMAPDATA)
	* @param	w		: Desired width		(NUMBER) 
	* @param	h		: Desired height		(NUMBER) 
	* @return	result	: Cropeed bitmapdata		(BITMAPDATA)
	*/
	static public function resize( source : BitmapData , w : Float , h : Float , bMax : Bool = false , bZoom : Bool = false , bSmooth : Bool = false ) : BitmapData {
		
		var fRatio : Float = getRatio ( source.width , source.height , w , h , bMax , bZoom );

		var oB : BitmapData = new BitmapData ( Std.int( source.width * fRatio ) , Std.int( source.height * fRatio ) , source.transparent , 0 );
			oB.draw ( source , resizeMatrix( source.width , source.height , w , h , bMax , bZoom ) , null , null , null , bSmooth );

		return oB;
	}	

	/**
	* 
	* 
	* @public
	* @return	void
	*/
	static public function resizeMatrix( fSourceW : Float , fSouceH : Float, w : Float , h : Float , bMax : Bool = false , bZoom : Bool = false ) : Matrix {
		
		var fRatio : Float = getRatio ( fSourceW , fSouceH , w , h , bMax , bZoom );
		if ( fRatio >= 1 && !bZoom )
			return new Matrix( );

		var mat : Matrix = new Matrix( );
			mat.scale( fRatio , fRatio );

		return mat;
	}
	
	/**
	* 
	*
	* @param 
	* @return
	*/
	static public function getBitmapRatio( source : BitmapData , w : Float , h : Float , bMax : Bool = false , bZoom : Bool = false) : Float {
		
		var fRatio : Float;
		if( bMax )
			fRatio = Math.max( w / source.width , h  / source.height );
		else
			fRatio = Math.min( w / source.width , h / source.height );
		
		if( !bZoom )
			fRatio = Math.min( fRatio , 1 ) ;
			
		return fRatio;	
	}

	/**
	* 
	* 
	* @public
	* @return	void
	*/
	static public function getRatio( fW : Float , fH : Float , fMaxW : Float , fMaxH : Float , bMax : Bool = false , bZoom : Bool = false ) : Float {
		
		var fRatio : Float;
		if( bMax )
			fRatio = Math.max( fMaxW / fW , fMaxH  / fH );
		else
			fRatio = Math.min( fMaxW / fW , fMaxH / fH );
		
		if( !bZoom )
			fRatio = Math.min( fRatio , 1 ) ;
			
		return fRatio;	

	}
}