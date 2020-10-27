//
//  RecordDataManager.h
//  GodProject
//
//  Created by 奇林刘 on 2020/10/27.
//

#import <Foundation/Foundation.h>
#define DateFormate @"yyyy-MM-dd HH:mm:ss"

NS_ASSUME_NONNULL_BEGIN

@interface RecordDataManager : NSObject

+ (void)updateSmokeDate;

+ (NSString *)smokeDate;

+ (void)updateMenheraDate;

+ (NSString *)menheraDate;

@end

NS_ASSUME_NONNULL_END
