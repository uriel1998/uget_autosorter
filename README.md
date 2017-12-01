# uget_autosorter
Making uGet sort downloads into categories automagically for both Linux and Windows... and work in instances where only KGet is an option.

Jump to the [Linux instructions](https://github.com/uriel1998/uget_autosorter#linux-instructions) or the [Windows Instructions](https://github.com/uriel1998/uget_autosorter#windows-instructions)

#What This Solves

I tried out [uGet](http://ugetdm.com/) and quickly realized it was **far** more lightweight than what I'd been using, had categories like I wanted, and could integrate easily with Firefox/Iceweasel using [FlashGot](https://flashgot.net/). The problem was that certain apps I use - in particular [Liferea](https://lzone.de/liferea/) - do not support uGet. But they *do* support [KGet](https://www.kde.org/applications/internet/kget/). While KGet was good, it just felt ... bloated. And uGet feels light, snappy, and quick.

The one feature that KGet does natively that uGet does not is *automatically* sort downloads into categories. You can *specify* what categories to use, but it won't automatically detect them.

Dammit, this is linux. I'm supposed to be able to do whatever I want.

So I did.

And it turns out the solution to both was the same script file.

Back in 2012, a user named [fehhh](http://ugetdm.com/forum/memberlist.php?mode=viewprofile&u=62) [wrote a script](http://ugetdm.com/forum/viewtopic.php?f=11&t=6) that you could call first. It was later edited by [Michael Tunnell](http://ugetdm.com/forum/memberlist.php?mode=viewprofile&u=2). It relies on [wget](https://www.gnu.org/software/wget/) to determine what kind of file you're downloading. I originally added a few tweaks, then rewrote it and also created a Windows version.

Now uGet has some category matching (yay!) but Firefox Quantum has broken everything (boo!), so I resurrected this to work with an extension that seems to make things work pretty well.

#Linux Instructions

1. Set up uGet with the following categories **in this order** (though the names don't matter)
	* Home
	* Archives
	* Docs
	* Movies
	* Music
	* Images
	* Torrents

The "Home" category should point to your "main" download directory.

2. Download the [uget_preprocessor.sh](https://raw.githubusercontent.com/uriel1998/uget_autosorter/master/uget_preprocessor.sh) script.  
3. Give the script executable permissions: ```chmod a+x uget_preprocessor.sh```  
4. Make sure you don't actually have KGet installed at this point.   
5. ```sudo ln -s uget_preprocessor.sh /usr/bin/kget```  
6. Setup [Download with Wget](https://addons.mozilla.org/en-US/firefox/addon/download-with-gnu-wget/) - *including the helper application* - to use *KGet* (or the script itself) as the downloader.  
7. If there's an option for commandline options, the following are available:

* -u URL: The url to download
* -f FILENAME: The suggested filename
* -r REFERRER: Referrer link
* -c COOKIEFILE: Cookies

If no options are specified, the first parameter is assumed to be the URL to download.

8. Profit!  


# Windows Instructions  

## EDIT:  Errrrr, sorry, I'm focused on trying to make this work for me on Linux.  I've left the Windows code here, but I'm not hugely motivated to fight with it again.  


Wait! You use Windows? Guess what! You're in luck too! uGet is a portable package for Windows, so you can use it as well. The only difference is that there's two basic tools that you'll need to snag, both free and open source. (Please note that if you deviate from these instructions, you'll have to change the script; some file paths are hardcoded in the beginning.)

1. Get uGet and unzip the portable archive into ```C:\uGet```
2. Set up uGet with the following categories **in this order** (though the names don't matter)
	* Home
	* Archives
	* Docs
	* Movies
	* Music
	* Images
	* Torrents
3. Get and install the **setup** packages of [Win32 WGet](http://gnuwin32.sourceforge.net/packages/wget.htm) and [Win32 Grep](http://gnuwin32.sourceforge.net/packages/grep.htm).
4. Download the [uget_preprocessor.cmd](https://raw.githubusercontent.com/uriel1998/uget_autosorter/master/uget_preprocessor.cmd) script.  
5. Copy ```uget_preprocessor.cmd``` to ```C:\uGet```
6. Set FlashGot (or whatever other application) to use C:\uGet\uget_preprocessor.cmd as the download processor
![Setting Up FlashGot](win_preprocessor.png?raw=true "Setting up FlashGot")
7. If there's an option for commandline options, use ```[URL] --filename=[FNAME]```
8. Profit!  
