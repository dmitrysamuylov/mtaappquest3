//
//  MTASubwayScheduleDBManager.m
//  mtaappquest3
//
//  Created by Mani Ramezan on 2/3/15.
//  Copyright (c) 2015 Diego Cruz. All rights reserved.
//

#import "MTASubwayScheduleDBManager.h"
#import "sqlite3.h"

@interface MTASubwayScheduleDBManager()
{
	NSArray *_sTrainSchedule;
	sqlite3 *_database;
}
@end

@implementation MTASubwayScheduleDBManager

+ (MTASubwayScheduleDBManager *)defaultManager
{
	static MTASubwayScheduleDBManager *manager;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [MTASubwayScheduleDBManager new];
	});
	return manager;
}

+ (NSDateFormatter *)formatter
{
	static NSDateFormatter *timeFormatter;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		timeFormatter = [NSDateFormatter new];
		timeFormatter.dateFormat = @"HH:mm:ss";
	});
	
	return timeFormatter;
}

- (NSArray *)fetchSTrainSchedule
{
	if (!_sTrainSchedule.count)
	{
		NSMutableArray *trainSchedule = [NSMutableArray new];
		
		NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"mta-subway" ofType:@"sqlite"];
		sqlite3_stmt *statement;
		const char *dbpath = [databasePath UTF8String];
		if (sqlite3_open(dbpath, &_database) == SQLITE_OK)
		{
			NSString *querySQL = @"select departure_time from stop_times as st inner join trips as t on st.trip_id = t.trip_id where t.route_id = 'GS' and t.direction_id = 0 order by departure_time asc";
			const char *query_stmt = [querySQL UTF8String];
			if (sqlite3_prepare_v2(_database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
			{
				NSDateFormatter *formatter = [MTASubwayScheduleDBManager formatter];
				while (sqlite3_step(statement) == SQLITE_ROW)
				{
					NSString *leaveTimeString = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
					
					NSDate *leaveTime = [formatter dateFromString:leaveTimeString];
					
					if (!leaveTime && [leaveTimeString hasPrefix:@"24:"])
					{
						leaveTimeString = [NSString stringWithFormat:@"00:%@", [leaveTimeString substringFromIndex:2]];
						leaveTime = [formatter dateFromString:@"00:00:00"];
					}
					
					[trainSchedule addObject:leaveTime];
				}
				sqlite3_reset(statement);
			}
		}
		_sTrainSchedule = [trainSchedule sortedArrayUsingComparator:^NSComparisonResult(NSDate *date1, NSDate *date2) {
			return [date1 timeIntervalSince1970] > [date2 timeIntervalSince1970];
		}];
	}
	
	return _sTrainSchedule;
}

- (NSInteger)nextSTrainLeave
{
	NSUInteger flags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
	[calendar setTimeZone:timeZone];
	NSDate *currentDate = [NSDate date];
	NSDateComponents* components = [calendar components:flags fromDate:currentDate];
	components.minute += 4;
	NSDate *currentTime = [calendar dateFromComponents:components];
	
	for (NSDate *date in [self fetchSTrainSchedule])
	{
		components = [calendar components:flags fromDate:date];
		components.minute += 4;
		
		NSDate* timeOnly = [calendar dateFromComponents:components];
		
		if ([timeOnly compare:currentTime] >= 0)
		{
			NSTimeInterval diff = [timeOnly timeIntervalSinceDate:currentTime];
			return (NSUInteger)(diff / 60.0);
		}
	}
	return -1;
}

- (void)dealloc
{
	sqlite3_close(_database);
}

@end
