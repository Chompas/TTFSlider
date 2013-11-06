//
//  TTFSlider.m
//  TTFSlider
//
//  Created by Ezequiel A Becerra on 11/6/13.
//  Copyright (c) 2013 Ezequiel A Becerra. All rights reserved.
//

#import "TTFSlider.h"

static const NSInteger kThumbSize = 30;

@interface TTFSlider()
-(void)setup;
-(void)setupThumbView;
-(void)updateThumbViewMask;

-(void)handleThumbPanGesture:(UIPanGestureRecognizer *)recognizer;
@end

@implementation TTFSlider

@synthesize value = _value;

#pragma mark - Private

- (void)updateThumbLabel {
    
    //  Calculate the value for the slider, from 0 to 1
    _value = (_thumbView.frame.origin.x + kThumbSize/2) / self.frame.size.width;
    
    if (_sliderSteps > 0) {
        // Getting discrete step
        float gap = 1.00/(_sliderSteps - 1);
        int discreteValue = ((_value + (gap/2)) / gap);
        
        int thumbRoundedValue = (discreteValue * (_sliderMaxValue - _sliderMinValue) * gap) + _sliderMinValue;
        
        // Update thumb label
        NSString *valueString = [NSString stringWithFormat:@"%i", thumbRoundedValue];
        _thumbLabel.text = valueString;
    } else {
        NSString *valueString = [NSString stringWithFormat:@"%0.2f", _value];
        _thumbLabel.text = valueString;
    }
    

    
}

- (void)updateThumbWithValue:(float)value {
    
    NSString *valueString = [NSString stringWithFormat:@"%0.2f", value];
    _thumbLabel.text = valueString;
    
    float delta = (value / (_sliderMaxValue - _sliderMinValue)) * self.frame.size.width;
    
    //  Move the thumbView using delta
    CGRect thumbRect = _thumbView.frame;
    thumbRect.origin.x = delta-kThumbSize/2;
    thumbRect.origin.x = MAX(-kThumbSize/2, thumbRect.origin.x);
    thumbRect.origin.x = MIN(self.frame.size.width - kThumbSize/2, thumbRect.origin.x);
    _thumbView.frame = thumbRect;
}

- (float)calculateAnimationThumbDelta {
    
    //  Calculate the value for the slider, from 0 to 1
    _value = (_thumbView.frame.origin.x + kThumbSize/2) / self.frame.size.width;
    
    // Getting discrete step
    float gap = 1.00/(_sliderSteps - 1);
    int discreteValue = ((_value + (gap/2)) / gap);
    
    return gap * discreteValue;
}

-(void)updateThumbViewMask{
    [_thumbViewLayerMask removeFromSuperlayer];
    
    /*  More information about masks
     *  http://evandavis.me/blog/2013/2/13/getting-creative-with-calayer-masks */
    
    //  Create a path with a shape of an ellipse
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, nil, _thumbView.bounds);
    
    //  Create the mask itself and assign the ellipse as mask's shape
    _thumbViewLayerMask = [CAShapeLayer layer];
    _thumbViewLayerMask.frame = _thumbView.bounds;
    _thumbViewLayerMask.path = path;
    
    _thumbView.layer.mask = _thumbViewLayerMask;
}

-(void)handleThumbPanGesture:(UIPanGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan){
        //  Began
        
    }else if (recognizer.state == UIGestureRecognizerStateChanged){

        CGPoint delta = [recognizer translationInView:self];
        
        //  Move the thumbView using delta
        CGRect thumbRect = _thumbView.frame;
        thumbRect.origin.x += delta.x;
        thumbRect.origin.x = MAX(-kThumbSize/2, thumbRect.origin.x);
        thumbRect.origin.x = MIN(self.frame.size.width - kThumbSize/2, thumbRect.origin.x);
        _thumbView.frame = thumbRect;
        
        //  Setting to zero the translation on the center view (otherwise it breaks)
        [recognizer setTranslation:CGPointMake(0, 0) inView:self];
        
        [self updateThumbLabel];
        
    }else if (recognizer.state == UIGestureRecognizerStateEnded){
        
        if (_sliderSteps > 0) {
        
            float animationDelta = [self calculateAnimationThumbDelta];
            
            CGRect thumbRect = _thumbView.frame;
            thumbRect.origin.x = (animationDelta * self.frame.size.width) - kThumbSize/2;
            thumbRect.origin.x = MAX(-kThumbSize/2, thumbRect.origin.x);
            thumbRect.origin.x = MIN(self.frame.size.width - kThumbSize/2, thumbRect.origin.x);
            
            [UIView animateWithDuration:0.2f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [_thumbView setFrame:thumbRect];
                             }
                             completion:nil];
        }
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
                                                                                  constant:kThumbSize];
    
    NSLayoutConstraint *thumbViewWidthConstraint = [NSLayoutConstraint constraintWithItem:_thumbView
                                                                                attribute:NSLayoutAttributeWidth
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:nil
                                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                                               multiplier:1.0
                                                                                 constant:kThumbSize];
    
    NSArray *thumbViewConstraints = @[thumbViewCenterXConstraint,
                                      thumbViewCenterYConstraint,
                                      thumbViewHeightConstraint,
                                      thumbViewWidthConstraint];
    
    [self addConstraints:thumbViewConstraints];
    
    
    //  Style
    _thumbView.backgroundColor = [UIColor colorWithRed:12/255.0 green:99/255.0 blue:121/255.0 alpha:1.0];
    
    
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
    _thumbLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
    
    //  Gesture handlers
    UIPanGestureRecognizer *thumbPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleThumbPanGesture:)];
    [_thumbView addGestureRecognizer:thumbPanRecognizer];
    
    //Default Values for Max and Min Slider
    _sliderMaxValue = 1;
    _sliderMinValue = 0;
    _sliderSteps = 0;
    
}

-(void)setup{
    self.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
    self.layer.cornerRadius = 4;
    [self setupThumbView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self updateThumbViewMask];
}

#pragma mark - Properties

- (float)value {
    return _value;
}

- (void)setValue:(float)newValue {
    _value = newValue;
    
    [self updateThumbWithValue:_value];
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
