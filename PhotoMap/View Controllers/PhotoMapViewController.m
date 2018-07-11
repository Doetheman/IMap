//
//  PhotoMapViewController.m
//  PhotoMap
//
//  Created by emersonmalca on 7/8/18.
//  Copyright © 2018 Codepath. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "PhotoMapViewController.h"
#import "LocationsViewController.h"
@interface PhotoMapViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapKit;
@property UIImage *image;
@property CLLocationDegrees *coordinate;
@end

@implementation PhotoMapViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
    MKCoordinateRegion sfRegion =  MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1));
    [self.mapKit setRegion: sfRegion animated:false];
    // Do any additional setup after loading the view.
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        annotationView.canShowCallout = true;
        annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    }
    
    UIImageView *imageView = (UIImageView*)annotationView.leftCalloutAccessoryView;
    imageView.image = [UIImage imageNamed:@"camera"];
    
    return annotationView;
}
- (void)locationsViewController:(LocationsViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = coordinate;
    annotation.title = @"Picture!";
    [self.mapKit addAnnotation:annotation];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popToViewController:self animated:YES];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)camButton:(id)sender {
//instantiates image picker
UIImagePickerController *imagePickerVC = [UIImagePickerController new];
imagePickerVC.delegate = self;
imagePickerVC.allowsEditing = YES;



if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    
} else {
    NSLog(@"Camera 🚫 available so we will use photo library instead");
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}
[ self presentViewController:imagePickerVC animated:true completion:nil ];


}

//Once image is selected store image in object and perform segue
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    self.image = info[UIImagePickerControllerOriginalImage];
    //UIImage *editedImage =
    // Do something with the images (based on your use case)
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"tagSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //Call Location View Controller
    LocationsViewController *locationViewController = [segue destinationViewController];
    locationViewController.delegate = self;
    
}


@end
