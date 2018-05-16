//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDSharedProjectConfigurator.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDSharedProjectConfigurator.h"
#import "SSZipArchive.h"

static NSString *documentChartExampleTempDirectory = @"ChartExample";
static NSString *documentChartExamplesTempDirectory = @"ChartExamples";
//static NSString *sciChartFrameworkPath = @"SciChart.framework";

// Objc
static NSString *shareChartExampleDirectory = @"ShareChartExample";
static NSString *targetChartViewImplementation = @"ShareChartExample/ChartView.m";
static NSString *sourceChartViewsDirectory = @"ExampleViews";
static NSString *importTargetString = @"#import \"ChartView.h\"";
static NSString *implementationTargetString = @"@implementation ChartView";
static NSString *interfaceTargetString = @"@interface ChartView";
static NSString *projectObjcFile = @"ShareChartExample.xcodeproj/project.pbxproj";

// Swift Share

static NSString *shareChartSwiftExampleDirectory = @"ShareChartSwiftExample";
static NSString *sourceChartViewSwiftDirectory = @"ChartViews";
static NSString *mainStoryBoardFile = @"ShareChartSwiftExample/Base.lproj/Main.storyboard";
static NSString *chartSwiftFile = @"ShareChartSwiftExample/ChartView.swift";
static NSString *projectFile = @"ShareChartSwiftExample.xcodeproj/project.pbxproj";

static NSString *infoPlist = @"Info.plist";


@implementation SCDSharedProjectConfigurator

+ (void)cachedSourceCodeWithHandler:(DidCachedHandler)handler {
    NSMutableDictionary<NSString*, NSString*> *dictionary = [NSMutableDictionary new];

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
    
        NSString *pathToObjcSourceCode = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:sourceChartViewsDirectory];
        
        NSArray<NSString*> *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathToObjcSourceCode error:nil];
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"  +" options:NSRegularExpressionCaseInsensitive error:nil];
        
        for (NSString *file in files) {
            NSURL *urlFile = [NSURL URLWithString:file];
            if ([urlFile.pathExtension isEqualToString:@"m"]) {
                NSString *contentOfFile = [NSString stringWithContentsOfFile:[pathToObjcSourceCode stringByAppendingPathComponent:file]
                                                                    encoding:NSUTF8StringEncoding
                                                                       error:nil];
                contentOfFile = [contentOfFile stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                contentOfFile = [regex stringByReplacingMatchesInString:contentOfFile options:0 range:NSMakeRange(0, [contentOfFile length]) withTemplate:@" "];
                [dictionary setObject:contentOfFile forKey:file];
            }
        }
        
        NSString *pathToSwiftSourceCode = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:sourceChartViewSwiftDirectory];
        files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathToSwiftSourceCode error:nil];
        
        for (NSString *file in files) {
            NSURL *urlFile = [NSURL URLWithString:file];
            if ([urlFile.pathExtension isEqualToString:@"swift"]) {
                NSString *contentOfFile = [NSString stringWithContentsOfFile:[pathToSwiftSourceCode stringByAppendingPathComponent:file]
                                                                    encoding:NSUTF8StringEncoding
                                                                       error:nil];
                contentOfFile = [contentOfFile stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                contentOfFile = [regex stringByReplacingMatchesInString:contentOfFile options:0 range:NSMakeRange(0, [contentOfFile length]) withTemplate:@" "];
                [dictionary setObject:contentOfFile forKey:file];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler(YES, dictionary, nil);
            }
        });
        
        
    });
    
}

+ (void)pathForZipedShareProjectWithChartName:(NSString*)chartName withHandler:(DidDoneHandler)handler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSError *error = nil;
        NSString *documetnPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pathToCopy = [documetnPath stringByAppendingPathComponent:documentChartExampleTempDirectory];
        
        
        [self pv_createObjcShareProjectWithChartName:chartName andPathToCopyShareProject:pathToCopy withError:&error];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(NO, nil, error);
                }
            });
            return;
        }
        
        
        NSString *documetnPathToZip = [documetnPath stringByAppendingPathComponent:@"ChartExample.zip"];
       
//        [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:sciChartFrameworkPath]
//                                                toPath:[[pathToCopy stringByAppendingPathComponent:shareChartExampleDirectory] stringByAppendingPathComponent:sciChartFrameworkPath]
//                                                 error:&error];

        if ([SSZipArchive createZipFileAtPath:documetnPathToZip
                      withContentsOfDirectory:pathToCopy] ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(YES, documetnPathToZip, nil);
                }
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(NO, nil, nil);
                }
            });
        }
        [[NSFileManager defaultManager] removeItemAtPath:pathToCopy error:nil];

    });
    
}

