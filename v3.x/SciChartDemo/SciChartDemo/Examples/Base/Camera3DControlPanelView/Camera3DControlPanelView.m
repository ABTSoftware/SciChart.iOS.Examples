//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// Camera3DControlPanelView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "Camera3DControlPanelView.h"

@interface Camera3DControlPanelView()

@property (weak, nonatomic) IBOutlet UILabel *pitchTItleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yawTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *radiusTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fovTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orthoWidthLabel;
@property (weak, nonatomic) IBOutlet UILabel *orthoHeightLabel;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *orhtogonalViews;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *perspectiveViews;

@end

@implementation Camera3DControlPanelView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [[NSBundle mainBundle] loadNibNamed:@"Camera3DControlPanelView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIScreen.mainScreen.bounds.size.width, 277);
}

- (void)updateUI {
    self.radiusTitleLabel.text = [NSString stringWithFormat:@"Radius: (%.1f)", self.radiusSlider.value];
    self.yawTitleLabel.text = [NSString stringWithFormat:@"Yaw: (%.1f)", self.yawSlider.value];
    self.pitchTItleLabel.text = [NSString stringWithFormat:@"Pitch: (%.1f)", self.pitchSlider.value];
    self.fovTitleLabel.text = [NSString stringWithFormat:@"FOV: (%.1f)", self.fovSlider.value];
    
    self.orthoWidthLabel.text = [NSString stringWithFormat:@"Ortho Width: (%.1f)", self.orthoWidthSlider.value];
    self.orthoHeightLabel.text = [NSString stringWithFormat:@"Ortho Height: (%.1f)", self.orthoHeightSlider.value];

    for (UIView *current in self.orhtogonalViews) {
        current.hidden = self.projectionModeSegmentControl.selectedSegmentIndex == 0;
    }
    
    for (UIView *current in self.perspectiveViews) {
        current.hidden = self.projectionModeSegmentControl.selectedSegmentIndex == 1;
    }
}

@end
