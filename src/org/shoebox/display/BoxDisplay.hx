package org.shoebox.display;

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Stage;
import nme.display.DisplayObject;
import nme.display.DisplayObjectContainer;
import nme.display.StageAlign;
import nme.geom.Rectangle;
import nme.text.TextField;

import org.shoebox.geom.AABB;

/**
 * ...
 * @author shoe[box]
 */

class BoxDisplay{

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			
		}
	
	// -------o public
				
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function haxeStage( d : DisplayObject ) : nme.display.Stage {
			return nme.Lib.current.stage;		
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function getStageW( d : DisplayObject ) : Int {
			return nme.Lib.current.stage.stageWidth;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function getStageH( d : DisplayObject ) : Int {
			return nme.Lib.current.stage.stageHeight;						
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function purge( d : DisplayObjectContainer ) : Array<Dynamic> {
			var a = [ ];
			while( d.numChildren > 0 ){
				var child = d.getChildAt( 0 );
				a.push( d );
				d.removeChild( child );
			}

			return a;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function distribute( d : DisplayObjectContainer , iMargin : Int , ?bHor : Bool ) : Void {
			DisplayFuncs.distribute_childs( d , iMargin , bHor );						
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function align( d : DisplayObject , ?dx : Int, ?dy : Int , ?where : StageAlign , ?bounds : AABB ) : Void {
			org.shoebox.display.DisplayFuncs.align( d , bounds , where , dx , dy );		
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function centerX( d : DisplayObject ) : Void {
			align( d , 0 , 0 , StageAlign.TOP );						
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		inline static public function alignIn( target : DisplayObject , container : DisplayObject ) : Void {
			DisplayFuncs.align_in_container( target ,container );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		inline static public function xAlignIn( target : DisplayObject , container : DisplayObject ) : Void {
			var bnds_container	= container.getRect( container );
			var bnds_target		= target.getRect( container );
			target.x = Math.round(( bnds_container.width - bnds_target.width ) / 2);
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function rasterize( target : DisplayObject , ?bmp : BitmapData , ?iMarginX : Int , ?iMarginY : Int ) : BitmapData {
			
			var w = Std.int( target.width + iMarginX * 2 );
			var h = Std.int( target.height + iMarginY * 2 );

			var mat = new nme.geom.Matrix( );
				mat.tx = iMarginX;
				mat.ty = iMarginY;

			if( bmp == null || bmp.width != ( target.width + iMarginX * 2 ) || bmp.height != ( target.height + iMarginY * 2 ) )
				bmp = new BitmapData( w , h , true , 0 );
				bmp.unlock( );				
				bmp.draw( target , mat );
				bmp.lock( );

			return bmp;

		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function fit( tf : TextField , w : Float , h : Float , ?size : Float ) : Void {

			
			var i = 0;
			var f;
			while( tf.textWidth > w || tf.textHeight > h ){
				
				f = tf.defaultTextFormat;
				f.size --;				
				tf.setTextFormat( tf.defaultTextFormat = f );
				
			}
		}


	// -------o protected
	
		

	// -------o misc
	
}
