//
//  InitialViewController.h
//  mtaappquest3
//
//  Created by Diego Cruz on 1/27/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#import <IndoorGuide/IGGuideManager.h>
#import <IndoorGuide/IGMapViewController.h>
#import <UIKit/UIKit.h>

@interface InitialViewController : IGMapViewController <UIAlertViewDelegate>
{
    IGGuideManager *guide;
    NSTimer *connectionTimer;
    int secondsPassed;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *loadingMessage;
@property (weak, nonatomic) IBOutlet UILabel *timeoutMessage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loadingMessageHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;


@end
