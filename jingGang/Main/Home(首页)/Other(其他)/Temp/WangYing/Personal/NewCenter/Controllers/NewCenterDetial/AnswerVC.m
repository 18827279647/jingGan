//
//  AnswerVC.m
//  jingGang
//
//  Created by wangying on 15/6/1.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "AnswerVC.h"
#import "VApiManager.h"
#import "userDefaultManager.h"
#import "NSObject+ApiResponseErrFliter.h"

@interface AnswerVC ()<UITextViewDelegate>
{
    NSMutableArray *arr_data ;
    VApiManager * _VApManager;
    UITextField *text;
}
@end

@implementation AnswerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor  =  [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];
    
    arr_data = [[NSMutableArray alloc]init];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
    [YSThemeManager setNavigationTitle:@"回复问题" andViewController:self];

    

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];


    UIBarButtonItem *right_ans = [[UIBarButtonItem alloc]initWithTitle:@"回复" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    [right_ans setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = right_ans;

    
    UIView *view_bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height- 64 - 5)];
    view_bg.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:view_bg];
    
    UILabel *l_ans =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 250, 50)];
    l_ans.text = [NSString stringWithFormat:@"回复帖子:%@",self.quest_ans];
    l_ans.textColor = [UIColor grayColor];
    l_ans.font = [UIFont systemFontOfSize:16];
    [view_bg addSubview:l_ans];

    
    UILabel *line_ans =[[UILabel alloc]initWithFrame:CGRectMake(10, 51, self.view.frame.size.width - 20, 1)];
    line_ans.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2];
    [view_bg addSubview:line_ans];

   
    UITextView *text_ans = [[UITextView alloc]initWithFrame:CGRectMake(10, 52, CGRectGetWidth(line_ans.frame), 800)];
    text_ans.delegate = self;
    text_ans.font = [UIFont systemFontOfSize:16];
    text = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, 150, 60)];
    text.placeholder = @"请输入回复内容";
    text.userInteractionEnabled = NO;
    [text_ans addSubview:text];
    [view_bg addSubview:text_ans];

    
   
}
-(void)textViewDidChange:(UITextView *)textView
{
    
    [[NSUserDefaults standardUserDefaults]setObject:textView.text forKey:@"text_text"];
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    text.hidden = YES;   
}

-(void)tapClick
{
    [self.view endEditing:YES];
}


-(void)rightClick
{
    [self.view endEditing:YES];
    
    _VApManager = [[VApiManager alloc]init];
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    
     SnsConsultingRepayAddRequest *snsConsultingRepayAddRequest = [[SnsConsultingRepayAddRequest alloc] init:accessToken];

    snsConsultingRepayAddRequest.api_consultingId = [[NSUserDefaults standardUserDefaults]objectForKey:@"zixunid"];
    snsConsultingRepayAddRequest.api_content = [[NSUserDefaults standardUserDefaults]objectForKey:@"text_text"];
    
    JGLog(@"++++zixunid+++++%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"zixunid"]);
    
    WEAK_SELF;
  [_VApManager snsConsultingRepayAdd:snsConsultingRepayAddRequest success:^(AFHTTPRequestOperation *operation, SnsConsultingRepayAddResponse *response) {
      [NSObject fliterResponse:response withBlock:^(int event, id responseObject) {
          NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
          NSString * jsonStr = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];

          [weak_self dismissViewControllerAnimated:YES completion:nil];
      }];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
      JGLog(@"咨询提问保存失败%@",error);
  }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
