package org.shoebox.core;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

/**
 * ...
 * @author shoe[box]
 */

class BoxTextField{

	// -------o constructor
	
	
	// -------o public
	
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function format( tf : TextField , sAutoSize : TextFieldAutoSize = null , bSelectable : Bool = false , bWordWrap : Bool = true , bMultiLine : Bool = false ) : Void {
			
			if ( sAutoSize == null )
				sAutoSize = TextFieldAutoSize.LEFT;
						
			tf.selectable 	= bSelectable;
			tf.multiline 	= bMultiLine;
			tf.wordWrap 	= bWordWrap;
			tf.autoSize		= sAutoSize;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function setFormat( 
											tf : TextField , 
											bEmbedFonts : Bool = true , 
											sFontName : String = null, 
											iFontSize : Int = 12 , 
											iCol : Int , 
											sAlign = null,
											sAutoSize = null
											) : Void {
			
			if ( sAutoSize != null )
				tf.autoSize = sAutoSize;
			
			tf.embedFonts = bEmbedFonts;
			tf.defaultTextFormat = new TextFormat( sFontName , iFontSize , iCol , false , false , false , null , null , sAlign );
		}

	// -------o protected
	
		

	// -------o misc
	
}