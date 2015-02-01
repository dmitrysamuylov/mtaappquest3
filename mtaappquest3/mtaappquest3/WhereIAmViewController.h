//
//  WhereIAmViewController.h
//  mtaappquest3
//
//  Created by Diego Cruz on 1/16/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IndoorGuide/IGMapViewController.h>
#import <IndoorGuide/IGGuideManager.h>

@interface WhereIAmViewController : IGMapViewController <UITableViewDelegate, UITableViewDataSource>
{
    IGGuideManager* guide;
}

@end
