state("Neon White") {}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.LoadSceneManager = true;
    vars.Helper.AlertLoadless();

    dynamic[,] _settings = 
    {
        { null, "levelRush", true, "Level Rush"},
            {"levelRush", "lr-st", true, "Start timer when loading into the first level."},
            {"levelRush", "lr-re", true, "Reset timer when exiting or restarting rush."},
            {"levelRush", "lr-sp-l", true, "Split timer when completing a level."},
            {"levelRush", "lr-sp-c", true, "Split timer when level rush completed."},
        { null, "chapterRush", false, "Chapter Rush"},
            {"chapterRush", "cr-st", true, "Start timer when loading into a level from level select."},
            {"chapterRush", "cr-re", true, "Reset timer when exiting back to level select."},
            {"chapterRush", "cr-sp", true, "Split timer when completing a level."},
        { null, "newGame", false, "New Game"},
            {"newGame", "ng-st", true, "Start timer when pressing \"New Game\"."},
            {"newGame", "ng-sp-l", true, "Split timer when completing a level."},
            {"newGame", "ng-sp-g", true, "Split timer when collecting a present."}
    };

    vars.Helper.Settings.CreateCustom(_settings, 4, 1, 2, 3);
}

init 
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
	{
        // Don't use, goes to 0 on level transition
        // ----------------
	//vars.Helper["levelRushMicroseconds"] = mono.Make<long>("Game", 1, "_instance", "_currentPlaythrough", "m_levelRushOffsetMicroseconds");
        // ----------------
        vars.Helper["levelRushMicroseconds"] = mono.Make<long>("LevelRush", "m_currentLevelRush", "currentTimerMicroseconds");
        vars.Helper["levelPlaythroughMicroseconds"] = mono.Make<long>("Game", 1, "_instance", "_currentPlaythrough", "microseconds");
        vars.Helper["levelRushIndex"] = mono.Make<int>("LevelRush", "m_currentLevelRush", "currentLevelIndex");

        vars.Helper["filePlayTime"] = mono.Make<long>("GameDataManager", "saveData", "_playTime");
        vars.Helper["mainMenuState"] = mono.Make<int>("MainMenu", "_instance", "_currentState");
        /* 
        public enum State
        {
            None,
            Title,
            Options,
            OptionsRebind,
            Campaign,
            Mission,
            Level,
            LevelSidequest,
            Pause,
            Staging,
            Results,
            Customization,
            Dialogue,
            Location,
            LocationExit,
            Inventory,
            Store,
            ItemShowcase,
            Map,
            StoreSidequest,
            Sidequests,
            Loading,
            BlackScreen,
            LocationMapTransition,
            TimePassage,
            GlobalNeonScore,
            LevelRush,
            LevelRushComplete,
            LevelRushTutorial,
            Miracle,
            Credits,
            TitleCard,
            OutroCard,
            RelationshipStatus,
            None_NoPause,
            LevelRushCompleteFailed,
        }  
        */
		return true;
	});
}

update 
{
    current.Scene = vars.Helper.Scenes.Active.Name ?? old.Scene;
    vars.Helper.Texts["index"].Left = current.filePlayTime;
    vars.Helper.Texts["menuState"].Left = current.mainMenuState;
}

isLoading 
{
    return true;
}

gameTime 
{
    if (settings["levelRush"])
    {
        long totalMilliseconds = (current.levelRushMicroseconds + current.levelPlaythroughMicroseconds) / 1000;
        return TimeSpan.FromMilliseconds(totalMilliseconds);
    }
    else if (settings["chapterRush"])
    {
        return 0;
    }
    else if (settings["newGame"])
    {
        return TimeSpan.FromMilliseconds(current.filePlayTime / 1000);
    }

}

split 
{
    if (settings["lr-sp-l"])
    {
        return old.mainMenuState != current.mainMenuState && current.mainMenuState == 10; //MainMenu.State.Results
    }
    if (settings["lr-sp-c"])
    {
        return current.mainMenuState == 27;
    }

}

start 
{
    if (settings["lr-st"])
    {
        return current.mainMenuState != old.mainMenuState && old.mainMenuState == 9; // MainMenu.State.Staging
    }
}

reset 
{
    if (settings["lr-re"])
    {
        return current.levelRushIndex < old.levelRushIndex;
    }
}
