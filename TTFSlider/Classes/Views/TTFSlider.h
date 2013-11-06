//
//  TTFSlider.h
//  TTFSlider
//
//  Created by Ezequiel A Becerra on 11/6/13.
//  Copyright (c) 2013 Ezequiel A Becerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TTFSlider : UIView{
    UIView *_thumbView;
    UILabel *_thumbLabel;
    
    CAShapeLayer *_thumbViewLayerMask;
}

@property (assign) float value;
@property (assign) float sliderMaxValue;
@property (assign) float sliderMinValue;
@property (assign) int sliderSteps;

@end
