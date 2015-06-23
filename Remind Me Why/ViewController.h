//
//  ViewController.h
//  Remind Me Why
//
//  Created by Justin Lennox on 4/5/15.
//  Copyright (c) 2015 Justin Lennox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIButton *remindMeWhyButton;
@property (strong, nonatomic) UIButton *setReminderButton;
@property (strong, nonatomic) UILabel *remindMeWhyLabel;
@property (strong, nonatomic) UIButton *settingsButton;

@property (strong, nonatomic) UIPickerView *remindersPicker;
@property (strong, nonatomic) UIImageView *customSelector;
@property (strong, nonatomic) NSDictionary *reminderListDictionary;
@property (strong, nonatomic) NSArray *reminderListArray;
@property (nonatomic) float tapStartLocation;
@property (nonatomic) float tapEndLocation;
-(void)remindMeWhyButtonPressed;


@end

