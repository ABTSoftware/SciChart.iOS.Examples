//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ExamplesViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "ExamplesViewController.h"
#import "SCDSharedProjectConfigurator.h"
#import "UIAlertController+SCDAdditional.h"
#import "UIViewController+SCDLoading.h"
#import "ExampleViewBase.h"
#import "SCDConstants.h"
#import "ShowSourceCodeViewController.h"
#import "ModifierTableViewController.h"

@implementation ExamplesViewController {
    UIView<SciChartBaseViewProtocol> * _exampleUIView;
    BOOL _sidebarIsShowing;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"SciChart iOS | %@", _example.exampleName];
    [self addExampleUIView];
    
    _sidebarIsShowing = false;
    UIImage * settingsImage = [UIImage imageNamed:@"BurgerMenu"];
    UIBarButtonItem * menuRightButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:self action:@selector(gotoSettingsMenu)];
    menuRightButton.image = settingsImage;
    
    self.navigationItem.rightBarButtonItem = menuRightButton;
    _menubarViewFromNib.frame = CGRectMake(self.view.frame.size.width, 0, 0, self.view.frame.size.height);
    
    self.navigationItem.backBarButtonItem.title = @"";

    __weak ExamplesViewController * wSelf = self;
    ((ExampleViewBase *)self.view).needsHideSideBarMenu = ^(id sender) {
        if (![sender isEqual:wSelf.menubarViewFromNib]) {
            ExamplesViewController * cached = wSelf;
            if (cached->_sidebarIsShowing) {
                [wSelf pv_hideMenu];
            }
        }
    };
}

- (void)addExampleUIView {
    self.view = [NSClassFromString(_example.exampleFile) new];
}

- (void)gotoSettingsMenu {
    if (_sidebarIsShowing) {
        [self pv_hideMenu];
    } else {
        if (!_menubarViewFromNib) {
            [NSBundle.mainBundle loadNibNamed:@"SideBarMenu" owner:self options:nil];
            _menubarViewFromNib.frame = CGRectMake(self.view.frame.size.width, 0, 200, self.view.frame.size.height);
            [self.view addSubview:_menubarViewFromNib];
            
            __weak typeof(self) weakSelf = self;
            [_menubarViewFromNib setSettingsClickHandler:^{
                [weakSelf performSegueWithIdentifier:@"ExampleSettingsSegue" sender:weakSelf];
            }];
        }
        
        if ([_exampleUIView conformsToProtocol:@protocol(SciChartBaseViewProtocol)]) {
            [_menubarViewFromNib showSettingsExampleOption:_exampleUIView.surface.chartModifiers.count];
        } else {
            [_menubarViewFromNib showSettingsExampleOption:NO];
        }
        
        [UIView animateWithDuration:0.3f delay:.0f options:UIViewAnimationOptionTransitionCurlUp animations:^{
            _exampleUIView.frame = CGRectMake(-200.f, .0f, CGRectGetWidth(_exampleUIView.frame), CGRectGetHeight(_exampleUIView.frame));
            _menubarViewFromNib.frame = CGRectMake(self.view.frame.size.width - 200, .0f, 200.f, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            _sidebarIsShowing = true;
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ExampleSettingsSegue"]){
        ModifierTableViewController * vc = segue.destinationViewController;
        vc.sciSurface = _exampleUIView.surface;
    }
}

- (IBAction)pv_showSourceCodeSelecting:(UIButton *)sender {
    UIAlertController * alertController = [UIAlertController sourceAlertControllerWithSwiftSourceActionHandler:^(UIAlertAction * _Nullable action) {
        [self pv_showSwiftSourceCode:_example.exampleFile atPath:_example.exampleFilePath];
    } andObjcSourceActionHandler:^(UIAlertAction * _Nullable action) {
        [self pv_showObjCSourceCode:_example.exampleFile atPath:_example.exampleFilePath];
    }];
    alertController.popoverPresentationController.sourceView = sender;
    alertController.popoverPresentationController.sourceRect = sender.bounds;
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (void)pv_hideMenu {
    [UIView animateWithDuration:0.3f delay:.0f options:UIViewAnimationOptionTransitionCurlUp animations:^{
        _menubarViewFromNib.frame = CGRectMake(self.view.frame.size.width, 0, 0, self.view.frame.size.height);
        _exampleUIView.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        _sidebarIsShowing = false;
    }];
}

- (void)pv_showSwiftSourceCode:(NSString *)chartName atPath:(NSString *)filePath {
   NSString * absolutePath = [[NSBundle.mainBundle.resourcePath stringByAppendingPathComponent:filePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.swift", _example.exampleFile]];
    NSString * data = [NSString stringWithContentsOfFile:absolutePath encoding:NSUTF8StringEncoding error:nil];
    
    [self showSourceCode:data type:kSwiftSourceCodeType];
}

- (void)pv_showObjCSourceCode:(NSString *)chartName atPath:(NSString *)filePath {
    NSString * absolutePath = [[NSBundle.mainBundle.resourcePath stringByAppendingPathComponent:filePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m", _example.exampleFile]];
    NSString * data = [NSString stringWithContentsOfFile:absolutePath encoding:NSUTF8StringEncoding error:nil];
    
    [self showSourceCode:data type:kObjectiveCSourceCodeType];
}

- (void)showSourceCode:(NSString *)sourceCode type:(NSString *)type {
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShowSourceCodeViewController * controller = [storyBoard instantiateViewControllerWithIdentifier:kSourceCodeViewControllerId];
    
    controller.sourceCodeText = sourceCode;
    controller.sourceCodeType = type;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)pv_shareProjectAction:(UIButton *)sender {
    DidDoneHandler handler = ^(BOOL succes, NSString * pathToZipFile, NSError * error) {
        if (succes) {
            NSURL * url = [NSURL fileURLWithPath:pathToZipFile];
            
            UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
            activityController.popoverPresentationController.sourceView = sender;
            activityController.popoverPresentationController.sourceRect = sender.bounds;
            [self presentViewController:activityController animated:YES completion:nil];
        } else {
            NSLog(@"%@", error);
        }
        [self stopAnimating];
    };
    
    UIAlertController * alertController = [UIAlertController shareAlertControllerWithSwiftShareActionHandler:^(UIAlertAction *action) {
        [self startAnimating];
        [SCDSharedProjectConfigurator pathForZipedSwiftShareProjectWithChartName:_example.exampleFile withHandler:handler];
    } andObjcShareActionHandler:^(UIAlertAction * action) {
        [self startAnimating];
        [SCDSharedProjectConfigurator pathForZipedShareProjectWithChartName:_example.exampleFile withHandler:handler];
    }];
    alertController.popoverPresentationController.sourceView = sender;
    alertController.popoverPresentationController.sourceRect = sender.bounds;
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
