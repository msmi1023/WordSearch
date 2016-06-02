//
//  GameCollectionViewController.m
//  WordSearch
//
//  Created by tstone10 on 6/2/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "GameCollectionViewController.h"

@interface GameCollectionViewController ()

@end

@implementation GameCollectionViewController

NSArray *gridLetters;
NSMutableArray *selectedLetters;
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
	
	gridLetters = [self generateRandomCharArray:64];
	
	selectedLetters = [[NSMutableArray alloc] init];
	
	self.collectionView.allowsMultipleSelection = YES;
	
	UIPanGestureRecognizer *collectionPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(wordPan:)];
	collectionPan.maximumNumberOfTouches = 1;
	[self.collectionView addGestureRecognizer:collectionPan];
	collectionPan.delegate = self;
	
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    /*[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
	
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	[flowLayout setItemSize:CGSizeMake(50, 50)];
	[flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
	
	[self.collectionView setCollectionViewLayout:flowLayout];*/
    
    // Do any additional setup after loading the view.
}

NSMutableArray *pannedIndices;



-(void)wordPan:(UIPanGestureRecognizer *)gesture {
	CGPoint location = [gesture locationInView:self.collectionView];
	NSIndexPath *swipedIndexPath = [self.collectionView indexPathForItemAtPoint:location];
	//NSNumber *currentItemIndex = [NSNumber numberWithInteger:swipedIndexPath.item];
	
	if ([gesture state] == UIGestureRecognizerStateBegan) {
		pannedIndices = [[NSMutableArray alloc] init];
		//[pannedIndices addObject:currentItemIndex];
		if(swipedIndexPath != nil) {
			[pannedIndices addObject:swipedIndexPath];
		}
	} else if ([gesture state] == UIGestureRecognizerStateChanged) {
		if(swipedIndexPath != nil && ![pannedIndices containsObject:swipedIndexPath]) {
			[pannedIndices addObject:swipedIndexPath];
		}
	}
	else if ([gesture state] == UIGestureRecognizerStateEnded){
		if(swipedIndexPath != nil && ![pannedIndices containsObject:swipedIndexPath]) {
			[pannedIndices addObject:swipedIndexPath];
		}
		
		//NSLog(@"Indices that were selected: %@", pannedIndices.description);
		for(int i=0; i<pannedIndices.count; i++) {
			
			if([[self.collectionView indexPathsForSelectedItems] containsObject:pannedIndices[i]]) {
				
			}
			else {
				[self.collectionView selectItemAtIndexPath:pannedIndices[i] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
			}
		}
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return gridLetters.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
	
	UILabel * label = (UILabel *)[cell viewWithTag:100];
	[label setText:gridLetters[indexPath.row]];
	[label setTextColor:[UIColor whiteColor]];
	
	UIView *backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
	backgroundView.backgroundColor = [UIColor blackColor];
	
	cell.backgroundView = backgroundView;
	
	UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
	selectedBackgroundView.backgroundColor = [UIColor magentaColor];
	
	cell.selectedBackgroundView = selectedBackgroundView;
	
    return cell;
}

-(NSArray *)generateRandomCharArray:(int)size {
	NSMutableArray *returnArray = [[NSMutableArray alloc] init];
	
	//for the given size, put in random chars
	for(int i=0; i<size; i++) {
		//valid range 65 thru 90 for uppercase ascii chars
		[returnArray addObject:[NSString stringWithFormat:@"%c", 65 + arc4random_uniform(90 - 65 + 1)]];
	}
	
	return [returnArray copy];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[selectedLetters addObject: gridLetters[indexPath.row]];
	
	//NSLog(@"selected letters: %@", [selectedLetters componentsJoinedByString:@""]);
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	[selectedLetters removeObject: gridLetters[indexPath.row]];
	
	//NSLog(@"selected letters: %@", [selectedLetters componentsJoinedByString:@""]);
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
