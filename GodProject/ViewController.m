//
//  ViewController.m
//  GodProject
//
//  Created by 奇林刘 on 2020/10/24.
//

#import "ViewController.h"
#import <YYKit.h>
#import "RecordDataManager.h"
#define IPHONE12PROMAX 11899

#import "MenheraAlert.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *iPhone12ProMax512G;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *askMenhera;

@end

@implementation ViewController {
    dispatch_source_t _repeatingTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.time.layer.cornerRadius = 20;
    self.time.layer.masksToBounds = YES;
    self.askMenhera.layer.cornerRadius = 20;
    self.askMenhera.layer.masksToBounds = YES;
    self.iPhone12ProMax512G.layer.cornerRadius = 20;
    self.iPhone12ProMax512G.layer.masksToBounds = YES;
    
    if ([RecordDataManager smokeDate].length > 0) [self startTimer];
}

- (IBAction)askMenheraAction:(id)sender {
    __weak __typeof (self)weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"呐" message:@"你确定要问Menhera吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"算啦" style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"是啦" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [RecordDataManager updateMenheraDate];
        [MenheraAlert showWithOperate:^(BOOL answer) {
            if (answer) {
                [weakSelf refreshSmokeTime];
            }
        }];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)refreshSmokeTime {
    if (_repeatingTimer) dispatch_cancel(_repeatingTimer);
    [RecordDataManager updateSmokeDate];
    [self startTimer];
}

- (void)refreshMenheraTime {
    [RecordDataManager updateMenheraDate];
}



#pragma mark - StartTimer
- (void)startTimer {
    __weak __typeof (self)weakSelf = self;
    _repeatingTimer = [self getTimerOfRepeatingThings:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateUI];
        });
    } timeInterval:1];
}

- (void)updateUI {
    NSDate *nowDate = [NSDate date];
    NSInteger seconds = [nowDate timeIntervalSinceDate:[NSDate dateWithString:[RecordDataManager smokeDate] format:DateFormate]];
    NSInteger secondsMenhera = [nowDate timeIntervalSinceDate:[NSDate dateWithString:[RecordDataManager menheraDate] format:DateFormate]];
    self.time.text = [NSString stringWithFormat:@"    %zd天 %zd小时 %zd分 %zd秒    ", seconds / 86400, seconds % 86400 / 3600, seconds % 3600 / 60, seconds % 60];
    self.iPhone12ProMax512G.text = [NSString stringWithFormat:@"    ¥ %.2f / %d    ", seconds * 1.0 / 1814400 * IPHONE12PROMAX, IPHONE12PROMAX];
    self.askMenhera.hidden = (secondsMenhera <= 3600);
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
