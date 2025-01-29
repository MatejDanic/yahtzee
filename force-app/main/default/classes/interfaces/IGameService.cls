public interface IGameService {
    
    Game getOrCreate();

    Game getById(Id id);

    Game rollById(Id id, Boolean[] diceMask);

    Game fillById(Id id, Category category);

    Game restartById(Id id);

    Game archiveById(Id id);

}