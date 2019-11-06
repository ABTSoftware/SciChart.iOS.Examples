//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AnimationsSandboxLayout.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "AnimationsSandboxLayout.h"

@implementation AnimationsSandboxLayout

- (IBAction)scalePressed:(id)sender {
    if (_scale) _scale();
}

- (IBAction)wavePressed:(id)sender {
    if (_wave) _wave();
}

- (IBAction)sweepPressed:(id)sender {
    if (_sweep) _sweep();
}

- (IBAction)translateXPressed:(id)sender {
    if (_translateX) _translateX();
}

- (IBAction)translateYPressed:(id)sender {
    if (_translateY) _translateY();
}

- (Class)exampleViewType {
    return AnimationsSandboxLayout.class;
}

@end
