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
    
    // ---------------
    
    /*
    myLocationManager = [[CLLocationManager alloc] init];
    myLocationManager.delegate = self;
    
    // Check for iOS 8
    if ([myLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusNotDetermined) {
            [myLocationManager requestWhenInUseAuthorization];
        }
        
    }
    else{
        [self startHeadingReading];
    }
     */
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    guide.directionsDelegate = self;
    guide.positioningDelegate = self;
    
}

#pragma mark - Indoor Delegate Methods

-(void)guideManager:(IGGuideManager *)manager didEnterZone:(uint32_t)zone_id name:(NSString *)name{
    
    [super guideManager:manager didEnterZone:zone_id name:name];
    
    NSString *correctedName = [name isEqualToString:@""]?@"Unnamed":name;
    
    self.currentZoneLabel.text = [NSString stringWithFormat:@"%@ - %@",correctedName,@"Grand Central"];
}

-(void)guideManager:(IGGuideManager *)manager didExitZone:(uint32_t)zone_id name:(NSString *)name{
    
    [super guideManager:manager didExitZone:zone_id name:name];
    
    self.currentZoneLabel.text = @"Unknown";
}

-(void)guideManager:(IGGuideManager *)manager didUpdateHeading:(CLLocationDirection)newHeading{
    
    NSString *headingString = @"Calculating...";
    
    if (newHeading < 0) {
    }else if (newHeading <= 45){
        headingString = @"North";
    } else if (newHeading <= 135 ){
        headingString = @"East";
    }
    else if (newHeading <= 225 ){
        headingString = @"South";
    }
    else if (newHeading <= 315 ){
        headingString = @"West";
    }
    else{
        headingString = @"North";
    }
    
    self.currentHeadingLabel.text = headingString;
}

-(void)guideManager:(IGGuideManager *)manager didFailWithError:(NSError *)error{
    
    self.currentHeadingLabel.text = @"Unknown";
    self.currentZoneLabel.text = @"Unknown";
    
    NSLog(@"%@",error.description);
}

/*

#pragma mark - CLLocationManager delegate methods

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self startHeadingReading];
    }
    
}

// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
   
}

-(BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager{
    
    if(!manager.heading){
        return YES;
    }else if( manager.heading.headingAccuracy < 0 ){
        return YES;
    }else if( manager.heading.headingAccuracy > 5 ){
        return YES;
    }
    else return NO;
}

-(void)startHeadingReading{
    
    myLocationManager.headingFilter = kCLHeadingFilterNone;
    [myLocationManager startUpdatingHeading];
    
}

*/

@end
