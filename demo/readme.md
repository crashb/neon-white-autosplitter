# Neon White Autosplitter

The accompanying `neonwhite.asl` file is an autosplitter for Neon White. It makes speedruns easier by hooking into the Neon White process and automatically timing your splits.

## Important Information!!!

* When using IGT, there may be small discrepancies between your level time in LiveSplit and your level time in the game (up to 2/100 of a second).
    * These discrepancies are because of how the game keeps track of time internally.
* The autosplitter assumes you are **NOT** playing on a new file. **Play on a save file with the 18 main missions already unlocked.**
* The autosplitter uses both RTA ("Real Time Attack") and IGT ("In Game Time"). You can choose which one to compare in LiveSplit:
    * Right-click on LiveSplit > "Compare Against" > "Real Time" / "Game Time"

This autosplitter is subject to change depending on the community's needs.

## Setup

There are two ways to install the autosplitter: **automated** and **manual**.

### Automated Install

Here is how to automatically add the Neon White autosplitter to your LiveSplit setup:
1. Right-click on LiveSplit, then select "Edit Splits..."
2. Under "Game Name", select "Neon White" / "Neon White Demo"
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

Here's a list of every level in the Neon White demo:

| Demo Levels |
|---|
| 01 Movement |
| 02 Pummel |
| 03 Gunner |
| 04 Cascade |
| 05 Elevate |
| 06 Bounce |
| 07 Purify |
| 08 Climb |
| 09 Fasttrack |
| 10 Glass Port |
| 11 Godspeed |
| 12 Dasher |
| 13 Thrasher |
| 14 Guardian |
| 15 Jumper |
| 16 Hanging Gardens |
| 17 Barrage |
| 18 Streak |

Here is how to add these levels as splits in LiveSplit:
1. Copy the contents of the list above (from "01 Movement" to "18 Streak")
2. Right-click on LiveSplit, then click "Edit Splits..."
3. Paste the list into the "Segment Name" column in LiveSplit

## Performing a Run

Here is how to perform a run with the autosplitter:
1. Start LiveSplit and the Neon White Demo.
2. Load a completed save file and navigate to Heaven's Gate > Visit Job Archive > Rebirth > Movement.
3. Complete each level in the demo and click "Play Next Level" after each one. **DO NOT** click "Return to Job Archive" or "Back to Hub" except at the very end of the run.
4. After completing the final level, click "Return to Job Archive" or "Go to Hub" to trigger the final split and stop the timer.

## Further Considerations

This autosplitter works for the Demo version of Neon White released as part of the 2021 Steam Next Fest. This autosplitter will need updates to be compatible with future versions of the game.

The autosplitter will only ever be available on PC - not on the upcoming Nintendo Switch version of the game.