//
//  LeafCameraRecordingButton.h
//  RecordingButton
//
//  Created by 李乾 on 2017/9/20.
//  Copyright © 2017年 liqian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeafCameraRecordingButton;
@protocol LeafCameraRecordingButtonDelegate <NSObject>
- (void)leafCameraRecordingButtonLongPressBegin:(LeafCameraRecordingButton *)button;
- (void)leafCameraRecordingButtonLongPressEnded:(LeafCameraRecordingButton *)button;
- (void)leafCameraRecordingButtonTapEnded:(LeafCameraRecordingButton *)button;
@end

@interface LeafCameraRecordingButton : UIControl
@property (nonatomic, assign) NSInteger curMode;
@property (nonatomic, weak) id<LeafCameraRecordingButtonDelegate> delegate;
@end
