//
//  MDisease.h
//  MedicalHelp
//
//  Created by Maxim Popov popovme@gmail.com on 23.11.15.
//  Copyright © 2015 Popovme. All rights reserved.
//

#import "MBase.h"

@class MMedicament, MSymptom;

@interface MDisease : MBase

@property (nonatomic, retain) NSSet<MMedicament *> *medicaments;
@property (nonatomic, retain) NSSet<MSymptom *> *symptoms;

@end

@interface MDisease (CoreDataGeneratedAccessors)

- (void)addMedicamentsObject:(MMedicament *)value;
- (void)removeMedicamentsObject:(MMedicament *)value;
- (void)addMedicaments:(NSSet<MMedicament *> *)values;
- (void)removeMedicaments:(NSSet<MMedicament *> *)values;

- (void)addSymptomsObject:(MSymptom *)value;
- (void)removeSymptomsObject:(MSymptom *)value;
- (void)addSymptoms:(NSSet<MSymptom *> *)values;
- (void)removeSymptoms:(NSSet<MSymptom *> *)values;

@end
