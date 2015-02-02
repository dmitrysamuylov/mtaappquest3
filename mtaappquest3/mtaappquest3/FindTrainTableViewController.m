//
//  FindTrainTableViewController.m
//  mtaappquest3
//
//  Created by Diego Cruz on 1/27/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#import "FindTrainTableViewController.h"

@interface FindTrainTableViewController ()

@end

@implementation FindTrainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    /*
    NSArray *stopsTime = [StopTime allForPredicate:[NSPredicate predicateWithFormat:@"myStop.id == 631"]];
    NSArray *trips = [stopsTime valueForKeyPath:@"@distinctUnionOfObjects.myTrip"];
    routes = [trips valueForKeyPath:@"@distinctUnionOfObjects.myRoute"];
    routes = [routes sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"shortName" ascending:YES]]];*/
    
    //routes = [Route allOrderedBy:@"shortName" ascending:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return routes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trainCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Route *currentRoute = routes[indexPath.row];
    cell.shortNameLabel.text = currentRoute.shortName;
    cell.shortNameLabel.backgroundColor = currentRoute.backgroundColor;
    cell.shortNameLabel.textColor = currentRoute.textColor;
    cell.shortNameLabel.layer.cornerRadius = 20;
    
    cell.longNameLabel.text = currentRoute.longName;
    
    return cell;
}


@end
