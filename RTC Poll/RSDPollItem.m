//
//  RSDPollItem.m
//  RTC Poll
//
//  Created by Le Viet Gia Khanh on 2014/07/17.
//  Copyright (c) 2014年 Recruit Tech. All rights reserved.
//

#import "RSDPollItem.h"
#import <Parse/Parse.h>

@implementation RSDPollItem

- (id)copyWithZone:(NSZone *)zone
{
    RSDPollItem *copyItem = [[RSDPollItem alloc] init];
    copyItem.questionNo = self.questionNo;
    copyItem.objectId = self.objectId;
    
    copyItem.question = self.question;
    copyItem.choice1 = self.choice1;
    copyItem.choice2 = self.choice2;
    copyItem.choice3 = self.choice3;
    copyItem.choice4 = self.choice4;
    
    copyItem.answer = self.answer;
    copyItem.correctAnswer = self.correctAnswer;
    
    return copyItem;
}

@end
