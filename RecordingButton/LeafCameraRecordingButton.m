//
//  LeafCameraRecordingButton.m
//  RecordingButton
//
//  Created by 李乾 on 2017/9/20.
//  Copyright © 2017年 liqian. All rights reserved.
//

#import "LeafCameraRecordingButton.h"

@interface LeafCameraRecordingButton () <CAAnimationDelegate>
@property (nonatomic, strong) CAShapeLayer *innerCircle;
@property (nonatomic, strong) CAShapeLayer *outCircle;
@end

@implementation LeafCameraRecordingButton

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor purpleColor].CGColor;
        
        if (CGRectIsNull(frame)) {
            frame = CGRectMake(0, 0, 85, 85);
        }
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        CGFloat innerWidth = 54.0;
        CGFloat innerHeight = 54.0;
        _innerCircle = [CAShapeLayer layer];
        _innerCircle.frame = CGRectMake(width/2.0-innerWidth/2.0, height/2.0-innerHeight/2.0, innerWidth, innerHeight);
        UIBezierPath *path1 = [UIBezierPath bezierPathWithOvalInRect:
                               CGRectMake(0, 0, innerWidth, innerHeight)];
        _innerCircle.path = path1.CGPath;
        _innerCircle.fillColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:_innerCircle];
        
        
        CGFloat outterWidth = 68.0;
        CGFloat outterHeight = 68.0;
        CGFloat lineWidth = 5.0;
        _outCircle = [CAShapeLayer layer];
        _outCircle.frame = CGRectMake(width/2.0-innerWidth/2.0-2.0-lineWidth, height/2.0-innerHeight/2.0-2.0-lineWidth, outterWidth, outterHeight);
        UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(outterWidth/2.0, outterHeight/2.0) radius:outterWidth/2.0 - lineWidth/2.0 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        _outCircle.path = path2.CGPath;
        _outCircle.strokeColor = [UIColor whiteColor].CGColor;
        _outCircle.fillColor = [UIColor clearColor].CGColor;
        _outCircle.lineWidth = lineWidth;
        [self.layer addSublayer:_outCircle];
        
        _curMode = 1;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        longPress.minimumPressDuration = 0.3;
        [self addGestureRecognizer:longPress];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    CGFloat innerWidth = 54.0;
    CGFloat innerHeight = 54.0;
    _innerCircle.frame = CGRectMake(width/2.0-innerWidth/2.0, height/2.0-innerHeight/2.0, innerWidth, innerHeight);

    CGFloat outterWidth = 68.0;
    CGFloat outterHeight = 68.0;
    CGFloat lineWidth = 5.0;
    _outCircle.frame = CGRectMake(width/2.0-innerWidth/2.0-2.0-lineWidth, height/2.0-innerHeight/2.0-2.0-lineWidth, outterWidth, outterHeight);
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateBegan) {

    }else if (tap.state == UIGestureRecognizerStateEnded) {
        self.enabled = NO;
        _innerCircle.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
        _outCircle.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
        
        if ([_delegate respondsToSelector:@selector(leafCameraRecordingButtonTapEnded:)]) {
            [_delegate leafCameraRecordingButtonTapEnded:self];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _innerCircle.fillColor = [UIColor whiteColor].CGColor;
            _outCircle.strokeColor = [UIColor whiteColor].CGColor;
            self.enabled = YES;
        });
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self addAnimationWithScale:0.9 toLayer:_innerCircle duration:0.5];
            [self addAniamtionWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3] toLayer:_innerCircle keyPath:@"fillColor" duration:0.5];
            
            [self addAnimationWithScale:1.25 toLayer:_outCircle duration:0.5];
            [self addAniamtionWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3] toLayer:_outCircle keyPath:@"strokeColor" duration:0.5];
            [self addAniamtionWithLineWidth:4.0 toLayer:_outCircle duration:0.5];
            
            if ([_delegate respondsToSelector:@selector(leafCameraRecordingButtonLongPressBegin:)]) {
                [_delegate leafCameraRecordingButtonLongPressBegin:self];
            }
        });
    }else if (longPress.state == UIGestureRecognizerStateEnded) {
        [self longPressEndedAction];
        if ([_delegate respondsToSelector:@selector(leafCameraRecordingButtonLongPressEnded:)]) {
            [_delegate leafCameraRecordingButtonLongPressEnded:self];
        }
    }
}

- (void)longPressEndedAction {
    [self addAnimationWithScale:1.0 toLayer:_innerCircle duration:0.4];
    [self addAniamtionWithColor:[UIColor whiteColor] toLayer:_innerCircle keyPath:@"fillColor" duration:0.4];
    
    [self addAnimationWithScale:1.0 toLayer:_outCircle duration:0.4];
    [self addAniamtionWithColor:[UIColor whiteColor] toLayer:_outCircle keyPath:@"strokeColor" duration:0.4];
    [self addAniamtionWithLineWidth:5.0 toLayer:_outCircle duration:0.4];
}

- (void)addAnimationWithScale:(CGFloat)scale toLayer:(CALayer *)layer duration:(NSTimeInterval)duration {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.toValue = @(scale);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = duration;
    NSString *mode = nil;
    if (_curMode == 0) {
        mode = kCAMediaTimingFunctionEaseIn;
    }else if (_curMode == 1) {
        mode = kCAMediaTimingFunctionEaseOut;
    }else if (_curMode == 2) {
        mode = kCAMediaTimingFunctionLinear;
    }
    animation.timingFunction = [CAMediaTimingFunction functionWithName:mode];
    [layer addAnimation:animation forKey:nil];
}

- (void)addAniamtionWithColor:(UIColor *)color toLayer:(CALayer *)layer keyPath:(NSString *)keyPath duration:(NSTimeInterval)duration {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.delegate = self;
    animation.toValue = (id)color.CGColor;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = duration;
    NSString *mode = nil;
    if (_curMode == 0) {
        mode = kCAMediaTimingFunctionEaseIn;
    }else if (_curMode == 1) {
        mode = kCAMediaTimingFunctionEaseOut;
    }else if (_curMode == 2) {
        mode = kCAMediaTimingFunctionLinear;
    }
    animation.timingFunction = [CAMediaTimingFunction functionWithName:mode];
    [layer addAnimation:animation forKey:nil];
}

- (void)addAniamtionWithLineWidth:(CGFloat)lineWidth toLayer:(CALayer *)layer duration:(NSTimeInterval)duration {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    animation.toValue = @(lineWidth);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = duration;
    NSString *mode = nil;
    if (_curMode == 0) {
        mode = kCAMediaTimingFunctionEaseIn;
    }else if (_curMode == 1) {
        mode = kCAMediaTimingFunctionEaseOut;
    }else if (_curMode == 2) {
        mode = kCAMediaTimingFunctionLinear;
    }
    animation.timingFunction = [CAMediaTimingFunction functionWithName:mode];
    [layer addAnimation:animation forKey:nil];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim {
    self.enabled = NO;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        self.enabled = YES;
    }
}

@end
