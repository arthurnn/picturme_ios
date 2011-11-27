//
//  SecondViewController.m
//  picturme
//
//  Created by Arthur Neves on 11-11-22.
//  Copyright (c) 2011 Isobar. All rights reserved.
//

#import "PhotoViewController.h"
#import "ASIFormDataRequest.h"


@implementation PhotoViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Set up the image view and add it to the view but make it hidden
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(IBAction)showCamera:(id)sender{
    
    // Set up the image picker controller and add it to the view
	imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
	//imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentModalViewController:imagePickerController animated:YES];
    
}

-(IBAction)upload:(id)sender{
    
    uploadProgress.hidden = NO;
    
    NSData *imageData = UIImageJPEGRepresentation(imageView.image,100);
    
    //NSLog(@"imageData size = %d", [imageData length]);
    
    
    NSURL *url = [NSURL URLWithString:@"http://pictur.me/upload.ajax"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request setTimeOutSeconds:60];
    
    [request setUploadProgressDelegate:self];
    
    
    [request addData:imageData forKey:@"file"];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(uploadRequestFinished:)];
    [request setDidFailSelector:@selector(uploadRequestFailed:)];
    
    [request startAsynchronous];
    
}

- (void)setProgress:(float)newProgress {
    [uploadProgress setProgress:newProgress];
    //NSLog(@"value: %f",[uploadProgress progress]);
    
    if(newProgress==1.0f){
        indicatorView.hidden=NO;
        uploadProgress.hidden = YES;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
	// Dismiss the image selection, hide the picker and show the image view with the picked image
	[picker dismissModalViewControllerAnimated:YES];
	imagePickerController.view.hidden = YES;
	imageView.image = image;
	imageView.hidden = NO;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	// Dismiss the image selection and close the program
	[picker dismissModalViewControllerAnimated:YES];
	//exit(0);
}

#pragma mark - ASIFormDataRequest

- (void)uploadRequestFinished:(ASIHTTPRequest *)request{    
    NSString *responseString = [request responseString];
    NSLog(@"Upload response %@", responseString);
    //[responseString JSONValue];
    
    indicatorView.hidden=YES;
    
    
    [self performSegueWithIdentifier:@"ShowDetail" sender:self];
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request{
    NSLog(@" Error - Statistics file upload failed: \"%@\"",[[request error] localizedDescription]); 
}


//// This will get called too before the view appears
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"ShowDetail"]) {
//        
//        // Get destination view
//        //SecondView *vc = [segue destinationViewController];
//        
//        // Get button tag number (or do whatever you need to do here, based on your object
//        NSInteger tagIndex = [(UIButton *)sender tag];
//        
//        // Pass the information to your destination view
//        //[vc setSelectedButton:tagIndex];
//    }
//}

@end
