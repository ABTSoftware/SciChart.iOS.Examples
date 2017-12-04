//
//  ExampleUIViewController.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 08.03.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "ExampleUIViewController.h"
#import "SCDSharedProjectConfigurator.h"
#import "UIAlertController+SCDAdditional.h"
#import "UIViewController+SCDLoading.h"
#import "SCDExampleView.h"
#import "SCDConstants.h"

@implementation ExampleUIViewController{
    BOOL sidebarIsShowing;
}

@synthesize exampleName;
@synthesize exampleUIView;
@synthesize exampleUIViewName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:[NSString stringWithFormat:@"%@%@", @"SciChart iOS | ", exampleName]];
    [self addExampleUIView];
    
    sidebarIsShowing = false;
    UIImage *settingsImage = [UIImage imageNamed:@"BurgerMenu"];
    UIBarButtonItem * menuRightButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:self action:@selector(gotoSettingsMenu)];
    
    [menuRightButton setImage:settingsImage];
    
    self.navigationItem.rightBarButtonItem = menuRightButton;
    _menubarViewFromNib.frame = CGRectMake(self.view.frame.size.width, 0, 0, self.view.frame.size.height);
    
    __weak ExampleUIViewController * wSelf = self;
    SCDExampleView *view = (SCDExampleView*)self.view;
    [view setNeedsHideSideBarMenu:^(id sender) {
        if (![sender isEqual:wSelf.menubarViewFromNib]) {
            ExampleUIViewController * cached = wSelf;
            if (cached->sidebarIsShowing) {
                [wSelf pv_hideMenu];
            }
        }
    }];
    
}

- (void)addExampleUIView {
    exampleUIView = [[NSClassFromString(exampleUIViewName) alloc]initWithFrame:self.view.bounds];
    exampleUIView.translatesAutoresizingMaskIntoConstraints = YES;
    exampleUIView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:exampleUIView];
    self.view.clipsToBounds = YES;
    self.view.layer.masksToBounds = YES;
}

- (void)gotoSettingsMenu {
    
    if (sidebarIsShowing) {

        [self pv_hideMenu];

    }
    else {

        if (!_menubarViewFromNib) {
            [[NSBundle mainBundle] loadNibNamed:@"SideBarMenu" owner:self options:nil];
            _menubarViewFromNib.frame = CGRectMake(self.view.frame.size.width, 0, 200, self.view.frame.size.height);
            [self.view addSubview:_menubarViewFromNib];
            __weak typeof(self) weakSelf = self;
            [_menubarViewFromNib setSettingsClickHandler:^{
                [weakSelf performSegueWithIdentifier:@"ExampleSettingsSegue" sender:weakSelf];
            }];
        }
        
        if ([exampleUIView conformsToProtocol:@protocol(SciChartBaseViewProtocol)]) {
            [_menubarViewFromNib showSettingsExampleOption:exampleUIView.surface.chartModifiers.count];
        }
        else {
            [_menubarViewFromNib showSettingsExampleOption:NO];
        }
        
        [UIView animateWithDuration:0.3f
                              delay:.0f
                            options:UIViewAnimationOptionTransitionCurlUp
                         animations:^{
                             exampleUIView.frame = CGRectMake(-200.f, .0f, CGRectGetWidth(exampleUIView.frame), CGRectGetHeight(exampleUIView.frame));
                             _menubarViewFromNib.frame = CGRectMake(self.view.frame.size.width - 200, .0f, 200.f, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             sidebarIsShowing = true;
                         }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ExampleSettingsSegue"]){
        ModifierTableViewController * vc = segue.destinationViewController;
        vc.sciSurface = exampleUIView.surface;
    }
}

- (IBAction)pv_showSourceCodeSelecting:(UIButton*)sender {
    
    UIAlertController *alertController = [UIAlertController sourceAlertControllerWithSwiftSourceActionHandler:^(UIAlertAction * _Nullable action) {
                                                                                        [self pv_showSwiftSourceCode:exampleUIViewName];
    }
                                                                                   andObjcSourceActionHandler:^(UIAlertAction * _Nullable action) {
                                                                                        [self pv_showObjCSourceCode:exampleUIViewName];
                                                                                   }];
    alertController.popoverPresentationController.sourceView = sender;
    alertController.popoverPresentationController.sourceRect = sender.bounds;
    [self.navigationController presentViewController:alertController
                                            animated:YES
                                          completion:nil];
    
}

- (void)pv_hideMenu {
    [UIView animateWithDuration:0.3f
                          delay:.0f
                        options:UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                         _menubarViewFromNib.frame = CGRectMake(self.view.frame.size.width, 0, 0, self.view.frame.size.height);
                         exampleUIView.frame = self.view.bounds;
                     }
                     completion:^(BOOL finished) {
                         sidebarIsShowing = false;
                     }];
}

- (void)pv_showSwiftSourceCode:(NSString *)chartName {
    NSString * nameUIView = [exampleUIViewName stringByReplacingOccurrencesOfString:@"SCD" withString:@""];
    NSString * filePath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ChartViews"]
                           stringByAppendingPathComponent:[NSString stringWithFormat:@"SCS%@.swift", nameUIView]];
    NSString * data = [NSString stringWithContentsOfFile:filePath
                                                encoding:NSUTF8StringEncoding
                                                   error:nil];
    
    ShowSourceCodeViewController *controller = [self pv_sourceCodeController];
    controller.sourceCodeText = data;
    controller.sourceCodeType = kSwiftSourceCodeType;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pv_showObjCSourceCode:(NSString *)chartName {
    NSString * filePath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ExampleViews"]
                           stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m", exampleUIViewName]];
    
    NSString * data = [NSString stringWithContentsOfFile:filePath
                                                encoding:NSUTF8StringEncoding
                                                   error:nil];
    
    ShowSourceCodeViewController *controller = [self pv_sourceCodeController];
    controller.sourceCodeText = data;
    [self.navigationController pushViewController:controller animated:YES];
}

- (ShowSourceCodeViewController*)pv_sourceCodeController {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShowSourceCodeViewController *controller = [storyBoard instantiateViewControllerWithIdentifier:kSourceCodeViewControllerId];
    return controller;
}

- (IBAction)pv_shareProjectAction:(UIButton*)sender {
    
    
    DidDoneHandler handler = ^(BOOL succes, NSString *pathToZipFile, NSError *error) {
        if (succes) {
            NSURL *url = [NSURL fileURLWithPath:pathToZipFile];
            
            UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
            activityController.popoverPresentationController.sourceView = sender;
            activityController.popoverPresentationController.sourceRect = sender.bounds;
            [self presentViewController:activityController animated:YES completion:nil];
        }
        else {
            NSLog(@"%@", error);
        }
        [self stopAnimating];
    };
    
    
    UIAlertController *alertController = [UIAlertController shareAlertControllerWithSwiftShareActionHandler:^(UIAlertAction *action) {
                                                                                    [self startAnimating];
                                                                                    [SCDSharedProjectConfigurator pathForZipedSwiftShareProjectWithChartName:exampleUIViewName
                                                                                                                                                 withHandler:handler];
    }
                                                                                  andObjcShareActionHandler:^(UIAlertAction *action) {
                                                                                      [self startAnimating];
                                                                                      [SCDSharedProjectConfigurator pathForZipedShareProjectWithChartName:exampleUIViewName
                                                                                                                                              withHandler:handler];
                                                                                  }];
    alertController.popoverPresentationController.sourceView = sender;
    alertController.popoverPresentationController.sourceRect = sender.bounds;
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
    
  
}

@end
