public with sharing class GameController {
    
    private static final GameService gameService;
    private static final GameMapper gameMapper; 

    static {
        gameService = ServiceLocator.getGameService();
    }

    @AuraEnabled(cacheable=true)
    public static Game getById(Id id) {
        return gameService.getById(id);
    }

}