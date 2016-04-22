//
//  MSymptom.h
//  MedicalHelp
//
//  Created by Maxim Popov popovme@gmail.com on 23.11.15.
//  Copyright © 2015 Popovme. All rights reserved.
//

#import "MBase.h"

@class MDisease;

@interface MSymptom : MBase

@property (nonatomic, retain) NSSet<MDisease *> *diseases;

@end

@interface MSymptom (CoreDataGeneratedAccessors)

- (void)addDiseasesObject:(MDisease *)value;
- (void)removeDiseasesObject:(MDisease *)value;
- (void)addDiseases:(NSSet<MDisease *> *)values;
- (void)removeDiseases:(NSSet<MDisease *> *)values;

@end