+ (void)pathForZipedSwiftShareProjectWithChartName:(NSString *)chartNameFull withHandler:(DidDoneHandler)handler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *chartName = [chartNameFull stringByReplacingOccurrencesOfString:@"SCD" withString:@""];
        NSString *documetnPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pathToExampleInDocument = [documetnPath stringByAppendingPathComponent:documentChartExampleTempDirectory];
        NSError *error = nil;
        
        [self pv_createSwiftShareProjectWithChartName:chartName
                            andPathToCopyShareProject:pathToExampleInDocument
                                            withError:&error];
        
        NSString *documetnPathToZip = [documetnPath stringByAppendingPathComponent:@"ChartExample.zip"];

//        [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:sciChartFrameworkPath]
//                                                toPath:[[pathToExampleInDocument stringByAppendingPathComponent:shareChartSwiftExampleDirectory] stringByAppendingPathComponent:sciChartFrameworkPath]
//                                                 error:&error];
        
        if ([SSZipArchive createZipFileAtPath:documetnPathToZip
                      withContentsOfDirectory:pathToExampleInDocument] ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(YES, documetnPathToZip, nil);
                }
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(NO, nil, nil);
                }
            });
        }
        [[NSFileManager defaultManager] removeItemAtPath:pathToExampleInDocument error:nil];

    });
}

+ (void)pathForZipedSwiftShareProjectWithChartNames:(NSArray<NSString*>*)chartNames withHandler:(DidDoneHandler)handler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
        NSString *documetnPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pathToExamplesInDocument = [documetnPath stringByAppendingPathComponent:documentChartExamplesTempDirectory];
        NSString *resourcePath = [NSBundle mainBundle].resourcePath;
        NSError *error = nil;
        
        
        for (NSString *chartNameFull in chartNames) {
            NSString *chartName = [chartNameFull stringByReplacingOccurrencesOfString:@"SCD" withString:@""];
             [[NSFileManager defaultManager] createDirectoryAtPath:[pathToExamplesInDocument stringByAppendingPathComponent:chartName]
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:&error];
            NSString *pathToCurrentprojectExample = [pathToExamplesInDocument stringByAppendingPathComponent:chartName];
            
            [self pv_createSwiftShareProjectWithChartName:chartName
                             andPathToCopyShareProject:pathToCurrentprojectExample
                                             withError:&error];
            
            NSString *contentOfProjectFile = [NSString stringWithContentsOfFile:[pathToCurrentprojectExample stringByAppendingPathComponent:projectFile]
                                                                       encoding:NSUTF8StringEncoding
                                                                          error:&error];
            
            contentOfProjectFile = [contentOfProjectFile stringByReplacingOccurrencesOfString:@"path = SciChart.framework; sourceTree = \"<group>\";"
                                                                                   withString:@"name = SciChart.framework; path = \"../SciChart.framework\"; sourceTree = SOURCE_ROOT;"];
            
            contentOfProjectFile = [contentOfProjectFile stringByReplacingOccurrencesOfString:@"\"$(PROJECT_DIR)/ShareChartSwiftExample\","
                                                                                   withString:@"\"$(PROJECT_DIR)/ShareChartSwiftExample\", \"$(PROJECT_DIR)/..\","];
            
            contentOfProjectFile = [contentOfProjectFile stringByReplacingOccurrencesOfString:@"path = SciChart.framework/SwiftUtil/SCIGenericWrapper.swift; sourceTree = \"<group>\";"
                                                                                   withString:@"path = \"../SciChart.framework/SwiftUtil/SCIGenericWrapper.swift\"; sourceTree = SOURCE_ROOT;"];

            
            [contentOfProjectFile writeToFile:[pathToCurrentprojectExample stringByAppendingPathComponent:projectFile]
                                   atomically:YES
                                     encoding:NSUTF8StringEncoding
                                        error:&error];

        }
               
