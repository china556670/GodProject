//
//  MenheraAlert.h
//  GodProject
//
//  Created by 奇林刘 on 2020/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenheraAlert : UIView

+ (void)showWithOperate:(void (^)(BOOL answer))answer;

@end

NS_ASSUME_NONNULL_END
