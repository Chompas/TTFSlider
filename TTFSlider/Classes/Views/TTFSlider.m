//
//  TTFSlider.m
//  TTFSlider
//
//  Created by Ezequiel A Becerra on 11/6/13.
//  Copyright (c) 2013 Ezequiel A Becerra. All rights reserved.
//

#import "TTFSlider.h"

static const NSInteger kSliderHeight = 40;
static const NSInteger kSliderWidth = 40;

@interface TTFSlider()
-(void)setup;
-(void)setupThumbView;

-(void)handleThumbPanGesture:(UIPanGestureRecognizer *)recognizer;
@end

@implementation TTFSlider

#pragma mark - Private

-(void)handleThumbPanGesture:(UIPanGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan){
        //  Began
        
    }else if (recognizer.state == UIGestureRecognizerStateChanged){

        CGPoint delta = [recognizer translationInView:self];
        
        //  Move the thumbView using delta
        CGRect thumbRect = _thumbView.frame;
        thumbRect.origin.x += delta.x;
        thumbRect.origin.x = MAX(-kSliderWidth/2, thumbRect.origin.x);
        thumbRect.origin.x = MIN(self.frame.size.width - kSliderWidth/2, thumbRect.origin.x);
        _thumbView.frame = thumbRect;
        
        //  Setting to zero the translation on the center view (otherwise it breaks)
        [recognizer setTranslation:CGPointMake(0, 0) inView:self];
        
    }else if (recognizer.state == UIGestureRecognizerStateEnded){
        
        //  Calculate the value for the slider, from 0 to 1
        _value = (_thumbView.frame.origin.x + kSliderWidth/2) / self.frame.size.width;

        NSString *valueString = [NSString stringWithFormat:@"%.2f", _value];
        _thumbLabel.text = valueString;
    }
}

-(void)setupThumbView{

    //  Basic Init
    _thumbView = [[UIView alloc] initWithFrame:CGRectZero];
    [_thumbView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_thumbView];
    
    
    //  Constraints
    NSLayoutConstraint *thumbViewCenterXConstraint = [NSLayoutConstraint constraintWithItem:_thumbView
                                                                                  attribute:NSLayoutAttributeCenterX
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self
                                                                                  attribute:NSLayoutAttributeCenterX
                                                                                 multiplier:1.0
                                                                                   constant:0];
    
    NSLayoutConstraint *thumbViewCenterYConstraint = [NSLayoutConstraint constraintWithItem:_thumbView
                                                                                  attribute:NSLayoutAttributeCenterY
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self
                                                                                  attribute:NSLayoutAttributeCenterY
                                                                                 multiplier:1.0
                                                                                   constant:0];
    
    NSLayoutConstraint *thumbViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_thumbView
                                                                                 attribute:NSLayoutAttributeHeight
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:nil
                                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                                multiplier:1.0
                                                                                  constant:kSliderHeight];
    
    NSLayoutConstraint *thumbViewWidthConstraint = [NSLayoutConstraint constraintWithItem:_thumbView
                                                                                attribute:NSLayoutAttributeWidth
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:nil
                                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                                               multiplier:1.0
                                                                                 constant:kSliderWidth];
    
    NSArray *thumbViewConstraints = @[thumbViewCenterXConstraint,
                                      thumbViewCenterYConstraint,
                                      thumbViewHeightConstraint,
                                      thumbViewWidthConstraint];
    
    [self addConstraints:thumbViewConstraints];
    
    
    //  Style
    _thumbView.backgroundColor = [UIColor redColor];
    
    
    //  Label init
    _thumbLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_thumbLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_thumbView addSubview:_thumbLabel];
    
    
    //  Constraints
    NSLayoutConstraint *topThumbLabelConstraint = [NSLayoutConstraint constraintWithItem:_thumbLabel
                                                                               attribute:NSLayoutAttributeTop
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:_thumbView
                                                                               attribute:NSLayoutAttributeTop
                                                                              multiplier:1.0
                                                                                constant:0];
    
    NSLayoutConstraint *rightThumbLabelConstraint = [NSLayoutConstraint constraintWithItem:_thumbLabel
                                                                                 attribute:NSLayoutAttributeRight
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:_thumbView
                                                                                 attribute:NSLayoutAttributeRight
                                                                                multiplier:1.0
                                                                                  constant:0];
    
    NSLayoutConstraint *bottomThumbLabelConstraint = [NSLayoutConstraint constraintWithItem:_thumbLabel
                                                                                attribute:NSLayoutAttributeBottom
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:_thumbView
                                                                                attribute:NSLayoutAttributeBottom
                                                                               multiplier:1.0
                                                                                 constant:0];
    
    NSLayoutConstraint *leftThumbLabelConstraint = [NSLayoutConstraint constraintWithItem:_thumbLabel
                                                                                attribute:NSLayoutAttributeLeft
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:_thumbView
                                                                                attribute:NSLayoutAttributeLeft
                                                                               multiplier:1.0
                                                                                 constant:0];
    
    NSArray *thumbLabelConstraints = @[topThumbLabelConstraint,
                                       rightThumbLabelConstraint,
                                       bottomThumbLabelConstraint,
                                       leftThumbLabelConstraint];
    
    [_thumbView addConstraints:thumbLabelConstraints];
    _thumbLabel.textAlignment = NSTextAlignmentCenter;
    _thumbLabel.textColor = [UIColor whiteColor];
    _thumbLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    
    //  Gesture handlers
    UIPanGestureRecognizer *thumbPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleThumbPanGesture:)];
    [_thumbView addGestureRecognizer:thumbPanRecognizer];
}

-(void)setup{
    self.backgroundColor = [UIColor greenColor];

    [self setupThumbView];
}

#pragma mark - Public

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self setup];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    //  This catches every touch on _thumbView :-)
    BOOL retVal = NO;
    
    if (CGRectContainsPoint(_thumbView.frame, point)){
        retVal = YES;
    }
    
    return retVal;
}

@end
