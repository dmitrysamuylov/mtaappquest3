//
//  WhereIAmViewController.m
//  mtaappquest3
//
//  Created by Diego Cruz on 1/16/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#import "WhereIAmViewController.h"

@interface WhereIAmViewController ()

@end

@implementation WhereIAmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    guide = [IGGuideManager sharedManager];
    guide.directionsDelegate = self;
    guide.positioningDelegate = self;
    
    [guide setNDDPath:[[NSBundle mainBundle] pathForResource:@"grand-central-1" ofType:@"ndd"]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [guide startUpdates];
    
    self.myLoadingView.alpha = 1;

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [guide stopUpdates];
}

-(void)guideManager:(IGGuideManager *)manager didEnterZone:(uint32_t)zone_id name:(NSString *)name{
    
    [super guideManager:manager didEnterZone:zone_id name:name];
    
    NSLog(@"ID: %d , Name: %@",zone_id,name);
    self.locationLabel.text = [[NSNumber numberWithInt:zone_id] stringValue];
    
}

-(void)guideManager:(IGGuideManager *)manager didExitZone:(uint32_t)zone_id name:(NSString *)name{
    
    [super guideManager:manager didExitZone:zone_id name:name];
    
    self.locationLabel.text = @"Unknown";
    
}

-(void)guideManager:(IGGuideManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    [super guideManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
    
    self.myLoadingView.alpha = 0;
    
}

-(void)guideManager:(IGGuideManager *)manager didFailWithError:(NSError *)error{
    
    [guide stopUpdates];
    
    UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Loading Error" message:error.userInfo[@"msg"] delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:nil];
    [a show];
    
    NSLog(@"%@",error.description);
    self.logTextView.text = error.description;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    [guide startUpdates];
    self.myLoadingView.alpha = 1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
