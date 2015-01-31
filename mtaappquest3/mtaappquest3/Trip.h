//
//  Trip.h
//  mtaappquest3
//
//  Created by Diego Cruz on 1/28/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Route, StopTime;

@interface Trip : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * headsign;
@property (nonatomic, retain) NSNumber * directionID;
@property (nonatomic, retain) Route *myRoute;
@property (nonatomic, retain) NSSet *stopTimes;
@end

@interface Trip (CoreDataGeneratedAccessors)

- (void)addStopTimesObject:(StopTime *)value;
- (void)removeStopTimesObject:(StopTime *)value;
- (void)addStopTimes:(NSSet *)values;
- (void)removeStopTimes:(NSSet *)values;

@end
