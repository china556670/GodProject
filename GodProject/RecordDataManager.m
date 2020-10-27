//
//  RecordDataManager.m
//  GodProject
//
//  Created by 奇林刘 on 2020/10/27.
//

#import "RecordDataManager.h"
#import <YYKit.h>
#define DateRecordKey @"DateRecordKey"
#define AskMenheraKey @"AskMenheraKey"

@implementation RecordDataManager

+ (void)updateSmokeDate {
    [[NSUserDefaults standardUserDefaults] setValue:[[NSDate date] stringWithFormat:DateFormate] forKey:DateRecordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)smokeDate {
    return [[NSUserDefaults standardUserDefaults] valueForKey:DateRecordKey];
}

+ (void)updateMenheraDate {
    [[NSUserDefaults standardUserDefaults] setValue:[[NSDate date] stringWithFormat:DateFormate] forKey:AskMenheraKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)menheraDate {
    return [[NSUserDefaults standardUserDefaults] valueForKey:AskMenheraKey];
}

@end
