//
//  StopTime.h
//  mtaappquest3
//
//  Created by Diego Cruz on 1/28/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StopTime : NSObject

@property (nonatomic, strong) NSDate * arrivalTime;
@property (nonatomic, strong) NSDate * departureTime;
@property (nonatomic, strong) NSString *myTripID;
@property (nonatomic, strong) NSString *myStopID;
@property (nonatomic, strong) NSString *myZoneID;

@end
