////
////  MTASubwayScheduleDBManager.m
////  mtaappquest3
////
////  Created by Mani Ramezan on 2/3/15.
////  Copyright (c) 2015 Diego Cruz. All rights reserved.
////
//
//#import "MTASubwayScheduleDBManager.h"
//#import "sqlite3.h"
//
//@implementation MTASubwayScheduleDBManager
//
//+ (MTASubwayScheduleDBManager *)defaultManager
//{
//	static MTASubwayScheduleDBManager *manager;
//	static dispatch_once_t onceToken;
//	dispatch_once(&onceToken, ^{
//		manager = [MTASubwayScheduleDBManager new];
//	});
//	return manager;
//}
//
//- (NSDate *)nextSTrainLeavesTime
//{
//	NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"mta-subway" ofType:@"sqlite"];
//	sqlite3 *database;
//	sqlite3_stmt *statement;
//	const char *dbpath = [databasePath UTF8String];
//	if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//	{
//		NSString *querySQL = @"select departure_time from stop_times as st inner join trips as t on st.trip_id = t.trip_id where t.route_id = 'GS' and t.direction_id = 0 order by departure_time asc limit 1";
//		const char *query_stmt = [querySQL UTF8String];
//		if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
//		{
//			if (sqlite3_step(statement) == SQLITE_ROW)
//			{
//				NSString *leaveTimeString = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
//				static NSDateFormatter *formatter;
//				if (!formatter)
//				{
//					formatter = [NSDateFormatter new];
//					formatter.dateFormat = @"HH:mm:ss";
//				}
//				
//				NSDate *leaveTime = [formatter dateFromString:leaveTimeString];
//				
//				return leaveTime;
//			}
//			else{
//				NSLog(@"Not found");
//				return nil;
//			}
//			sqlite3_reset(statement);
//		}
//	}
//	return nil;
//}
//
//@end
