//
//  HHPhotoViewController.h
//  Hands
//
//  Created by Aik Ampardjian on 19.04.13.
//  Copyright (c) 2013 Aik Ampardjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHAbstractViewController.h"

@class AVCamCaptureManager, AVCamPreviewView, AVCaptureVideoPreviewLayer;

@interface HHPhotoViewController : HHAbstractViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, DBRestClientDelegate> {
    BOOL mouseSwiped;
    BOOL imgPickerDismissed;
    BOOL shouldDraw;
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    
    UIPopoverController * _popover;
    UIImage * pickedImage;
    UIImage * grayOrigImage;
    NSAttributedString * attrQuestion;
    
    DBRestClient *restClient;
}

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *imageHolderView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIView *reshootView;
@property (weak, nonatomic) IBOutlet UIView *redoFinishView;
@property (weak, nonatomic) IBOutlet UIView *questionView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIView *allQuestionsView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *questionButtons;

@property (nonatomic, strong) AVCamCaptureManager *captureManager;
@property (nonatomic, weak) IBOutlet UIView *videoPreviewView;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, weak) IBOutlet UIButton *stillButton;
@property (nonatomic, strong) UIImage * takenImage;

- (IBAction)takePhoto:(UIButton *)sender;
- (IBAction)reshoot:(UIButton *)sender;
- (IBAction)confirmPreview:(UIButton *)sender;
- (IBAction)redo:(UIButton *)sender;
- (IBAction)finish:(UIButton *)sender;
- (IBAction)questionButtonPressed:(UIButton *)sender;
- (IBAction)answerFinish:(UIButton *)sender;
- (IBAction)tempDropbox:(id)sender;
- (IBAction)captureStillImage:(UIButton *)sender;

- (void)saveImage;

@end
