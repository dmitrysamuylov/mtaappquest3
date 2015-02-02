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
#import "SignParser.h"
#import "LocationSignTableViewCell.h"

static const NSTimeInterval kZoneUpdateInterval = 2;
static NSString *const kSpecialZoneName = @"passageway_entrance_west";

@interface WhereIAmViewController ()<UITableViewDataSource, UITableViewDelegate, IGPositioningDelegate, IGDirectionsDelegate>
{
	Location *_currentLocation;
	IBOutlet UITableView *_SignTableView;
	NSString *_currentHeadingDirection;
	NSString *_currentZoneName;
	NSString *_lastZoneName;
	NSTimeInterval _lastUpdatedZone;
}
@end

@implementation WhereIAmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
    guide = [IGGuideManager sharedManager];
	guide.positioningDelegate = self;
	guide.directionsDelegate = self;
	[guide startUpdates];
    
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
    }*/
	
	_lastZoneName = nil;
	
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
	
	Location *newZone = [[SignParser sharedParser] getLocationWithZoneName:correctedName];
	NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
	if (!newZone && currentTime - _lastUpdatedZone < kZoneUpdateInterval)
	{
		return;
	}
	
	_lastUpdatedZone = currentTime;
	_lastZoneName = _currentZoneName;
	_currentLocation = newZone;
	[_SignTableView reloadData];
    _currentZoneName = correctedName;
}

-(void)guideManager:(IGGuideManager *)manager didExitZone:(uint32_t)zone_id name:(NSString *)name{
    
    [super guideManager:manager didExitZone:zone_id name:name];
    
    _currentZoneName = @"Unknown";
}

-(void)guideManager:(IGGuideManager *)manager didUpdateHeading:(CLLocationDirection)newHeading
{
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
    
    _currentHeadingDirection = headingString;
	
	[_SignTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:NO];
}

-(void)guideManager:(IGGuideManager *)manager didFailWithError:(NSError *)error{
    
    _currentHeadingDirection = @"Unknown";
    _currentZoneName = @"Unknown";
    
    NSLog(@"%@",error.description);
}


#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row < 2)
	{
		CurrentSignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrentSignIdentifier"];
		
		if (indexPath.row == 0)
		{
			cell.titleLabel.text = @"You are facing:";
			[cell.titleLabel sizeToFit];
			
			cell.descriptionLabel.text = _currentHeadingDirection;
			[cell.descriptionLabel sizeToFit];
		}
		else
		{
			[cell.titleLabel sizeToFit];
			cell.titleLabel.text = @"You are at the:";
			NSString *name;
			
			if ([_currentZoneName isEqualToString:kSpecialZoneName])
			{
				// Going toward Stations
				if ([_lastZoneName isEqualToString:@"passageway_1"])
				{
					NSRange startRange = [_currentLocation.name rangeOfString:@"enter{"];
					NSRange endRange = [_currentLocation.name rangeOfString:@"}exist{"];
					NSRange messageRange = NSMakeRange(startRange.length, endRange.location - startRange.length);
					name = [_currentLocation.name substringWithRange:messageRange];
				}
				else // coming from station
				{
					NSRange startRange = [_currentLocation.name rangeOfString:@"}exist{"];
					NSInteger startIndex = startRange.location + startRange.length;
					NSRange messageRange = NSMakeRange(startIndex, _currentLocation.name.length - startIndex - 1);
					name = [_currentLocation.name substringWithRange:messageRange];
				}
			}
			else
			{
				name = _currentLocation.name;
			}
			
			cell.descriptionLabel.text = name;
			[cell.descriptionLabel sizeToFit];
		}
		
		return cell;

	}
	else if (indexPath.row < 6)
	{
		LocationSignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationSignCellIdentifier"];
		
		NSString *signDirection = _currentLocation.signs.allKeys[indexPath.row - 2];
		Sign *sign = _currentLocation.signs[signDirection];
		cell.descriptionLabel.text = [NSString stringWithFormat:@"%@ %@", sign.direction, sign.message];
		[cell.descriptionLabel sizeToFit];
		
		return cell;
	}
	else
	{
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecalibrateCellIdentifier"];

		return cell;
	}
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
