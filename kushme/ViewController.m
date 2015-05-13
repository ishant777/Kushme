//
//  ViewController.m
//  Kushme
//
//  Created by Test on 12/05/15.
//  Copyright (c) 2015 Ishant Tiwari. All rights reserved.
//

#import "ViewController.h"
#import "SignUpViewController.h"
#import "NSConnection.h"
#import "MBProgressHUD.h"
#import "JSON.h"
#import "Api.h"


@interface ViewController ()<CLLocationManagerDelegate>

@end

@implementation ViewController
@synthesize fldPassword,fldUsername;

- (void)viewDidLoad {
    [super viewDidLoad];
    nsUrlResponseData =[[NSMutableData alloc]init];
    self.locationManager = [[CLLocationManager alloc] init];
    
    [[self locationManager] setDelegate:self];
    
    if ([[self locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [[self locationManager] requestWhenInUseAuthorization];
    }
    
    [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
    [[self locationManager] startUpdatingLocation];
    
    UITapGestureRecognizer *oneTapGesture = [[UITapGestureRecognizer alloc]
                                             
                                             
                                             
                                             initWithTarget: self
                                             
                                             
                                             
                                             action: @selector(hideKeyboard:)];
    
    [oneTapGesture setNumberOfTouchesRequired:1];
    [[self view] addGestureRecognizer:oneTapGesture];
   
}
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = locations.lastObject;
    latitudeValue =[NSString stringWithFormat:@"%.6f", location.coordinate.latitude];
    longitudeValue =[NSString stringWithFormat:@"%.6f", location.coordinate.longitude];
    
    NSLog(@"%@",latitudeValue);
    NSLog(@"%@",longitudeValue);
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
     
}
- (void) keyboardWillShow {
    
    
    
    
    
    CGRect frame = self.view.frame;
    
    frame.origin.y = -100;
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.frame = frame;
        
    }];
    
}
- (void) keyboardDidHide {
    
    
    
    // move the view back to the origin
    
    CGRect frame = self.view.frame;
    
    frame.origin.y = 0;
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.frame = frame;
        
    }];
    
}
- (void)hideKeyboard:(UITapGestureRecognizer *)sender {
    [self keyboardDidHide];
    [fldPassword resignFirstResponder];
    [fldUsername resignFirstResponder];
   
    
    //  return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [fldPassword resignFirstResponder];
    [fldUsername resignFirstResponder];
    [self keyboardDidHide];
    return YES;
}

-(IBAction)clickForget:(id)sender{
    
}
-(IBAction)clickSignUp:(id)sender{
    SignUpViewController *signUp = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
        [self.navigationController pushViewController:signUp animated:YES];
}
-(IBAction)clickLogin:(id)sender{
    [self Login];
}
-(void)Login{
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"Kushme";
    HUD.detailsLabelText = @"Loading...";
    HUD.mode = MBProgressHUDModeIndeterminate;
    [HUD show:YES];
    [self.view addSubview:HUD];
    
    /**** THIS IS THE WAY YOU SHOULD BE CODING ****/
    
    NSString *urlString = [NSString stringWithFormat:kLoginurl];
    NSString *parameter = [NSString stringWithFormat:@"uname=%@&password=%@",fldUsername.text,fldPassword.text];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"%@",parameter] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSURLConnection *connnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connnection start];
    
    
    
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    [HUD hide:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Kushme" message:@"Check your Internet Connection" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil,nil];
    
    [alert show];
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [nsUrlResponseData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [nsUrlResponseData appendData:data];
}

NSString *user_id;
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [HUD hide:YES];
    
    if ([nsUrlResponseData length]==0)
    {
        
    }
    
    else
    {
        
        NSString* newStr = [[NSString alloc] initWithData:nsUrlResponseData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", newStr);
        allData = [newStr JSONValue];
        NSLog(@"allData==%@",allData);
        NSString *getMessage = [allData valueForKey:@"Success"];
        NSLog(@"%@",getMessage);
        if([getMessage isEqualToString:@"Done"]){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Kushme" message:@"You have Sucessfully Login" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil,nil];
            [alert show];
            }
        else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Kushme" message:getMessage delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil,nil];
            [alert show];
        }
    }
}




@end
