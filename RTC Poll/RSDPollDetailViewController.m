//
//  RSDPollDetailViewController.m
//  RTC Poll
//
//  Created by Le Viet Gia Khanh on 2014/07/17.
//  Copyright (c) 2014年 Recruit Tech. All rights reserved.
//

#import "RSDPollDetailViewController.h"
#import <Parse/Parse.h>
#import "RSDSettingsManager.h"

@interface RSDPollDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (nonatomic) RSDPollItem *pollItem;
@property (nonatomic) RSDPollItem *activePollItem;
@property (nonatomic) UIAlertView *loadingView;

@end

@implementation RSDPollDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //clear sample question text
    self.questionLabel.text = @"";
    
    __weak RSDPollDetailViewController *weakSelf = self;
    
    //check if team setting finished
    RSDSettingsManager *manager = [RSDSettingsManager sharedManager];
    if (manager.currentTeamNumber == 0) {
        [self showNoTeamSelected];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.8 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        });
        return;
    }
    
    //show loading alert
    [self showLoadingAlert];
    
    //start loading poll information
    [self loadActiveQuestionAndDoWhenComplete:^(void) {
        weakSelf.pollItem = [weakSelf.activePollItem copy];
        [weakSelf reflectPollItemToUI];
        [weakSelf dismissLoadingView];
    }
                     ifError:^(void) {
                         [weakSelf dismissLoadingView];
                         [weakSelf showNoQuestionAlert];
                         //delay modal dismiss to wait until alert view show. if not, current viewcontroller wont dismiss
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                              [weakSelf dismissViewControllerAnimated:YES completion:nil];
                         });

    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)chooseAnswer:(UIButton *)button
{
    self.pollItem.answer = button.tag - VIEW_TAG_OFFSET;
    //[self dismissViewControllerAnimated:YES completion:nil];
    //if (self.pollItem.answer == self.pollItem.correctAnswer)
    [self showLoadingAlert];
    
    __weak RSDPollDetailViewController *weakSelf = self;
    [self loadActiveQuestionAndDoWhenComplete:^(void) {
        if ([weakSelf.pollItem.objectId isEqualToString:weakSelf.activePollItem.objectId]) {
            [weakSelf saveAnswer];
        } else {
            [weakSelf dismissLoadingView];
            [weakSelf showNotActiveQuestionAlert];
            //delay modal dismiss to wait until alert view show. if not, current viewcontroller wont dismiss
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }
                     ifError:^(void) {
                         [weakSelf dismissLoadingView];
                         [weakSelf showNotActiveQuestionAlert];
                         //delay modal dismiss to wait until alert view show. if not, current viewcontroller wont dismiss
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                             [weakSelf dismissViewControllerAnimated:YES completion:nil];
                         });
                         
                     }];

}