//        [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:sciChartFrameworkPath]
//                                                toPath:[pathToExamplesInDocument stringByAppendingPathComponent:sciChartFrameworkPath]
//                                                 error:&error];
        
        [[NSFileManager defaultManager] copyItemAtPath:[resourcePath stringByAppendingPathComponent:@"CheckExamplesScript.sh"]
                                                toPath:[pathToExamplesInDocument stringByAppendingPathComponent:@"CheckExamplesScript.sh"]
                                                 error:&error];
        
        NSString *documetnPathToZip = [documetnPath stringByAppendingPathComponent:@"ChartExamples.zip"];
        
        
        if ([SSZipArchive createZipFileAtPath:documetnPathToZip
                      withContentsOfDirectory:pathToExamplesInDocument] ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(YES, documetnPathToZip, nil);
                }
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(NO, nil, nil);
                }
            });
        }
        [[NSFileManager defaultManager] removeItemAtPath:pathToExamplesInDocument error:nil];
    
    });
}

+ (void)pathForZipedObjcShareProjectWithChartNames:(NSArray<NSString*>*)chartNames withHandler:(DidDoneHandler)handler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSString *documetnPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pathToExamplesInDocument = [documetnPath stringByAppendingPathComponent:documentChartExamplesTempDirectory];
        NSString *resourcePath = [NSBundle mainBundle].resourcePath;
        NSError *error = nil;
        
        
        for (NSString *chartName in chartNames) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[pathToExamplesInDocument stringByAppendingPathComponent:chartName]
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            NSString *pathToCurrentprojectExample = [pathToExamplesInDocument stringByAppendingPathComponent:chartName];
            
            [self pv_createObjcShareProjectWithChartName:chartName
                               andPathToCopyShareProject:pathToCurrentprojectExample
                                               withError:&error];
            
            NSString *contentOfProjectFile = [NSString stringWithContentsOfFile:[pathToCurrentprojectExample stringByAppendingPathComponent:projectObjcFile]
                                                                       encoding:NSUTF8StringEncoding
                                                                          error:&error];
            
            contentOfProjectFile = [contentOfProjectFile stringByReplacingOccurrencesOfString:@"path = SciChart.framework; sourceTree = \"<group>\";"
                                                                                   withString:@"name = SciChart.framework; path = \"../SciChart.framework\"; sourceTree = SOURCE_ROOT;"];
            
            contentOfProjectFile = [contentOfProjectFile stringByReplacingOccurrencesOfString:@"\"$(PROJECT_DIR)/ShareChartExample\","
                                                                                   withString:@"\"$(PROJECT_DIR)/ShareChartExample\", \"$(PROJECT_DIR)/..\","];
            
            
            [contentOfProjectFile writeToFile:[pathToCurrentprojectExample stringByAppendingPathComponent:projectObjcFile]
                                   atomically:YES
                                     encoding:NSUTF8StringEncoding
                                        error:&error];
            
        }
        
//        [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:sciChartFrameworkPath]
//                                                toPath:[pathToExamplesInDocument stringByAppendingPathComponent:sciChartFrameworkPath]
//                                                 error:&error];

        
        [[NSFileManager defaultManager] copyItemAtPath:[resourcePath stringByAppendingPathComponent:@"CheckExamplesScript.sh"]
                                                toPath:[pathToExamplesInDocument stringByAppendingPathComponent:@"CheckExamplesScript.sh"]
                                                 error:&error];
        
        NSString *documetnPathToZip = [documetnPath stringByAppendingPathComponent:@"ChartExamples.zip"];
        
        
        if ([SSZipArchive createZipFileAtPath:documetnPathToZip
                      withContentsOfDirectory:pathToExamplesInDocument] ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(YES, documetnPathToZip, nil);
                }
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(NO, nil, nil);
                }
            });
        }
        [[NSFileManager defaultManager] removeItemAtPath:pathToExamplesInDocument error:nil];
        
    });
    
}

