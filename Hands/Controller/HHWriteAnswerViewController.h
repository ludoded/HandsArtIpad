//
//  HHWriteAnswerViewController.h
//  Hands
//
//  Created by Aik Ampardjian on 28.04.13.
//  Copyright (c) 2013 Aik Ampardjian. All rights reserved.
//

#import "HHAbstractViewController.h"

@interface HHWriteAnswerViewController : HHAbstractViewController<DBRestClientDelegate> {
    BOOL mouseSwiped;
    BOOL imgPickerDismissed;
    BOOL shouldDraw;
    CGPoint lastPoint;
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    CGPoint currentPoint;
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

@property (weak, nonatomic) IBOutlet UIView *questionBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *annotationButton;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property (weak, nonatomic) IBOutlet UIView *imageHolderView;
@property (weak, nonatomic) IBOutlet UIView *fadeView;
@property (weak, nonatomic) IBOutlet UIView *topFinishView;
@property (weak, nonatomic) IBOutlet UIView *bottomFinishView;

@property (strong, nonatomic) UIImage * image;

- (IBAction)showAnnotation:(UIButton *)sender;
- (IBAction)redo:(UIButton *)sender;
- (IBAction)finish:(UIButton *)sender;

@end
