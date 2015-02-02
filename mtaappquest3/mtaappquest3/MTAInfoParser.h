//
//  MTAInfoParser.h
//
//
//  Created by Diego Cruz on 2/1/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTAInfoParserDelegate <NSObject>

-(void)MTAInfoParserFinished:(BOOL)success;

@end

@interface MTAInfoParser : NSObject

@property(strong,nonatomic) NSMutableArray *routes;
@property(strong,nonatomic) NSMutableArray *trips;
@property(strong,nonatomic) NSMutableArray *stops;
@property(strong,nonatomic) NSMutableArray *stoptimes;
@property(strong,nonatomic) NSMutableArray *zones;

@property(nonatomic) id<MTAInfoParserDelegate> myDelegate;

+ (id)sharedParser;
-(NSString *)timeForZoneName:(NSString *)zoneName;

@end
