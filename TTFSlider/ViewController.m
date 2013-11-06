//
//  ViewController.m
//  TTFSlider
//
//  Created by Ezequiel A Becerra on 11/6/13.
//  Copyright (c) 2013 Ezequiel A Becerra. All rights reserved.
//

#import "ViewController.h"

static const NSInteger kSliderWidth = 280;
static const NSInteger kThumbSize = 9;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _slider = [[TTFSlider alloc] initWithFrame:CGRectZero];
    _slider.sliderMinValue = 0;
    _slider.sliderMaxValue = 5;
    _slider.sliderSteps = 6;
    
    [_slider setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_slider];
    
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:_slider
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0];
    
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:_slider
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0
                                                                          constant:0];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:_slider
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:kSliderWidth];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_slider
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:kThumbSize];
    
    NSArray *constraints = @[centerXConstraint, centerYConstraint, widthConstraint, heightConstraint];
    [self.view addConstraints:constraints];
    
    _slider.value = 4.5;
    
}


@end
