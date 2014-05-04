//
//  MainViewController.m
//  hangman
//
//  Created by Bruens IT on 11/04/14.
//  Copyright (c) 2014 bruens_uva. All rights reserved.
//

#import "MainViewController.h"
#import "GamePlay.h"

@interface MainViewController ()


@end

@implementation MainViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    GamePlay *gamePlay = [[GamePlay alloc] init];
    self.gamePlay = gamePlay;
    
    
    // Make sure the keyboard popsup
    [self.myTextField becomeFirstResponder];
    

    [self startGame];
    
}
-(void)startGame
{
    [self.gamePlay startGame];
    self.lblGuessesLeft.text = self.gamePlay.strTotalGuessesLeft;
   
    self.lblTotalGuessed.text = @"0";
    
    
    
    self.lblResultWinLoos.text = self.gamePlay.resultText;
    
    
    
    self.lblGuessedResult.text = self.gamePlay.getHypenGuessingWord;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showKeyboardOnLaunch
{
    
}
- (IBAction)hideKeyboard
{
    [self.myTextField resignFirstResponder];
}
#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}
- (IBAction)startNewGame
{
    [self startGame];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.gamePlay updateGameState:textField.text];
    self.lblGuessesLeft.text = self.gamePlay.strTotalGuessesLeft;
    self.lblTotalGuessed.text = self.gamePlay.strTotalGuessed;
    self.lblResultWinLoos.text = self.gamePlay.resultText;
    self.lblGuessedResult.text = self.gamePlay.getHypenGuessingWord;
    self.myTextField.text = @"";
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [self.gamePlay validateInput:textField.text theRange:range thirdValue:string];
}


-(void)showHistoryGuessedChars
{
    UIAlertView *alertHistoryGuessedChars = [[UIAlertView alloc]
                                    initWithTitle:@"History"
                                    message: self.gamePlay.guessedChars
                                    delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
    [alertHistoryGuessedChars show];
}

-(void)showHighScoreBoard
{
    UIAlertView *alertHighScoreBoard = [[UIAlertView alloc]
                                             initWithTitle:@"Name, Word, Incorrect, Score"
                                             message: self.gamePlay.highScoresMessage
                                             delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [alertHighScoreBoard show];
}

@end
