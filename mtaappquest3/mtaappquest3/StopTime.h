//
//  StopTime.h
//  mtaappquest3
//
//  Created by Diego Cruz on 1/28/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Stop, Trip, Zone;

@interface StopTime : NSManagedObject

@property (nonatomic, retain) NSDate * arrivalTime;
@property (nonatomic, retain) NSDate * departureTime;
@property (nonatomic, retain) Trip *myTrip;
@property (nonatomic, retain) Stop *myStop;
@property (nonatomic, retain) Zone *myZone;

@end
