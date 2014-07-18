//
//  RSDFirstViewController.m
//  RTC Poll
//
//  Created by Le Viet Gia Khanh on 2014/07/17.
//  Copyright (c) 2014年 Recruit Tech. All rights reserved.
//

#import "RSDPollEntranceViewController.h"
#import "RSDPollDetailViewController.h"
#import "RSDPollItem.h"

@interface RSDPollEntranceViewController ()

@end

@implementation RSDPollEntranceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    RSDPollDetailViewController *pdvc = (RSDPollDetailViewController*) [segue destinationViewController];
    // Pass the selected object to the new view controller.
    
    RSDPollItem *samplePollItem = [[RSDPollItem alloc] init];
    samplePollItem.question = @"例題。このキャラクターはどの都道府県のキャラーですか？";
    samplePollItem.choice1 = @"選択肢１";
    samplePollItem.choice2 = @"選択肢２";
    samplePollItem.choice3 = @"選択肢３";
    samplePollItem.choice4 = @"選択肢４";
    samplePollItem.correctAnswer = 1;
    
    pdvc.pollItem = samplePollItem;
}
 */

@end
