//
//  MLCameraViewController.m
//  MLCameraViewControllerDemo
//
//  Created by Tyler on 7/25/14.
//  Copyright (c) 2014 Delaware consulting. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#import "MLCameraViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface MLCameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIView *_viewTop;
    UIView *_viewMiddle;
    UIView *_viewBottom;
    
    UIButton *_btnFlash;
    
    AVCaptureSession *_session;
    AVCaptureDeviceInput *_captureInput;
    AVCaptureStillImageOutput *_captureOutput;
    AVCaptureVideoPreviewLayer *_preview;
    AVCaptureDevice *_device;
}

@end

@implementation MLCameraViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    self.view.backgroundColor = [UIColor blackColor];
    
    _viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    _viewMiddle = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 44 - 100)];
    _viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 100, kScreenWidth, 100)];
    
    _viewTop.backgroundColor = [UIColor blackColor];
    _viewMiddle.backgroundColor = [UIColor clearColor];
    _viewBottom.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:_viewTop];
    [self.view addSubview:_viewMiddle];
    [self.view addSubview:_viewBottom];
    
    [self customizeBottom];
    [self initializeCamera];
//    [self drawGrid];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (!_session.running) {
        [_session startRunning];
        
        [self customizeTop];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
//    [_session stopRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [self closeCamera];
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(handleCompletionForMLCameraViewControllerWithImage:)]) {
            [self.delegate handleCompletionForMLCameraViewControllerWithImage:image];   
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

#pragma mark - Methods

- (void)customizeTop
{
    if (_device.hasFlash) {
        [_device lockForConfiguration:nil];
        
        _device.flashMode = AVCaptureFlashModeOff;
        
        [_device unlockForConfiguration];
    
        _btnFlash = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 44, 44)];
        
        [_btnFlash setImage:[UIImage imageNamed:@"ml_camera_btn_flash_off.png"] forState:UIControlStateNormal];
        [_btnFlash addTarget:self action:@selector(switchFlash:) forControlEvents:UIControlEventTouchUpInside];
        
        [_viewTop addSubview:_btnFlash];
    }

    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        UIButton *btnSwitchCamera = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 54, 0, 44, 44)];
        
        [btnSwitchCamera setImage:[UIImage imageNamed:@"ml_camera_btn_switch_camera.png"] forState:UIControlStateNormal];
        [btnSwitchCamera addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
        
        [_viewTop addSubview:btnSwitchCamera];
    }
}

- (void)customizeBottom
{
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 80, 80)];
    
    [btnClose setImage:[UIImage imageNamed:@"ml_camera_btn_close.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(closeCamera) forControlEvents:UIControlEventTouchUpInside];
    
    [_viewBottom addSubview:btnClose];
    
    UIButton *btnCamera = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth - 80) / 2, 10, 80, 80)];
    
    [btnCamera setImage:[UIImage imageNamed:@"ml_camera_btn_camera.png"] forState:UIControlStateNormal];
    [btnCamera addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    
    [_viewBottom addSubview:btnCamera];
    
    UIButton *btnPhotos = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 80, 10, 80, 80)];
    
    [btnPhotos setImage:[UIImage imageNamed:@"ml_camera_btn_photos.png"] forState:UIControlStateNormal];
    [btnPhotos addTarget:self action:@selector(showPhotos) forControlEvents:UIControlEventTouchUpInside];
    
    [_viewBottom addSubview:btnPhotos];
}

- (void)switchFlash:(UIButton *)pButton
{
    if (!_device.hasFlash) {
        return;
    }
    
    [_device lockForConfiguration:nil];
    
    switch (_device.flashMode) {
        case AVCaptureFlashModeAuto:
        {
            _device.flashMode = AVCaptureFlashModeOn;
            
            [_btnFlash setImage:[UIImage imageNamed:@"ml_camera_btn_flash_on.png"] forState:UIControlStateNormal];
            
            break;
        }
        case AVCaptureFlashModeOn:
        {
            _device.flashMode = AVCaptureFlashModeOff;
            
            [_btnFlash setImage:[UIImage imageNamed:@"ml_camera_btn_flash_off.png"] forState:UIControlStateNormal];
            
            break;
        }
        case AVCaptureFlashModeOff:
        {
            _device.flashMode = AVCaptureFlashModeAuto;
            
            [_btnFlash setImage:[UIImage imageNamed:@"ml_camera_btn_flash_auto.png"] forState:UIControlStateNormal];
            
            break;
        }
    }

    [_device unlockForConfiguration];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *arrDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    __block AVCaptureDevice *result = nil;
    
    [arrDevices enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AVCaptureDevice *device = obj;
        
        if (device.position == position) {
            result = device;
            
            *stop = YES;
        }
    }];
    
    return result;
}

