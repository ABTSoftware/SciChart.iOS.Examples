#import "ExampleViewBase.h"
#import "SingleChartLayout.h"

@implementation ExampleViewBase

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setubXib];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setubXib];
    }
    return self;
}

- (Class)exampleViewType {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] userInfo:nil];
}

- (void)setubXib {
    Class class = self.exampleViewType;
    NSString * str = NSStringFromClass(class);
    NSArray * nibs = [NSBundle.mainBundle loadNibNamed:str owner:self options:nil];
    UIView * view = [nibs objectAtIndex:0];
    view.frame = self.bounds;
    [self addSubview:view];
    
    [self initExample];
}

- (void)initExample {
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (_needsHideSideBarMenu) {
        _needsHideSideBarMenu([touches anyObject].view);
    }
}

@end
