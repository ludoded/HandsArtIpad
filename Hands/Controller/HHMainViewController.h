//
//  HHMainViewController.h
//  Hands
//
//  Created by Aik Ampardjian on 19.04.13.
//  Copyright (c) 2013 Aik Ampardjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHAbstractViewController.h"

@interface HHMainViewController : HHAbstractViewController <UIScrollViewDelegate>

//@property (weak, nonatomic) IBOutlet UIView *scrollViewMainView;
//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//@property (weak, nonatomic) IBOutlet UIView *logoView;
//@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
//@property (weak, nonatomic) IBOutlet UIButton *startButton;


@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *topViewBackgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *topViewLogoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *touchToBeginImageView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *bottomTopLeftView;
@property (weak, nonatomic) IBOutlet UIView *bottomTopCenterView;
@property (weak, nonatomic) IBOutlet UIView *bottomTopRightView;
@property (weak, nonatomic) IBOutlet UIView *bottomBottomLeftView;
@property (weak, nonatomic) IBOutlet UIView *bottomBottomCenterView;
@property (weak, nonatomic) IBOutlet UIView *bottomBottomRightView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomTopLeftFirstImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomTopLeftSecondImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomTopCenterFirstImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomTopCenterSecondImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomTopRightFirstImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomTopRightSecondImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBottomLeftFirstImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBottomLeftSecondmage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBottomCenterFirstImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBottomCenterSecondImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBottomRightFirstImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBottomRightSecondImage;

@property (weak, nonatomic) IBOutlet UIView *infoPanelView;
@property (weak, nonatomic) IBOutlet UIImageView *infoPanelImage;
@property (weak, nonatomic) IBOutlet UIImageView *infoPanelBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *infoPanelTextAreaView;
@property (weak, nonatomic) IBOutlet UIScrollView *infoPanelScrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollViewFirstTextView;
@property (weak, nonatomic) IBOutlet UIView *scrollViewSecondTextView;
@property (weak, nonatomic) IBOutlet UIView *scrollViewThirdTextView;
@property (weak, nonatomic) IBOutlet UITextView *firstTextView;
@property (weak, nonatomic) IBOutlet UILabel *firstTextLabel;
@property (weak, nonatomic) IBOutlet UITextView *secondTextView;
@property (weak, nonatomic) IBOutlet UILabel *secondTextLabel;
@property (weak, nonatomic) IBOutlet UITextView *thirdTextView;
@property (weak, nonatomic) IBOutlet UILabel *thirdTextLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIImageView *infoPanelLogoImage;
@property (weak, nonatomic) IBOutlet UIButton *infoPanelShowButton;

- (IBAction)moveInfoPanel:(id)sender;
- (IBAction)dragging:(UIPanGestureRecognizer *)sender;
- (IBAction)pageControlChanged:(UIPageControl *)sender;

@end
