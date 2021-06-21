# HOW TO INSTALL CHARACTER BUILDER (FOR DUMMIES)

This is a manual installation guide for the D&D 4e Character Builder by Wizards of the Coast.
It is recommended that you discard these instructions and read the README instead.
You should only follow these steps if install_cb.bat has failed to install.
However, saying that, these instructions are almost guaranteed to work.

`INSTALL_DIRECTORY` = C:\Program Files (x86)\Wizards of the Coast\Character Builder
Change this to wherever you want to install the Character Builder.

## DIRECTIONS
1. Make sure you've read ALL of the text above.
    - If you continue without doing so, you really are a dummy.
1. Download everything in the /repository directory to some working folder on your computer.
1. Right click `CharacterBuilderInstaller.exe` > Run as administrator.
    - Install to `INSTALL_DIRECTORY`.
    - Do NOT run the Character Builder!
1. Right click `CharacterBuilderUpdateAug2010.exe` > Run as administrator.
    - Install to `INSTALL_DIRECTORY`.
    - If Windows tells you that you need the .NET framework, do as it says, but wait until it's finished before moving onto the next step!
1. Right click `CharacterBuilderUpdateOct2010.exe` > Run as administrator.
    Install to `INSTALL_DIRECTORY`.
1. Extract "CBLoader.zip" to `INSTALL_DIRECTORY`.
1. Copy "WotC.index" to `INSTALL_DIRECTORY\Custom`.
    1. Open `parts.zip`.
    1. Copy all the files from the `sorted` directory into `INSTALL_DIRECTORY\Custom`.
    1. Copy all the files from the `parts` directory into `INSTALL_DIRECTORY\Custom`.
1. Open `INSTALL_DIRECTORY` in Windows File Explorer. Shift + Right Click in a blank space > "Open a command window here".
1. Type the following command into the command window and then press enter: `CBLoader.exe -a -n -d -e && exit`
    - This will set up the Character Builder, but you can continue following these instructions.
1. Right click `CBLoader.exe` > Send to > Desktop (create shortcut).
1. Delete the "Character Builder" shortcut on your desktop.
    1. Rename "CBLoader.exe - Shortcut" to "Character Builder".
    1. Right click the "Character Builder" shortcut > Properties.
    1. In the "Target" box, put `-d -F` at the end.
1. Open the Start Menu and search "Character Builder".
    1. Right click "Character Builder" > Open file location.
    1. Delete everything in the folder except the uninstall utility.
    1. Copy "Desktop\Character Builder" shortcut to this folder.
1. Wait for the command window that was opened in step 9 to disappear.
1. Installation is now fully complete, you may now use the Character Builder.

NOTES:
- Only ever run `CBLoader.exe -d -F`, or the shortcuts you created in steps 10-12. Do not run any other executable file relating to the Character Builder.
- You can change INSTALL_DIRECTORY to a different path, but make sure you use only that path.
- By default, your characters will be saved in "My Documents\ddi\Saved Characters".
- To uninstall, use the uninstall utility in the Start Menu folder. Then:
    1. Delete the Start Menu folder and desktop shortcut.
    1. Then remove the following folders manually:
        - `%appdata%\CBLoader`
        - `%localappdata%\Wizards_of_the_Coast`
        - `My Documents\builder_known_files.txt`
    - Note that you may have characters saved in `My Documents\ddi`.
    - It is recommended to back up all `.dnd4e` files, then remove this folder to complete uninstallation.