#pragma mark - LoadView methods
- (void)reflectPollItemToUI
{
    //init answer list
    NSMutableArray *answersList = [NSMutableArray array];
    if ((![self.pollItem.choice1 isEqualToString:@""]) && (self.pollItem.choice1))
        [answersList addObject:self.pollItem.choice1];
    if ((![self.pollItem.choice2 isEqualToString:@""]) && (self.pollItem.choice2))
        [answersList addObject:self.pollItem.choice2];
    if ((![self.pollItem.choice3 isEqualToString:@""]) && (self.pollItem.choice3))
        [answersList addObject:self.pollItem.choice3];
    if ((![self.pollItem.choice4 isEqualToString:@""]) && (self.pollItem.choice4))
        [answersList addObject:self.pollItem.choice4];
    
    //adjust question label
    
    /*self.questionLabel.frame = CGRectMake(self.questionLabel.frame.origin.x,
                                          spaceBetweenTopAndQuestion,
                                          self.questionLabel.frame.size.width, self.questionLabel.frame.size.height);*/
    
    //make answer button
    CGSize buttonSize = CGSizeMake(243, 44);
    NSInteger numberOfChoices = answersList.count;
    self.questionLabel.text = self.pollItem.question;
    int spaceVerticalBetweenButton = (self.view.bounds.size.height - numberOfChoices * buttonSize.height
        - self.questionLabel.frame.size.height - self.questionLabel.frame.origin.y) / (numberOfChoices + 1);

    
    CGPoint origin = CGPointMake(39, self.questionLabel.frame.origin.y + self.questionLabel.frame.size.height
                                 + spaceVerticalBetweenButton);
    
    for (int i=0;i<answersList.count;i++) {
        
        CGRect frame = CGRectMake(origin.x,
                                  origin.y + i * (buttonSize.height + spaceVerticalBetweenButton),
                                  buttonSize.width, buttonSize.height);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:[NSString stringWithFormat:@"%@",answersList[i]] forState:UIControlStateNormal];
        button.frame = frame;
        button.titleLabel.font = [UIFont systemFontOfSize:20];
        button.backgroundColor = [UIColor greenColor];
        button.tag = VIEW_TAG_OFFSET + i + 1; //answer no. starts from 1
        [button addTarget:self action:@selector(chooseAnswer:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
    }
    
}

#pragma view - Parse communication methods
- (void)loadActiveQuestionAndDoWhenComplete:(void (^)()) completionHandler
                   ifError:(void (^)()) errorHandler
{
    //load from parse
    PFQuery *query = [PFQuery queryWithClassName:@"PollQuestion"];
    [query whereKey:@"active" equalTo:[NSNumber numberWithBool:YES]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            //NSLog(@"%@", object[@"question"]);
            RSDPollItem *item = [[RSDPollItem alloc] init];
            item.objectId = object.objectId;
            item.questionId = [object[@"question"] integerValue];
            item.question = object[@"question"];
            item.choice1 = object[@"choice1"];
            item.choice2 = object[@"choice2"];
            item.choice3 = object[@"choice3"];
            item.choice4 = object[@"choice4"];
            item.correctAnswer = [object[@"correctAnswer"] integerValue];
            self.activePollItem = item;
            if (completionHandler) {
                completionHandler();
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            if (errorHandler)
                errorHandler();
        }
    }];

}

- (void)saveAnswer
{
    RSDSettingsManager *manager = [RSDSettingsManager sharedManager];
    __weak RSDPollDetailViewController *weakSelf = self;
    
    //firstly, check if current team already answer or not
    PFQuery *query = [PFQuery queryWithClassName:@"PollAnswer"];
    [query whereKey:@"questionNo" equalTo:[NSNumber numberWithInteger:self.pollItem.questionId]];
    [query whereKey:@"team" equalTo:[NSNumber numberWithInteger:manager.currentTeamNumber]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFObject *pollAnswer;
        if (!error)
            // will update existed answer
            pollAnswer = object;
        else
            // create new answer
            pollAnswer = [PFObject objectWithClassName:@"PollAnswer"];
        pollAnswer[@"questionNo"] = [NSNumber numberWithInteger:self.pollItem.questionId];
        pollAnswer[@"team"] = [NSNumber numberWithInteger:manager.currentTeamNumber];
        pollAnswer[@"answerNo"] = [NSNumber numberWithInteger:self.pollItem.answer];
        pollAnswer[@"isCorrect"] = [NSNumber numberWithBool:(self.pollItem.answer == self.pollItem.correctAnswer)];
        [pollAnswer saveEventually];
        
        [weakSelf showAnswerAcceptedAlert];
        //delay modal dismiss to wait until alert view show. if not, current viewcontroller wont dismiss
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        });
        
    }];

}

#pragma view - Alert methods
- (void)showNoQuestionAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                    message:@"現在は有効な質問がありません。"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];

    [alert show];
}

- (void)showNotActiveQuestionAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                    message:@"回答期限を過ぎた為、あなたの回答は無効です。"
                                                   delegate:nil
                                          cancelButtonTitle:@"閉じる"
                                          otherButtonTitles: nil];
    [alert show];
}

- (void)showNoTeamSelected
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                    message:@"チームは選択されていません。\n先ずは設定画面からチーム選択してください。"
                                                   delegate:nil
                                          cancelButtonTitle:@"閉じる"
                                          otherButtonTitles: nil];
    [alert show];
}

- (void)showAnswerAcceptedAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"回答完了"
                                                    message:@"回答を正しく受け付けました。"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [self dismissLoadingView];
}

- (void)showLoadingAlert
{
    
    //show loading alert
    self.loadingView = [[UIAlertView alloc] initWithTitle:@"通信中・・・" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    [self.loadingView show];
}

- (void)dismissLoadingView
{
    [self.loadingView dismissWithClickedButtonIndex:0 animated:YES];
}

@end
