//
//  HHLikePhotoViewController.h
//  Hands
//
//  Created by Aik Ampardjian on 27.04.13.
//  Copyright (c) 2013 Aik Ampardjian. All rights reserved.
//

#import "HHAbstractViewController.h"

@interface HHLikePhotoViewController : HHAbstractViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage * image;

- (IBAction)doLike:(UIButton *)sender;
- (IBAction)dontLike:(UIButton *)sender;


@end
