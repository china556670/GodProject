//
//  ViewController.m
//  GodProject
//
//  Created by 奇林刘 on 2020/10/24.
//

#import "ViewController.h"
#import <YYKit.h>
#define DateFormate @"yyyy-MM-dd HH:mm:ss"
#define DateRecordKey @"DateRecordKey"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *reset;

@end

@implementation ViewController {
    dispatch_source_t _repeatingTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.time.layer.cornerRadius = 20;
    self.time.layer.masksToBounds = YES;
    self.reset.layer.cornerRadius = 20;
    self.reset.layer.masksToBounds = YES;
    
    if ([self obtainRecordedDateSting].length > 0) [self startTimer];
}

- (IBAction)resetAction:(id)sender {
    [self showAlert];
}

- (void)takeOne {
    [self stopTimer];
    [self recordNewDate];
    [self startTimer];
}

- (void)stopTimer {
    if (_repeatingTimer) dispatch_cancel(_repeatingTimer);
}

- (void)recordNewDate {
    [[NSUserDefaults standardUserDefaults] setValue:[[NSDate date] stringWithFormat:DateFormate] forKey:DateRecordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)obtainRecordedDateSting {
    return [[NSUserDefaults standardUserDefaults] valueForKey:DateRecordKey];
}

- (void)startTimer {
    __weak __typeof (self)weakSelf = self;
    _repeatingTimer = [self getTimerOfRepeatingThings:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateTimeLabel];
        });
    } timeInterval:1];
}

- (void)updateTimeLabel {
    NSDate *nowDate = [NSDate date];
    NSInteger seconds = [nowDate timeIntervalSinceDate:[NSDate dateWithString:[self obtainRecordedDateSting] format:DateFormate]];
    self.time.text = [NSString stringWithFormat:@"    %zdd %zdh %zdm %zds    ", seconds / 86400, seconds % 86400 / 3600, seconds % 3600 / 60, seconds % 60];
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

- (void)showAlert {
    __weak __typeof (self)weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Are you sure to take one now ?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"JustTakeOne" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf takeOne];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
