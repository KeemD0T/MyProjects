package application;



import java.util.stream.Collectors;

import javafx.application.Application;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TableColumn;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

public class PigGUI extends Application {
    private PigClass  game;

    @Override
    public void start(Stage primaryStage) {
        game = new PigClass();
        
        Label scoreLabel = new Label("Player: 0 | Computer: 0");
        Label statusLabel = new Label("Player's turn");
        Button rollButton = new Button("Roll");
        Button holdButton = new Button("Hold");
        Button historyButton = new Button("History");
        historyButton.setOnAction(event -> {
        	
        	
            
            // show the history window
        });
        historyButton.setOnAction(event -> {
            HistoryWindow historyWindow = new HistoryWindow();
            historyWindow.show();
        });
        
        
        Button newGameButton = new Button("New Game");
        newGameButton.setOnAction(event -> {
            // start a new game
        });
        TableColumn<Record, String> resultCol = new TableColumn<>("Result");
        resultCol.setCellValueFactory(new PropertyValueFactory<>("result"));
        resultCol.setSortable(true);
        

        
        

        rollButton.setOnAction(e -> {
            int roll = game.rollDice();
            if (roll == 1) {
                statusLabel.setText("You rolled a 1 Computer's turn.");
            } else {
                statusLabel.setText("You rolled a " + roll + ". Roll again or hold?");
            }
            updateScoreLabel(scoreLabel);
        });
        
        holdButton.setOnAction(e -> {
             game.hold();
            statusLabel.setText("Computer's turn.");
            updateScoreLabel(scoreLabel);
        });

        VBox root = new VBox(10, scoreLabel, statusLabel, rollButton, holdButton, historyButton);
        root.setAlignment(Pos.CENTER);

        Scene scene = new Scene(root, 300, 200);
        primaryStage.setScene(scene);
        primaryStage.setTitle("Pig");
        primaryStage.show();
    }
    
    private void updateScoreLabel(Label scoreLabel) {
        scoreLabel.setText("Player: " + game.getPlayerScore() + " | Computer: " + game.getComputerScore());
    }

  

	public static void main(String[] args) {
        launch(args);
    }
}
    
