//
//  ViewController.m
//  字体大小控件
//
//  Created by _ on 16/7/24.
//  Copyright © 2016年 zhaofuqiang. All rights reserved.
//

#import "ViewController.h"
#import "ZFQSliderControl.h"
#import "Masonry.h"

@interface ViewController () <ZFQSliderControlDelegate>
@property (nonatomic,strong) ZFQSliderControl *stateControl;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *sv = self.view;
    _stateControl = [[ZFQSliderControl alloc] initWithFrame:CGRectZero];
    _stateControl.numberStrs = @[@"30%",@"40%",@"50%",@"60%",@"70%"];
    _stateControl.thumbWidth = 30;
    _stateControl.sliderDelegate = self;
    [sv addSubview:_stateControl];
    
    CGFloat marginLeft = 20;
    [_stateControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sv).offset(30);
        make.left.equalTo(sv).offset(marginLeft);
        make.right.equalTo(sv).offset(-marginLeft);
        make.height.mas_equalTo(40);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _stateControl.numberStrs = @[@"30%",@"",@"50%"];
        _stateControl.currIndex = 1;
    });
}

- (void)sliderBarDidMoved:(ZFQSliderControl *)control
{
    NSLog(@"当前选中了第%zi个",control.currIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
