public with sharing class GameService implements IGameService {

    public Game getOrCreate() {
        List<Game__c> gameRecords = fetchInProgressByCurrentUser();
        Game__c gameRecord;
        if (gameRecords.isEmpty()) {
            Game__c gameRecord = new Game__c();
            insert gameRecord;
        } else {
            gameRecord = gameRecords[0];
        }
        return GameMapper.mapFromSObject(gameRecord);
    }
    
    public Game getById(Id id) {
        return GameMapper.mapFromSObject(fetchById(id));
    }

    public Game rollById(Id id, Boolean[] diceMask) {
        Game__c game = fetchById(id);
        Dice[] dice = JSON.deserialize(game.Dice__c, Dice[].class);
        update game;
        return GameMapper.mapFromSObject(game);
    }

    public Game fillById(Id id, Category category) {
        Game__c game = fetchById(id);
        validateFill(game);
        Sheet sheet = JSON.deserialize(game.Sheet__c, Sheet.class);
        sheet.scores.put(category, 0);
        game.Sheet__c = JSON.serialize(sheet);
        update game;
        return GameMapper.fromSObject(game);
    }

    public Game restartById(Id id) {
        Game__c game = fetchById(id);
        validateRestart(game);
        Dice[] dices = JSON.deserialize(game.Dice__c, Dice[].class);
        Sheet sheet = JSON.deserialize(game.Sheet__c, Sheet.class);
        game.Sheet__c = JSON.serialize(sheet);
        update game;
        return GameMapper.mapFromSObject(game);
    }

    public Game archiveById(Id id) {
        Game__c game = fetchById(id);
        game.Status__c = GameStatus.ARCHIVED;
        update game;
        return GameMapper.mapFromSObject(game);
    }

    private Game__c fetchById(Id id) {
        return [
            SELECT Dice_Cup__c, Score_Card__c
                Roll_Count__c, Total_Score__c,
                Status__c
            FROM Game__c 
            WHERE Id = :id
        ];
    }

    private List<Game__c> fetchInProgressByCurrentUser() {
        return [
            SELECT Dice_Cup__c, Score_Card__c
                Roll_Count__c, Total_Score__c,
                Status__c
            FROM Game__c 
            WHERE OwnerId = :UserInfo.getUserId()
            LIMIT 1
        ];
    }

}
