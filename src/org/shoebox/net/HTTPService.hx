package org.shoebox.net;

#if flash
import flash.events.IOErrorEvent;
#end

import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.ByteArray;
import org.shoebox.core.interfaces.IDispose;

/**
 * ...
 * @author shoe[box]
 */

class HTTPService extends URLLoader  implements IDispose{

	public var method( default , default ) : Method;

	public var onDatas : String->Void;
	public var onBinaryDatas : ByteArray->Void;

	//public var onDatas			: Signal1<String>;
	//public var onBinaryDatas	: Signal1<ByteArray>;

	private var _oVariables	: URLVariables;
	private var _method		: URLRequestMethod;

	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		public function new( ?method : Method , ?format : URLLoaderDataFormat ) {
			super( );
			this.method		= method == null ? GET : method;
			this.dataFormat	= format == null ? TEXT : format;
		}

	// -------o public

		/**
		*
		*
		* @public
		* @return	void
		*/
		override public function load( req : URLRequest ) : Void {
			//trace("load ::: "+req);
			try{
				close( );
			}catch( e : flash.errors.Error ){

			}
			//trace("_oVariables ::: "+_oVariables);
			if( _oVariables != null )
				req.data   = _oVariables;
				req.method = method == GET ? URLRequestMethod.GET : URLRequestMethod.POST;

			addEventListener( Event.COMPLETE , _onDatas	, false );

			#if flash
			addEventListener( IOErrorEvent.IO_ERROR 		, _onIoError	, false );
			addEventListener( IOErrorEvent.DISK_ERROR 		, _onIoError	, false );
			addEventListener( IOErrorEvent.NETWORK_ERROR 	, _onIoError	, false );
			addEventListener( IOErrorEvent.VERIFY_ERROR 	, _onIoError	, false );
			#end

			if( !hasEventListener( HTTPStatusEvent.HTTP_STATUS ) )
				addEventListener( HTTPStatusEvent.HTTP_STATUS 	, _onStatus  	, false );

			try{
				super.load( req );
			}catch( e : flash.errors.Error ){
				//trace('e ::: '+e);
			}
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function dispose( ) : Void {

			onDatas = null;
			onBinaryDatas = null;

			try{
				close( );
			}catch( e : flash.errors.Error ){

			}

			removeEventListener( Event.COMPLETE 				, _onDatas 		, false );
			#if flash
				removeEventListener( IOErrorEvent.IO_ERROR 			, _onIoError	, false );
			removeEventListener( IOErrorEvent.DISK_ERROR 		, _onIoError	, false );
			removeEventListener( IOErrorEvent.NETWORK_ERROR 	, _onIoError	, false );
			removeEventListener( IOErrorEvent.VERIFY_ERROR 		, _onIoError	, false );
			#end
			removeEventListener( HTTPStatusEvent.HTTP_STATUS 	, _onStatus  	, false );
		}

		/**
		*
		*
		* @public
		* @param name : Variable name ( String )
		* @param value : Variable value ( Dynamic )
		* @return	void
		*/
		public function addVariable( name : String , value : Dynamic ) : Void {

			if( _oVariables == null )
				_oVariables = new URLVariables( );

			Reflect.setField( _oVariables , name , value );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function clearVariables( ) : Void {
			_oVariables = null;
		}

	// -------o protected

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _onDatas( e : Event ) : Void{

			if( dataFormat == BINARY )
				_onBinaryDatas( data );
			else if( onDatas != null )
				onDatas( data );

		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _onBinaryDatas( datas : ByteArray ) : Void{
			onBinaryDatas( datas );
		}

		#if flash

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _onIoError( e : IOErrorEvent ) : Void{
			#if debug
			//trace( e );
			#end
			throw e;
		}

		#end

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _onStatus( e : HTTPStatusEvent ) : Void{

			if( e.status > 400 ){
				#if debug
				trace( e );
				#end
				throw e;
			}

		}

	// -------o misc

}

enum Method{
	GET;
	POST;
}
