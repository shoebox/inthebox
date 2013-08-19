package org.shoebox.display;

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Stage;
import nme.display.DisplayObject;
import nme.display.DisplayObjectContainer;
import nme.display.StageAlign;
import nme.geom.Rectangle;
import nme.Lib;
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
		static public function align( o : DisplayObject , ?dx : Int, ?dy : Int , ?where : StageAlign , ?bounds : AABB ) : Void {
			var aabb = bounds != null ? bounds : new AABB( 0 , 0 , Lib.current.stage.stageWidth , Lib.current.stage.stageHeight );

			var centerX : Float = aabb.min.x + ( aabb.max.x - aabb.min.x - o.getRect( Lib.current.stage ).width ) / 2;
			var centerY : Float = aabb.min.y + ( aabb.max.y - aabb.min.y - o.getRect( Lib.current.stage ).height ) / 2;

			if( where == null ){
				o.x = centerX + dx;
				o.y = centerY + dy;
				return;
			}

			switch( where ){

				case StageAlign.TOP:
					o.x = centerX;
					o.y = aabb.min.y;

				case StageAlign.LEFT:
					o.x = aabb.min.x;
					o.y = centerY;

				case StageAlign.RIGHT:
					o.x = aabb.max.x - o.width;
					o.y = centerY;

				case StageAlign.BOTTOM:
					o.x = centerX;
					o.y = aabb.max.y - o.height;

				case StageAlign.TOP_LEFT:
					o.x = aabb.min.x;
					o.y = aabb.min.y;

				case StageAlign.BOTTOM_LEFT:
					o.x = aabb.min.x;
					o.y = aabb.max.y - o.height;

				case StageAlign.TOP_RIGHT:
					o.x = aabb.max.x - o.width;
					o.y = aabb.min.y;

				case StageAlign.BOTTOM_RIGHT:
					o.x = aabb.max.x - o.width;
					o.y = aabb.max.y - o.height;
			}

			o.x = Math.round( o.x );
			o.y = Math.round( o.y );

			o.x += dx;
			o.y += dy;
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
		inline static public function xAlignChilds( target : DisplayObjectContainer ) : Void {

			var l = target.numChildren;
			var w = 0.0;
			for( i in 0...l )
				w = Math.max( target.getChildAt( i ).width , w );

			var c;
			for( i in 0...l ){
				c = target.getChildAt( i );
				c.x = Std.int( ( w - c.width ) / 2 );
			}

		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		inline static public function yAlignChilds( target : DisplayObjectContainer ) : Void {

			var l = target.numChildren;
			var h = 0.0;
			for( i in 0...l )
				h = Math.max( target.getChildAt( i ).height , h );

			var c;
			for( i in 0...l ){
				c = target.getChildAt( i );
				c.x = Std.int( ( h - c.height ) / 2 );
			}

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
		static public function fit( tf : TextField , w : Float , h : Float , ?size : Float  ) : Float {

			var i = 0;
			var f;
			var size = tf.defaultTextFormat.size;
			while( tf.textWidth > w || tf.textHeight > h ){

				f = tf.defaultTextFormat;
				size = f.size --;
				tf.setTextFormat( tf.defaultTextFormat = f );

			}

			return size;
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function addChilds( target : DisplayObjectContainer , a : Array<DisplayObject> ) : Void {

			for( d in a )
				target.addChild( d );

		}


	// -------o protected



	// -------o misc

}
