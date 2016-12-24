//
//  StartLiveView.m
//  yingke
//
//  Created by 夏明伟 on 16/8/31.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "StartLiveView.h"
#import <LFLiveSession.h>

#define XJScreenH [UIScreen mainScreen].bounds.size.height
#define XJScreenW [UIScreen mainScreen].bounds.size.width

@interface StartLiveView ()<LFLiveSessionDelegate>
//开始直播
@property (nonatomic, strong) UIButton *startLiveButton;
@property (nonatomic , strong)LFLiveSession *session;

@property (nonatomic , strong)UIView *containerView;

//美颜
@property (nonatomic, strong) UIButton *beautyButton;

//切换前后摄像头
@property (nonatomic, strong) UIButton *cameraButton;

//关闭
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic , strong)UILabel *statusLabel;

@end

static int padding = 30;
@implementation StartLiveView

#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self requestAccessForVideo];
        [self requestAccessForAudio];
        
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.statusLabel];
        
        [self.containerView addSubview:self.cameraButton];
        [self.containerView addSubview:self.closeButton];
        [self.containerView addSubview:self.beautyButton];
        [self.containerView addSubview:self.startLiveButton];
    }
    
    return self;
}

- (LFLiveSession *)session{
    if(!_session){
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
        _session.running = YES;
        _session.preView = self;
        _session.delegate = self;
    }
    return _session;
}

#pragma Mark 加载视频录制
- (void)requestAccessForVideo{
    __weak typeof(self) _weakSelf = self;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [_weakSelf.session setRunning:YES];
                    });
                   
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            [_weakSelf.session setRunning:YES];
            break;
        }
        case AVAuthorizationStatusDenied:{break;}
        case AVAuthorizationStatusRestricted:{ break;}
            
        default:
            break;
    }
}

#pragma  Mark 加载音频录制
- (void)requestAccessForAudio{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusAuthorized:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                
            }];
            break;
        }
        case AVAuthorizationStatusRestricted:{
            
            break;
        }
        case AVAuthorizationStatusDenied:{break;}
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                
            }];
            break;
        }
            
        default:
            break;
    }
}

#pragma Mark LFLiveSessionDelegate
/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    NSLog(@"change:%ld",state);
    [self statusLabelTextShouldChanged:state];
    
}
/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug *)debugInfo{
    
    NSLog(@"LFLiveDebug:%@",debugInfo);
    
}
/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode{
   
    NSLog(@"errorCode:%lu",errorCode);
}

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.frame = self.bounds;
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
    }
    return _containerView;
}
- (UIButton *)startLiveButton{
    if (!_startLiveButton) {
        _startLiveButton = [UIButton new];
        
        //位置
        _startLiveButton.frame = CGRectMake((XJScreenW - 200) * 0.5, XJScreenH - 100, 200, 40);
        
        _startLiveButton.layer.cornerRadius = _startLiveButton.frame.size.height * 0.5;
        [_startLiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_startLiveButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_startLiveButton setTitle:@"开始直播" forState:UIControlStateNormal];
        [_startLiveButton setBackgroundColor:[UIColor grayColor]];
        _startLiveButton.exclusiveTouch = YES;
        __weak typeof(self) _self = self;
        [_startLiveButton bk_addEventHandler:^(id sender) {
            _self.startLiveButton.selected = !_self.startLiveButton.selected;
            if(_self.startLiveButton.selected){
                [_self.startLiveButton setTitle:@"结束直播" forState:UIControlStateNormal];
                LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
                stream.url = @"rtmp://60.174.36.89:1935/live/aaa";
                [_self.session startLive:stream];
            }else{
                [_self.startLiveButton setTitle:@"开始直播" forState:UIControlStateNormal];
                [_self.session stopLive];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _startLiveButton;
}

#pragma mark ---- <关闭界面>
- (UIButton*)closeButton{
    
    if(!_closeButton){
        _closeButton = [UIButton new];
        
        //位置
        _closeButton.frame = CGRectMake(XJScreenW - padding * 2, padding, padding, padding);
        
        [_closeButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
        _closeButton.exclusiveTouch = YES;
        [_closeButton bk_addEventHandler:^(id sender) {
            __weak __typeof__(self) weakSelf = self;
            [weakSelf.findViewController dismissViewControllerAnimated:YES completion:nil];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
#pragma mark ---- <切换摄像头>
- (UIButton*)cameraButton{
    if(!_cameraButton){
        _cameraButton = [UIButton new];
        
        //位置
        _cameraButton.frame = CGRectMake(XJScreenW - padding * 4, padding, padding, padding);
        
        [_cameraButton setImage:[UIImage imageNamed:@"camra_preview"] forState:UIControlStateNormal];
        _cameraButton.exclusiveTouch = YES;
        __weak typeof(self) _self = self;
        [_cameraButton bk_addEventHandler:^(id sender) {
            AVCaptureDevicePosition devicePositon = _self.session.captureDevicePosition;
            _self.session.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraButton;
}
#pragma mark ---- <美颜功能>
- (UIButton*)beautyButton{
    if(!_beautyButton){
        _beautyButton = [UIButton new];
        
        //位置
        _beautyButton.frame = CGRectMake(padding, padding, padding, padding);
        
        [_beautyButton setImage:[UIImage imageNamed:@"camra_beauty"] forState:UIControlStateSelected];
        [_beautyButton setImage:[UIImage imageNamed:@"camra_beauty_close"] forState:UIControlStateNormal];
        _beautyButton.exclusiveTouch = YES;
        __weak typeof(self) _self = self;
        [_beautyButton bk_addEventHandler:^(id sender) {
            _self.session.beautyFace = !_self.session.beautyFace;
            _self.beautyButton.selected = !_self.session.beautyFace;
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _beautyButton;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [UILabel new];
        _statusLabel.frame = CGRectMake(0, 70, XJScreenW -padding, 31);
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.text = @"未连接";
    }
    
    return _statusLabel;
}

- (void)statusLabelTextShouldChanged:(LFLiveState )state{
    switch (state) {
        case LFLiveReady:
            self.statusLabel.text = @"RTMP服务器准备中..";
            break;
        case LFLivePending:
            self.statusLabel.text = @"RTMP服务器连接中..";
            break;
        case LFLiveStart:
            self.statusLabel.text = @"RTMP服务器已连接";
            [self.startLiveButton setTitle:@"结束直播" forState:UIControlStateNormal];
            break;
        case LFLiveStop:
            self.statusLabel.text = @"RTMP服务器已断开";
            [self.startLiveButton setTitle:@"开始直播" forState:UIControlStateNormal];
            break;
        case LFLiveError:
            self.statusLabel.text = @"RTMP服务器连接出错";
            [self.startLiveButton setTitle:@"开始直播" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}
@end
