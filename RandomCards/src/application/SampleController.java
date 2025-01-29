package application;

import java.util.Random;

import javafx.fxml.FXML;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;

public class SampleController {

	
	  private int numb1; 
	  private int numb2;
	  private int numb3; 
	  private Random rand  = new Random(); 
	  
	  
	  @FXML
	  private ImageView img1;
	  
	  @FXML 
	  private ImageView img2;
	  
	  @FXML
	  private ImageView img3;
	  
	  private String filePath = "file:/C:/Users/13137/OneDrive/Documents/Downloads/card/";
	  
		/*
		 * public void intialize() { numb1 = rand.nextInt(54)*1; numb2 =
		 * rand.nextInt(54)*1; numb3 = rand.nextInt(54)*1; }
		 */
	 public void intialize() {
		 numb1 = rand.nextInt(54)+1;
			numb2 = rand.nextInt(54)+1;
			numb3 = rand.nextInt(54)+1;
	 }
	public void onImgClicked(MouseEvent e) {
		if (e.getSource().equals(img1)) {
			img1.setImage(new Image(filePath + numb1 +  ".png"));
		}
		else if (e.getSource().equals(img2)) {
			img2.setImage(new Image(filePath + numb2 + ".png"));
		}
		if (e.getSource().equals(img3)) {
			img3.setImage(new Image(filePath + numb3 + ".png"));
		}
	}
	public void onBtnClicked() {
			numb1 = rand.nextInt(54)+1;
			numb2 = rand.nextInt(54)+1;
			numb3 = rand.nextInt(54)+1;
			
			img1.setImage(new Image(filePath+"backCard.png"));
			img2.setImage(new Image(filePath+"backCard.png"));
			img3.setImage(new Image(filePath+"backCard.png"));
	}
	
	
	
	
	
	
}
