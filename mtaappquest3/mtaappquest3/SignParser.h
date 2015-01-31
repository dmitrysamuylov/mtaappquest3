//
//  SignParser.h
//  mtaappquest3
//
//  Created by Diego Cruz on 1/31/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface SignParser : NSObject
{
    NSDictionary *myModel;
}
+ (id)sharedParser;
-(Location *)getLocationWithZoneName:(NSString *)zoneName;

@end
