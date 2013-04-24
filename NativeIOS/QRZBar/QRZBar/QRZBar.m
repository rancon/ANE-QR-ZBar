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

#import "QRZBar.h"
#import "CallZBar.h"

FREContext QRZBarCtx = nil;


@implementation QRZBar

#pragma mark - Singleton

static QRZBar *sharedInstance = nil;

+ (QRZBar *)sharedInstance
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[super allocWithZone:NULL] init];
    }

    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return self;
}

@end


#pragma mark - C interface

/* This is a TEST function that is being included as part of this template. 
 *
 * Users of this template are expected to change this and add similar functions 
 * to be able to call the native functions in the ANE from their ActionScript code
 */
DEFINE_ANE_FUNCTION(IsSupported)
{
    NSLog(@"Entering IsSupported()");

    FREObject fo;

    FREResult aResult = FRENewObjectFromBool(YES, &fo);
    if (aResult == FRE_OK)
    {
        //things are fine
        NSLog(@"Result = %d", aResult);
    }
    else
    {
        //aResult could be FRE_INVALID_ARGUMENT or FRE_WRONG_THREAD, take appropriate action.
        NSLog(@"Result = %d", aResult);
    }
    
    NSLog(@"Exiting IsSupported()");
    
    return fo;
}


DEFINE_ANE_FUNCTION(scan)
{
    NSLog(@"Entering scan()");
    CallZBar *zBar = [[CallZBar alloc] init];
    [zBar scan:context];
    return NULL;
}


#pragma mark - ANE setup

/* QRZBarExtInitializer()
 * The extension initializer is called the first time the ActionScript side of the extension
 * calls ExtensionContext.createExtensionContext() for any context.
 *
 * Please note: this should be same as the <initializer> specified in the extension.xml 
 */
void QRZBarExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) 
{
    NSLog(@"Entering QRZBarExtInitializer()");

    *extDataToSet = NULL;
    *ctxInitializerToSet = &QRZBarContextInitializer;
    *ctxFinalizerToSet = &QRZBarContextFinalizer;

    NSLog(@"Exiting QRZBarExtInitializer()");
}

/* QRZBarExtFinalizer()
 * The extension finalizer is called when the runtime unloads the extension. However, it may not always called.
 *
 * Please note: this should be same as the <finalizer> specified in the extension.xml 
 */
void QRZBarExtFinalizer(void* extData) 
{
    NSLog(@"Entering QRZBarExtFinalizer()");

    // Nothing to clean up.
    NSLog(@"Exiting QRZBarExtFinalizer()");
    return;
}

/* ContextInitializer()
 * The context initializer is called when the runtime creates the extension context instance.
 */
void QRZBarContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    NSLog(@"Entering QRZBarContextInitializer()");

    /* The following code describes the functions that are exposed by this native extension to the ActionScript code.
     * As a sample, the function isSupported is being provided.
     */
    *numFunctionsToTest = 2;

    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToTest));
    func[0].name = (const uint8_t*) "isSupported";
    func[0].functionData = NULL;
    func[0].function = &IsSupported;
    
    func[1].name = (const uint8_t*) "scan";
    func[1].functionData = NULL;
    func[1].function = &scan;

    *functionsToSet = func;

    QRZBarCtx = ctx;

    NSLog(@"Exiting QRZBarContextInitializer()");
}

/* ContextFinalizer()
 * The context finalizer is called when the extension's ActionScript code
 * calls the ExtensionContext instance's dispose() method.
 * If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls ContextFinalizer().
 */
void QRZBarContextFinalizer(FREContext ctx) 
{
    NSLog(@"Entering QRZBarContextFinalizer()");

    // Nothing to clean up.
    NSLog(@"Exiting QRZBarContextFinalizer()");
    return;
}


