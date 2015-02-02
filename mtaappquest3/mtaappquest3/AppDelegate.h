//
//  AppDelegate.h
//  mtaappquest3
//
//  Created by Diego Cruz on 1/16/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHCSVParser.h"
#import "Route.h"
#import "Stop.h"
#import "Zone.h"
#import "StopTime.h"
#import "Trip.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CHCSVParserDelegate>
{
    NSDateFormatter *myFormatter;
}
@property (strong, nonatomic) UIWindow *window;


@end

