//
//  ThisIsWhyViewController.h
//  Remind Me Why
//
//  Created by Justin Lennox on 4/5/15.
//  Copyright (c) 2015 Justin Lennox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ThisIsWhyViewController : UIViewController <MPMediaPickerControllerDelegate, MPMediaPlayback, MPPlayableContentDataSource, MPPlayableContentDelegate>

@property (strong, nonatomic) NSString *reminderString;
@property (strong, nonatomic) NSString *currentReminderType;
@property (strong, nonatomic) UILabel *thisIsWhyLabel;
@property (strong, nonatomic) UIImageView *thisIsWhyLabelBackground;
@property (strong, nonatomic) UIImageView *bottomBar;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) UIImageView *reminderImageView;


@end
