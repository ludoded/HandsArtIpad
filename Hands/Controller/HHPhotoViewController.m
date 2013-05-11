//
//  HHPhotoViewController.m
//  Hands
//
//  Created by Aik Ampardjian on 19.04.13.
//  Copyright (c) 2013 Aik Ampardjian. All rights reserved.
//

#import "HHPhotoViewController.h"
#import "ImageFilter.h"

#import "AVCamCaptureManager.h"
#import "AVCamRecorder.h"
#import <AVFoundation/AVFoundation.h>

#import "HHLikePhotoViewController.h"

static void *AVCamFocusModeObserverContext = &AVCamFocusModeObserverContext;

@interface HHPhotoViewController (AVCamCaptureManager) <AVCamCaptureManagerDelegate>
@end

@interface HHPhotoViewController () <UIGestureRecognizerDelegate>
@end

@implementation HHPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self customizeAppearance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Custom Methods

- (void)customizeAppearance
{
    
    // Customize brush
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 5.0;
    opacity = 1.0;
    
    // Boolean setting
    imgPickerDismissed = NO;
    shouldDraw = NO;
}

- (void)customizeVideoView
{
	if ([self captureManager] == nil) {
		AVCamCaptureManager *manager = [[AVCamCaptureManager alloc] init];
		[self setCaptureManager:manager];
		
		[[self captureManager] setDelegate:self];
        
		if ([[self captureManager] setupSession]) {
            // Create video preview layer and add it to the UI
            AVCaptureSession * session = [[self captureManager] session];
            session.sessionPreset = AVCaptureSessionPresetPhoto;
			AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
			UIView *view = _videoPreviewView;
			CALayer *viewLayer = [view layer];
			[viewLayer setMasksToBounds:YES];
			
			CGRect bounds = [view bounds];
			[newCaptureVideoPreviewLayer setFrame:bounds];

			
//			[newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
			
			[viewLayer insertSublayer:newCaptureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
			
			[self setCaptureVideoPreviewLayer:newCaptureVideoPreviewLayer];
			
            // Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				[[[self captureManager] session] startRunning];
			});
			
//            [self updateButtonStates];
			
            // Create the focus mode UI overlay
			UILabel *newFocusModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, viewLayer.bounds.size.width - 20, 20)];
			[newFocusModeLabel setBackgroundColor:[UIColor clearColor]];
			[newFocusModeLabel setTextColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.50]];
//			AVCaptureFocusMode initialFocusMode = [[[_captureManager videoInput] device] focusMode];
			[view addSubview:newFocusModeLabel];
            
            // Add a single tap gesture to focus on the point tapped, then lock focus
			UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToAutoFocus:)];
			[singleTap setDelegate:self];
			[singleTap setNumberOfTapsRequired:1];
			[view addGestureRecognizer:singleTap];
			
            // Add a double tap gesture to reset the focus mode to continuous auto focus
			UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToContinouslyAutoFocus:)];
			[doubleTap setDelegate:self];
			[doubleTap setNumberOfTapsRequired:2];
			[singleTap requireGestureRecognizerToFail:doubleTap];
			[view addGestureRecognizer:doubleTap];
			
		}
	}
    [self addObserver:self forKeyPath:@"captureManager.videoInput.device.focusMode" options:NSKeyValueObservingOptionNew context:AVCamFocusModeObserverContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == AVCamFocusModeObserverContext) {
        // Update the focus UI overlay string when the focus mode changes
//		[focusModeLabel setText:[NSString stringWithFormat:@"focus: %@", [self stringForFocusMode:(AVCaptureFocusMode)[[change objectForKey:NSKeyValueChangeNewKey] integerValue]]]];
	} else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)convertImageToGrayscale:(UIImage *)origImage
{
    UIImage *grayImage = [origImage greyscale];
    grayOrigImage = [grayImage contrast:1.5];
    [self.mainImage setImage:grayOrigImage]; // Increasing contrast on one and a half
    [SVProgressHUD dismiss];
    [self customizeReshootView];
}

