//
//  RxTwoHealthIntegrationMachineTableViewCell.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/25.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RxTwoHealthIntegrationMachineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *oneNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *oneTitlelabel;
@property (weak, nonatomic) IBOutlet UIImageView *oneImage;


@property (weak, nonatomic) IBOutlet UILabel *twoNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *twoTitlelabel;
@property (weak, nonatomic) IBOutlet UIImageView *twoImage;

@property (weak, nonatomic) IBOutlet UILabel *freeNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *freeTitlelabel;

@property (weak, nonatomic) IBOutlet UIImageView *freeImage;

@end

NS_ASSUME_NONNULL_END
