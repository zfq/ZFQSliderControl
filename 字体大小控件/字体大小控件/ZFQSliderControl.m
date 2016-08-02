//
//  ZFQSliderControl.m
//  字体大小控件
//
//  Created by _ on 16/7/24.
//  Copyright © 2016年 NXB. All rights reserved.
//

#import "ZFQSliderControl.h"
#import "ZFQTumbLayer.h"

@interface ZFQSliderControl()
{
    NSInteger _stageCount;
    
    CGFloat _leftPadding;
    CAShapeLayer *_sliderLayer;   //横线
    ZFQTumbLayer *_thumbLayer;   //圆形按钮
    CGPoint _preLocation;
    CGFloat _averageValue;  //平均值
    NSMutableArray<CATextLayer *> *_numbers;
}
@end
@implementation ZFQSliderControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CALayer *layer = self.layer;
        _sliderLayer = [CAShapeLayer layer];
        _sliderLayer.backgroundColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1].CGColor;
        [layer addSublayer:_sliderLayer];
        
        CGFloat width = 34;
        _thumbLayer = [ZFQTumbLayer layer];
        _thumbLayer.bounds = CGRectMake(0, 0, width, width);
        _thumbLayer.cornerRadius = width/2;
        _thumbLayer.borderWidth = 1;
        _thumbLayer.borderColor = [UIColor lightGrayColor].CGColor;
        _thumbLayer.shadowColor = [UIColor grayColor].CGColor;
        _thumbLayer.shadowOffset = CGSizeMake(0, 1);
        _thumbLayer.shadowOpacity = 0.5;
        _thumbLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _thumbLayer.sliderControl = self;
        [layer addSublayer:_thumbLayer];
        
        _currIndex = 0;
        _stageCount = 2;
        _allowTapToChange = YES;
    }
    return self;
}

- (void)moveThumbToIndex:(NSInteger)index
{
    _currIndex = index;
    _thumbLayer.position = CGPointMake(index * _averageValue, self.bounds.size.height/2);
    
    if ([self.sliderDelegate respondsToSelector:@selector(sliderBarDidMoved:)]) {
        [self.sliderDelegate sliderBarDidMoved:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //计算平均值
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    if (_stageCount == 1) {
        _averageValue = w;
    } else {
        _averageValue = w/(_stageCount-1);
    }
    
    CGFloat sliderHeight = 1;
    CGSize size = self.bounds.size;
    _sliderLayer.bounds = CGRectMake(0, 0, size.width, sliderHeight);
    _sliderLayer.position = CGPointMake(size.width/2, size.height/2);
    [self moveThumbToIndex:_currIndex];
    
    //更新UI
    if (!_numbers) {
        _numbers = [[NSMutableArray alloc] initWithCapacity:_stageCount];
    }
    CATextLayer *tempTextLayer = nil;
    CALayer *layer = self.layer;
    for (NSInteger i = 0; i < _stageCount; i++) {
        if (i>= _numbers.count) {
            CATextLayer *textLayer = [self textLayerWithStr:_numberStrs[i]];
            [_numbers addObject:textLayer];
            [layer addSublayer:textLayer];
        }
        tempTextLayer = _numbers[i];
        //修改位置
        tempTextLayer.string = _numberStrs[i];
        tempTextLayer.position = CGPointMake(i * _averageValue, h+tempTextLayer.bounds.size.height/2);
    }
}

- (CATextLayer *)textLayerWithStr:(NSString *)str
{
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.fontSize = 14;
    textLayer.string = str;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.bounds = CGRectMake(0, 0, 50, 30);
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    return textLayer;
}

- (void)setCurrIndex:(NSInteger)currIndex
{
    _currIndex = currIndex;
    [self moveThumbToIndex:currIndex];
}

- (void)setNumberStrs:(NSArray<NSString *> *)numberStrs
{
    _numberStrs = [numberStrs copy];
    _stageCount = numberStrs.count;
    [self setNeedsLayout];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event
{
    if (_stageCount <= 1) {
        return NO;
    }
    _preLocation = [touch locationInView:self];
    
    if (_allowTapToChange) {
        NSInteger currPos = lroundf(_preLocation.x/_averageValue);
        if (currPos < 0 || currPos > _stageCount) {
            return NO;
        }
        [self moveThumbToIndex:currPos];
        return YES;
    } else {
        if (CGRectContainsPoint(_thumbLayer.frame, _preLocation)) {
            _thumbLayer.hightlighted = YES;
        } else {
            _thumbLayer.hightlighted = NO;
        }
        return _thumbLayer.hightlighted;
    }
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event
{
    CGPoint currLocation = [touch locationInView:self];
    
    //计算位置
    NSInteger currPos = lroundf(currLocation.x/_averageValue);
    currPos = currPos > _stageCount ? (_stageCount-1) : currPos;
    _preLocation = currLocation;
    
    //移动到新的位置,关闭隐式动画
    if (_currIndex != currPos) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [self moveThumbToIndex:currPos];
        [CATransaction commit];
    }
    
    return YES;
}

- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event // touch is sometimes nil if cancelTracking calls through to this.
{
    _thumbLayer.hightlighted = false;
}

- (void)cancelTrackingWithEvent:(nullable UIEvent *)event
{
    _thumbLayer.hightlighted = false;
}

@end
