//
//  HHChooseQuestionViewController.m
//  Hands
//
//  Created by Aik Ampardjian on 28.04.13.
//  Copyright (c) 2013 Aik Ampardjian. All rights reserved.
//

#import "HHChooseQuestionViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "HHWriteAnswerViewController.h"

@interface HHChooseQuestionViewController ()

@end

@implementation HHChooseQuestionViewController

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

    [self customizeAppearance];
}

- (void)customizeAppearance
{
    _questionBackgroundView.layer.cornerRadius = 10.0f;
    _imageView.image = _image;
}

- (void)viewDidUnload {
    [self setQuestionBackgroundView:nil];
    [self setQuestionButton1:nil];
    [self setQuestionButtin2:nil];
    [self setImageView:nil];
    [super viewDidUnload];
}
- (IBAction)questionChosen:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"WriteYourAnswer" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"WriteYourAnswer"]) {
        HHWriteAnswerViewController * viewController = segue.destinationViewController;
        viewController.image = _image;
    }
}

@end
