ANE-QR-ZBar
===========

A QRCode scanner ANE for adobe flash iOS extension. Will scan barcodes using the zbar library

This QR Scanner uses ZBar iPhone library. It has a flash wrapper so you can connect to the Native Code via Actionscript so flash developers get native performance for scanning but speedy production from flash.

Original Libraries
---------

The original ZBar QR Scanner for iOS can be found here:
http://zbar.sourceforge.net/iphone/sdkdoc/

Files
---------

Thanks to the ANE-Wizard here on github (thanks FreshPlanet) our files are organised in four folders.

* AS (The AS3 wrapper)
* Binaries (Where you will find the .ane file and the components that made that file)
* NativeAndroid (empty, sorry to mislead)
* NativeIOS (Xcode project for the native library)

To Compile
---------

To compile the ANE file, first configure the build.properties with your paths.
Then call 'ant' in the directory with build.xml

Sample Code
---------

Here is a snippet of how the actionscript side works:

	package
	{
		import flash.display.Sprite;
		import com.rancondev.extensions.qrzbar.QRZBar;
		import com.rancondev.extensions.qrzbar.QRZBarEvent;
		
		
		public class TestQRZBar extends Sprite
		{
			private var qrExtension:QRZBar;

			public function TestQRZBar()
			{
		 		qrExtension = QRZBar.getInstance();	
				qrExtension.addEventListener(QRZBarEvent.SCANNED_BAR_CODE, onScan);
				qrExtension.addEventListener(QRZBarEvent.CANCELED_SCAN, onCancel);
				qrExtension.scan();
			}
			
			private function onScan(e:QRZBarEvent):void
			{
				trace("Scanned barcode: " + e.result);
			}
			
			private function onCancel(e:QRZBarEvent):void
			{
				trace("User canceled scan");
			}
		}
	}

