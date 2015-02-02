//
//  Trip.h
//  mtaappquest3
//
//  Created by Diego Cruz on 1/28/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trip : NSObject

@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSString * headsign;
@property (nonatomic, strong) NSNumber * directionID;
@property (nonatomic, strong) NSString *myRouteID;

@end
