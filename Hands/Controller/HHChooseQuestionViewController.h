//
//  HHChooseQuestionViewController.h
//  Hands
//
//  Created by Aik Ampardjian on 28.04.13.
//  Copyright (c) 2013 Aik Ampardjian. All rights reserved.
//

#import "HHAbstractViewController.h"

@interface HHChooseQuestionViewController : HHAbstractViewController

@property (weak, nonatomic) IBOutlet UIView *questionBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *questionButton1;
@property (weak, nonatomic) IBOutlet UIButton *questionButtin2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIImage *image;

- (IBAction)questionChosen:(UIButton *)sender;

@end
