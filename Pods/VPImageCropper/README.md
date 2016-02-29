VPImageCropper
==============

##Installation

###Copy Source Files

You can simply copy VPImageCropperViewController.* files into you project.

###Using CocoaPods

[CocoaPods](http://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. See the [Get Started](http://cocoapods.org/#get_started) section for more details.

#### Podfile
```
platform :ios, '6.0'
pod 'VPImageCropper', '~>0.0.3'
```

##Usage
It's incredibly easy to use this kit. Before present the cropper view controller, you should implement the protocol ``VPImageCropperDelegate``:

```ObjectiveC
// callback when cropping finished
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage;

// callback when cropping cancelled
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController;
```

Now it's time to present the image cropper view controller and do some cropping.
```ObjectiveC
// present the cropper view controller
VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
imgCropperVC.delegate = self;
//you can change the button title and background color
//imgCropperVC.confirmTitle = @"确定";
//imgCropperVC.cancelTitle = @"取消";
//imgCropperVC.btnBgColor = [UIColor clearColor];
[self presentViewController:imgCropperVC animated:YES completion:^{
        // TO DO
}];
```

##Summary
As negligible as it is, I am glad this work could be used in some of the products in our company which is the best part. Anyway, if you are interested enough to have a test. Please refer to the VPImageCropperDemo Project and enjoy the beauty of coding.
