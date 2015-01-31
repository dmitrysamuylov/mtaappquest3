//
//  MyIndoorManager.h
//  mtaappquest3
//
//  Created by Diego Cruz on 1/27/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <IndoorGuide/IGGuideManager.h>

@interface MyIndoorManager : NSObject <IGDirectionsDelegate,IGPositioningDelegate>

@property IGGuideManager *manager;
+ (id)sharedManager;

@end
