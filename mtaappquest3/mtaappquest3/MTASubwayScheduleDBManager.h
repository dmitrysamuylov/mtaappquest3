//
//  MTASubwayScheduleDBManager.h
//  mtaappquest3
//
//  Created by Mani Ramezan on 2/3/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTASubwayScheduleDBManager : NSObject

+ (MTASubwayScheduleDBManager *)defaultManager;

- (NSArray *)fetchSTrainSchedule;
- (NSInteger)nextSTrainLeave;

@end
