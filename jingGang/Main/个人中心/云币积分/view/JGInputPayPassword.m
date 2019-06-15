//
//  JGInputPayPassword.m
//  jingGang
//
//  Created by dengxf on 16/1/11.
//  Copyright © 2016年 yi jiehuang. All rights reserved.
//

#import "JGInputPayPassword.h"
#import "CorePasswordView.h"
#import "YSLoginManager.h"
#import "UIAlertView+Extension.h"
typedef void(^InputPasswordCompleted)(NSString *passwordKey);

typedef void(^CancelInputBlock)(void);

@interface JGInputPayPassword ()

@property (weak, nonatomic) IBOutlet CorePasswordView *passwordView;

@property (copy , nonatomic) InputPasswordCompleted passwordBlock;

@property (copy , nonatomic) CancelInputBlock cancelBlock;
//CN账号密码输入框
@property (weak, nonatomic) IBOutlet UITextField *textFieldCNAccountPasswordInputView;
//CN账号确定按钮
@property (weak, nonatomic) IBOutlet UIButton *buttonCNAccountConfirm;

@end

@implementation JGInputPayPassword

- (instancetype)initWithInputPasswordCompleted:(void (^)(NSString *))complete cancel:(void (^)())cancel{
    if (self = [super init]) {
        self.passwordBlock = complete;
        self.cancelBlock = cancel;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([YSLoginManager isCNAccount]) {
        //CN账号
        self.textFieldCNAccountPasswordInputView.hidden = NO;
        self.passwordView.hidden = YES;
        self.buttonCNAccountConfirm.hidden = NO;
        [self.textFieldCNAccountPasswordInputView becomeFirstResponder];
    }else{
        
        self.textFieldCNAccountPasswordInputView.hidden = YES;
        self.passwordView.hidden = NO;
        self.buttonCNAccountConfirm.hidden = YES;
        [self.passwordView beginInput];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WeakSelf;
    self.passwordView.PasswordCompeleteBlock = ^(NSString *password){
        StrongSelf;
        BLOCK_EXEC(strongSelf.passwordBlock,password);
        [strongSelf.view endEditing:YES];
    };
}
//cn账号确定密码按钮
- (IBAction)CNAccountConfirmButtonClick:(id)sender {
    
    if (self.textFieldCNAccountPasswordInputView.text.length == 0) {
        [UIAlertView xf_showWithTitle:@"请输入密码" message:nil delay:1.2 onDismiss:NULL];
        return;
    }
    BLOCK_EXEC(self.passwordBlock,self.textFieldCNAccountPasswordInputView.text);
    [self.view endEditing:YES];

}


- (IBAction)cancelInputPasswordAction:(id)sender {
    [self.passwordView endInput];
    BLOCK_EXEC(self.cancelBlock);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
