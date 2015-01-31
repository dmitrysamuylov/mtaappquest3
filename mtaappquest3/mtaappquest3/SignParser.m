//
//  SignParser.m
//  mtaappquest3
//
//  Created by Diego Cruz on 1/31/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#import "SignParser.h"
#import "CJSONDeserializer.h"

@implementation SignParser

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
    static NSString *jsonName = @"";
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:jsonName ofType:@"txt"]]];
    
    NSError *imError=nil;
    self.myModel = [CJSONDeserializer deserializer] deserialize:jsonData error:<#(NSError *__autoreleasing *)#>
}

@end
