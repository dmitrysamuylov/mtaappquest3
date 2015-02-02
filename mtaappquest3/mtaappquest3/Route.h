//
//  Route.h
//  mtaappquest3
//
//  Created by Diego Cruz on 1/28/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Route : NSObject

@property (nonatomic, strong) UIColor* backgroundColor;
@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSString * longName;
@property (nonatomic, strong) NSString * routeDescription;
@property (nonatomic, strong) NSString * shortName;
@property (nonatomic, strong) UIColor* textColor;

@end
