//
//  SignParser.m
//  mtaappquest3
//
//  Created by Diego Cruz on 1/31/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#import "SignParser.h"
#import "NSDictionary_JSONExtensions.h"
#import "Sign.h"

@implementation SignParser : NSObject 

+ (id)sharedParser {
    static SignParser *sharedParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedParser = [[self alloc] init];
        [sharedParser loadJSON];
    });
    return sharedParser;
}

-(void)loadJSON{
    static NSString *jsonName = @"locations";
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"]]];
    
    NSError *imError=nil;
    myModel = [NSDictionary dictionaryWithJSONData:jsonData error:&imError];
    
    if (imError) {
        NSLog(@"%@",imError.description);
    }
}

-(Location *)getLocationWithZoneName:(NSString *)zoneName{
    
    if (myModel) {
        NSDictionary *zoneDictionary = myModel[zoneName];
        
        if (zoneDictionary) {
            Location *newLocation = [[Location alloc] init];
            newLocation.name = zoneDictionary[@"name"];;
            newLocation.descriptionPrimary = zoneDictionary[@"descriptionPrimary"];
            newLocation.descriptionDetailed = zoneDictionary[@"descriptionDetailed"];
            NSMutableDictionary *mySigns = [[NSMutableDictionary alloc] init];
            
            if (zoneDictionary[@"signs"]) {
                for (NSDictionary *signDictionary in zoneDictionary[@"signs"]) {
                    Sign *newSign = [[Sign alloc] init];
                    newSign.name = signDictionary[@"name"];
                    newSign.message = signDictionary[@"message"];
                    newSign.direction = signDictionary[@"direction"];
                    
                    [mySigns setObject:newSign forKey:newSign.direction];
                }
                newLocation.signs = mySigns;
            }
            else{
                NSLog(@"No signs for zone name %@",zoneName);
            }
            
            return newLocation;
        }else{
            NSLog(@"No location for zone name %@",zoneName);
            return nil;
        }
        
    }else{
        NSLog(@"JSON was not loaded corretly");
        return nil;
    }
    
    
}

@end
