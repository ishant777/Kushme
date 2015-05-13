//
//  SignUpViewController.h
//  Kushme
//
//  Created by Test on 12/05/15.
//  Copyright (c) 2015 Ishant Tiwari. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;


@interface SignUpViewController : UIViewController<UITextFieldDelegate>{
    NSMutableData *
    nsUrlResponseData;
    NSMutableArray * allData;
    MBProgressHUD *HUD;
}

@property(nonatomic,retain)IBOutlet UITextField *fldUserame;
@property(nonatomic,retain)IBOutlet UITextField *fldPassword;
@property(nonatomic,retain)IBOutlet UITextField *fldEmail;

@end
