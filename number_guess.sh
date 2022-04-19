#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME
USER_ID="$($PSQL "SELECT user_id FROM users WHERE name = '$USERNAME'")"
if [[ -z $USER_ID ]]; then
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users(name) VALUES('$USERNAME')")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  USER_ID="$($PSQL "SELECT user_id FROM users WHERE name = '$USERNAME'")"
else
  
  $PSQL "SELECT COUNT(*), MIN(guesses) FROM games WHERE user_id = $USER_ID" | while IFS="|" read N MIN; do
    echo "Welcome back, $USERNAME! You have played $N games, and your best game took $MIN guesses."
  done
fi
NUMBER=$(( RANDOM % 1000 + 1 ))

echo "Guess the secret number between 1 and 1000:"
(( I = 1 ))
while :; do
  read GUESS
  if [[ ! $GUESS =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
  elif (( GUESS > NUMBER )); then
    echo "It's lower than that, guess again:"
  elif (( GUESS < NUMBER )); then
   echo "It's higher than that, guess again:"
  else
    echo "You guessed it in $I tries. The secret number was $NUMBER. Nice job!"
    break
  fi
  (( I += 1 ))
done
INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(user_id, guesses) VALUES($USER_ID, $I)")