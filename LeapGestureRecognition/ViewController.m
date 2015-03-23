//
//  ViewController.m
//  LeapGestureRecognition
//
//  Created by Dave Qorashi on 3/23/15.
//  Copyright (c) 2015 Dave Qorashi. All rights reserved.
//

#import "ViewController.h"
#import "LeapObjectiveC.h"
#import "RawImageView.h"

@implementation ViewController
{
    LeapController *controller;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
//    self.testLabel.stringValue = @"Hello World";
    
    controller = [[LeapController alloc] init];
    [controller addListener:self];
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


#pragma mark - Leap Controller Callbacks

- (void)onInit:(NSNotification *)notification
{
    NSLog(@"Initialized");
}

- (void)onConnect:(NSNotification *)notification
{
    NSLog(@"Connected");
    LeapController *aController = (LeapController *)[notification object];
//    [aController enableGesture:LEAP_GESTURE_TYPE_CIRCLE enable:YES];
//    [aController enableGesture:LEAP_GESTURE_TYPE_KEY_TAP enable:YES];
//    [aController enableGesture:LEAP_GESTURE_TYPE_SCREEN_TAP enable:YES];
//    [aController enableGesture:LEAP_GESTURE_TYPE_SWIPE enable:YES];
    [aController setPolicy:LEAP_POLICY_IMAGES];
    [aController.config save];
}

- (void)onDisconnect:(NSNotification *)notification
{
    //Note: not dispatched when running in a debugger.
    NSLog(@"Disconnected");
}

- (void)onFrame:(NSNotification *)notification
{
    LeapController *aController = (LeapController *)[notification object];
    
    LeapFrame *frame = [aController frame:0];
//    NSLog(@"Frame id: %lld, timestamp: %lld, hands: %ld, fingers: %ld, tools: %ld, gestures: %ld",
//          [frame id], [frame timestamp], [[frame hands] count],
//          [[frame fingers] count], [[frame tools] count], [[frame gestures:nil] count]);
    
    self.testLabel.stringValue = [[NSString alloc] initWithFormat:@"%lld", [frame id]];
    
    
    //Update Picture
    if (frame.images.count > 0) {
        LeapImage *image = [frame.images objectAtIndex:0];
//        LeapImage *rightImage = [frame.images objectAtIndex:1];
        
        NSBitmapImageRep *imgRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                                           pixelsWide:image.width
                                                                           pixelsHigh:image.height
                                                                        bitsPerSample:8
                                                                      samplesPerPixel:1
                                                                             hasAlpha:NO
                                                                             isPlanar:NO
                                                                       colorSpaceName:NSCalibratedWhiteColorSpace
                                                                         bitmapFormat:0
                                                                          bytesPerRow:image.width
                                                                         bitsPerPixel:8];
        
//        NSData * asNSData = [[NSData alloc] initWithBytesNoCopy:(void *)leftImage.data
//                                                         length:leftImage.width * leftImage.height
//                                                        deallocator:^void (void * bytes, NSUInteger length) {}];
        NSImage *nsimage = [[NSImage alloc] initWithSize:NSMakeSize(image.width, image.height)];
        
        unsigned char * bmpData = [imgRep bitmapData];
        memcpy(bmpData, image.data, image.width * image.height);
        
        [nsimage addRepresentation:imgRep];
        
        [self.lImageView setImage:nsimage];
    }
}

@end
