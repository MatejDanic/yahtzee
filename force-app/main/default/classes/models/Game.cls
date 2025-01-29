public with sharing class Game {

    public List<Dice> diceCup { get; private set; }
    public Map<Category, Integer> scoreCard { get; private set; }
    public Integer rollCount { get; private set; }
    public Integer totalScore { get; private set; }
    public GameStatus status { get; private set; }

    public Boolean isLocked { 
        get {
            return status == GameStatus.COMPLETED || status == GameStatus.ARCHIVED;
        }
        private set;
    }

    public Game(List<Dice> diceCup, Map<Category, Integer> scoreCard, Integer rollCount, Integer totalScore, GameStatus status) {
        this.diceCup = diceCup;
        this.scoreCard = scoreCard;
        this.rollCount = rollCount;
        this.totalScore = totalScore;
        this.status = status;
    }

    private static List<Dice> generateDiceCup() {
        List<Dice> diceCup = new List<Dice>();
        for (Integer i = 0; i < Constants.NUMBER_OF_DICE; i++) {
            diceCup.add(new Dice(6));
        }
        return diceCup;
    }

    private static Map<Category, Integer> generateScoreCard() {
        Map<Category, Integer> scoreCard = new Map<Category,Integer>();
        for (Category cat : Category.values()) {
            scoreCard.put(cat, null);
        }
        return scoreCard;
    }
    
    public void roll(Boolean[] rollMask) {
        validateRoll(rollMask);
        if (rollCount == 0) { 
            // always roll all dice on first roll
            for (Dice dice : diceCup) {
                dice.roll();
            }
        } else {
            for (Integer i = 0; i < diceCup.size(); i++) {
                if (rollMask.get(i)) {
                    diceCup.get(i).roll();
                }
            }
        }
        rollCount += 1;
    }

    public void fill(Category cat) {
        validateFill(cat);
        Integer score = ScoreCalculator.calculateScore(diceCup, cat);
        scoreCard.put(cat, score);
        if (isCompleted()) {
            status = GameStatus.COMPLETED;
        }
        rollCount = 0;
    }

    private Boolean isCompleted() {
        for (Category cat : scoreCard.keySet()) {
            if (scoreCard.get(cat) == null) {
                return false;
            }
        }
        return true;
    }

    public void restart() {
        validateRestart();
        diceCup = generateDiceCup();
        scoreCard = generateScoreCard();
        rollCount = 0;
        totalScore = 0;
    }

    public void archive() {
        validateArchive();
        status = GameStatus.ARCHIVED;
    }

    private void validateRoll(Boolean[] rollMask) {
        if (isLocked) {
            throw new GameLockedException();
        } else if (rollCount == 3) {
            throw new RollLimitExceededException();
        } else if (rollMask == null) {
            throw new IllegalArgumentException('Dice to roll cannot be null.');
        } else if (rollMask.size() != Constants.NUMBER_OF_DICE) {
            throw new IllegalArgumentException('Dice to roll must contain 5 elements.');
        }
    }

    private void validatefill(Category cat) {
        if (isLocked) {
            throw new GameLockedException();
        } else if (rollCount == 0) {
			throw new RollRequiredException();
        } else if (cat == null) {
            throw new IllegalArgumentException('Box type cannot be null.');
        } else if (!isCategoryAvailable(cat)) {
            throw new CategoryUnavailableException();
        }
    }
    
    private boolean isCategoryAvailable(Category cat) {
        return scoreCard.get(cat) == null;
    }

    private void validateRestart() {
        if (isLocked) {
            throw new GameLockedException();
        }
    }

    private void validateArchive() {
        if (status != GameStatus.COMPLETED) {
            throw new GameNotCompletedException();
        }
    }


    // public void complete() {
    //     int[] diceToRoll = {0, 1, 2, 3, 4};
    //     for (int i = 0; i < BoxType.values().length; i++) {    
    //         roll(diceToRoll);
    //         fill(ColumnType.DOWNWARDS, BoxType.values()[i]);
    //     }
    //     for (int i = BoxType.values().length - 1; i >= 0; i--) {    
    //         roll(diceToRoll);
    //         fill(ColumnType.UPWARDS, BoxType.values()[i]);
    //     }
    //     for (int i = 0; i < BoxType.values().length; i++) {    
    //         roll(diceToRoll);
    //         fill(ColumnType.FREE, BoxType.values()[i]);
    //     }
    //     for (int i = 0; i < BoxType.values().length; i++) {    
    //         roll(diceToRoll);
    //         announce(BoxType.values()[i]);
    //         fill(ColumnType.ANNOUNCEMENT, BoxType.values()[i]);
    //     }
    // }
    
}