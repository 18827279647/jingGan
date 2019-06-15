//
//  guizeViewController.m
//  jingGang
//
//  Created by whlx on 2019/3/24.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "guizeViewController.h"
#import "GlobeObject.h"
@interface guizeViewController ()


@property (weak, nonatomic) IBOutlet UITextView *guizeTextView;
@property (weak, nonatomic) IBOutlet UIButton *xuanzeButton;
@property (weak, nonatomic) IBOutlet UIButton *tijiaoButton;
@property (nonatomic,assign) int isButton;
@end

@implementation guizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  //  self.view .frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
      self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _guizeTextView.editable = NO;
    
  
     _isButton=2;
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (IBAction)fanhui:(id)sender {
    
//    if(_isButton == 1){
//        [_tijiaoButton setBackgroundImage:[UIImage imageNamed:@"button111.png"] forState:UIControlStateNormal];
//    }else{
//        [_tijiaoButton setBackgroundImage:[UIImage imageNamed:@"jrrw_jb_bg.png"] forState:UIControlStateNormal];
//        [self dismissModalViewControllerAnimated:YES];
//    }
    
    if (_isButton == 2) {
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *name = @"yitijiao";
        [defaults setObject:name forKey:@"guize"];
        [defaults synchronize];
        [self dismissModalViewControllerAnimated:YES];
    }
    
    
}

- (IBAction)gaibian:(id)sender {
//    if (_isButton == 1) {
//    [_xuanzeButton setBackgroundImage:[UIImage imageNamed:@"weixuanzhong.png"] forState:UIControlStateNormal];
//    _isButton = 2;
    
//    }else{
//    [_xuanzeButton setBackgroundImage:[UIImage imageNamed:@"xuanzhong.png"] forState:UIControlStateNormal];
//    _isButton == 1;
//    }
    
   
    
    [self gaibianzhuangtai];
    
}

-(void)gaibianzhuangtai{
    
        if (_isButton == 1) {
     
            
            [_xuanzeButton setBackgroundImage:[UIImage imageNamed:@"xuanzhong.png"] forState:UIControlStateNormal];
            [_tijiaoButton setBackgroundImage:[UIImage imageNamed:@"jrrw_jb_bg.png"] forState:UIControlStateNormal];
        _isButton = 2;
            
        }else{
            
            [_xuanzeButton setBackgroundImage:[UIImage imageNamed:@"weixuanzhong.png"] forState:UIControlStateNormal];
            [_tijiaoButton setBackgroundImage:[UIImage imageNamed:@"button111.png"] forState:UIControlStateNormal];
       _isButton = 1;
        }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
