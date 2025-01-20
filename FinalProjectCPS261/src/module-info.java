module JavaFX {
	requires javafx.controls;
	requires javafx.graphics;
	requires javafx.base;
	requires java.desktop;
	requires javafx.fxml;

	opens application to javafx.graphics, javafx.fxml;
}
