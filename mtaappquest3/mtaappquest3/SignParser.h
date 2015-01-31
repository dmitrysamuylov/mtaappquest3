//
//  SignParser.h
//  mtaappquest3
//
//  Created by Diego Cruz on 1/31/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignParser : NSObject

@property (strong,nonatomic) NSMutableDictionary *myModel;

+ (id)sharedParser;


@end
