//
//  GamePlay.h
//  hangman
//
//  Created by Bruens IT on 04/05/14.
//  Copyright (c) 2014 bruens_uva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GamePlay : NSObject
-(BOOL) validateInput:(NSString *)input theRange:(NSRange)range thirdValue:(NSString*)string;

-(void)startGame;


@property BOOL *gamecompleted;

@property int(totalIncorrectGuesses);

@property int(highScore);

@property NSString *guessedChars;
@property int(totalGuessed);
@property int(guessesLeft);

@property NSString *strTotalGuessesLeft;
@property NSString *strTotalGuessed;

@property NSString *resultText;
@property NSString *highScoresMessage;

@property NSString *getHypenGuessingWord;

-(void)updateGameState: (NSString *)inputChar;

//update this property so other classes are allowed to only read it.
@property NSString * guessingWord;
@end
