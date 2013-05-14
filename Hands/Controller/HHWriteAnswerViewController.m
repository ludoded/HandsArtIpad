//
//  HHWriteAnswerViewController.m
//  Hands
//
//  Created by Aik Ampardjian on 28.04.13.
//  Copyright (c) 2013 Aik Ampardjian. All rights reserved.
//

#import "HHWriteAnswerViewController.h"

#import "UIView+Genie.h"

@interface HHWriteAnswerViewController () {
    
}

@end

@implementation HHWriteAnswerViewController

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
	// Do any additional setup after loading the view.
    _mainImage.image = _image;
    // Customize brush
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 2.5;
    opacity = 1.0;
    
    // Boolean setting
    imgPickerDismissed = NO;
}

- (void)viewDidUnload {
    [self setQuestionBackgroundView:nil];
    [self setAnnotationButton:nil];
    [self setImageHolderView:nil];
    [self setFadeView:nil];
    [self setTopFinishView:nil];
    [self setBottomFinishView:nil];
    [super viewDidUnload];
}

- (void)finalAnimation
{
    [UIView animateWithDuration:1.0f
                     animations:^(){
                         _topFinishView.frame = CGRectMake(0, 0, _topFinishView.frame.size.width, _topFinishView.frame.size.height);
                         _bottomFinishView.frame = CGRectMake(0, 522, _bottomFinishView.frame.size.width, _bottomFinishView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:.2f
                                          animations:^(){
                                              _topFinishView.frame = CGRectMake(0, -20, _topFinishView.frame.size.width, _topFinishView.frame.size.height);
                                              _bottomFinishView.frame = CGRectMake(0, 542, _bottomFinishView.frame.size.width, _bottomFinishView.frame.size.height);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:.2f
                                                               animations:^(){
                                                                   _topFinishView.frame = CGRectMake(0, 0, _topFinishView.frame.size.width, _topFinishView.frame.size.height);
                                                                   _bottomFinishView.frame = CGRectMake(0, 522, _bottomFinishView.frame.size.width, _bottomFinishView.frame.size.height);
                                                               }
                                                               completion:^(BOOL finished){
                                                                   [self performSegueWithIdentifier:@"MainScreen" sender:nil];
                                                               }];
                                          }];
                     }];
}

- (DBRestClient *)restClient {
    if (!restClient) {
        restClient =
        [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

- (void)sendImage
{
    NSString * pathOfImage = [self pathOfSavedImage];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [SVProgressHUD showWithStatus:@"Your hand is uploading..." maskType:SVProgressHUDMaskTypeGradient];
    [[self restClient] uploadFile:[NSString stringWithFormat:@"hand-%@.jpg", [formatter stringFromDate:[NSDate date]]] toPath:@"/" withParentRev:nil fromPath:pathOfImage];
}

- (NSString *)pathOfSavedImage
{
    UIGraphicsBeginImageContextWithOptions(self.mainImage.bounds.size, NO, 0.0);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height)];
    UIImage *saveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
	NSLog(@"saving jpeg");
	NSString *jpegFilePath = [NSString stringWithFormat:@"%@/hand.jpeg",docDir];
	NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(saveImage, 1.0f)];//1.0f = 100% quality
	[data2 writeToFile:jpegFilePath atomically:YES];
    return jpegFilePath;
}

- (IBAction)showAnnotation:(UIButton *)sender {
    BOOL isSelected = _annotationButton.isSelected;
    [_annotationButton setSelected:!isSelected];
    if (isSelected) {
        _questionBackgroundView.hidden = NO;
        [_questionBackgroundView genieOutTransitionWithDuration:.7f
                                                      startRect:_annotationButton.frame
                                                      startEdge:BCRectEdgeBottom
                                                     completion:^(){
                                                         _fadeView.hidden = NO;
                                                         shouldDraw = NO;
                                                     }];
    } else {
        _fadeView.hidden = YES;
        [_questionBackgroundView genieInTransitionWithDuration:.7f
                                               destinationRect:_annotationButton.frame
                                               destinationEdge:BCRectEdgeBottom
                                                    completion:^(){
                                                        _questionBackgroundView.hidden = YES;
                                                        shouldDraw = YES;
                                                    }];
    }
}

- (IBAction)redo:(UIButton *)sender
{
    _mainImage.image = _image;
//    shouldDraw = YES;
}

- (IBAction)finish:(UIButton *)sender
{
    [self sendImage];
}

#pragma mark Touch Methods
CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (shouldDraw) {
        mouseSwiped = NO;
        UITouch *touch = [touches anyObject];
        lastPoint = [touch locationInView:self.mainImage];
        previousPoint1 = [touch previousLocationInView:self.mainImage];
        previousPoint2 = [touch previousLocationInView:self.mainImage];
        currentPoint = [touch locationInView:self.mainImage];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (shouldDraw) {
        mouseSwiped = YES;
        UITouch *touch = [touches anyObject];
        previousPoint2 = previousPoint1;
        previousPoint1 = [touch previousLocationInView:self.mainImage];
        currentPoint = [touch locationInView:self.mainImage];
        CGPoint mid1 = midPoint(previousPoint1, previousPoint2);
        CGPoint mid2 = midPoint(currentPoint, previousPoint1);
        UIGraphicsBeginImageContext(self.mainImage.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height)];
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), mid1.x, mid1.y);
//        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextAddQuadCurveToPoint(UIGraphicsGetCurrentContext(), previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        [self.tempDrawImage setAlpha:opacity];
        UIGraphicsEndImageContext();
        
        lastPoint = currentPoint;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (shouldDraw) {
        if(!mouseSwiped) {
            UIGraphicsBeginImageContext(self.imageHolderView.frame.size);
            [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height)];
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextStrokePath(UIGraphicsGetCurrentContext());
            CGContextFlush(UIGraphicsGetCurrentContext());
            self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        UIGraphicsBeginImageContext(self.mainImage.frame.size);
        [self.mainImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
        self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
        self.tempDrawImage.image = nil;
        UIGraphicsEndImageContext();
    }
}

#pragma mark - DBRestClientDelegate

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath
              from:(NSString*)srcPath metadata:(DBMetadata*)metadata {
    
    [SVProgressHUD dismiss];
    [self finalAnimation];
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error {
    NSLog(@"File upload failed with error - %@", error);
    
    [SVProgressHUD dismiss];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:[NSString stringWithFormat:@"File upload failed with error - %@", error] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


@end