- (void)switchCamera
{
//    UIViewAnimationOptions animationOptions = UIViewAnimationOptionTransitionFlipFromRight;
//    
//    if (_device.position == AVCaptureDevicePositionFront) {
//        animationOptions = UIViewAnimationOptionTransitionFlipFromRight;
//    }
//    else if (_device.position == AVCaptureDevicePositionBack) {
//        animationOptions = UIViewAnimationOptionTransitionFlipFromLeft;
//    }
//    
//    [UIView transitionWithView:_viewMiddle
//                      duration:0.5
//                       options:animationOptions
//                    animations:nil
//                    completion:nil];

    [_session.inputs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AVCaptureDeviceInput *input = obj;
        
        if ([input.device hasMediaType:AVMediaTypeVideo]) {
            if (input.device.position == AVCaptureDevicePositionFront) {
                _device = [self cameraWithPosition:AVCaptureDevicePositionBack];
            }
            else {
                _device = [self cameraWithPosition:AVCaptureDevicePositionFront];
            }
            
            if (_device.hasFlash) {
                _btnFlash.hidden = NO;
            }
            else {
                _btnFlash.hidden = YES;
            }
            
            AVCaptureDeviceInput *newInput = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];

            [_session beginConfiguration];
            
            [_session removeInput:input];
            [_session addInput:newInput];
            
            [_session commitConfiguration];
            
            *stop = YES;
        }
    }];
}

- (void)closeCamera
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)takePhoto
{
    __block AVCaptureConnection *videoConnection = nil;
    
    [_captureOutput.connections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AVCaptureConnection *connection = obj;
        
        [connection.inputPorts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AVCaptureInputPort *port = obj;
            
            if ([port.mediaType isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                
                *stop = YES;
            }
        }];
        
        if (videoConnection != nil) {
            *stop = YES;
        }
    }];
    
    [_captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                                    NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                    
                                                    [self closeCamera];
                                                    
                                                    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(handleCompletionForMLCameraViewControllerWithImage:)]) {
                                                        [self.delegate handleCompletionForMLCameraViewControllerWithImage:[UIImage imageWithData:imageData]];
                                                    }
                                                }];
}

- (void)showPhotos
{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    
    UIImagePickerController *ipcAlbum = [[UIImagePickerController alloc] init];
    ipcAlbum.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    ipcAlbum.allowsEditing = YES;
    ipcAlbum.delegate = self;
    
    [self presentViewController:ipcAlbum animated:YES completion:nil];
}

- (void)initializeCamera
{
    _session = [[AVCaptureSession alloc] init];
    
    [_session setSessionPreset:AVCaptureSessionPresetPhoto];

    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
	_captureInput = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    
    if (_captureInput == nil) {
        return;
    }
    
    [_session addInput:_captureInput];

    _captureOutput = [[AVCaptureStillImageOutput alloc] init];
    
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    
    [_captureOutput setOutputSettings:outputSettings];
    
    if (_captureOutput == nil) {
        return;
    }
    
	[_session addOutput:_captureOutput];
    
    _preview = [AVCaptureVideoPreviewLayer layerWithSession: _session];
    _preview.frame = CGRectMake(0, 0, _viewMiddle.frame.size.width, _viewMiddle.frame.size.height);
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [_viewMiddle.layer addSublayer:_preview];
}

- (void)drawGrid
{
    for (int i = 1; i < 3; i++) {
        UIView *viewHorizontal = [[UIView alloc] initWithFrame:CGRectMake(0, _viewMiddle.frame.size.height / 3 * i, _viewMiddle.frame.size.width, 1)];
        viewHorizontal.backgroundColor = [UIColor lightGrayColor];
        
        [_viewMiddle addSubview:viewHorizontal];
    }
    
    for (int i = 1; i < 3; i++) {
        UIView *viewVertical = [[UIView alloc] initWithFrame:CGRectMake(_viewMiddle.frame.size.width / 3 * i, 0, 1, _viewMiddle.frame.size.height)];
        viewVertical.backgroundColor = [UIColor lightGrayColor];
        
        [_viewMiddle addSubview:viewVertical];
    }
}

@end
