//
//  MyIndoorManager.m
//  mtaappquest3
//
//  Created by Diego Cruz on 1/27/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#import "MyIndoorManager.h"

@implementation MyIndoorManager

+ (id)sharedManager {
    static MyIndoorManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        
        sharedMyManager.manager = [IGGuideManager sharedManager];
        sharedMyManager.manager.directionsDelegate = sharedMyManager;
        sharedMyManager.manager.positioningDelegate = sharedMyManager;
        
    });
    return sharedMyManager;
}

#pragma mark Position Delegate methods

-(void)guideManager:(IGGuideManager *)manager didUpdateHeading:(CLLocationDirection)newHeading{
    
}

-(void)guideManager:(IGGuideManager *)manager didEnterZone:(uint32_t)zone_id name:(NSString *)name
{
    
}

-(void)guideManager:(IGGuideManager *)manager didExitZone:(uint32_t)zone_id name:(NSString *)name{
    
}

-(void)guideManager:(IGGuideManager *)manager didFailWithError:(NSError *)error{
    
}


#pragma mark Directions Delegate methods

-(void)guideManager:(IGGuideManager *)manager didUpdateRoutePosition:(CLLocationCoordinate2D)pos altitude:(CLLocationDistance)alt direction:(CLLocationDirection)direction distanceToChange:(CLLocationDistance)toChange distanceToGoal:(CLLocationDistance)toGoal{
    
}

-(void)guideManager:(IGGuideManager *)manager didCompleteRouting:(NSArray *)routepoints{
    
}

-(void)guideManager:(IGGuideManager *)manager didFailRoutingWithError:(NSError *)err{
    
}

@end
