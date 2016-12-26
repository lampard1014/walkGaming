//
//  CHDXCityMainSenceViewController.m
//  xcity
//
//  Created by 余妙玉 on 16/11/7.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#import "CHDXCityMainSenceViewController.h"
#import "CHDXCityMapSence.h"

@interface CHDXCityMainSenceViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation CHDXCityMainSenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    return ;
    SKView * skView = (SKView *)self.view;
    skView.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.2];
    
    CHDXCityMapSence *scene = [[CHDXCityMapSence alloc]initWithSize:self.view.frame.size];
    scene.anchorPoint = CGPointMake(0, 0);
//    scene.anchorPoint = CGPointZero;
//    scene.position = CGPointMake(40, 40);
    scene.backgroundColor = [UIColor redColor];
    scene.scaleMode = SKSceneScaleModeFill;
    
    [skView presentScene:scene];
    
//    UIView *x = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 200, 200)];
//    x.backgroundColor = [UIColor blueColor];
//    [skView addSubview:x];

//    UIView *overlay = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    overlay.opaque = NO;
//    overlay.backgroundColor=[UIColor clearColor];
//    [overlay addSubview:[uip view]];
//    [skView addSubview:overlay];
    
//    SKAction *action = [SKAction rotateByAngle:M_PI duration:2];
//    [scene runAction:action];
    
}
//-(void)viewDidAppear:(BOOL)animated;
//{
//    [super viewDidAppear:animated];
//#define CAMERA_TRANSFORM  1.24299
//    //
//    
//    
//    UIImagePickerController *uip = [[UIImagePickerController alloc] init ];
//    uip.modalPresentationStyle = UIModalPresentationOverCurrentContext;
////    self.modalPresentationStyle= UIModalPresentationOverCurrentContext;
////    
//    BOOL isCameraSupport = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
//    
//    uip.sourceType = UIImagePickerControllerSourceTypeCamera;
//    uip.showsCameraControls = NO;
//    uip.toolbarHidden = YES;
//    uip.navigationBarHidden = YES;
//    uip.cameraViewTransform = CGAffineTransformScale(uip.cameraViewTransform, CAMERA_TRANSFORM,CAMERA_TRANSFORM);
//    uip.delegate = self;
//    [self presentViewController:uip animated:YES completion:^{
//        
//    }];
//}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;
{

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{

}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
