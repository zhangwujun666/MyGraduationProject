//
//  SYJCarcellTableViewCell.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/4.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//
#import "SYJCarcellTableViewCell.h"
#import "SYJCarGoodsTableViewController.h"
#import "SYJCustomview.h"
#import "AppDelegate.h"
@interface SYJCarcellTableViewCell ()<SYJCustomvDeleate>{
    
    SYJCarGoodsTableViewController *babydetail;
    int i;
    SYJCustomview *allgoodsprice;
}

@end
@implementation SYJCarcellTableViewCell

- (void)awakeFromNib {
    
    
    self.a=1;
    i=1;
    [self.selectButton setImage:[UIImage imageNamed:@"Nobabyselect.jpg"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"allselect" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Nochange:) name:@"Noallselect" object:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}//cell里面的选中
- (IBAction)selectButton:(UIButton *)sender {
    self.count=[self.Numberlable.text intValue];
    self.a++;
    if(self.a%2==0){
        self.selectState=YES;//作用是为了里面的加减
        APPDELEGATE.State1=YES;
        [sender setImage:[UIImage imageNamed:@"babyselect.jpg"] forState:UIControlStateNormal];
        
        int  longth=(int)[self.priceLable.text length]-1;
        NSString *str=[self.priceLable.text substringWithRange:NSMakeRange(1, longth)];
        int singprice=[str intValue];
        APPDELEGATE.allprice=singprice*self.count+APPDELEGATE.allprice;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"name" object:nil];
        //显示价格
        NSNumber *goodsid=[NSNumber numberWithInteger:sender.tag];
        [APPDELEGATE.selectid addObject:goodsid];
        
        //添加到全局数组中
        if ([self.deleate respondsToSelector:@selector(selectBox:)]) {
            [self.deleate selectBox:self.path];
        }
        
    }
    else{
        self.selectState=NO;
        APPDELEGATE.State1=NO;
        [sender setImage:[UIImage imageNamed:@"Nobabyselect.jpg"] forState:UIControlStateNormal];
        int  longth=(int)[self.priceLable.text length]-1;
        NSString *str=[self.priceLable.text substringWithRange:NSMakeRange(1, longth)];
        int singprice=[str intValue];
        
        APPDELEGATE.allprice=APPDELEGATE.allprice-singprice*self.count;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"name" object:nil];
        
        for(int k=0;k<APPDELEGATE.selectid.count;k++){
            NSNumber *nm=[APPDELEGATE.selectid objectAtIndex:k];
            NSInteger selectTag=[nm integerValue];
            if(sender.tag==selectTag){
                [APPDELEGATE.selectid removeObjectAtIndex:k];
                
            }
        }
        
        //移除数组中的对象
        if ([self.deleate respondsToSelector:@selector(deselectBox:)]) {
            [self.deleate deselectBox:self.path];
        }
    }
    //NSLog(@"%@",APPDELEGATE.selectid);
}


//监听事件，作用改变cellbutton同时，改变总的价格并显示出来
-(void)change:(NSNotification *)sender{
    self.count=[self.Numberlable.text intValue];
    self.a=2;
    self.selectState=YES;//里面的加减//实际每个selectState都是不一样的
    [self.selectButton setImage:[UIImage imageNamed:@"babyselect.jpg"] forState:UIControlStateNormal];
    int  longth=(int)[self.priceLable.text length]-1;//这里有几个宝贝就执行几次，主要是根据self.priceLable.text，去执行的
    NSString *str=[self.priceLable.text substringWithRange:NSMakeRange(1, longth)];
    int singprice=[str intValue];
    APPDELEGATE.allprice=singprice*self.count+APPDELEGATE.allprice;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"name" object:nil];//改变总的价格并显示
}
-(void)Nochange:(NSNotification *)sender{
    self.a=1;
    self.selectState=NO;
    [self.selectButton setImage:[UIImage imageNamed:@"Nobabyselect.jpg"] forState:UIControlStateNormal];
    APPDELEGATE.allprice=0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"name" object:nil];
}
- (IBAction)AddButton:(UIButton *)sender {
    
    if(self.selectState==YES){
        self.count++;
        NSString *babycount=[NSString stringWithFormat:@"%d",self.count];
        self.Numberlable.text=babycount;//显示商品数量
        
        int  longth=(int)[self.priceLable.text length]-1;
        NSString *str=[self.priceLable.text substringWithRange:NSMakeRange(1, longth)];
        int singprice=[str intValue];
        APPDELEGATE.allprice=singprice+APPDELEGATE.allprice;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"name" object:nil];
        
        //增加商品个数
        if ([self.deleate respondsToSelector:@selector(addCount:)]) {
            [self.deleate addCount:self.path];
        }
    }
}
- (IBAction)delectButton:(UIButton *)sender {
    if(self.selectState==YES&&self.count>0){
        self.count--;
        NSString *babycount=[NSString stringWithFormat:@"%d",self.count];
        self.Numberlable.text=babycount;
        
        int  longth=(int)[self.priceLable.text length]-1;
        NSString *str=[self.priceLable.text substringWithRange:NSMakeRange(1, longth)];
        int singprice=[str intValue];
        APPDELEGATE.allprice=APPDELEGATE.allprice-singprice;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"name" object:nil];
        
        //减少商品个数
        if ([self.deleate respondsToSelector:@selector(deleteCount:)]) {
            [self.deleate deleteCount:self.path];
        }
    }
}

-(void)allselect1{
    [self.selectButton setImage:[UIImage imageNamed:@"babyselect.jpg"] forState:UIControlStateNormal];
}
@end