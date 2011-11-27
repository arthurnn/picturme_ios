//
//  SecondViewController.h
//  picturme
//
//  Created by Arthur Neves on 11-11-22.
//  Copyright (c) 2011 Isobar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController
<UIImagePickerControllerDelegate>
{
    UIImagePickerController* imagePickerController;
    IBOutlet UIImageView* imageView;
    
    IBOutlet UIProgressView *uploadProgress;
    
    IBOutlet UIView *indicatorView;
}

-(IBAction)upload:(id)sender;

-(IBAction)showCamera:(id)sender;

@end
