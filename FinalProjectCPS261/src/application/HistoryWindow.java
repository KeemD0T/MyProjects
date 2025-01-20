package application;




import javafx.collections.ObservableList;
import javafx.scene.Scene;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.stage.Stage;

public class HistoryWindow {
    private ObservableList<GameRecord> records;

    public HistoryWindow() {
        this.records = records;
    }
    public HistoryWindow(ObservableList<GameRecord> records) {
        this.records = records;
    }

    public void show() {
        Stage stage = new Stage();
        stage.setTitle("History");

        TableView<GameRecord> table = new TableView<>();
        table.setItems(records);

        TableColumn<GameRecord, String> resultCol = new TableColumn<>("Result");
        resultCol.setCellValueFactory(new PropertyValueFactory<>("result"));

        TableColumn<GameRecord, String> dateCol = new TableColumn<>("Date");
        dateCol.setCellValueFactory(new PropertyValueFactory<>("date"));

        TableColumn<GameRecord, Integer> pointsCol = new TableColumn<>("Points");
        pointsCol.setCellValueFactory(new PropertyValueFactory<>("points"));

        TableColumn<GameRecord, String> playerCol = new TableColumn<>("Player");
        playerCol.setCellValueFactory(new PropertyValueFactory<>("player"));

        table.getColumns().addAll(resultCol, dateCol, pointsCol, playerCol);

        Scene scene = new Scene(table);
        stage.setScene(scene);
        stage.show();
    }
}
