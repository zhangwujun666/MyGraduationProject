//
//  SYJMiaoShaTableViewCell.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/5.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJMiaoShaTableViewCell.h"

@implementation SYJMiaoShaTableViewCell{
    NSMutableArray * miaoshaGoodsArray;
}

- (void)awakeFromNib {
    // Initialization code
    
}
- (IBAction)miaoshaBuyClicked:(UIButton *)sender {
    NSDictionary *dic ;
    if (sender.tag == 755) {
        dic = [miaoshaGoodsArray objectAtIndex:0];
    }
    else{
        dic = [miaoshaGoodsArray objectAtIndex:1];
    }

    //让代理执行操作，同时传递参数
    if ([self.delegate  respondsToSelector:@selector(SYJMiaoShaTableViewCellDelegateWithGoodId:)]) {
        [self.delegate SYJMiaoShaTableViewCellDelegateWithGoodId:dic[@"goods_id"]];
    }
}

#pragma mark - 获取collection数据资源和配置
- (void)getDataSourceWithNum:(int)Num{
    
    NSString *urlPath = [NSString stringWithFormat:@"%@Index/getmiaosha",SYJHTTP];
    NSDictionary *info=@{@"goods_miaosha":self.type
                         };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:urlPath parameters:info success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success!");
        //接收响应数据responseObject，已经经过JSon解析-》id对象
        NSDictionary * dicdescription = (NSDictionary *)responseObject;
        miaoshaGoodsArray = dicdescription[@"data"];
        NSLog(@"dic=%@",miaoshaGoodsArray);
        [self setCellWithNum:Num];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail!");
    }];
}
- (void)setCellWithNum:(int)Num{
    NSDictionary *dic = [miaoshaGoodsArray objectAtIndex:Num];
    //获取图片路径
    NSURL *urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@goodimg/%@",korderimage,dic[@"goods_image"]]];
    [self.goodsImageView sd_setImageWithURL:urlPath placeholderImage:nil] ;
    [self.goodsTitleLable setText:dic[@"goods_name"]];
    [self.priceLable setText:[NSString stringWithFormat:@"￥%@",dic[@"goods_price"]]];
    self.buyButton.layer.cornerRadius = 5.0f;
    self.buyButton.tag = 755+Num;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
