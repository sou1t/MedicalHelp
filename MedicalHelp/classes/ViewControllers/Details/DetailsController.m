//
//  DetailsController.m
//  MedicalHelp
//
//  Created by Maxim Popov popovme@gmail.com on 24.11.15.
//  Copyright © 2015 Popovme. All rights reserved.
//

#import "DetailsController.h"

#import "DescriptionCell.h"
#import "TagsCell.h"

@interface DetailsController () <UITableViewDataSource, UITableViewDelegate, TagsCellDelegate>

@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet UIButton *rightButton;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UILabel *infoLabel;

@property (nonatomic, strong) DescriptionCell *descriptionProtCell;
@property (nonatomic, strong) TagsCell *tagsProtCell;

@property (nonatomic, strong) NSMutableArray *tags;

@end

@implementation DetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView.layer.cornerRadius = 9;
    
    self.backButton.contentEdgeInsets = UIEdgeInsetsMake(0, AUTO_SCALE(16), 0, 0);
    self.backButton.titleLabel.font = [UIFont helveticaNeueBoldFontOfSize:16];
    [self.backButton setTitleColor:[UIColor textLightColor] forState:UIControlStateNormal];
    
    self.rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, AUTO_SCALE(16));
    
    self.infoLabel.font = [UIFont helveticaNeueFontOfSize:11];
    self.infoLabel.textColor = [UIColor textLightColor];
    
    self.tags = [[NSMutableArray alloc] init];
    if ([self.mData isKindOfClass:[MFirstAid class]]) {
        self.tableView.hidden = YES;
        
        CGFloat offset = AUTO_SCALE(12);
        self.textView.textContainerInset = UIEdgeInsetsMake(offset, offset, offset, offset);
        
        UIFont *font = [UIFont helveticaNeueFontOfSize:14];
        NSString *hexColor = [[UIColor textDarkColor] hexString];
        
        MFirstAid *firstAid = (MFirstAid *)self.mData;
        NSString *extension = [firstAid.dataFile pathExtension];
        NSString *fileName = [[firstAid.dataFile lastPathComponent] stringByDeletingPathExtension];
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:fileName ofType:extension];
        NSString *htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUnicodeStringEncoding error:nil];
        htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: '%@'; font-size:%fpx; color: %@;}</style>", font.fontName, font.pointSize, hexColor]];
        NSData *htmlData = [htmlString dataUsingEncoding:NSUnicodeStringEncoding];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:htmlData options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.textView.attributedText = attributedString;
            self.textView.contentOffset = CGPointZero;
        });
    } else {
        self.textView.hidden = YES;
        if ([self.mData isKindOfClass:[MSymptom class]]) {
            MSymptom *mSymptom = (MSymptom *)self.mData;
            if (mSymptom.diseases.count > 0) {
                [self.tags addObject:mSymptom.diseases.allObjects];
            }
        } else if ([self.mData isKindOfClass:[MDisease class]]) {
            MDisease *mDisease = (MDisease *)self.mData;
            if (mDisease.symptoms.count > 0) {
                [self.tags addObject:mDisease.symptoms.allObjects];
            }
            if (mDisease.medicaments.count > 0) {
                [self.tags addObject:mDisease.medicaments.allObjects];
            }
        } else if ([self.mData isKindOfClass:[MMedicament class]]) {
            MMedicament *mMedicament = (MMedicament *)self.mData;
            if (mMedicament.diseases.count > 0) {
                [self.tags addObject:mMedicament.diseases.allObjects];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSInteger controllersCount = self.navigationController.viewControllers.count;
    if (controllersCount > 2) {
        DetailsController *detailsController = self.navigationController.viewControllers[controllersCount - 2];
        [self.backButton setTitle:detailsController.mData.title forState:UIControlStateNormal];
    } else {
        [self.backButton setTitle:nil forState:UIControlStateNormal];
    }
    
    if ((controllersCount - 1) > kMaxStackControllers) {
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [viewControllers removeObjectAtIndex:1];
        self.navigationController.viewControllers = viewControllers;
    }
}


#pragma mark - Property Private

- (DescriptionCell *)descriptionProtCell {
    if (!_descriptionProtCell) {
        _descriptionProtCell = [self.tableView dequeueReusableCellWithIdentifier:[DescriptionCell defaultIdentifer]];
    }
    return _descriptionProtCell;
}

- (TagsCell *)tagsProtCell {
    if (!_tagsProtCell) {
        _tagsProtCell = [self.tableView dequeueReusableCellWithIdentifier:[TagsCell defaultIdentifer]];
    }
    return _tagsProtCell;
}


#pragma mark - Actions

- (IBAction)actionBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionBackMain {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Work

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [(DescriptionCell *)cell setMData:self.mData];
    } else {
        [(TagsCell *)cell setDelegate:self];
        [(TagsCell *)cell setTags:self.tags[indexPath.row - 1]];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.mData isKindOfClass:[MFirstAid class]]) {
        return 0;
    } else {
        return 1 + self.tags.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *defaultIdentifer = indexPath.row == 0 ? [DescriptionCell defaultIdentifer] : [TagsCell defaultIdentifer];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultIdentifer forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


#pragma mark - UITableViewDeleagte

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *protCell = indexPath.row == 0 ? self.descriptionProtCell : self.tagsProtCell;
    
    [self configureCell:protCell atIndexPath:indexPath];
    
    protCell.bounds = ({
        CGRect bounds = protCell.bounds;
        bounds.size.width = tableView.bounds.size.width;
        bounds;
    });
    
    [protCell layoutIfNeeded];
    
    return [protCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


#pragma mark - TagsCellDelegate

- (void)tagCell:(TagsCell *)tagCell didSelectTagIndex:(NSInteger)tagIndex {
    NSInteger row = [self.tableView indexPathForCell:tagCell].row;
    
    MBase *mBase = self.tags[row - 1][tagIndex];
   
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailsController *detailsController = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([DetailsController class])];
    detailsController.mData = mBase;
    
    [self.navigationController pushViewController:detailsController animated:YES];
}

@end
