//
//  SYJActivityHeadTableViewCell.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/10.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJActivityHeadTableViewCell.h"

@implementation SYJActivityHeadTableViewCell{
    NSString * Y;
    NSString * M;
    NSString * D;
    NSString * h;
    NSString * m;
    NSString * s;
    
    
}

- (void)awakeFromNib {
    // Initialization code
    NSDate *  nowdate=[NSDate date];
    //时间格式
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *  locationString=[dateformatter stringFromDate:nowdate];
    Y = [locationString substringToIndex:4];
    M = [[locationString substringToIndex:6] substringFromIndex:4];
    D = [[locationString substringToIndex:8] substringFromIndex:6];
    h = [[locationString substringToIndex:10] substringFromIndex:8];
    NSString * nowH = [[locationString substringToIndex:10] substringFromIndex:8];
    m = [[locationString substringToIndex:12] substringFromIndex:10];
    s = [locationString substringFromIndex:12];
    NSLog(@"%d",[h intValue]);
    if ([nowH intValue]<10 && [nowH intValue]>=0) {
        self.timeLabel.text = [NSString stringWithFormat:@"秒杀·%d点场",0];
        h = [NSString stringWithFormat:@"%d",10];
    }
    if ([nowH intValue]<16 && [nowH intValue]>=10) {
        self.timeLabel.text = [NSString stringWithFormat:@"秒杀·%d点场",10];
        h = [NSString stringWithFormat:@"%d",16];
    }
    if ([nowH intValue]<22 && [nowH intValue]>=16) {
        self.timeLabel.text = [NSString stringWithFormat:@"秒杀·%d点场",16];
        h = [NSString stringWithFormat:@"%d",22];
    }
    if ([nowH intValue]>=22) {
        self.timeLabel.text = [NSString stringWithFormat:@"秒杀·%d点场",22];
        h = [NSString stringWithFormat:@"%d",0];
        D = [NSString stringWithFormat:@"%d",[D intValue]+1];
        
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    
    
    
}
- (void)timerFireMethod:(NSTimer*)theTimer
{
    //NSDateFormatter *dateformatter = [[[NSDateFormatter alloc]init] autorelease];//定义NSDateFormatter用来显示格式
    //[dateformatter setDateFormat:@"yyyy MM dd hh mm ss"];//设定格式
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateComponents *shibo = [[NSDateComponents alloc] init];//初始化目标时间（好像是世博会的日期）
    [shibo setYear:[Y intValue]];
    [shibo setMonth:[M intValue]];
    [shibo setDay:[D intValue]];
    [shibo setHour:[h intValue]];
    [shibo setMinute:0];
    [shibo setSecond:0];
    
    NSDate *todate = [cal dateFromComponents:shibo];//把目标时间装载入date
    // NSString *ssss = [dateformatter stringFromDate:dd];
    // NSLog([NSString stringWithFormat:@"shibo shi:%@",ssss]);
    
    NSDate *today = [NSDate date];//得到当前时间
    // NSString *sss = [dateformatter stringFromDate:today];
    // NSLog([NSString stringWithFormat:@"xianzai shi:%@",sss]);
    //用来得到具体的时差
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:today toDate:todate options:0];
    self.timeRemainingLabel.text = [NSString stringWithFormat:@"%02d：%02d：%02d",(int)[d hour], (int)[d minute], (int)[d second]];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
