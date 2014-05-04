//
//  FlipsideViewController.h
//  hangman
//
//  Created by Bruens IT on 11/04/14.
//  Copyright (c) 2014 bruens_uva. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblTotalToGuessSetting;
@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@property (weak, nonatomic) IBOutlet UISlider *sliTotalAllowedGuesses;
@property (weak, nonatomic) IBOutlet UITextField *txtPlayerName;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalAllowedGuesses;

@property (weak, nonatomic) IBOutlet UISlider *sliTotalCharsToGuess;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalCharsToGuess;

-(IBAction)savePlayerName;
@end
