//
//  RSDPollItemManager.m
//  RTC Poll
//
//  Created by Le Viet Gia Khanh on 2014/07/18.
//  Copyright (c) 2014年 Recruit Tech. All rights reserved.
//

#import "RSDSettingsManager.h"

@implementation RSDSettingsManager

+ (instancetype)sharedManager
{
    static RSDSettingsManager *sharedSettingsManager = nil;
    if (!sharedSettingsManager) {
        sharedSettingsManager = [[RSDSettingsManager alloc] init];
    }
    return sharedSettingsManager;
}

- (NSInteger)currentTeamNumber {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"TeamNo"];
}

- (void)setCurrentTeamNumber:(NSInteger)currentTeamNumber
{
    [[NSUserDefaults standardUserDefaults] setInteger:currentTeamNumber forKey:@"TeamNo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
