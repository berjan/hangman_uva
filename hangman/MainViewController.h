//
//  MainViewController.h
//  hangman
//
//  Created by Bruens IT on 11/04/14.
//  Copyright (c) 2014 bruens_uva. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *myTextField;

@property NSString *guessingWord;
@property (weak, nonatomic) IBOutlet UIButton *btnStartKeyboard;

@property int(totalGuessed);

@property (weak, nonatomic) IBOutlet UILabel *lblTotalGuessed;

@property (weak, nonatomic) IBOutlet UILabel *lblGuessesLeft;
@property (weak, nonatomic) IBOutlet UILabel *lblGuessedResult;
@property (weak, nonatomic) IBOutlet UILabel *lblResultWinLoos;

@property int(guessesLeft);

@property int(totalIncorrectGuesses);

@property int(highScore);

@property NSString *guessedChars;

@property BOOL *gameCompleted;

-(IBAction)returnKeyWasHist:(id)sender;

-(IBAction)showHighScoreBoard;



-(IBAction)showHistoryGuessedChars;

-(IBAction)showKeyboardOnLaunch;

-(IBAction)hideKeyboard;

-(IBAction)startNewGame;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

- (void)textFieldDidBeginEditing:(UITextField *)textField;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
