# Brick Blaster

<img src="img/BrickBlaster_banner.png" alt="Brick Blaster Banner">

## Description
This repository contains the source code of the game Brick Blaster (Media Pocket 1999) including WinEOS 4.00 Alpha and instructions on how to build it.

This game was made using a custom DOS extender called EOS (Eclipse Operating System) which was adapted to make Windows applications with DirectX support hence WinEOS.

The compiled blaster.exe from the given source code was not exactly matching the released version but the small changes have been included by comparison of disassemblies.
The differences were mainly related to the length allowed for some texts that needed to be longer for translations which also involved fixing a few coordinates values.

The unmodified game sources (including WinEOS ones) as well as EOS 3.05 and 3.06 can be found in this repository: [BrickBlaster-EOS-Archive](https://github.com/david4599/BrickBlaster-EOS-Archive)

Also, here are links to download the released game:
- French: [https://archive.org/details/brick-blaster-1999](https://archive.org/details/brick-blaster-1999)
- Spanish: [https://archive.org/details/brick-blaster-1999-spanish](https://archive.org/details/brick-blaster-1999-spanish)

## Dependencies
- Watcom 11.0B: [https://winworldpc.com/product/watcom-c-c/110b](https://winworldpc.com/product/watcom-c-c/110b)
- DirectX 6 SDK: [https://archive.org/details/directx6sdk](https://archive.org/details/directx6sdk)

To avoid conflicting with other tools (make, etc), their installation is not needed.

## Build
- Extract the following files from the Watcom 11.0b ISO located at `WATCOM_C11B\binnt` to `RESOURCE\watcom`:
  - `lib.exe` `lib386.exe` (Watcom C/C++ LIB Clone for 386 Version 11.0)
  - `link.exe` `link386.exe` (Watcom C/C++ LINK Clone for 386 Version 11.0)
  - `rc.exe` (Watcom C/C++ RC Clone for 386 Version 11.0)
  - `wcc386.exe` `wccd386.dll` (Watcom C32 Optimizing Compiler Version 11.0)
  - `wlib.exe` `wlibd.dll` (Watcom Library Manager Version 11.0)
  - `wlink.exe` `wlink.dll` (Watcom Linker Version 11.0)
  - `wpp386.exe` `wppd386.dll` (Watcom C++32 Optimizing Compiler Version 11.0)
  - `wrc.exe` (Watcom Windows Resource Compiler Version 11.0)

- Extract the following folders from the Watcom 11.0b ISO to `C:\watcom`:
  - `WATCOM_C11B\h`
  - `WATCOM_C11B\lib386`
  - `WATCOM_C11B\mfc`

- Execute the DirectX 6 SDK self-extracting archive and extract the files.

- Copy the following folders from the extracted DirectX 6 SDK files to `C:\mssdk`:
  - `DIRX6SDK.98\include`
  - `DIRX6SDK.98\lib`

- Add the Watcom and DirectX SDK environment variables (in "USER" part on Windows XP and up):
  - `WATCOM` -> `C:\watcom`
  - `DXSDKROOT` -> `C:\mssdk`
  - `INCLUDE` -> `C:\mssdk\include;C:\watcom\h;C:\watcom\h\nt;C:\watcom\mfc\include;` (make sure mssdk path is set before watcom ones)
  - `LIB` -> `C:\mssdk\lib;C:\watcom\lib386;C:\watcom\lib386\nt;`

- Open `cmd.exe` (or `command.com` for Windows 98 or less) and run: `build.bat make complete` (see help by running `build.bat help` for more build options).

- The built game is now located at `Blaster\pack` and ready to be launched :)

## Patches
These following patches were made in the source files to be able to run the game on recent Windows versions:
- In FILE.ASM, `Init_File` routine: `mov ecx,800h` was replaced by `mov ecx,8000h`.
  - Issue: This routine searches and saves the full path of blaster.exe which is stored just after the environment variables list in memory.
    To be able to get this path, the routine gets the env vars list's beginning and runs through it until reaching a null word i.e. the end.
    [Due to how worked old Windows versions](http://web.archive.org/web/20071020044153/http://support.microsoft.com/kb/906469), a limit of 2048 characters was set in the list counting loop and the game exits if this limit is exceeded.
    On a fresh Windows installation, this will not be an issue but installing apps will grow the list and the limit will be reach (see result of `set` in a command prompt).
  - Solution: Setting an arbitrary higher limit e.g. 32768 (0x8000) does the job.
- In MAIN.ASM, `init_random` routine: `out 70h,al` and `in al,71h` (2 occurrences each) were commented.
  - Issue: For initializing the random number generator (RNG) used in several parts in the game, the I/O instructions `in` and `out` were used to talk directly to the hardware and retrieve the current number of seconds in the CMOS RTC.
    These instructions are called privileged and are not accessible to the user on modern Windows versions.
    If used, they will crash the game and throw a Privileged Instruction Exception (0xC0000096).
  - Solution: Since these instructions are used only for the RNG which is not critical in the game, they can be simply commented.
    However, instead of altering the RNG, another solution would be to enable the `Windows 98 / Windows Me` compatibility mode in blaster.exe properties (actually discovered after making the patch).


## Compatibility issues
- When launching Brick Blaster in VMware (and maybe other virtualization softwares), 3D acceleration in the virtual machine's display settings may need to be enabled.
  Otherwise, the game may crash with an Access Violation Exception (0xC0000005).
  Using dxdiag.exe, under Display tab -> Drivers, check if the DDI version is a number.
  If "unknown" is displayed, try to enable the 3D acceleration.

- For Windows Vista and up, color problems may happen. In this case, under blaster.exe properties -> Compatibility tab, tick these checkboxes:
  - Run in 256 colors
  - Run in 640 x 480 screen resolution
  - Disable desktop composition

## Notes
- Some required tools (installed in `RESOURCE` folder) have already been included to simplify the building steps:
  - `diet.exe` (Version 1.45f) from EOS 3.05 or 3.06 (`Eos305\RESOURCE` or `Eos306\RESOURCE`)
  - `make.exe` (Version 5.2) from Borland C++ 5.5 - (`Borland C++\Borland\BCC55\Bin`)
  - `tasm32.exe` (Version 5.0) from Borland Turbo Assembler (`Borland Turbo Assembler 5.0 (3.5-1.44mb)\disk02.img\CMD32.PAK` (img and pak files can be opened with 7zip))
  - `msdos.exe` (MS-DOS Player for Win32-x64, Version ia32_x86, 7/1/2022), for running 16-bit diet.exe and llink.exe under recent Windows versions

- The sounds, musics and videos were made in file formats that are less commonly used nowadays but they can be read with these softwares:
  - IFF sounds: [Fasttracker II clone](https://16-bits.org/ft2.php). To play them at the correct tone/speed, in the bottom-left corner of the sample editor, change the key to G#4.
  - MOD musics: [OpenMPT](https://openmpt.org/). Some effects need to be tweaked. Go to View tab -> Setup -> Mixer tab and set the "Resampling Filter" option to "No interpolation". Also, set the "Stereo Separation" to 200%.
  - FLC videos: VLC player works even though blaster.flc seems to be not well decoded and plays poorly.

- The built version is in French but the files `Blaster\Blaster_en.cfg` and `Blaster\Blaster_es.cfg` contain the translations for English and Spanish languages.
  For instance, to change to English language, simply rename `Blaster\Blaster.cfg` to e.g. `Blaster\Blaster_fr.cfg` and `Blaster\Blaster_en.cfg` to `Blaster\Blaster.cfg`.

- Build and execution are compatible from Windows 95 to Windows 11.

## Credits
- Members of the [Eclipse](https://www.eclipse-game.com) demomaker team:
  - Rez (Christophe Résigné) - Musics
  - Profil (Frédéric Box) - Graphics
  - Hacker Croll (Marc Radermacher) - Code (Brick Blaster + WinEOS)
  - Light Show (Régis Vidal) - Code (WinEOS)
- Video game company [Carapace](https://www.abandonware-france.org/compagnies/carapace-82/) (Softplace)
- Video game publisher [Media Pocket](https://www.abandonware-france.org/compagnies/media-pocket-1019/)

## Acknowledgments
A big thanks to the author Marc Radermacher ([website](https://www.edromel.com)) for kindly providing the source code of this awesome game and allowing to preserve it!

#
david4599 - 2024
