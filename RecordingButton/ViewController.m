//
//  ViewController.m
//  RecordingButton
//
//  Created by 李乾 on 2017/9/20.
//  Copyright © 2017年 liqian. All rights reserved.
//

#import "ViewController.h"
#import "LeafCameraRecordingButton.h"

@interface ViewController () <LeafCameraRecordingButtonDelegate>
@property (nonatomic, strong) LeafCameraRecordingButton *button;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    _button = [LeafCameraRecordingButton new];
    _button.delegate = self;
    _button.frame = CGRectMake((375-80)*0.5, 200, 85.0, 85.0);
    [self.view addSubview:_button];
}

- (IBAction)segAction:(UISegmentedControl *)sender {
    _button.curMode = sender.selectedSegmentIndex;
}

#pragma mark - LeafCameraRecordingButtonDelegate
- (void)leafCameraRecordingButtonTapEnded:(LeafCameraRecordingButton *)button {
    NSLog(@"拍照");
}

-(void)leafCameraRecordingButtonLongPressBegin:(LeafCameraRecordingButton *)button {
    NSLog(@"开始录制");
}

- (void)leafCameraRecordingButtonLongPressEnded:(LeafCameraRecordingButton *)button {
    NSLog(@"结束录制");
}

@end