- (void)customizeReshootView
{
    [self hideAllView];
    [_reshootView setHidden:NO];
}

- (void)customizeAllQuestionsView
{
    [self hideAllView];
    [self showAllQuestionsView];
}

- (void)customizeQuestionView
{
    [self hideAllView];
    [_questionLabel setAttributedText:attrQuestion];
    [_questionView setHidden:NO];
}

- (void)customizeRedoView
{
    [self hideAllView];
    [_redoFinishView setHidden:NO];
}

- (void)hideAllView
{
    [_photoButton setHidden:YES];
    [_reshootView setHidden:YES];
    [_redoFinishView setHidden:YES];
    [_questionView setHidden:YES];
}

- (void)showAllQuestionsView
{
    [UIView animateWithDuration:1.0f animations:^{
        _allQuestionsView.alpha = 1.0f;
    }];
}

- (void)hideAllQuestionsView
{
    [UIView animateWithDuration:1.0f animations:^{
        _allQuestionsView.alpha = .0f;
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
    [[self restClient] uploadFile:@"hand.jpg" toPath:@"/" withParentRev:nil fromPath:pathOfImage];
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

- (void)saveImage
{
    [self performSegueWithIdentifier:@"LikeThisPhoto" sender:nil];
//    [SVProgressHUD showWithStatus:@"Converting To Grayscale" maskType:SVProgressHUDMaskTypeGradient];
//    [self performSelectorInBackground:@selector(convertImageToGrayscale:) withObject:pickedImage];
//    // Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [[[self captureManager] session] stopRunning];
//    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LikeThisPhoto"]) {
        HHLikePhotoViewController * asViewController = segue.destinationViewController;
        asViewController.image = _takenImage;
    }
}

#pragma mark IBActions

- (IBAction)takePhoto:(UIButton *)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [popover presentPopoverFromRect:_photoButton.bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        _popover = popover;
    }
}

- (IBAction)savePhoto:(UIButton *)sender
{
    
}

- (IBAction)reshoot:(UIButton *)sender
{
    [self takePhoto:nil];
}

- (IBAction)confirmPreview:(UIButton *)sender
{
    [self customizeAllQuestionsView];
}

- (IBAction)redo:(UIButton *)sender
{
    _mainImage.image = grayOrigImage;
    shouldDraw = YES;
}

- (IBAction)finish:(UIButton *)sender
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    UIViewController *rootViewController = [viewControllers objectAtIndex:viewControllers.count - 2];
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:rootViewController];
    }
    [self sendImage];
}

- (IBAction)questionButtonPressed:(UIButton *)sender
{
    UIButton * buttonPressed = sender;
    attrQuestion = buttonPressed.titleLabel.attributedText;
    shouldDraw = YES;
    [self hideAllQuestionsView];
    [self customizeQuestionView];
}

- (IBAction)answerFinish:(UIButton *)sender
{
    [self customizeRedoView];
    shouldDraw = NO;
}

- (IBAction)tempDropbox:(id)sender {
    NSArray *viewControllers = self.navigationController.viewControllers;
    UIViewController *rootViewController = [viewControllers objectAtIndex:viewControllers.count - 2];
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:rootViewController];
    }
}

- (IBAction)captureStillImage:(UIButton *)sender
{
    // Capture a still image
//    [[self stillButton] setEnabled:NO];
    [[self captureManager] captureStillImage];
    
    // Flash the screen white and fade it out to give UI feedback that a still image was taken
    UIView *flashView = [[UIView alloc] initWithFrame:[[self view] frame]];
    [flashView setBackgroundColor:[UIColor whiteColor]];
    [[[self view] window] addSubview:flashView];
    
    [UIView animateWithDuration:.4f
                     animations:^{
                         [flashView setAlpha:0.f];
                     }
                     completion:^(BOOL finished){
                         [flashView removeFromSuperview];
                     }
     ];
}

