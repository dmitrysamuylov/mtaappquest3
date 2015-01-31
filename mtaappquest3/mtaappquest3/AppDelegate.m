//
//  AppDelegate.m
//  mtaappquest3
//
//  Created by Diego Cruz on 1/16/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
    
    if (![myDefaults boolForKey:@"informationParsed"]) {
        
        myFormatter = [[NSDateFormatter alloc] init];
        myFormatter.dateFormat = @"hh:mm:ss";
        
        NSURL *routesURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"routes" ofType:@"txt"]];
        NSURL *stopsURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"stops" ofType:@"txt"]];
        NSURL *tripsURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"trips" ofType:@"txt"]];
        NSURL *stopTimesURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"stop_times" ofType:@"txt"]];
        //NSURL *zonesURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"stop_times" ofType:@"txt"]];
        
        [self parseRoutes:[NSArray arrayWithContentsOfCSVURL:routesURL]];
        //[self parseStops:[NSArray arrayWithContentsOfCSVURL:stopsURL]];
        //[self parseTrips:[NSArray arrayWithContentsOfCSVURL:tripsURL]];
        //[self parseZones:[NSArray arrayWithContentsOfCSVURL:zonesURL]];
        //[self parseStopTimes:[NSArray arrayWithContentsOfCSVURL:stopTimesURL]];
        
        [myDefaults setBool:YES forKey:@"informationParsed"];
    }
    
    return YES;
}

#pragma mark Parsing methods

-(void)parseStops:(NSArray *)array{
    
    if (array) {
        
        BOOL firstLine = YES;
        for (NSArray* line in array) {
            
            if (!firstLine) {
                
                Stop* newStop = [Stop create];
                newStop.id = line[0];
                newStop.name = line[2];
                newStop.stopDescription = line[3];
                
            }else{
                firstLine = NO;
            }
            
        }
        
        [[IBCoreDataStore mainStore] save];
        
    }
}

-(void)parseRoutes:(NSArray *)array{
    
    if (array) {
    
    BOOL firstLine = YES;
    for (NSArray* line in array) {
        
        if (!firstLine) {
            
            Route* newRoute = [Route create];
            newRoute.id = line[0];
            newRoute.shortName = line[2];
            newRoute.longName = line[3];
            newRoute.routeDescription = line[4];
            newRoute.backgroundColor = UIColorFromRGB([self hexFromString:line[7]]);
            
            if ([newRoute.shortName isEqualToString:@"N"] || [newRoute.shortName isEqualToString:@"Q"] || [newRoute.shortName isEqualToString:@"R"]) {
                newRoute.textColor = [UIColor blackColor];
            }
            else{
                newRoute.textColor = [UIColor whiteColor];
            }
            
        }else{
            firstLine = NO;
        }
        
    }
    
    [[IBCoreDataStore mainStore] save];
        
    }
    
}

-(void)parseTrips:(NSArray *)array{
    
    if (array) {
        
        BOOL firstLine = YES;
        for (NSArray* line in array) {
            
            if (!firstLine) {
                
                Trip* newTrip = [Trip create];
                newTrip.id = line[2];
                newTrip.headsign = line[3];
                newTrip.directionID = [NSNumber numberWithInt:((NSString *)line[4]).intValue];
                
                Route *myRoute = [Route allForPredicate:[NSPredicate predicateWithFormat:@"%K == %@" argumentArray:@[@"id",line[0]]]][0];
                newTrip.myRoute = myRoute;
                
            }else{
                firstLine = NO;
            }
            
        }
        
        [[IBCoreDataStore mainStore] save];
        
    }
    
}

-(void)parseStopTimes:(NSArray *)array{
    
    if (array) {
        
        BOOL firstLine = YES;
        for (NSArray* line in array) {
            
            if (!firstLine) {
                
                StopTime* newStopTime = [StopTime create];
                
                Trip *myTrip = [Trip allForPredicate:[NSPredicate predicateWithFormat:@"%K == %@" argumentArray:@[@"id",line[0]]]][0];
                newStopTime.myTrip = myTrip;
                
                newStopTime.arrivalTime = [myFormatter dateFromString:line[1]];
                newStopTime.departureTime = [myFormatter dateFromString:line[2]];
                
                Stop *myStop = [Stop allForPredicate:[NSPredicate predicateWithFormat:@"%K == %@" argumentArray:@[@"id",line[3]]]][0];
                newStopTime.myStop = myStop;
                
            }else{
                firstLine = NO;
            }
            
        }
        
        [[IBCoreDataStore mainStore] save];
        
    }
    
}

-(void)parseZones:(NSArray *)array{
    
    if (array) {
        
        BOOL firstLine = YES;
        for (NSArray* line in array) {
            
            if (!firstLine) {
                
                Zone *imZone;
                NSArray *existingZone = [StopTime allForPredicate:[NSPredicate predicateWithFormat:@"%K == %@" argumentArray:@[@"id",line[0]]]];
                
                if (existingZone.count > 0) {
                    imZone = existingZone[0];
                }else{
                    imZone = [Zone create];
                    imZone.id = line[0];
                    imZone.name = line[1];
                }
                
                StopTime *myStopTime = [StopTime allForPredicate:[NSPredicate predicateWithFormat:@"%K == %@" argumentArray:@[@"id",line[2]]]][0];
                [imZone addStopTimesObject:myStopTime];
                
            }else{
                firstLine = NO;
            }
            
        }
        
        [[IBCoreDataStore mainStore] save];
        
    }
    
}

-(unsigned)hexFromString:(NSString *)string{
    
    NSString *correctedString = [self correctedColorString:string];
    unsigned colorInt = 0;
    [[NSScanner scannerWithString:correctedString] scanHexInt:&colorInt];
    
    return colorInt;
}

-(NSString *)correctedColorString:(NSString *)string{
    
    NSString *correctedString = [string isEqualToString:@""]?@"F5F5F5":string;
    return [NSString stringWithFormat:@"0x%@",correctedString];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
