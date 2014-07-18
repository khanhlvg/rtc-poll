//
//  RSDPollItemManager.h
//  RTC Poll
//
//  Created by Le Viet Gia Khanh on 2014/07/18.
//  Copyright (c) 2014年 Recruit Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RSDPollItem;
@class PFObject;

@interface RSDSettingsManager : NSObject

@property (nonatomic) NSInteger currentTeamNumber;

+ (instancetype) sharedManager;

@end
