//
//  HHSegueStyle.m
//  Hands
//
//  Created by Aik Ampardjian on 29.04.13.
//  Copyright (c) 2013 Aik Ampardjian. All rights reserved.
//

#import "HHSegueStyle.h"

@implementation HHSegueStyle

- (void) perform {
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    [UIView transitionWithView:src.navigationController.view duration:0.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [src.navigationController pushViewController:dst animated:NO];
                    }
                    completion:NULL];
}


@end
