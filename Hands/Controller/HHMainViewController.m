//
//  HHMainViewController.m
//  Hands
//
//  Created by Aik Ampardjian on 19.04.13.
//  Copyright (c) 2013 Aik Ampardjian. All rights reserved.
//

#import "HHMainViewController.h"

const CGFloat HH_RAND_MAX = 15;
const int SIDE_VIEW_DRAG_MIN = -522;
const int SIDE_VIEW_DRAG_MAX = 0;
const int TEXT_LEAD_FONT_SIZE = 20;
const int TEXT_REGULAR_FONT_SIZE = 18;

@interface HHMainViewController () {
    NSTimer *timer1, *timer2, *timer3, *timer4, *timer5, *timer6;
    CGFloat firstX, firstY;
    CGFloat _translatedPointY;
}

@end

@implementation HHMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload {
    [self setTopView:nil];
    [self setTopViewBackgroundImage:nil];
    [self setTopViewLogoImageView:nil];
    [self setTouchToBeginImageView:nil];
    [self setBottomView:nil];
    [self setBottomTopLeftView:nil];
    [self setBottomTopCenterView:nil];
    [self setBottomTopRightView:nil];
    [self setBottomBottomLeftView:nil];
    [self setBottomBottomCenterView:nil];
    [self setBottomBottomRightView:nil];
    [self setBottomTopLeftFirstImage:nil];
    [self setBottomTopLeftSecondImage:nil];
    [self setBottomTopCenterFirstImage:nil];
    [self setBottomTopCenterSecondImage:nil];
    [self setBottomTopRightFirstImage:nil];
    [self setBottomTopRightSecondImage:nil];
    [self setBottomBottomLeftFirstImage:nil];
    [self setBottomBottomLeftSecondmage:nil];
    [self setBottomBottomCenterFirstImage:nil];
    [self setBottomBottomCenterSecondImage:nil];
    [self setBottomBottomRightFirstImage:nil];
    [self setBottomBottomRightSecondImage:nil];
    [self setInfoPanelView:nil];
    [self setInfoPanelImage:nil];
    [self setInfoPanelBackgroundImageView:nil];
    [self setInfoPanelTextAreaView:nil];
    [self setInfoPanelScrollView:nil];
    [self setScrollViewFirstTextView:nil];
    [self setScrollViewSecondTextView:nil];
    [self setScrollViewThirdTextView:nil];
    [self setFirstTextView:nil];
    [self setSecondTextView:nil];
    [self setThirdTextView:nil];
    [self setPageControl:nil];
    [self setInfoPanelLogoImage:nil];
    [self setInfoPanelShowButton:nil];
    
    [timer1 invalidate];
    [timer2 invalidate];
    [timer3 invalidate];
    [timer4 invalidate];
    [timer5 invalidate];
    [timer6 invalidate];
    
    [self setFirstTextLabel:nil];
    [self setSecondTextLabel:nil];
    [self setThirdTextLabel:nil];
    [super viewDidUnload];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self customizeAppearance];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
}

#pragma mark - Custom Methods

