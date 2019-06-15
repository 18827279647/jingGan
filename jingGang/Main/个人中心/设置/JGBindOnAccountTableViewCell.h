//
//  JGBindOnAccountTableViewCell.h
//  jingGang
//
//  Created by Ai song on 16/2/25.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGBindOnAccountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLeftArr;
@property (weak, nonatomic) IBOutlet UIButton *bindButton;

/**
 *  第三方账号名称
 */
@property (nonatomic,copy) NSString *strThirdNickName;


- (void)setBindStatuWithArray:(NSArray *)array indexPath:(NSIndexPath *)indexPath;

@end
