package com.rancondev.extensions.qrzbar
{
	import flash.events.Event;
	
	public class QRZBarEvent extends Event
	{
		public static const SCANNED_BAR_CODE:String = "scannedBarCode";
		public static const CANCELED_SCAN:String = "canceledScan";
		private var _result:String;
		
		public function get result():String
		{
			return _result;
		}
		
		public function QRZBarEvent(type:String, inputResult:String)
		{
			_result = inputResult;
			super(type);
		}
		
		override public function clone() : Event
		{
			return new QRZBarEvent( type, result );
		}
	}
}