- (void)customizeAppearance
{
    // Customize Gallery
    [self customizeGallery];
    
    // Customize textArea
    NSMutableAttributedString * firstAttributedString =  [[NSMutableAttributedString alloc] initWithAttributedString:_firstTextLabel.attributedText];//_firstTextView.attributedText];
    NSMutableAttributedString * secondAttributedString =  [[NSMutableAttributedString alloc] initWithAttributedString:_secondTextLabel.attributedText];
    NSMutableAttributedString * thirdAttributedString =  [[NSMutableAttributedString alloc] initWithAttributedString:_thirdTextLabel.attributedText];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 30.0f;
    paragraphStyle.maximumLineHeight = 30.0f;
    paragraphStyle.minimumLineHeight = 30.0f;
    
    // First text View
    NSRange firstStringRange1 = [firstAttributedString.string rangeOfString:@"Handmade Stories" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 50)];
    NSRange firstStringRange2 = [firstAttributedString.string rangeOfString:@"Handmade Stories" options:NSCaseInsensitiveSearch range:NSMakeRange(50, firstAttributedString.length - 50)];
    [firstAttributedString addAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor], [UIFont fontWithName:@"TradeGothic" size:TEXT_REGULAR_FONT_SIZE], nil]
                                                                     forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, NSFontAttributeName, nil]]
                                   range:NSMakeRange(0, firstAttributedString.length)];
    [firstAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"TradeGothic" size:TEXT_LEAD_FONT_SIZE] range:firstStringRange1];
    [firstAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"TradeGothic" size:TEXT_LEAD_FONT_SIZE] range:firstStringRange2];
    [firstAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, firstAttributedString.length)];
    [_firstTextLabel setAttributedText:firstAttributedString];
    
    // Second text View
    NSRange secondStringRange1 = [secondAttributedString.string rangeOfString:@"Handmade Stories"];
    NSRange secondStringRange2 = [secondAttributedString.string rangeOfString:@"Christopher Paretti"];
    NSRange secondStringRange3 = [secondAttributedString.string rangeOfString:@"Maria Mortati"];
    NSRange secondStringRange4 = [secondAttributedString.string rangeOfString:@"Scott L. Minneman, Jennifer Bove"];
    [secondAttributedString addAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor], [UIFont fontWithName:@"TradeGothic" size:TEXT_REGULAR_FONT_SIZE], nil]
                                                                      forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, NSFontAttributeName, nil]]
                                    range:NSMakeRange(0, secondAttributedString.length)];
    [secondAttributedString addAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"TradeGothic" size:TEXT_LEAD_FONT_SIZE] forKey:NSFontAttributeName] range:secondStringRange1];
    [secondAttributedString addAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"TradeGothic" size:TEXT_LEAD_FONT_SIZE] forKey:NSFontAttributeName] range:secondStringRange2];
    [secondAttributedString addAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"TradeGothic" size:TEXT_LEAD_FONT_SIZE] forKey:NSFontAttributeName] range:secondStringRange3];
    [secondAttributedString addAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"TradeGothic" size:TEXT_LEAD_FONT_SIZE] forKey:NSFontAttributeName] range:secondStringRange4];
    [secondAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, secondAttributedString.length)];
    [_secondTextLabel setAttributedText:secondAttributedString];
    
    // Third text View
    NSRange thirdStringRange1 = [thirdAttributedString.string rangeOfString:@"Installation Concept:"];
    NSRange thirdStringRange2 = [thirdAttributedString.string rangeOfString:@"User Interface Design:"];
    NSRange thirdStringRange3 = [thirdAttributedString.string rangeOfString:@"Coding:"];
    NSRange thirdStringRange4 = [thirdAttributedString.string rangeOfString:@"Booth Design:"];
    NSRange thirdStringRange5 = [thirdAttributedString.string rangeOfString:@"Booth Lighting:"];
    [thirdAttributedString addAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName] range:NSMakeRange(0, thirdAttributedString.length)];
    [thirdAttributedString addAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"TradeGothic" size:TEXT_REGULAR_FONT_SIZE] forKey:NSFontAttributeName] range:NSMakeRange(0, thirdAttributedString.length)];
    [thirdAttributedString addAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"TradeGothic" size:TEXT_LEAD_FONT_SIZE] forKey:NSFontAttributeName] range:thirdStringRange1];
    [thirdAttributedString addAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"TradeGothic" size:TEXT_LEAD_FONT_SIZE] forKey:NSFontAttributeName] range:thirdStringRange2];
    [thirdAttributedString addAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"TradeGothic" size:TEXT_LEAD_FONT_SIZE] forKey:NSFontAttributeName] range:thirdStringRange3];
    [thirdAttributedString addAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"TradeGothic" size:TEXT_LEAD_FONT_SIZE] forKey:NSFontAttributeName] range:thirdStringRange4];
    [thirdAttributedString addAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"TradeGothic" size:TEXT_LEAD_FONT_SIZE] forKey:NSFontAttributeName] range:thirdStringRange5];
    [thirdAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, thirdAttributedString.length)];
    [_thirdTextLabel setAttributedText:thirdAttributedString];
    
    
    // Scroll View  customization
    _infoPanelScrollView.delegate = self;
    _infoPanelScrollView.contentSize = CGSizeMake(500 * 3, 350);
}

- (void)customizeGallery
{
    // Customizing Timers
    timer1 = [NSTimer scheduledTimerWithTimeInterval: 7.0f /*fmodf((CGFloat)random(), HH_RAND_MAX)*/ target:self selector:@selector(changeGalleryImage:) userInfo:[NSNumber numberWithInt:1] repeats:YES];
    timer2 = [NSTimer scheduledTimerWithTimeInterval: 5.0f /*fmodf((CGFloat)random(), HH_RAND_MAX)*/ target:self selector:@selector(changeGalleryImage:) userInfo:[NSNumber numberWithInt:2] repeats:YES];
    timer3 = [NSTimer scheduledTimerWithTimeInterval: 8.0f /*fmodf((CGFloat)random(), HH_RAND_MAX)*/ target:self selector:@selector(changeGalleryImage:) userInfo:[NSNumber numberWithInt:3] repeats:YES];
    timer4 = [NSTimer scheduledTimerWithTimeInterval: 6.0f /*fmodf((CGFloat)random(), HH_RAND_MAX)*/ target:self selector:@selector(changeGalleryImage:) userInfo:[NSNumber numberWithInt:4] repeats:YES];
    timer5 = [NSTimer scheduledTimerWithTimeInterval: 4.0f /*fmodf((CGFloat)random(), HH_RAND_MAX)*/ target:self selector:@selector(changeGalleryImage:) userInfo:[NSNumber numberWithInt:5] repeats:YES];
    timer6 = [NSTimer scheduledTimerWithTimeInterval: 7.5f /*fmodf((CGFloat)random(), HH_RAND_MAX)*/ target:self selector:@selector(changeGalleryImage:) userInfo:[NSNumber numberWithInt:6] repeats:YES];
    
}

