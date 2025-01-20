package application;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class PigClass {
    private int playerScore;
    private int computerScore;
    private int roundScore;
    private boolean playerTurn;
    private String currentPlayer = "Player";
    private List<GameRecord> history = new ArrayList<>();
    
    public void endGame(String result, int points) {
        String date = getCurrentDate();
        String player = getCurrentPlayer();
        GameRecord record = new GameRecord(result, date, points, player);
        history.add(record);
    }
    private String getCurrentDate() {
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        return now.format(formatter);
    }
    private String getCurrentPlayer() {
        return currentPlayer;
    }
    
    public PigClass() {
        playerScore = 0;
        computerScore = 0;
        roundScore = 0;
        playerTurn = true;
    }

    public int rollDice() {
        int roll = (int) (Math.random() * 6) + 1;
        if (roll == 1) {
        	
        	roundScore = 0;
            playerTurn = !playerTurn;
        } else {
            roundScore += roll;
        }
        return roll;
    }

    public void hold() {
        if (playerTurn) {
            playerScore += roundScore;
        } else {
            computerScore += roundScore;
        }
        roundScore = 0;
        playerTurn = !playerTurn;
    }
    public int getPlayerScore() {
        return playerScore;
    }

    public int getComputerScore() {
        return computerScore;
    }

    public boolean isPlayerTurn() {
        return playerTurn;
    }
}