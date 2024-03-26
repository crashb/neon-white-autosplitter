state("Neon White") {}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.AlertLoadless();
    vars.levelPlaythroughMicrosecondsAccumulator = 0l;
    dynamic[,] _settings = 
    {
        { null, "levelRush", true, "Level Rush"},
            {"levelRush", "lr-st", true, "Start timer when loading into the first level."},
            {"levelRush", "lr-re", true, "Reset timer when exiting or restarting rush."},
            {"levelRush", "lr-sp-l", true, "Split timer when completing a level."},
            {"levelRush", "lr-sp-c", true, "Split timer when level rush completed."},
        { null, "chapterRush", false, "Chapter Rush"},
            {"chapterRush", "cr-st", true, "Start timer when loading into a level from level select."},
            {"chapterRush", "cr-re", false, "Reset timer when exiting back to level select."},
            {"chapterRush", "cr-sp", true, "Split timer when completing a level."},
        { null, "newGame", false, "New Game"},
            {"newGame", "ng-st", true, "Start timer when pressing \"New Game\"."},
            {"newGame", "ng-re", false, "Reset timer when exiting to the main menu."},
            {"newGame", "ng-sp-l", true, "Split timer when completing a level."},
            //TODO {"newGame", "ng-sp-g", true, "Split timer when collecting a gift."},
            {"newGame", "ng-sp-c", true, "Split timer when entering credits."}
    };
    vars.Helper.Settings.CreateCustom(_settings, 4, 1, 2, 3);
}

init 
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        vars.Helper["levelRushOffsetMicroseconds"] = mono.Make<long>("Game", 1, "_instance", "_currentPlaythrough", "m_levelRushOffsetMicroseconds");
        vars.Helper["levelRushMicroseconds"] = mono.Make<long>("LevelRush", "m_currentLevelRush", "currentTimerMicroseconds");
        vars.Helper["levelPlaythroughMicroseconds"] = mono.Make<long>("Game", 1, "_instance", "_currentPlaythrough", "microseconds");
        vars.Helper["levelRushIndex"] = mono.Make<int>("LevelRush", "m_currentLevelRush", "currentLevelIndex");

        vars.Helper["filePlayTimeMicroseconds"] = mono.Make<long>("GameDataManager", "saveData", "_playTime");
        vars.Helper["mainMenuState"] = mono.Make<int>("MainMenu", "_instance", "_currentState");
        return true;
    });
}

isLoading
{
    return true;
}

gameTime
{
    if (settings["levelRush"])
    {
        if (current.levelPlaythroughMicroseconds > 0)
        {
            return TimeSpan.FromMilliseconds((current.levelRushOffsetMicroseconds + current.levelPlaythroughMicroseconds) / 1000);
        }
        else
        {
            return TimeSpan.FromMilliseconds(current.levelRushMicroseconds / 1000);
        }
    }
    else if (settings["chapterRush"])
    {
        if (current.levelPlaythroughMicroseconds < old.levelPlaythroughMicroseconds && old.mainMenuState == 0) // MainMenu.State.None
        {
            // adds the time when the player attempts but doesn't beat a level
            vars.levelPlaythroughMicrosecondsAccumulator += current.levelPlaythroughMicroseconds;
        }

        if (current.mainMenuState == 10) // MainMenu.State.Results
        {
            // adds the time when the player beats a level
            if (old.mainMenuState != 10) // MainMenu.State.Results
            {
                vars.levelPlaythroughMicrosecondsAccumulator += old.levelPlaythroughMicroseconds;
            }
            return TimeSpan.FromMilliseconds(vars.levelPlaythroughMicrosecondsAccumulator / 1000);
        }
        else
        {
            return TimeSpan.FromMilliseconds((vars.levelPlaythroughMicrosecondsAccumulator + current.levelPlaythroughMicroseconds) / 1000);
        }
    }
    else if (settings["newGame"])
    {
        return TimeSpan.FromMilliseconds(current.filePlayTimeMicroseconds / 1000);
    }
}

split
{
    if ((settings["lr-sp-l"] || settings["cr-sp"] || settings["ng-sp-l"]) && old.mainMenuState != current.mainMenuState && current.mainMenuState == 10) // MainMenu.State.Results
    {
        return true;
    }
    if (settings["lr-sp-c"] && current.mainMenuState == 27) // MainMenu.State.LevelRushComplete
    {
        return true;
    }
    if (settings["ng-sp-c"] && current.mainMenuState == 30) // MainMenu.State.Credits
    {
        return true;
    }

}

start
{
    if (settings["lr-st"] || settings["cr-st"])
    {
        vars.levelPlaythroughMicrosecondsAccumulator = 0l;
        return current.mainMenuState != old.mainMenuState && old.mainMenuState == 9; // MainMenu.State.Staging
    }
    if (settings["ng-st"])
    {
        return current.filePlayTimeMicroseconds != old.filePlayTimeMicroseconds && old.filePlayTimeMicroseconds == 0l;
    }
}

reset
{
    if (settings["lr-re"])
    {
        return current.levelRushIndex < old.levelRushIndex || current.mainMenuState == 26; // MainMenu.State.LevelRush
    }
    if (settings["cr-re"])
    {
        return current.mainMenuState == 6; // MainMenu.State.Levels
    }
    if (settings["ng-re"])
    {
        return current.mainMenuState == 1; // MainMenu.State.Main
    }
}