+ (NSString*)pv_createObjcShareProjectWithChartName:(NSString*)chartName andPathToCopyShareProject:(NSString*)pathToCopy withError:(NSError**)error {
    
    NSString *chartNameFileImplementation = [NSString stringWithFormat:@"%@.m", chartName];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *sourceChartFileImplementation = [[resourcePath stringByAppendingPathComponent:sourceChartViewsDirectory] stringByAppendingPathComponent:chartNameFileImplementation];
    NSString *pathToShareChartExample = [resourcePath stringByAppendingPathComponent:shareChartExampleDirectory];
    
    [[NSFileManager defaultManager] removeItemAtPath:pathToCopy
                                               error:nil];
    
    [[NSFileManager defaultManager] copyItemAtPath:pathToShareChartExample
                                            toPath:pathToCopy
                                             error:error];
    
    NSString *implementationSourceChartView = [NSString stringWithContentsOfFile:sourceChartFileImplementation
                                                                        encoding:NSUTF8StringEncoding
                                                                           error:error];
    

    
    implementationSourceChartView = [implementationSourceChartView stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"#import \"%@.h\"", chartName]
                                                                                             withString:importTargetString];
    
    implementationSourceChartView = [implementationSourceChartView stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"@implementation %@", chartName]
                                                                                             withString:implementationTargetString];
    
    implementationSourceChartView = [implementationSourceChartView stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"@interface %@", chartName]
                                                                                             withString:interfaceTargetString];
    

    
    [implementationSourceChartView writeToFile:[pathToCopy stringByAppendingPathComponent:@"ShareChartExample/ChartView.m"]
                                    atomically:NO
                                      encoding:NSUTF8StringEncoding
                                         error:error];
    
    NSString *chartNameFileHeader = [NSString stringWithFormat:@"%@.h", chartName];

    NSString *sourceChartFileHeader = [[resourcePath stringByAppendingPathComponent:sourceChartViewsDirectory] stringByAppendingPathComponent:chartNameFileHeader];

    NSString *headerSourceChartView = [NSString stringWithContentsOfFile:sourceChartFileHeader
                                                                encoding:NSUTF8StringEncoding
                                                                   error:error];
    
    headerSourceChartView = [headerSourceChartView stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@", chartName]
                                                                             withString:@"ChartView"];
    
    NSString *plistPath = [NSString stringWithFormat:@"%@/%@/%@", pathToCopy, shareChartExampleDirectory, infoPlist];
    NSDictionary *plistContent = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    [plistContent setValue:@"$(EXECUTABLE_NAME)" forKey:@"CFBundleExecutable"];
    [plistContent writeToFile:plistPath atomically:YES];
    plistContent = [[NSDictionary alloc] initWithContentsOfFile:plistPath];

    [headerSourceChartView writeToFile:[pathToCopy stringByAppendingPathComponent:@"ShareChartExample/ChartView.h"]
                            atomically:NO
                              encoding:NSUTF8StringEncoding
                                 error:error];

    
    
    return pathToCopy;
}

+ (NSString*)pv_createSwiftShareProjectWithChartName:(NSString*)chartName andPathToCopyShareProject:(NSString*)pathToCopy withError:(NSError**)error {
    
    NSString *chartClassName = [@"SCS" stringByAppendingString:chartName];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *pathToShareChartExample = [resourcePath stringByAppendingPathComponent:shareChartSwiftExampleDirectory];
    
    [[NSFileManager defaultManager] removeItemAtPath:pathToCopy
                                               error:nil];
    
    [[NSFileManager defaultManager] copyItemAtPath:pathToShareChartExample
                                            toPath:pathToCopy
                                             error:error];
    
    
    NSString *storyBoard = [NSString stringWithContentsOfFile:[pathToCopy stringByAppendingPathComponent:mainStoryBoardFile]
                                                     encoding:NSUTF8StringEncoding
                                                        error:error];
    
    storyBoard = [storyBoard stringByReplacingOccurrencesOfString:@"customClass=\"ChartView\"" withString:[NSString stringWithFormat:@"customClass=\"%@\"", chartClassName]];
    [storyBoard writeToFile:[pathToCopy stringByAppendingPathComponent:mainStoryBoardFile]
                 atomically:YES
                   encoding:NSUTF8StringEncoding
                      error:error];
    
    NSString *plistPath = [NSString stringWithFormat:@"%@/%@/%@", pathToCopy, shareChartSwiftExampleDirectory, infoPlist];
    NSDictionary *plistContent = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    [plistContent setValue:@"$(EXECUTABLE_NAME)" forKey:@"CFBundleExecutable"];
    [plistContent writeToFile:plistPath atomically:YES];
    plistContent = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSString *pathToSourceSwiftFile = [resourcePath stringByAppendingPathComponent:[NSString stringWithFormat:@"ChartViews/%@.swift", chartClassName]];
    
    NSString *chartViewSourceSwiftFile = [NSString stringWithContentsOfFile:pathToSourceSwiftFile
                                                                   encoding:NSUTF8StringEncoding
                                                                      error:error];
    
    [chartViewSourceSwiftFile writeToFile:[pathToCopy stringByAppendingPathComponent:chartSwiftFile]
                               atomically:YES
                                 encoding:NSUTF8StringEncoding
                                    error:error];

    return pathToCopy;
}



@end
