//
//  SCDFileManager.h
//  SciChartDemo
//
//  Created by Admin on 5/26/16.
//  Copyright © 2016 ABT. All rights reserved.
//

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
