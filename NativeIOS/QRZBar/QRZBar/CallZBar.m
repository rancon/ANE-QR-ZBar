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

#import "CallZBar.h"

@implementation CallZBar

FREContext *context;
UIView *myControlView;
ZBarReaderViewController *reader;
UIBarButtonItem *infoButton;


- (void) scan:(FREContext *)ctx
{
    context = ctx;
    NSLog(@"Scan");
    // ADD: present a barcode reader that scans from the camera feed
    reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsZBarControls = NO;
    
    // Add a toolbar programatically
    myControlView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Initialize the toolbar
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleBlack;
    
    //Set the toolbar to fit the width of the app.
    [toolbar sizeToFit];
    [toolbar setFrame:CGRectOffset([toolbar frame], 0, CGRectGetHeight([[UIScreen mainScreen] bounds]) - CGRectGetHeight([toolbar frame]))]; 
    
    //Create a button
    infoButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelScan)];
    
    [toolbar setItems:[NSArray arrayWithObjects:infoButton,nil]];
    [myControlView addSubview:toolbar];
    reader.cameraOverlayView = myControlView;
    [toolbar release];
    
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    id delegate = [[UIApplication sharedApplication] delegate];
    [[[delegate window] rootViewController] presentViewController:reader animated:YES completion:nil];
    [reader release];
}

- (void) cancelScan
{
    NSLog(@"Cancel Scan");
    NSString *event_name = @"canceledScan";
    FREDispatchStatusEventAsync(context, (uint8_t*)[event_name UTF8String], (uint8_t*)[event_name UTF8String]);
    [self closeScanner:nil];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    NSLog(@"Recieved Scan");
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
    {
        NSString *event_name = @"scannedBarCode";
        FREDispatchStatusEventAsync(context, (uint8_t*)[event_name UTF8String], (uint8_t*)[[symbol data] UTF8String]);
    }
     
    [self closeScanner:nil];
}

- (void) closeScanner:(FREContext *)ctx
{
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    NSLog(@"Close Scanner");
    
    [reader dismissViewControllerAnimated:YES completion:nil];
    [myControlView release];
    context = nil;
}

@end
