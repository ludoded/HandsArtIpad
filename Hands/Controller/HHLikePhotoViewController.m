//
//  HHLikePhotoViewController.m
//  Hands
//
//  Created by Aik Ampardjian on 27.04.13.
//  Copyright (c) 2013 Aik Ampardjian. All rights reserved.
//

#import "HHLikePhotoViewController.h"
#import "ImageFilter.h"
#import "HHWriteAnswerViewController.h"

@interface HHLikePhotoViewController () {
    UIImage * grayOrigImage;
}

@end

@implementation HHLikePhotoViewController

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
    [SVProgressHUD showWithStatus:@"Converting To Grayscale" maskType:SVProgressHUDMaskTypeClear];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self convertImageToGrayscale];
}


- (void)convertImageToGrayscale
{
    UIImage *grayImage = [_image greyscale];
    grayOrigImage = [grayImage contrast:1.5];
    [_imageView setImage:grayOrigImage]; // Increasing contrast on one and a half
    [SVProgressHUD dismiss];
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"WriteAnswerView"]) {
        HHWriteAnswerViewController * viewController = segue.destinationViewController;
        viewController.image = grayOrigImage;
    }
}

- (IBAction)doLike:(UIButton *)sender {
    
}

- (IBAction)dontLike:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
