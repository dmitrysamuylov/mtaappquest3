//
//  Route.h
//  mtaappquest3
//
//  Created by Diego Cruz on 1/28/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Trip;

@interface Route : NSManagedObject

@property (nonatomic, retain) UIColor* backgroundColor;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * longName;
@property (nonatomic, retain) NSString * routeDescription;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) UIColor* textColor;
@property (nonatomic, retain) NSSet *myTrips;
@end

@interface Route (CoreDataGeneratedAccessors)

- (void)addMyTripsObject:(Trip *)value;
- (void)removeMyTripsObject:(Trip *)value;
- (void)addMyTrips:(NSSet *)values;
- (void)removeMyTrips:(NSSet *)values;

@end