- (IBAction)goHome:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - DBRestClientDelegate

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath
              from:(NSString*)srcPath metadata:(DBMetadata*)metadata {
    
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error {
    NSLog(@"File upload failed with error - %@", error);
}

#pragma mark - UIImagePickerControllerDelegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_photoButton setHidden:YES];
    pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    imgPickerDismissed = YES;
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setPhotoButton:nil];
    [self setReshootView:nil];
    [self setRedoFinishView:nil];
    [self setQuestionView:nil];
    [self setQuestionLabel:nil];
    [self setAllQuestionsView:nil];
    [self setQuestionButtons:nil];
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [[[self captureManager] session] stopRunning];
//    [self setCaptureManager:nil];
    [self removeObserver:self forKeyPath:@"captureManager.videoInput.device.focusMode" context:AVCamFocusModeObserverContext];
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Customize Camera View
    [self customizeVideoView];
    
    if (imgPickerDismissed) {
        imgPickerDismissed = NO;
        [SVProgressHUD showWithStatus:@"Converting To Grayscale" maskType:SVProgressHUDMaskTypeGradient];
        [self performSelectorInBackground:@selector(convertImageToGrayscale:) withObject:pickedImage];
    }
}

@end

@implementation HHPhotoViewController (InternalMethods)

// Convert from view coordinates to camera coordinates, where {0,0} represents the top left of the picture area, and {1,1} represents
// the bottom right in landscape mode with the home button on the right.
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates
{
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = [[self videoPreviewView] frame].size;
    
    if ([_captureVideoPreviewLayer.connection isVideoMirrored]) {
        viewCoordinates.x = frameSize.width - viewCoordinates.x;
    }
    
    if ( [[_captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResize] ) {
		// Scale, switch x and y, and reverse x
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    } else {
        CGRect cleanAperture;
        for (AVCaptureInputPort *port in [[[self captureManager] videoInput] ports]) {
            if ([port mediaType] == AVMediaTypeVideo) {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
                
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if ( [[_captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspect] ) {
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
						// If point is inside letterboxed area, do coordinate conversion; otherwise, don't change the default value returned (.5,.5)
                        if (point.x >= blackBar && point.x <= blackBar + x2) {
							// Scale (accounting for the letterboxing on the left and right of the video preview), switch x and y, and reverse x
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    } else {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
						// If point is inside letterboxed area, do coordinate conversion. Otherwise, don't change the default value returned (.5,.5)
                        if (point.y >= blackBar && point.y <= blackBar + y2) {
							// Scale (accounting for the letterboxing on the top and bottom of the video preview), switch x and y, and reverse x
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                } else if ([[_captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
					// Scale, switch x and y, and reverse x
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2; // Account for cropped height
                        yc = (frameSize.width - point.x) / frameSize.width;
                    } else {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2); // Account for cropped width
                        xc = point.y / frameSize.height;
                    }
                }
                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    
    return pointOfInterest;
}

// Auto focus at a particular point. The focus mode will change to locked once the auto focus happens.
- (void)tapToAutoFocus:(UIGestureRecognizer *)gestureRecognizer
{
    if ([[[_captureManager videoInput] device] isFocusPointOfInterestSupported]) {
        CGPoint tapPoint = [gestureRecognizer locationInView:[self videoPreviewView]];
        CGPoint convertedFocusPoint = [self convertToPointOfInterestFromViewCoordinates:tapPoint];
        [_captureManager autoFocusAtPoint:convertedFocusPoint];
    }
}

// Change to continuous auto focus. The camera will constantly focus at the point choosen.
- (void)tapToContinouslyAutoFocus:(UIGestureRecognizer *)gestureRecognizer
{
    if ([[[_captureManager videoInput] device] isFocusPointOfInterestSupported])
        [_captureManager continuousFocusAtPoint:CGPointMake(.5f, .5f)];
}

@end

