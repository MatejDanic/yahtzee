public with sharing class Dice {

    public Integer value { get; set; }

    public Dice(Integer value) {
        this.value = value;
    }

    public void roll() {
        value = (Integer) Math.floor(Math.random() * 6) + 1;
    }

}