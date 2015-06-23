//
//  SetReminderViewController.m
//  Remind Me Why
//
//  Created by Justin Lennox on 4/6/15.
//  Copyright (c) 2015 Justin Lennox. All rights reserved.
//

#import "SetReminderViewController.h"
#import <Parse/Parse.h>

@interface SetReminderViewController ()

@end

@implementation SetReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor magentaColor];
    
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightRecognizer];
    
    self.thisIsWhyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 5.00f, self.view.frame.size.width, self.view.frame.size.height/4.00f)];
    self.thisIsWhyLabel.backgroundColor = [UIColor blackColor];
    self.thisIsWhyLabel.text = @"THIS IS WHY...";
    self.thisIsWhyLabel.textColor = [UIColor whiteColor];
    self.thisIsWhyLabel.textAlignment = NSTextAlignmentCenter;
    [self.thisIsWhyLabel setFont:[UIFont fontWithName:@"Helvetica" size:35.0f]];
    [self.view addSubview:self.thisIsWhyLabel];
    
    self.reminderNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.thisIsWhyLabel.frame) + 10, self.view.frame.size.width, 50)];
    self.reminderNameField.textAlignment = NSTextAlignmentCenter;
    self.reminderNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.reminderNameField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.reminderNameField.returnKeyType = UIReturnKeyDone;
    self.reminderNameField.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.reminderNameField];
    self.reminderNameField.delegate = self;
 
    self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cameraButton setFrame:CGRectMake(10, CGRectGetMaxY(self.reminderNameField.frame) + 10, 50, 50)];
    [self.cameraButton addTarget:self action:@selector(recordVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"camera-96.png"] forState:UIControlStateNormal];
    [self.view addSubview:self.cameraButton];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
      //  [self.remindersPicker reloadAllComponents];
    }];

    
    
    
}

-(void)recordVideo{
    
    [self startCameraControllerFromViewController:self usingDelegate:self];

}

-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller
                                 usingDelegate:(id )delegate {
    // 1 - Validattions
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        return NO;
    }
    // 2 - Get image picker
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    // Displays a control that allows the user to choose movie capture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie, nil];
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    cameraUI.videoMaximumDuration = 30.0f;
    cameraUI.delegate = delegate;
    // 3 - Display image picker
    [controller presentViewController:cameraUI animated:NO completion:nil];
    return YES;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    // Handle a movie capture
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSData *fileData;
        NSString *fileName;
        NSString *videoFilePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        fileData = [NSData dataWithContentsOfFile:videoFilePath];
        fileName = @"movie.mov";
        PFFile *file = [PFFile fileWithName:fileName data:fileData];
        PFObject *movie = [PFObject objectWithClassName:@"Reminders"];
        [movie setObject:file forKey:@"file"];
        [movie setObject:self.reminderNameField.text forKey:@"reminderName"];
        [movie setObject:@"movie" forKey:@"type"];
        [movie setObject:[PFUser currentUser].username forKey:@"username"];
        [movie saveInBackground];
    }
    
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        NSData *fileData;
        NSString *fileName;
        UIImage *image= [info objectForKey:UIImagePickerControllerOriginalImage];
        fileData = UIImageJPEGRepresentation(image, 0.5f);
        fileName = @"picture.jpeg";
        PFFile *file = [PFFile fileWithName:fileName data:fileData];
        PFObject *picture = [PFObject objectWithClassName:@"Reminders"];
        [picture setObject:file forKey:@"file"];
        [picture setObject:self.reminderNameField.text forKey:@"reminderName"];
        [picture setObject:@"picture" forKey:@"type"];
        [picture setObject:[PFUser currentUser].username forKey:@"username"];
        [picture saveInBackground];
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
    

}

-(void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)handleSwipe : (UISwipeGestureRecognizer *)recognizer{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.reminderNameField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];

    return NO;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
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
