//
//  HHAbstractViewController.m
//  Hands
//
//  Created by Aik Ampardjian on 19.04.13.
//  Copyright (c) 2013 Aik Ampardjian. All rights reserved.
//

#import "HHAbstractViewController.h"

@interface HHAbstractViewController ()

@end

@implementation HHAbstractViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self customizeAbstractAppearance];
}

- (void)customizeAbstractAppearance
{
    // Customizing exhibitTitleLabel
    NSString * exhibitTitleString = [@"Hands Exhibition" stringByAppendingString:@" / "];
    NSString * subtitleString = @"Palms";
    NSUInteger exhibitTitleStringLength = exhibitTitleString.length;
    NSUInteger subtitleStringLength = subtitleString.length;
    NSString * title = [exhibitTitleString stringByAppendingString:subtitleString];
    NSMutableAttributedString * attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
    UIColor * titleColor = [UIColor blackColor];
    UIFont * exhibitTitleFont = [UIFont fontWithName:@"Helvetica-Bold" size:20.0f];
    UIFont * subtitleFont = [UIFont fontWithName:@"Helvetica" size:20.0f];
    [attrTitle addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, title.length)];
    [attrTitle addAttribute:NSFontAttributeName value:exhibitTitleFont range:NSMakeRange(0, exhibitTitleStringLength)];
    [attrTitle addAttribute:NSFontAttributeName value:subtitleFont range:NSMakeRange(exhibitTitleStringLength, subtitleStringLength)];
    self.exhibitTitleLabel.attributedText = attrTitle;
    
    // Customize scrollView
    
}

#pragma mark - IBAction methods

- (IBAction)showInfoMessage:(UIButton *)sender {
    [UIView animateWithDuration:1.0f animations:^{
        _infoView.alpha = 1.0f;
    }];
}

- (IBAction)closeInfoView:(UIButton *)sender {
    [UIView animateWithDuration:1.0f animations:^{
        _infoView.alpha = .0f;
    }];
}

- (IBAction)goHome:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
