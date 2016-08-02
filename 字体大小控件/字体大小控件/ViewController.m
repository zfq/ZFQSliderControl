//
//  ViewController.m
//  字体大小控件
//
//  Created by _ on 16/7/24.
//  Copyright © 2016年 NXB. All rights reserved.
//

#import "ViewController.h"
#import "ZFQSliderControl.h"

@interface ViewController ()
@property (nonatomic,strong) ZFQSliderControl *stateControl;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _stateControl = [[ZFQSliderControl alloc] initWithFrame:CGRectZero];
    _stateControl.backgroundColor = [UIColor redColor];
//    _stateControl.numberStrs = @[@"30%",@"40%",@"50%",@"60%",@"70%"];
    [self.view addSubview:_stateControl];
}

- (void)viewDidLayoutSubviews
{
    CGFloat l = 40;
    CGSize size = self.view.bounds.size;
    _stateControl.frame = CGRectMake(l, 40, size.width - 2 * l, 40);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
