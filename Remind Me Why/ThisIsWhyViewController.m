//
//  ThisIsWhyViewController.m
//  Remind Me Why
//
//  Created by Justin Lennox on 4/5/15.
//  Copyright (c) 2015 Justin Lennox. All rights reserved.
//

#import "ThisIsWhyViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@interface ThisIsWhyViewController ()

@end

@implementation ThisIsWhyViewController

- (void)viewDidLoad {
    NSLog(@"This is why view did load");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    self.thisIsWhyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.thisIsWhyLabel.text = @"THIS IS WHY";
    self.thisIsWhyLabel.textAlignment = NSTextAlignmentCenter;
    self.thisIsWhyLabel.font = [UIFont fontWithName:@"Helvetica" size:35.00f];
    [[self.thisIsWhyLabel layer] setAnchorPoint:CGPointMake(0.0f, 0.0f)];
    [self.thisIsWhyLabel layer].position = CGPointMake(0, 0);
    self.thisIsWhyLabel.textColor = [UIColor redColor];
    
    self.thisIsWhyLabelBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.thisIsWhyLabelBackground.backgroundColor = [UIColor whiteColor];
    
    self.bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 75, self.view.frame.size.width, 75)];
    self.bottomBar.backgroundColor = [UIColor redColor];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setFrame:CGRectMake(10, self.view.frame.size.height - 50, 50, 50)];
    [self.backButton setTitle:@"Done" forState:UIControlStateNormal];
    self.backButton.titleLabel.textColor = [UIColor whiteColor];
    [self.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextButton setFrame:CGRectMake(self.view.frame.size.width - 75, self.view.frame.size.height - 50, 50, 50)];
    [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    self.nextButton.titleLabel.textColor = [UIColor whiteColor];
    [self.nextButton addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 25, self.view.frame.size.height - 50, 50, 50)];
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    self.playButton.titleLabel.textColor = [UIColor whiteColor];
    [self.playButton addTarget:self action:@selector(playButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.moviePlayer = [[MPMoviePlayerController alloc] init];
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerPlaybackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
    
    self.reminderImageView = [[UIImageView alloc] init];
    
    self.moviePlayer.view.alpha = 0.0f;
    self.reminderImageView.alpha = 0.0f;
    
    [self.view addSubview:self.moviePlayer.view];
    [self.view addSubview:self.reminderImageView];
    [self.view addSubview:self.bottomBar];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.thisIsWhyLabelBackground];
    [self.view addSubview:self.thisIsWhyLabel];

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.currentReminderType = @"nil";
    NSLog(@"PFQuery this is why view will appear");
    PFQuery *query = [PFQuery queryWithClassName:@"Reminders"];
    [query whereKey:@"username" equalTo:[PFUser currentUser].username];
    [query whereKey:@"reminderName" equalTo:self.reminderString];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        NSLog(@"QUERRRY");
        if(!error){
            self.currentReminderType = [object objectForKey:@"type"];
            NSLog(@"queryed");
            if([self.currentReminderType isEqualToString:@"movie"]){
                PFFile *file = [object objectForKey:@"file"];
                NSURL *fileUrl = [NSURL URLWithString:file.url];
                self.moviePlayer.contentURL = fileUrl;
                NSLog(@"movie");
                [self.moviePlayer prepareToPlay];
            }else if([self.currentReminderType isEqualToString:@"picture"]){
                NSLog(@"It's a picture");
                [self.reminderImageView setFrame:CGRectMake(0, CGRectGetMaxY(self.thisIsWhyLabelBackground.frame), (self.view.frame.size.width), CGRectGetMinY(self.bottomBar.frame) - CGRectGetMaxY(self.thisIsWhyLabelBackground.frame))];
                self.reminderImageView.alpha = 1.0f;
                PFFile *imageFile = [object objectForKey:@"file"];
                NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
                NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
                //FIX THIS, change to sd_setimage cause this is slow as sh**
                self.reminderImageView.image = [UIImage imageWithData:imageData];
                NSLog(@"picture");
                [self.view bringSubviewToFront:self.reminderImageView];
            }
        }
    }];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
   
    [UIView animateWithDuration:0.5f delay:0.5f options:
     UIViewAnimationOptionCurveEaseIn animations:^{
         self.thisIsWhyLabelBackground.frame = CGRectMake(0, 0, self.view.frame.size.width, 75);
         self.thisIsWhyLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 75);
         
     } completion:^ (BOOL completed) {
         
     }];
    [UIView commitAnimations];

    

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if([self.currentReminderType isEqualToString:@"movie"]){
        [self.moviePlayer stop];
     }
     [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
}

-(void)loadNextReminder{
    
    
    
    if([self.currentReminderType isEqualToString:@"movie"]){
        [self.moviePlayer.view setFrame:CGRectMake(0, CGRectGetMaxY(self.thisIsWhyLabelBackground.frame), (self.view.frame.size.width), CGRectGetMinY(self.bottomBar.frame) - CGRectGetMaxY(self.thisIsWhyLabelBackground.frame))];
        self.moviePlayer.view.alpha = 1.0f;
        [self.view bringSubviewToFront:self.moviePlayer.view];
        [self.moviePlayer play];
        NSLog(@"movie");
        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
    }else if([self.currentReminderType isEqualToString:@"picture"]){
        NSLog(@"picture");
        [self.reminderImageView setFrame:CGRectMake(0, CGRectGetMaxY(self.thisIsWhyLabelBackground.frame), (self.view.frame.size.width), CGRectGetMinY(self.bottomBar.frame) - CGRectGetMaxY(self.thisIsWhyLabelBackground.frame))];
        self.reminderImageView.alpha = 1.0f;
        [self.view bringSubviewToFront:self.reminderImageView];
    }
    
}

-(void)playButtonPressed{
    if([self.currentReminderType isEqualToString:@"movie"]){
        if(self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying){
            [self.moviePlayer pause];
        }else if(self.moviePlayer.playbackState == MPMoviePlaybackStatePaused){
            [self.moviePlayer play];

        }
    }
    
}

- (void)MPMoviePlayerPlaybackStateDidChange:(NSNotification *)notification
{
    if([self.currentReminderType isEqualToString:@"movie"]){
        if(self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying){
            [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
        }else if(self.moviePlayer.playbackState == MPMoviePlaybackStatePaused){
            [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
            
        }
    }
    
}

-(void)backButtonPressed{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)nextButtonPressed{
    
    if([self.currentReminderType isEqualToString:@"movie"]){
        if(self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying){
            [self.moviePlayer pause];
        }
    }
    
    [self.view bringSubviewToFront:self.thisIsWhyLabelBackground];
    [self.view bringSubviewToFront:self.thisIsWhyLabel];
    
    [UIView animateWithDuration:0.5f delay:0.0f options:
     UIViewAnimationOptionCurveEaseIn animations:^{
         self.thisIsWhyLabelBackground.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
         self.thisIsWhyLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
         
     } completion:^ (BOOL completed) {
         [UIView animateWithDuration:0.5f delay:0.5f options:
          UIViewAnimationOptionCurveEaseIn animations:^{
              self.thisIsWhyLabelBackground.frame = CGRectMake(0, 0, self.view.frame.size.width, 75);
              self.thisIsWhyLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 75);
          } completion:nil];
     }];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
