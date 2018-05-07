//
//  SYJMiaoshaCellTableViewCell.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/8.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJMiaoshaCellTableViewCell.h"
#import "LDProgressView.h"
@interface SYJMiaoshaCellTableViewCell ()<UIAlertViewDelegate>
@property(strong ,nonatomic) LDProgressView * progressView;
@end

@implementation SYJMiaoshaCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //设置库存数量进度条

    self.progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(220, 65, 80, 10)];
    self.progressView.color = pink;
    self.progressView.flat = @YES;
    self.progressView.progress = 0.4;
    self.progressView.animate = @YES;
    self.progressView.showStroke = @NO;
    self.progressView.progressInset = @4;
    self.progressView.showBackground = @NO;
    self.progressView.outerStrokeWidth = @3;
    self.progressView.type = LDProgressSolid;
    [self addSubview:self.progressView];
}
- (void)setUpCellWithDic:(NSDictionary *)cellDic{
    NSLog(@"%@",cellDic);
    //获取图片路径
    NSURL *urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SYJHTTPHOME,cellDic[@"miaoshaactivityimage_path"]]];
    [self.goodsImage sd_setImageWithURL:urlPath placeholderImage:nil] ;
    
    //设置名称
    [self.goodsName setText:cellDic[@"miaoshaactivityimage_goodsname"]];
    self.goodsName.textColor = cellTextColor;
    //设置折数
    [self.discountLabel setText:
     [NSString stringWithFormat:@"%@折", cellDic[@"miaoshaactivityimage_discount"] ]];
    [self.discountLabel setTextColor:[UIColor redColor]];
    self.discountLabel.layer.cornerRadius = 5.0f;

    //设置价格
    [self.discountPriceLabel setText:cellDic[@"miaoshaactivityimage_price"]];
    
    //设置进度条进度
    
    NSDate *  nowdate=[NSDate date];
    //时间格式
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *  locationString=[dateformatter stringFromDate:nowdate];
    NSString * nowH = [[locationString substringToIndex:10] substringFromIndex:8];
    if ([nowH intValue]<10 && [nowH intValue]>=0) {
        nowH = [NSString stringWithFormat:@"%d",0];
    }
    if ([nowH intValue]<16 && [nowH intValue]>=10) {
        nowH = [NSString stringWithFormat:@"%d",10];
    }
    if ([nowH intValue]<22 && [nowH intValue]>=16) {
        nowH = [NSString stringWithFormat:@"%d",16];
    }
    if ([nowH intValue]>=22) {
        nowH = [NSString stringWithFormat:@"%d",22];
    }
    
    if ([self.date isEqualToString:nowH]) {
        NSString * nowNum = cellDic[@"miaoshaactivityimage_newnum"];
        NSString * num = cellDic[@"miaoshaactivityimage_num"];
        double progress = [nowNum floatValue]/[num floatValue];
        [self.progressView setProgress:progress];
        self.buyButton.layer.cornerRadius = 5.0f;
        self.buyButton.backgroundColor = [UIColor redColor];
        [self.buyButton  setTitle:@"去购买" forState:UIControlStateNormal];
        [self.buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.buyButton.layer setBorderWidth:0.0]; //边框宽度
        [self addSubview:self.progressView];
    }
    else{
        [self.progressView removeFromSuperview];
        
        self.buyButton.layer.cornerRadius = 5.0f;
        self.buyButton.backgroundColor = Green;
        [self.buyButton  setTitle:@"设置闹钟" forState:UIControlStateNormal];
    }
    
    
    
    
    
}
- (IBAction)BuyButtonClicked:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"去购买"]) {
        
    }
    else if([sender.titleLabel.text isEqualToString:@"设置闹钟"]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否确定设置" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: @" No",nil];
        alert.delegate =self;
        [alert show];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否取消设置" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: @" No",nil];
        alert.delegate =self;
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if([self.buyButton.titleLabel.text isEqualToString:@"设置闹钟"]){
            [self.buyButton setTitle:@"已设置" forState:UIControlStateNormal];
            [self.buyButton setBackgroundColor:[UIColor whiteColor]];
            [self.buyButton setTitleColor:Green forState:UIControlStateNormal];
            [self.buyButton.layer setBorderWidth:1.0]; //边框宽度
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.0/255, 201.0/255, 87.0/255, 1.0 });
            [self.buyButton.layer setBorderColor:colorref];//边框颜色
        }
        else{
            self.buyButton.layer.cornerRadius = 5.0f;
            self.buyButton.backgroundColor = Green;
            [self.buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.buyButton  setTitle:@"设置闹钟" forState:UIControlStateNormal];
            [self.buyButton.layer setBorderWidth:0.0]; //边框宽度

        }
        

        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
