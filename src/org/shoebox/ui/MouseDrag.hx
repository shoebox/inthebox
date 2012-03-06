package org.shoebox.ui;

import nme.display.InteractiveObject;
import nme.events.Event;
import nme.events.MouseEvent;
#if mobile
import nme.events.TouchEvent;
import nme.ui.Multitouch;
import nme.ui.MultitouchInputMode;
#end
import org.shoebox.geom.FPoint;
import org.shoebox.patterns.commands.AbstractCommand;
import org.shoebox.patterns.commands.ICommand;

/**
 * ...
 * @author shoe[box]
 */

class MouseDrag extends AbstractCommand , implements ICommand{

	public static inline var START : String = 'MouseDrag_START';
	public static inline var STOP  : String = 'MouseDrag_STOP';

	public var startPosition( _getStart , never ) : FPoint;

	private var _bTouchEnabled : Bool;
	private var _fStart        : FPoint;
	private var _iTouchId      : Int;
	private var _fCallBack     : Float->Float->Void;
	private var _oTarget       : InteractiveObject;
	private var _sDown         : String;
	private var _sMove         : String;
	private var _sRel          : String;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( target : InteractiveObject , f : Float->Float->Void , bTouchEnabled : Bool = true ) {
			super( );
			_fCallBack     = f;
			_bTouchEnabled = bTouchEnabled;
			_oTarget       = target;
			_iTouchId      = -1;
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function onExecute( ?e : Event = null ) : Void {
			#if mobile
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				_sDown = TouchEvent.TOUCH_BEGIN;
				_sMove = TouchEvent.TOUCH_MOVE;
				_sRel  = TouchEvent.TOUCH_END;
			#else
				_sDown = MouseEvent.MOUSE_DOWN;
				_sMove = MouseEvent.MOUSE_MOVE;
				_sRel  = MouseEvent.MOUSE_UP;
			#end
			
			_fStart = { x : 0.0 , y : 0.0 };
			_oTarget.addEventListener( _sDown , _onDown , false );
			
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function onCancel( ?e : Event = null ) : Void {
			trace('cancel');
			if( _oTarget == null )
				return;

			_oTarget.removeEventListener( _sDown 	, _onDown 		, false );
			_oTarget.removeEventListener( _sMove 	, _onMove 		, false );
			_oTarget.removeEventListener( _sRel 	, _onMouseUp 	, false );
			_oTarget = null;

		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onDown( e ) : Void{
			
			if( _iTouchId != -1 )
				return;

			#if mobile
				_iTouchId = cast( e , TouchEvent ).touchPointID;
			#end
			
			if( hasEventListener( START ) )
				dispatchEvent( new Event( START ) );

			_fStart.x = e.stageX;
			_fStart.y = e.stageY;
			_oTarget.addEventListener( _sMove , _onMove , false );
			_oTarget.addEventListener( _sRel , _onMouseUp , false );
			
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onMove( e ) : Void{
			
			#if mobile
				var ev = cast( e , TouchEvent );
				if( ev.touchPointID != _iTouchId ) 
					return;
				_iTouchId = ev.touchPointID;
			#end

			_fCallBack( e.stageX - _fStart.x , e.stageY - _fStart.y );
			_fStart.x = e.stageX;
			_fStart.y = e.stageY;

		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onMouseUp( _ ) : Void{
			_oTarget.removeEventListener( _sMove , _onMove , false );
			_oTarget.removeEventListener( _sRel , _onMouseUp , false );
			_iTouchId = -1;
			if( hasEventListener( STOP ) )
				dispatchEvent( new Event( STOP ) );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getStart( ) : FPoint{
			return _fStart;
		}

	// -------o misc
	
}