//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
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
#import "SCDToolbarView.h"
#import <SciChart.Examples/SCDExampleBaseViewController.h>
#import <SciChart.Examples/SCDConstants.h>
#import <SciChart.Examples/SCDMenuItem.h>

@implementation SCDExampleViewController {
    SCDExampleBaseViewController *_exampleVC;
    SCDToolbarView *_toolbarView;
}

@synthesize menuButton = _menuButton;
@synthesize backButton = _backButton;

- (instancetype)initWithExampleController:(SCDExampleBaseViewController *)exampleController {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _exampleVC = exampleController;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _exampleVC.view.frame = self.view.bounds;
    
    
    
    [self addChildViewController:_exampleVC];
    [self.view addSubview:_exampleVC.view];
}


- (UIButton *)menuButton {
    if (_menuButton == nil) {
        _menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIImage *image = [[UIImage imageNamed:@"chart.more"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_menuButton setImage:image forState:UIControlStateNormal];
        _menuButton.tintColor = [UIColor colorWithRed:(145/255.f) green:(147/255.f) blue:(149/255.f) alpha:1.0];
        _menuButton.backgroundColor = [UIColor colorWithRed:(23/255.f) green:(36/255.f) blue:(61/255.f) alpha:0.3];
        _menuButton.layer.cornerRadius = 8;
        _menuButton.layer.borderWidth = 1;
        _menuButton.layer.borderColor = [UIColor colorWithRed:(76/255.f) green:(81/255.f) blue:(86/255.f) alpha:0.7].CGColor;
        [_menuButton addTarget:self action:@selector(p_SCD_showSettings) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuButton;
}

- (UIButton *)backButton {
    if (_backButton == nil) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIImage *image = [[UIImage imageNamed:@"charts.back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_backButton setImage:image forState:UIControlStateNormal];
        _backButton.tintColor = [UIColor colorWithRed:(145/255.f) green:(147/255.f) blue:(149/255.f) alpha:1.0];
        _backButton.backgroundColor = [UIColor colorWithRed:(23/255.f) green:(36/255.f) blue:(61/255.f) alpha:0.3];
        _backButton.layer.cornerRadius = 8;
        _backButton.layer.borderWidth = 1;
        _backButton.layer.borderColor = [UIColor colorWithRed:(76/255.f) green:(81/255.f) blue:(86/255.f) alpha:0.7].CGColor;
        [_backButton addTarget:self action:@selector(p_SCD_navigateHome) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationController.navigationBar.titleTextAttributes = @{
        NSFontAttributeName:[UIFont fontWithName:@"Inter-Regular" size:21],
        NSForegroundColorAttributeName: [UIColor whiteColor]
        };
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.menuButton];
}

- (void)p_SCD_navigateHome {
    CATransition *transition = [CATransition new];
    transition.duration = 0.25;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController popViewControllerAnimated:false];
}

- (void)p_SCD_showSettings {
    
    if (_toolbarView != nil) {
        [_toolbarView removeFromSuperview];
        _toolbarView = nil;
        self.menuButton.backgroundColor = [UIColor colorWithRed:(23/255.f) green:(36/255.f) blue:(61/255.f) alpha:0.3];
        self.menuButton.tintColor = [UIColor colorWithRed:(145/255.f) green:(147/255.f) blue:(149/255.f) alpha:1.0];
    } else {
        NSArray *toolbarItems = [_exampleVC generateToolbarItems];
        if (toolbarItems.count == 0) return;
        self.menuButton.backgroundColor = [UIColor colorWithRed:(71/255.f) green:(189/255.f) blue:(230/255.f) alpha:1.0];
        self.menuButton.tintColor = [UIColor colorWithRed:(23/255.f) green:(36/255.f) blue:(61/255.f) alpha:1.0];
        _toolbarView = [[SCDToolbarView alloc] initWithItems:toolbarItems];
        _toolbarView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addSubview:_toolbarView];
        [NSLayoutConstraint activateConstraints:@[
            [_toolbarView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0],
            [_toolbarView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0],
        ]];
    }
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
