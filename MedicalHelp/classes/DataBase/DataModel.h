//
//  DataModel.h
//  MedicalHelp
//
//  Created by Maxim Popov popovme@gmail.com on 23.11.15.
//  Copyright © 2015 Popovme. All rights reserved.
//

#import "MFirstAid.h"
#import "MSymptom.h"
#import "MDisease.h"
#import "MMedicament.h"

@interface DataModel : NSObject

@property (nonatomic, strong) NSArray *firstAids;
@property (nonatomic, strong) NSArray *symptoms;
@property (nonatomic, strong) NSArray *diseases;
@property (nonatomic, strong) NSArray *medicaments;

+ (instancetype)sharedInstance;

@end
