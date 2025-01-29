public with sharing class GameMapper {

    public Game mapFromSObject(Game__c gameRecord) {
        return new Game(
            (List<Dice>) JSON.deserialize(gameRecord.Dice_Cup__c, List<Dice>.class),
            (Map<Category, Integer>) JSON.deserialize(gameRecord.Score_Card__c, Map<Category, Integer>.class),
            (Integer) gameRecord.Roll_Count__c,
            (Integer) gameRecord.Total_Score__c,
            GameStatus.valueOf(gameRecord.Status__c)
        );
    }

}