- (void)changeGalleryImage:(NSTimer *)timer
{
    int num = ((NSNumber *)[timer userInfo]).intValue;
    switch (num) {
        case 1:
        {
            [self animateImageAlpha:_bottomTopLeftFirstImage];
            break;
        }
        case 2:
        {
            [self animateImageAlpha:_bottomTopCenterFirstImage];
            break;
        }
        case 3:
        {
            [self animateImageAlpha:_bottomTopRightFirstImage];
            break;
        }
        case 4:
        {
            [self animateImageAlpha:_bottomBottomLeftFirstImage];
            break;
        }
        case 5:
        {
            [self animateImageAlpha:_bottomBottomCenterFirstImage];
            break;
        }
        case 6:
        {
            [self animateImageAlpha:_bottomBottomRightFirstImage];
            break;
        }
        default:
            break;
    }
}

// Method for info panel dragging
- (IBAction)dragging:(UIPanGestureRecognizer *)sender
{
    // Defining section
    UIView * superView = sender.view.superview;
    CGRect frameOfSuperview = superView.frame;
    
    // Main Section
    [self.view bringSubviewToFront:[[sender view] superview]];
    CGPoint translatedPoint = [sender translationInView:self.view];
    switch ([sender state]) {
        case UIGestureRecognizerStateBegan:
            firstX = frameOfSuperview.origin.x;
            firstY = frameOfSuperview.origin.y;
            break;
        case UIGestureRecognizerStateChanged:
            
            firstY = firstY + translatedPoint.y;
            if (firstY > SIDE_VIEW_DRAG_MAX)
                firstY = SIDE_VIEW_DRAG_MAX;
            else if (firstY < SIDE_VIEW_DRAG_MIN)
                firstY = SIDE_VIEW_DRAG_MIN;
            
            [superView setFrame:CGRectMake(0, firstY, frameOfSuperview.size.width, frameOfSuperview.size.height)];
            _translatedPointY = translatedPoint.y;
            [sender setTranslation:CGPointMake(0, 0) inView:self.view];
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGFloat finalY;
            if (_translatedPointY <= 0) {
                finalY = SIDE_VIEW_DRAG_MIN;
            } else {
                finalY = SIDE_VIEW_DRAG_MAX;
            }
            CGFloat animationDuration = .5f;
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animationDuration];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [superView setFrame:CGRectMake(0, finalY, frameOfSuperview.size.width, frameOfSuperview.size.height)];
            [UIView commitAnimations];
            
            [_infoPanelShowButton setSelected:!_infoPanelShowButton.isSelected];
            break;
        }
        default:
            break;
    }    
}

- (void)animateImageAlpha:(UIImageView *)imageView
{
    int alpha = (imageView.alpha > 0) ? 0 : 1;
    [UIView animateWithDuration:1.0f animations:^{
        imageView.alpha = alpha;
    }];
}

#pragma mark IBAction

- (IBAction)moveInfoPanel:(id)sender
{
    UIButton * button = sender;
    BOOL isSelected = button.isSelected;
    CGRect frame = CGRectMake(0, (isSelected) ? SIDE_VIEW_DRAG_MIN : SIDE_VIEW_DRAG_MAX, 768, 598);
    
    [button setSelected:!isSelected];
    
    [UIView animateWithDuration:1.0f animations:^{
        _infoPanelView.frame = frame;
    }];
}

- (IBAction)pageControlChanged:(UIPageControl *)sender
{
//    NSLog(@"curPage:%d", sender.currentPage);
    [_infoPanelScrollView setContentOffset:CGPointMake(sender.currentPage * 500, 0) animated:YES];
}

#pragma  mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"%f %f", scrollView.contentOffset.x, scrollView.contentOffset.y);
    int currentPage = scrollView.contentOffset.x / 500;
    _pageControl.currentPage = currentPage;
}

@end
