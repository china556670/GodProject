//
//  MenheraAlert.m
//  GodProject
//
//  Created by 奇林刘 on 2020/10/27.
//

#import "MenheraAlert.h"
#define MenheraThink 6

@interface MenheraAlert ()
@property (weak, nonatomic) IBOutlet UIButton *menhera;
@property (assign, nonatomic) BOOL answer;

@end

@implementation MenheraAlert

- (void)awakeFromNib {
    [super awakeFromNib];
    self.menhera.layer.cornerRadius = 20;
    self.menhera.layer.masksToBounds = YES;
    self.menhera.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.answer = ({
        int value = arc4random() % MenheraThink;
        value == (MenheraThink - 1);
    });
    UIImage *menheraAnswer = self.answer ? [UIImage imageNamed:@"MenheraYES"] : [UIImage imageNamed:@"MenheraNO"];
    [self.menhera setImage:menheraAnswer forState:UIControlStateNormal];

}

- (IBAction)menheraAction:(id)sender {
    [self removeFromSuperview];
}

+ (void)showWithOperate:(void (^)(BOOL answer))answer {
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    MenheraAlert *alert = [[NSBundle mainBundle] loadNibNamed:@"MenheraAlert" owner:nil options:nil].firstObject;
    if (answer) answer(alert.answer);
    alert.frame = window.bounds;
    [window addSubview:alert];
}

@end
