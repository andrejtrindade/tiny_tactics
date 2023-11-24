# tiny_tactics
 Turn-based tactics / puzzle game for PICO-8

## Where to play
 You can play the game or download the cart at the [Lexaloffle BBS](https://www.lexaloffle.com/bbs/).
 
## Postmortem
 You can read about my experience developing Tiny Tactics at this [Blog post](https://www.lexaloffle.com/bbs/).
 
## PICO-8
 If you want to know more about PICO-8, check the [PICO-8 landing page](https://www.lexaloffle.com/pico-8.php) or its [FAQ](https://www.lexaloffle.com/pico-8.php?page=faq).
 
## Pull requests
 This project is mostly done and uses over 99% of the available tokens and compressed size for a PICO-8 cart. Therefore, I'm not accepting pull requests for this one.
 
## Files and Folders
 - **tiny_tactics.p8**: PICO-8 source is a single, plain text file, containing graphics, sound and code (which, in this case, only `#include`s some lua files from the folder below).
 - **inc**: the lua files included in the .p8 file. The project was structured this way so that the code was better organized and editable in an external editor, outside PICO-8. Lua files were creted in Notepad++.
 - **exports**
   - **cart/tiny_tactics.p8.png**: image with the compressed cartridge embedded into it, playable in PICO-8.
   - **html**: standalone HTML version
   - **bynary apps**: executable versions for Windows, Mac, Linux and Raspberry Pi
   - **map and sprites** (useful for revieing level layouts)
 - **test_cdata**: save states used for testing the alternative skin reward
 
 ## Cartridge Data
  Cartridge data is how PICO-8 persists your progress. 
  - If you are using PICO-8 or the binary app in Windows, for example, a text file is saved in `C:\Users\[username]\AppData\Roaming\pico-8\cdata\tiny_tactics'.
  - If you are playing on a browser (either on Lexaloffle BBS or using the standalone HTML version), data is saved on the browser's local storage.
 