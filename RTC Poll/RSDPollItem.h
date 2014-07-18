//
//  RSDPollItem.h
//  RTC Poll
//
//  Created by Le Viet Gia Khanh on 2014/07/17.
//  Copyright (c) 2014年 Recruit Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSDPollItem : NSObject <NSCopying>

@property (nonatomic) NSString *objectId;
@property (nonatomic) NSInteger questionNo;

@property (nonatomic) NSString *question;

@property (nonatomic) NSString *choice1;
@property (nonatomic) NSString *choice2;
@property (nonatomic) NSString *choice3;
@property (nonatomic) NSString *choice4;

@property (nonatomic) NSInteger answer;
@property (nonatomic) NSInteger correctAnswer;

@end
