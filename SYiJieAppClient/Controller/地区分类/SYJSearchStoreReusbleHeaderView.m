//
//  SYJSearchStoreReusbleHeaderView.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/8.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJSearchStoreReusbleHeaderView.h"


#define headerBgColor [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1]//导航栏的背景色
#define showAllGood [UIColor colorWithRed:96.0/255 green:96.0/255 blue:96.0/255 alpha:1]//导航栏的背景色
#define btnBackgroundColor [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1]//导航栏的背景色

@implementation SYJSearchStoreReusbleHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor=headerBgColor;
        self.storeNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, 1, 100, 30)];
        self.showAllButton=[[UIButton alloc] initWithFrame:CGRectMake(220, 4, 89, 23)];
        [self.contentView addSubview:self.storeNameLabel];
        [self.contentView addSubview:self.showAllButton];
        
        //设置label和button的字体和颜色
        self.storeNameLabel.font=textFont;
        self.storeNameLabel.textColor=btnColor;
        self.showAllButton.titleLabel.font=textFont;

        [self.showAllButton setTitleColor:btnColor forState:UIControlStateNormal];
        
        self.showAllButton.titleLabel.textAlignment=NSTextAlignmentRight;
        
        self.showAllButton.backgroundColor=headerBgColor;
        self.showAllButton.layer.cornerRadius=10;
        self.showAllButton.layer.borderWidth=1;
        self.showAllButton.layer.borderColor=[btnBackgroundColor CGColor];
        
        [self.showAllButton addTarget:self action:@selector(showClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

//点击方法
- (void)showClicked:(UIButton *)sender {
    SYJSearchStoreReusbleHeaderView *headerView=self;
    if ([self.delegate respondsToSelector:@selector(showAllData:)]) {
        [self.delegate showAllData:headerView];
    }
}
@end
