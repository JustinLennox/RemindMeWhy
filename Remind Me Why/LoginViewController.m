//
//  LoginViewController.m
//  Remind Me Why
//
//  Created by Justin Lennox on 4/6/15.
//  Copyright (c) 2015 Justin Lennox. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    self.emailField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"3DBlueButton.png"] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"3DBlueButtonPressed.png"] forState:UIControlStateHighlighted];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"3DBlueButtonPressed.png"] forState:UIControlStateSelected];
    
    [self.signUpButton setBackgroundImage:[UIImage imageNamed:@"3DYellowButton.png"] forState:UIControlStateNormal];
    [self.signUpButton setBackgroundImage:[UIImage imageNamed:@"3DYellowButtonPressed.png"] forState:UIControlStateHighlighted];
    [self.signUpButton setBackgroundImage:[UIImage imageNamed:@"3DYellowButtonPressed.png"] forState:UIControlStateSelected];
    
    [self.usernameField setLeftViewMode:UITextFieldViewModeAlways];
    UIImageView *userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 15, 15)];
    userIcon.image = [UIImage imageNamed:@"user-50.png"];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 15)];
    [paddingView addSubview:userIcon];
    self.usernameField.leftView = paddingView;
    self.usernameField.borderStyle = UITextBorderStyleRoundedRect;
    
    [self.passwordField setLeftViewMode:UITextFieldViewModeAlways];
    UIImageView *userIcon2 = [[UIImageView alloc] initWithFrame:CGRectMake(3, 0, 15, 15)];
    userIcon2.image = [UIImage imageNamed:@"lock-50.png"];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 15)];
    [paddingView2 addSubview:userIcon2];
    self.passwordField.leftView = paddingView2;
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    
    [self.emailField setLeftViewMode:UITextFieldViewModeAlways];
    UIImageView *userIcon3 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 15, 15)];
    userIcon3.image = [UIImage imageNamed:@"email-50.png"];
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 15)];
    [paddingView3 addSubview:userIcon3];
    self.emailField.leftView = paddingView3;
    self.emailField.borderStyle = UITextBorderStyleRoundedRect;
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

- (IBAction)signUpButtonPressed:(id)sender {
    
    
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0 || [email length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter a username, password, email address, and choose your gender!" delegate:nil cancelButtonTitle:@"Ok :D" otherButtonTitles: nil];
        [alertView show];
    }
    
    else{
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.password = password;
        newUser.email = email;
        
        NSDictionary *emptyDictionary = [[NSDictionary alloc] init];
        
        PFObject *reminderList = [PFObject objectWithClassName:@"ReminderLists"];
        [reminderList setObject:newUser.username forKey:@"username"];
        [reminderList setObject:emptyDictionary forKey:@"reminderList"];
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
            }else{
                [reminderList saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(error){
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                        [alertView show];
                        
                        
                    }else{
                        
                    }
                    
                }];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        
        
    }
}

- (IBAction)loginButtonPressed:(id)sender {
    
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter a username and password!" delegate:nil cancelButtonTitle:@"Ok :D" otherButtonTitles: nil];
        [alertView show];
    }else{
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if (error){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            
        }];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.passwordField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.usernameField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameField) {
        //[textField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        //[textField resignFirstResponder];
        [self.emailField becomeFirstResponder];
        // here you can define what happens
        // when user presses return on the email field
    }else if (textField == self.emailField) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}


@end
