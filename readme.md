# Neon White Autosplitter

The accompanying `neonwhite.asl` file is an autosplitter for Neon White. This autosplitter makes speedruns easier by hooking into the Neon White process and automatically tracking individual level times.

## Important Information!!!

* The autosplitter **only supports Level Rushes.**
    * This is because Level Rushes are the only place the game keeps a cumulative timer that the autosplitter can sync with.
* The autosplitter supports **all 5 Level Rushes** in both Heaven and Hell mode.
    * The autosplitter **does not** support the "shuffle" option on Level Rushes.
* The autosplitter will automatically start/reset the timer when a Level Rush starts / is reset.
* The autosplitter supports both RTA ("Real Time Attack") and IGT ("In Game Time"). Although IGT will be used for leaderboards, you can choose which one to compare in LiveSplit:
    * Right-click on LiveSplit > "Compare Against" > "Real Time" / "Game Time"

## Setup

There are two ways to install the autosplitter: **automated** and **manual**.

### Automated Install (DOES NOT WORK CURRENTLY)

Here is how to automatically add the Neon White autosplitter to your LiveSplit setup:
1. Right-click on LiveSplit, then select "Edit Splits..."
2. Under "Game Name", select "Neon White"
3. Under "Run Category", select your desired category
4. If an autosplitter is available for that category, click "Activate"

### Manual Install

Here is how to manually add the Neon White autosplitter to your LiveSplit setup:
1. Download the `neonwhite.asl` file to your computer
2. Right-click on LiveSplit, then select "Edit Layout..."
3. Click the plus button to add an item to your LiveSplit layout, then choose "Control > Scriptable Auto Splitter"
4. Double-click the newly-created "Scriptable Auto Splitter" entry to open its settings
5. Fill in the "Script Path" box with the location where you saved the `neonwhite.asl` file

### Adding Splits

For your convenience, the [`/livesplit`](https://github.com/crashb/neon-white-autosplitter/tree/main/livesplit) folder of this repository contains empty split files which are pre-populated with split names.

## Performing a Run

Here is how to perform a run with the autosplitter:
1. Start LiveSplit and Neon White.
2. Ensure that Level Rushes are unlocked; if they are, click on "Level Rush" at the main menu.
3. Select a Level Rush and a Heaven/Hell mode. Ensure that the "Shuffle" option is **not** selected.
4. Click on "Start Rush" and play the Level Rush.
5. After completing the final level, click "**Back to Level Rush**" to trigger the final split and stop the timer.