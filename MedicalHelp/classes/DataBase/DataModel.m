//
//  DataModel.m
//  MedicalHelp
//
//  Created by Maxim Popov popovme@gmail.com on 23.11.15.
//  Copyright © 2015 Popovme. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

- (id)init {
    self = [super init];
    if (self) {
        if (kRemoveDBTestMode) {
            NSURL *dbUrl = [NSPersistentStore MR_urlForStoreName:[MagicalRecord defaultStoreName]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:dbUrl.path]) {
                [fileManager removeItemAtPath:dbUrl.path error:nil];
            }
        }

        [MagicalRecord setShouldDeleteStoreOnModelMismatch:YES];
        [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelOff];
        [MagicalRecord setupCoreDataStack];
        
        self.firstAids = [MFirstAid MR_findAllSortedBy:NSStringFromSelector(@selector(title)) ascending:YES];
        if (self.firstAids.count == 0) {
            [self importClass:[MFirstAid class] withFileName:@"first_aid"];
            [self importClass:[MMedicament class] withFileName:@"medicaments"];
            [self importClass:[MDisease class] withFileName:@"diseases"];
            [self importClass:[MSymptom class] withFileName:@"symptoms"];
            
            self.firstAids = [MFirstAid MR_findAllSortedBy:NSStringFromSelector(@selector(title)) ascending:YES];
        }
        
        self.symptoms = [MSymptom MR_findAllSortedBy:NSStringFromSelector(@selector(title)) ascending:YES];
        self.diseases = [MDisease MR_findAllSortedBy:NSStringFromSelector(@selector(title)) ascending:YES];
        self.medicaments = [MMedicament MR_findAllSortedBy:NSStringFromSelector(@selector(title)) ascending:YES];
    }
    return self;
}

#pragma mark - Class

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    
    return sharedInstance;
}


#pragma mark - Work

- (void)importClass:(Class)class withFileName:(NSString *)fileName {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    NSArray *jsonArray = nil;
    @try {
        NSError *error = nil;
        jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }
    @catch (NSException *exception) {
        
    }
    if (jsonArray.count > 0) {
        [class MR_importFromArray:jsonArray];
    }
}

@end
