//
//  HHAbstractViewController.h
//  Hands
//
//  Created by Aik Ampardjian on 19.04.13.
//  Copyright (c) 2013 Aik Ampardjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

#import "SVProgressHUD.h"

@interface HHAbstractViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *exhibitTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIView *infoView;

- (IBAction)showInfoMessage:(UIButton *)sender;
- (IBAction)closeInfoView:(UIButton *)sender;
- (IBAction)goHome:(UIButton *)sender;
@end
