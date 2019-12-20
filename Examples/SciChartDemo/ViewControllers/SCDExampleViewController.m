//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDExampleViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDExampleViewController.h"
#import "SCDExampleSettingsViewController.h"
#import "SCDMenuItem.h"
#import "ExampleViewBase.h"

@implementation SCDExampleViewController {
    SCDExampleItem *_example;
    BOOL _isSwift;
}

- (instancetype)initWithExample:(SCDExampleItem *)example isSwift:(BOOL)isSwift {
    self = [super init];
    if (self) {
        _example = example;
        _isSwift = isSwift;
    }
    return self;
}

- (void)loadView {
    NSString *namespace = [[NSBundle.mainBundle.infoDictionary[@"CFBundleExecutable"] stringByReplacingOccurrencesOfString:@"-" withString:@"_"] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    // If swift - create swift example view, otherwise - Obj-C
    NSString *className = _isSwift ? [NSString stringWithFormat:@"%@.%@", namespace, _example.fileName] : _example.fileName;
    
    self.view = [NSClassFromString(className) new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _example.title;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon.more"] style:UIBarButtonItemStylePlain target:self action:@selector(p_SCD_showSettings)];
}

- (void)p_SCD_showSettings {
    NSMutableDictionary<NSNumber *, NSArray<id<ISCDMenuItem>> *> *settings = [NSMutableDictionary<NSNumber *, NSArray<id<ISCDMenuItem>> *> new];
    settings[@(0)] = [self p_SCD_appWideSettings];
    
    SCDExampleSettingsViewController *viewController = [SCDExampleSettingsViewController new];
    viewController.settings = settings;
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    // [self presentViewController:viewController animated:YES completion:nil];
}

- (NSArray<id<ISCDMenuItem>> *)p_SCD_appWideSettings {
    return @[
        [[SCDMenuItem alloc] initWithTitle:@"Show source code" subtitle:nil iconImageName:@"icon.chevron.left.slash.right" andAction:^{
            // TODO: Implement show source code with swift/obj-c options
        }],
        [[SCDMenuItem alloc] initWithTitle:@"Share project" subtitle:nil iconImageName:@"icon.share" andAction:^{
            // TODO: Implement Share Project
        }],
#ifdef DEBUG
        [[SCDMenuItem alloc] initWithTitle:@"Dev options" subtitle:nil iconImageName:@"icon.hammer" andAction:^{
            // TODO: Implement custom dev options
        }],
#endif
    ];
}

// MARK: - Show source code
//- (IBAction)pv_showSourceCodeSelecting:(UIButton *)sender {
//    UIAlertController * alertController = [UIAlertController sourceAlertControllerWithSwiftSourceActionHandler:^(UIAlertAction * _Nullable action) {
//        [self pv_showSwiftSourceCode:_example.exampleFile];
//    } andObjcSourceActionHandler:^(UIAlertAction * _Nullable action) {
//        [self pv_showObjCSourceCode:_example.exampleFile];
//    }];
//    alertController.popoverPresentationController.sourceView = sender;
//    alertController.popoverPresentationController.sourceRect = sender.bounds;
//
//    [self.navigationController presentViewController:alertController animated:YES completion:nil];
//}
//
//- (void)pv_showSwiftSourceCode:(NSString *)chartName {
//    NSString * nameUIView = [_example.exampleFile stringByReplacingOccurrencesOfString:@"SCD" withString:@""];
//    NSString * filePath = [[NSBundle.mainBundle.resourcePath stringByAppendingPathComponent:@"ChartViews"] stringByAppendingPathComponent:[NSString stringWithFormat:@"SCS%@.swift", nameUIView]];
//    NSString * data = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//
//    [self showSourceCode:data type:kSwiftSourceCodeType];
//}
//
//- (void)pv_showObjCSourceCode:(NSString *)chartName {
//    NSString * filePath = [[NSBundle.mainBundle.resourcePath stringByAppendingPathComponent:@"ExampleViews"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m", _example.exampleFile]];
//    NSString * data = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//
//    [self showSourceCode:data type:kObjectiveCSourceCodeType];
//}
//
//- (void)showSourceCode:(NSString *)sourceCode type:(NSString *)type {
//    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ShowSourceCodeViewController * controller = [storyBoard instantiateViewControllerWithIdentifier:SCDSourceCodeControllerID];
//
//    controller.sourceCodeText = sourceCode;
//    controller.sourceCodeType = type;
//
//    [self.navigationController pushViewController:controller animated:YES];
//}
//
//// MARK: - Share project
//- (IBAction)pv_shareProjectAction:(UIButton *)sender {
//    DidDoneHandler handler = ^(BOOL succes, NSString * pathToZipFile, NSError * error) {
//        if (succes) {
//            NSURL * url = [NSURL fileURLWithPath:pathToZipFile];
//
//            UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
//            activityController.popoverPresentationController.sourceView = sender;
//            activityController.popoverPresentationController.sourceRect = sender.bounds;
//            [self presentViewController:activityController animated:YES completion:nil];
//        } else {
//            NSLog(@"%@", error);
//        }
//    };
//
//    UIAlertController * alertController = [UIAlertController shareAlertControllerWithSwiftShareActionHandler:^(UIAlertAction *action) {
//        [SCDSharedProjectConfigurator pathForZipedSwiftShareProjectWithChartName:_example.exampleFile withHandler:handler];
//    } andObjcShareActionHandler:^(UIAlertAction * action) {
//        [SCDSharedProjectConfigurator pathForZipedShareProjectWithChartName:_example.exampleFile withHandler:handler];
//    }];
//    alertController.popoverPresentationController.sourceView = sender;
//    alertController.popoverPresentationController.sourceRect = sender.bounds;
//
//    [self presentViewController:alertController animated:YES completion:nil];
//}

@end
