package application;


public class GameRecord {
    private String result;
    private String date;
    private int points;
    private String player;

    public GameRecord(String result, String date, int points, String player) {
        this.result = result;
        this.date = date;
        this.points = points;
        this.player = player;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getPoints() {
        return points;
    }

    public void setPoints(int points) {
        this.points = points;
    }

    public String getPlayer() {
        return player;
    }

    public void setPlayer(String player) {
        this.player = player;
    }

	public static Object stream() {
		// TODO Auto-generated method stub
		return null;
	}
}
