//
//  ViewController.m
//  Remind Me Why
//
//  Created by Justin Lennox on 4/5/15.
//  Copyright (c) 2015 Justin Lennox. All rights reserved.
//

#import "ViewController.h"
#import "ThisIsWhyViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.remindMeWhyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    self.remindMeWhyButton.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * (3.00f/4.00f));
    self.remindMeWhyButton.backgroundColor = [UIColor redColor];
    [self.remindMeWhyButton addTarget:self action:@selector(remindMeWhyButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.remindMeWhyButton];
    
    self.setReminderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.setReminderButton.frame = CGRectMake(0, CGRectGetMaxY(self.remindMeWhyButton.frame), self.view.frame.size.width, self.view.frame.size.height * (1.00f/4.00f));
    [self.setReminderButton setTitle:@"Set Reminder" forState:UIControlStateNormal];
    self.setReminderButton.backgroundColor = [UIColor yellowColor];
    [self.setReminderButton addTarget:self action:@selector(setReminderButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.setReminderButton];
    
    self.remindMeWhyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.remindMeWhyButton.frame.size.height / 4.00f, self.view.frame.size.width, self.remindMeWhyButton.frame.size.height/4.00f)];
    self.remindMeWhyLabel.backgroundColor = [UIColor blackColor];
    self.remindMeWhyLabel.text = @"REMIND ME WHY";
    self.remindMeWhyLabel.textColor = [UIColor whiteColor];
    self.remindMeWhyLabel.textAlignment = NSTextAlignmentCenter;
    [self.remindMeWhyLabel setFont:[UIFont fontWithName:@"Helvetica" size:35.0f]];
    [self.view addSubview:self.remindMeWhyLabel];
    
    self.remindersPicker = [[UIPickerView alloc] initWithFrame: CGRectMake(CGRectGetMidX(self.view.frame)-self.remindersPicker.frame.size.width/2, CGRectGetMaxY(self.remindMeWhyLabel.frame) + 10, self.view.frame.size.width/1.100f, 25)];
    self.remindersPicker.frame = CGRectMake(CGRectGetMidX(self.view.frame)-self.remindersPicker.frame.size.width/2, CGRectGetMaxY(self.remindMeWhyLabel.frame) + 10, self.view.frame.size.width/1.100f, 25);
    self.remindersPicker.delegate = self;
    self.remindersPicker.userInteractionEnabled=YES;
    self.remindersPicker.showsSelectionIndicator = YES;
    
    self.customSelector = [[UIImageView alloc] initWithFrame:CGRectMake(self.remindersPicker.frame.origin.x, CGRectGetMidY(self.remindersPicker.frame) - 12, self.remindersPicker.frame.size.width, 25)];
    self.customSelector.backgroundColor = [UIColor whiteColor];
    self.customSelector.userInteractionEnabled = YES;
    
    [self.view addSubview:self.customSelector];
    [self.view addSubview:self.remindersPicker];
    
    self.settingsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.settingsButton.frame = CGRectMake(10, 25, 30, 30);
    self.settingsButton.tintColor = [UIColor whiteColor];
    [self.settingsButton setImage:[UIImage imageNamed:@"Settings-50.png"] forState:UIControlStateNormal];
    [self.settingsButton addTarget:self action:@selector(settingsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.settingsButton];
    
    self.reminderListDictionary = [[NSDictionary alloc] init];
    
    UILongPressGestureRecognizer *tapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapRecognizer.minimumPressDuration = 0.001f;
    [self.remindersPicker addGestureRecognizer:tapRecognizer];
    tapRecognizer.delegate = self;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    PFUser *currentUser = [PFUser currentUser];
    if(!currentUser){
        NSLog(@"No user!");
        //ViewController *controller = [[ViewController alloc] init];
        //[self.view.window.rootViewController presentViewController:controller animated:YES completion:nil];
        [self performSegueWithIdentifier:@"showLoginSegue" sender:self];
        
    }else{
        NSLog(@"View did appear");
        PFQuery *reminderListQuery = [PFQuery queryWithClassName:@"ReminderLists"];
        [reminderListQuery whereKey:@"username" equalTo:[PFUser currentUser].username];
        [reminderListQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            self.reminderListDictionary = [object objectForKey:@"reminderList"];
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for(id key in self.reminderListDictionary){
                NSString *string = [NSString stringWithFormat:@"%@",key];
                [tempArray addObject:string];
            }
            self.reminderListArray = [NSArray arrayWithArray:tempArray];
            [self.remindersPicker reloadAllComponents];
        }];
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"remindMeWhySegue"]){
        ThisIsWhyViewController *vc = segue.destinationViewController;
        NSString *reminderString = [self.reminderListArray objectAtIndex:[self.remindersPicker selectedRowInComponent:0]];
        vc.reminderString = reminderString;
        NSLog(@"Reminder string:%@", reminderString);
    }
}

-(void)remindMeWhyButtonPressed{
    
    [self performSegueWithIdentifier:@"remindMeWhySegue" sender:self];
    
}

-(void)setReminderButtonPressed{
    
    [self performSegueWithIdentifier:@"setReminderSegue" sender:self];

}

-(void)settingsButtonPressed{
    [self performSegueWithIdentifier:@"showSettingsSegue" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleTap : (UITapGestureRecognizer *) recognizer{
    if(recognizer.state ==UIGestureRecognizerStateBegan){
        self.tapStartLocation = [recognizer locationInView:self.view].y;
        NSLog(@"Tap Begun");

    }
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        self.tapEndLocation = [recognizer locationInView:self.view].y;
        NSLog(@"Start %f, Finish %f", self.tapStartLocation, self.tapEndLocation);
        if(!(self.tapStartLocation - self.tapEndLocation > 15.0f || self.tapStartLocation - self.tapEndLocation < -15.0f)){
            [self performSegueWithIdentifier:@"remindMeWhySegue" sender:self];

        }
    }
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Touches began");
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    self.tapStartLocation = touchLocation.y;

}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    // return
    return true;
}

#pragma mark- Picker View Methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    NSLog(@"Selected");
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    NSLog(@"View for row");
    if(self.reminderListDictionary.count > 0){
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        lbl.text = [self.reminderListArray objectAtIndex:row];
        lbl.adjustsFontSizeToFitWidth = YES;
        lbl.textAlignment= NSTextAlignmentCenter;
        lbl.font=[UIFont systemFontOfSize:20];

        return lbl;
    }else{
        return nil;
    }
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = self.reminderListDictionary.count;
    
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


@end
