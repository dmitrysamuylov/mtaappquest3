//
//  InitialViewController.m
//  mtaappquest3
//
//  Created by Diego Cruz on 1/27/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#import "InitialViewController.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    guide = [IGGuideManager sharedManager];
    [guide setNDDPath:[[NSBundle mainBundle] pathForResource:@"gcs-zones" ofType:@"ndd"]];
    guide.directionsDelegate = self;
    guide.positioningDelegate = self;
    
    //When in Grand Central
    [guide startUpdates];
    
    [self startTimer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //For testing without beacon signal
    
    /*UITabBarController *main = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarScene"];
    [self showDetailViewController:main sender:nil];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startTimer{
    
    connectionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
}

-(void)timerAction{
    
    secondsPassed ++;
    
    if (secondsPassed > 5) {
        self.timeoutMessage.alpha = 1;
        
        [connectionTimer invalidate];
        connectionTimer = nil;
    }
    
}

#pragma mark Position Delegate Methods

-(BOOL)guideManagerShouldDisplayHeadingCalibration:(IGGuideManager *)manager{
    return YES;
}

-(void)guideManager:(IGGuideManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    [super guideManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
    
    UITabBarController *main = [self.storyboard instantiateViewControllerWithIdentifier:@"WhereIAmScene"];
    
    [self showDetailViewController:main sender:nil];
}

-(void)guideManager:(IGGuideManager *)manager didFailWithError:(NSError *)error{
    
    [guide stopUpdates];
    [self handleError:error];
    
}

-(void)handleError:(NSError *)error{
    
    NSLog(@"%@",error);
    self.loadingView.alpha = 0;
    self.loadingMessage.text = error.userInfo[@"msg"];
    self.timeoutMessage.alpha = 0;
    
    [connectionTimer invalidate];
    connectionTimer = nil;
    
    switch (error.code) {
        case 1:
            self.refreshButton.alpha = 1;
            break;
        case 3:
        {
            
            break;
        }
        default:
            break;
    }
    
    
    
    
}

#pragma mark UIAlertView delegate methods

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    [guide startUpdates];
    self.loadingView.alpha = 1;
}

- (IBAction)refreshPressed:(UIButton *)sender {
    
    [guide startUpdates];
    self.refreshButton.alpha = 0;
    self.timeoutMessage.alpha = 0;
    self.loadingView.alpha = 1;
    self.loadingMessage.text = @"Hang on while we look for a nearby beacon...";
    
    [self startTimer];
    
}


@end
