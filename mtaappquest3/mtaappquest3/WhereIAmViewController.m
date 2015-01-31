//
//  WhereIAmViewController.m
//  mtaappquest3
//
//  Created by Diego Cruz on 1/16/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#import "WhereIAmViewController.h"
#import "Location.h"
#import "Sign.h"
#import "CurrentSignTableViewCell.h"
#import "LocationSignTableViewCell.h"

@interface WhereIAmViewController ()<UITableViewDataSource, UITableViewDelegate>
{
	Location *_currentLocation;
	IBOutlet UITableView *_SignTableView;
}
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
	
	_currentLocation = [self getCurrentLocation];
	[_SignTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"NormalCellID"];
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


#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row < 2)
	{
		CurrentSignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrentSignIdentifier"];
		
		if (indexPath.row == 0)
		{
			cell.titleLabel.text = @"You are facing:";
			cell.descriptionLabel.text = @"You are facing information would go here!";
		}
		else
		{
			cell.titleLabel.text = indexPath.row == 0 ? @"You are facing:" : @"You are at the:";
			cell.descriptionLabel.text = _currentLocation.name;
		}
		
		return cell;

	}
	else if (indexPath.row < 6)
	{
		LocationSignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationSignCellIdentifier"];
		
		NSString *signKey = _currentLocation.signs.allKeys[indexPath.row - 2];
		NSString *signDescription = _currentLocation.signs[signKey];
		cell.descriptionLabel.text = [NSString stringWithFormat:@"%@ %@", signKey, signDescription];
		
		return cell;
	}
	else
	{
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCellID"];
		cell.backgroundColor = [UIColor clearColor];
		
		if (indexPath.row == 7)
		{
			UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.frame), CGRectGetHeight(cell.frame))];
			[button setTitle:@"Recalibrate my location" forState:UIControlStateNormal];
			[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			button.backgroundColor = [UIColor colorWithRed:0 green:170.0f/255 blue:239.0f/255 alpha:1];
			[cell addSubview:button];
		}

		return cell;
	}
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 6)
		return 40;
	return 60;
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

#pragma mark - Private Helper Methods

- (Location*)getCurrentLocation
{
    Location* currentLocation = [Location new];
    currentLocation.name = @"Mezzanine 1";
    currentLocation.descriptionPrimary = @"Description of everything you can see in the mezzanine";
    currentLocation.signs = @{ @"NorthSign": @"North Trains list",
                               @"EastSign": @"East Trains list",
                               @"SouthSign": @"South Trains list",
                               @"WestSign": @"West Trains list" };
    
    return currentLocation;
}


@end
