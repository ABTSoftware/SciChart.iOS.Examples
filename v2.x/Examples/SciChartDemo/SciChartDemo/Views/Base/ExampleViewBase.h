#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^TouchCallback)(id sender);

@interface ExampleViewBase : UIView

@property (nonatomic,copy) TouchCallback needsHideSideBarMenu;

@property (nonatomic, readonly) Class exampleViewType;
    
- (void)initExample;

@end
