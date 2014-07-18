//
//  RSDSecondViewController.m
//  RTC Poll
//
//  Created by Le Viet Gia Khanh on 2014/07/17.
//  Copyright (c) 2014年 Recruit Tech. All rights reserved.
//

#import "RSDSettingsViewController.h"
#import "RSDSettingsManager.h"

@interface RSDSettingsViewController ()

@property (nonatomic) NSMutableArray *teamSelectionButtonList;
@property (nonatomic,readonly) UIColor *activeButtonColor;
@property (nonatomic,readonly) UIColor *inactiveButtonColor;

@end


@implementation RSDSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.teamSelectionButtonList = [NSMutableArray array];
    [self createTeamSelectionButtons];
    [self loadSelectedTeam];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LoadView methods
- (void)createTeamSelectionButtons
{
    
    CGSize buttonSize = CGSizeMake(60, 60);
    int spaceHorizontolBetweenButton = (self.view.bounds.size.width - TEAM_PER_ROW * buttonSize.width) / (TEAM_PER_ROW + 1);
    int spaceVerticalBetweenButton = 30;
    
    CGPoint origin = CGPointMake(spaceHorizontolBetweenButton, 80);
    
    for (int i=0;i<NUMBER_OF_TEAMS;i++) {
        
        int posX = i % TEAM_PER_ROW;
        int posY = i / TEAM_PER_ROW;
        CGRect frame = CGRectMake(origin.x + posX * (buttonSize.width + spaceHorizontolBetweenButton),
                                  origin.y + posY * (buttonSize.height + spaceVerticalBetweenButton),
                                  buttonSize.width, buttonSize.height);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        button.frame = frame;
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        button.backgroundColor = self.inactiveButtonColor;
        button.tag = VIEW_TAG_OFFSET + i;
        [button addTarget:self action:@selector(saveSelectedTeam:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        
        [self.teamSelectionButtonList addObject:button];
    }
}

- (void)loadSelectedTeam
{
    RSDSettingsManager *manager = [RSDSettingsManager sharedManager];
    
    NSInteger currentTeam = manager.currentTeamNumber;
    if (currentTeam != 0) {
        UIButton *button = (UIButton *) [self.view viewWithTag:currentTeam + VIEW_TAG_OFFSET - 1];
        button.backgroundColor = self.activeButtonColor;
    }
}

- (void)saveSelectedTeam:(UIButton *)button{
    RSDSettingsManager *manager = [RSDSettingsManager sharedManager];
    
    NSInteger currentTeam = manager.currentTeamNumber;
    
    // select myself to deactivate team settings
    if (currentTeam + VIEW_TAG_OFFSET - 1 == button.tag) {
        manager.currentTeamNumber = 0;
        button.backgroundColor = self.inactiveButtonColor;
        return;
    }
    
    // if team selected, then deactivate old team selection
    if (currentTeam !=0 ) {
        UIButton *oldButton = (UIButton *) [self.view viewWithTag:currentTeam];
        oldButton.backgroundColor = self.inactiveButtonColor;
    }
    
    //set new button color
    button.backgroundColor = self.activeButtonColor;
    manager.currentTeamNumber = button.tag - VIEW_TAG_OFFSET + 1;
}

#pragma mark - Color settings
- (UIColor *)activeButtonColor
{
    return [UIColor greenColor];
}

- (UIColor *)inactiveButtonColor
{
    return [UIColor lightGrayColor];
}

@end
