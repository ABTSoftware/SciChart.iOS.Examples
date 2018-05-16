//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDSharedProjectConfigurator.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <Foundation/Foundation.h>

typedef void(^DidDoneHandler)(BOOL succes, NSString *pathToZipFile, NSError *error);
typedef void(^DidCachedHandler)(BOOL succes, NSMutableDictionary<NSString*, NSString*> *cachedDictionary, NSError *error);

@interface SCDSharedProjectConfigurator : NSObject

+ (void)cachedSourceCodeWithHandler:(DidCachedHandler)handler;
+ (void)pathForZipedShareProjectWithChartName:(NSString*)chartName withHandler:(DidDoneHandler)handler;
+ (void)pathForZipedSwiftShareProjectWithChartName:(NSString*)chartName withHandler:(DidDoneHandler)handler;
+ (void)pathForZipedSwiftShareProjectWithChartNames:(NSArray<NSString*>*)chartNames withHandler:(DidDoneHandler)handler;
+ (void)pathForZipedObjcShareProjectWithChartNames:(NSArray<NSString*>*)chartNames withHandler:(DidDoneHandler)handler;

@end
