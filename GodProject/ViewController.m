//
//  ViewController.m
//  GodProject
//
//  Created by 奇林刘 on 2020/10/24.
//

#import "ViewController.h"
#import <YYKit.h>
#define GodOrigin @"2020-10-25 14:59:00"
#define GodValuePerDay 20
#define DateFormate @"yyyy-MM-dd HH:mm:ss"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *money;

@end

@implementation ViewController {
    dispatch_source_t _repeatingTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak __typeof (self)weakSelf = self;
    _repeatingTimer = [self getTimerOfRepeatingThings:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateGodInfo];
        });
    } timeInterval:1];
    
    self.time.layer.cornerRadius = 20;
    self.time.layer.masksToBounds = YES;
    self.money.layer.cornerRadius = 20;
    self.money.layer.masksToBounds = YES;
}

- (void)updateGodInfo {
    NSDate *godOriginDate = [NSDate dateWithString:GodOrigin format:DateFormate];
    NSDate *nowDate = [NSDate date];
    NSInteger godAge = [nowDate timeIntervalSinceDate:godOriginDate];
    self.time.text = [NSString stringWithFormat:@"    %zd天 %zd小时 %zd分 %zd秒    ", godAge / 86400, godAge % 86400 / 3600, godAge % 3600 / 60, godAge % 60];
    self.money.text = [NSString stringWithFormat:@"    %.2f元    ", godAge * 1.0 / 86400 * GodValuePerDay];
}

- (dispatch_source_t)getTimerOfRepeatingThings:(void(^)(void))block timeInterval:(int)interval {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),interval*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (block) block();
    });
    dispatch_resume(_timer);
    return _timer;
}


@end
