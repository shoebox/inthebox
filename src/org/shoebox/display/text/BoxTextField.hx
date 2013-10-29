package org.shoebox.display.text;
import flash.errors.Error;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import org.shoebox.display.text.BoxTextField.TextStyle;

/**
 * ...
 * @author shoe[box]
 */
class BoxTextField{

	// -------o constructor
	
		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function applyStyle( tf : TextField , style : TextStyle ) : Void {
			trace("applyStyle ::: " + tf);
			
			//TODO
		}
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function fit( tf : TextField , w : Float , h : Float , step : Int = 2 , startSize : Int = -1 ) : Int {
			
			//Testing if the defaulttext format exists
				#if debug	
				
				if ( tf == null )
					throw new Error("TextField is null");
				
				if ( tf.defaultTextFormat == null )
					throw new Error("The textfield has no defaultTextFormat");
				#end
			
			//The textfield textformat
				var f : TextFormat = tf.defaultTextFormat;				
			
			//Start size
				if ( startSize == -1 )
					startSize = Std.int( f.size );				
				f.size = startSize;
					
			//Apply the "default" defaultTextFormat
				applyTextformat( tf , f );
			
			//Already smaller than the max bounds
				if ( tf.textWidth < w && tf.textHeight < h )
					return Std.int( tf.defaultTextFormat.size );
				
			//Whille the textfield does not fit the bounds the fontsize is reduced
				while ( ( tf.textWidth >= w || tf.textHeight >= h ) && f.size > 0 ) {
					f.size-=step;				
					applyTextformat( tf , f );
				}
			
			return Std.int( tf.defaultTextFormat.size );
		}
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function applyTextformat( tf : TextField , t : TextFormat ) : Void {
			tf.setTextFormat( tf.defaultTextFormat = t );
			tf.text = tf.text;
		}
	
	// -------o public
		
	// -------o protected
	
	// -------o misc
	
}

/**
 * ...
 * @author shoe[box]
 */
typedef TextStyle = {
	public var fontSize : Int;
	@optional public var autoSize : TextFieldAutoSize;
	@optional public var wordWrap : Bool;
}