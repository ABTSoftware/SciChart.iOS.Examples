//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDPermissionRequestHelper.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDPermissionRequestHelper.h"
#import <AVFoundation/AVFoundation.h>

@implementation SCDPermissionRequestHelper

+ (void)requestPermission:(void (^)(bool))completion {
#if TARGET_OS_OSX
    if (@available(macOS 10.14, *)) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            completion(granted);
        }];
    } else {
        
    }
#elif TARGET_OS_IOS
    [AVAudioSession.sharedInstance requestRecordPermission:^(BOOL granted) {
        completion(granted);
    }];
#endif
}

@end
