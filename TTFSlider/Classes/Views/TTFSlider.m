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
        NSLog(@"began");
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
        
        _value = (_thumbView.frame.origin.x + kSliderWidth/2) / self.frame.size.width;
        NSLog(@"#DEBUG ended %.3f", _value);
    }
}

-(void)setupThumbView{

    //  Init
    _thumbView = [[UIView alloc] initWithFrame:CGRectZero];
    [_thumbView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_thumbView];
    
    
    //  Constraints
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:_thumbView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0];
    
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:_thumbView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0
                                                                          constant:0];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_thumbView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:kSliderHeight];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:_thumbView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:kSliderWidth];
    
    NSArray *constraints = @[centerXConstraint, centerYConstraint, heightConstraint, widthConstraint];
    [self addConstraints:constraints];
    
    
    //  Style
    _thumbView.backgroundColor = [UIColor redColor];
    
    
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

@end
