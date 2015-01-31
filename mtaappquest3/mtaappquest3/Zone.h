//
//  Zone.h
//  mtaappquest3
//
//  Created by Diego Cruz on 1/28/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StopTime;

@interface Zone : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *stopTimes;
@end

@interface Zone (CoreDataGeneratedAccessors)

- (void)addStopTimesObject:(StopTime *)value;
- (void)removeStopTimesObject:(StopTime *)value;
- (void)addStopTimes:(NSSet *)values;
- (void)removeStopTimes:(NSSet *)values;

@end
