//////////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2013 Rancon (http://rancon.co.uk | hello@rancon.co.uk)
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//    http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  
//////////////////////////////////////////////////////////////////////////////////////

package com.rancondev.extensions.qrzbar
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	[Event(name="scannedBarCode", type="com.rancondev.extensions.qrzbar.QRZBarEvent")]
	[Event(name="canceledScan", type="com.rancondev.extensions.qrzbar.QRZBarEvent")]
	
	public class QRZBar extends EventDispatcher
	{
		private static var _instance:QRZBar;
		
		private var extCtx:ExtensionContext = null;
				
		public function QRZBar()
		{
			if (!_instance)
			{
				extCtx = ExtensionContext.createExtensionContext("com.rancondev.extensions.qrzbar.QRZBar", null);
				if (extCtx == null)
					trace('[QRZBar] Error - Extension Context is null.');
				_instance = this;
			}
			else
			{
				throw Error('This is a singleton, use getInstance(), do not call the constructor directly.');
			}
		}
		
		public static function getInstance() : QRZBar
		{
			return _instance ? _instance : new QRZBar();
		}
		
		
		/**
		 * Checks if the extension is supported
		 */
		public function isSupported() : Boolean
		{
			return extCtx.call('isSupported');
		}
		
		/**
		 * Will open up the scan dialog
		 */
		public function scan():void
		{
			extCtx.addEventListener(StatusEvent.STATUS, onScanHandler);
			extCtx.call("scan");
		}
		
		/**
		 * Will listen from the scanner for results or cancelations
		 */
		private function onScanHandler(event:StatusEvent):void
		{
			switch (event.code)
			{
				case QRZBarEvent.SCANNED_BAR_CODE:
					dispatchEvent(new QRZBarEvent(QRZBarEvent.SCANNED_BAR_CODE, event.level));
					extCtx.removeEventListener(StatusEvent.STATUS, onScanHandler);
					break;
				case QRZBarEvent.CANCELED_SCAN:
					dispatchEvent(new QRZBarEvent(QRZBarEvent.CANCELED_SCAN, event.level));
					extCtx.removeEventListener(StatusEvent.STATUS, onScanHandler);
					break;
				
			}
		}
	}
}
