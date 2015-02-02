//
//  MTAInfoParser.m
//  mtaappquest3
//
//  Created by Diego Cruz on 2/1/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "MTAInfoParser.h"
#import "CHCSVParser.h"
#import "Route.h"
#import "Stop.h"
#import "Trip.h"
#import "StopTime.h"
#import "Zone.h"

@implementation MTAInfoParser

+ (id)sharedParser {
    static MTAInfoParser *sharedParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedParser = [[self alloc] init];
        [sharedParser loadMTAInfo];
    });
    return sharedParser;
}

-(void)loadMTAInfo{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
        [self loadRoutes];
        [self loadTrips];
        [self loadStops];
        [self loadZones];
        [self loadStopTimes];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myDelegate MTAInfoParserFinished:YES];
        });
        
    
    });
    
    
}

//route_id,agency_id,route_short_name,route_long_name,route_desc,route_type,route_url,route_color,route_text_color
-(void)loadRoutes{
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"routes" ofType:@"txt"]];
    NSArray *loadedArray = [NSArray arrayWithContentsOfCSVURL:url];
    
    if (loadedArray) {
        self.routes = [NSMutableArray array];
        NSLog(@"Parsing routes: %lu lines",(unsigned long)loadedArray.count);
        
        for (int k=1; k<loadedArray.count; k++) {
            
            NSLog(@"Parsing route %d / %lu",k,(unsigned long)loadedArray.count);
            
            NSArray *line = loadedArray[k];
            NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
            Route *newRoute = [[Route alloc] init];
            newRoute.identifier = line[0];
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
            
            newDic[line[0]] = newRoute;
            [self.routes addObject:newDic];
        }
        
    }
    
}

//route_id,service_id,trip_id,trip_headsign,direction_id,block_id,shape_id
-(void)loadTrips{
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"trips" ofType:@"txt"]];
    NSArray *loadedArray = [NSArray arrayWithContentsOfCSVURL:url];
    
    if (loadedArray) {
        self.trips = [NSMutableArray array];
        NSLog(@"Parsing trips: %lu lines",(unsigned long)loadedArray.count);
        
        for (int k=1; k<loadedArray.count; k++) {
            
            NSLog(@"Parsing trip %d / %lu",k,(unsigned long)loadedArray.count);
            
            NSArray *line = loadedArray[k];
            NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
            Trip *newTrip = [[Trip alloc] init];
            newTrip.myRouteID = line[0];
            newTrip.identifier = line[2];
            newTrip.headsign = line[3];
            newTrip.directionID = line[4];
            
            newDic[line[0]] = newTrip;
            [self.trips addObject:newDic];
        }
        
    }
    
}

//stop_id,stop_code,stop_name,stop_desc,stop_lat,stop_lon,zone_id,stop_url,location_type,parent_station
-(void)loadStops{
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"stops" ofType:@"txt"]];
    NSArray *loadedArray = [NSArray arrayWithContentsOfCSVURL:url];
    
    if (loadedArray) {
        self.stops = [NSMutableArray array];
        NSLog(@"Parsing stops: %lu lines",(unsigned long)loadedArray.count);
        
        for (int k=1; k<loadedArray.count; k++) {
            
            NSLog(@"Parsing stop %d / %lu",k,(unsigned long)loadedArray.count);
            
            NSArray *line = loadedArray[k];
            NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
            Stop *newStop = [[Stop alloc] init];
            newStop.identifier = line[0];
            newStop.name = line[2];
            newStop.stopDescription = line[3];
            
            newDic[line[0]] = newStop;
            [self.stops addObject:newDic];
        }
        
    }
    
}

//zone_id,name,stop_time_id
-(void)loadZones{
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"zones" ofType:@"txt"]];
    NSArray *loadedArray = [NSArray arrayWithContentsOfCSVURL:url];
    
    if (loadedArray) {
        self.zones = [NSMutableArray array];
        NSLog(@"Parsing zones: %lu lines",(unsigned long)loadedArray.count);
        
        for (int k=1; k<loadedArray.count; k++) {
            
            NSLog(@"Parsing zone %d / %lu",k,(unsigned long)loadedArray.count);
            
            NSArray *line = loadedArray[k];
            NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
            Zone *newZone = [[Zone alloc] init];
            newZone.identifier = line[0];
            newZone.name = line[2];
            newZone.myStopTimeID = line[3];
            
            newDic[line[0]] = newZone;
            [self.zones addObject:newDic];
        }
        
    }
    
}

//trip_id,arrival_time,departure_time,stop_id,stop_sequence,stop_headsign,pickup_type,drop_off_type,shape_dist_traveled
-(void)loadStopTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"hh:mm:ss";
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"stop_times" ofType:@"txt"]];
    NSArray *loadedArray = [NSArray arrayWithContentsOfCSVURL:url];
    
    if (loadedArray) {
        self.stoptimes = [NSMutableArray array];
        NSLog(@"Parsing stop times: %lu lines",(unsigned long)loadedArray.count);
        
        for (int k=1; k<loadedArray.count; k++) {
            
            NSLog(@"Parsing stop times %d / %lu",k,(unsigned long)loadedArray.count);
            
            NSArray *line = loadedArray[k];
            NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
            StopTime *newStopTime = [[StopTime alloc] init];
            newStopTime.myTripID = line[0];
            newStopTime.arrivalTime = [formatter dateFromString:line[1]];
            newStopTime.departureTime = [formatter dateFromString:line[2]];
            newStopTime.myStopID = line[3];
            
            newDic[line[0]] = newStopTime;
            [self.stoptimes addObject:newDic];
        }
        
    }
    
}

-(NSString *)timeForZoneName:(NSString *)zoneName{
    
    
    return @"";
}

#pragma mark - UTil methods

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

@end
