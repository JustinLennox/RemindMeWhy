//
//  SetReminderViewController.h
//  Remind Me Why
//
//  Created by Justin Lennox on 4/6/15.
//  Copyright (c) 2015 Justin Lennox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>

@interface SetReminderViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UILabel *thisIsWhyLabel;
@property (strong, nonatomic) UIButton *photoButton;
@property (strong, nonatomic) UIButton *cameraButton;
@property (strong, nonatomic) UIButton *textButton;

@property (strong, nonatomic) IBOutlet UITextField *reminderNameField;
@property (strong, nonatomic) NSDictionary *reminderListDictionary;
@property (strong, nonatomic) NSArray *reminderListArray;

@end
