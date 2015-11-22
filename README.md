# uget_autosorter
Making uGet sort downloads into categories automagically... and work in instances where only KGet is an option.


I tried out [uGet](http://ugetdm.com/) and quickly realized it was **far** more lightweight than what I'd been using, had categories like I wanted, and could integrate easily with Firefox/Iceweasel using [FlashGot](https://flashgot.net/). The problem was that certain apps I use - in particular [Liferea](https://lzone.de/liferea/) - do not support uGet. But they *do* support [KGet](https://www.kde.org/applications/internet/kget/). While KGet was good, it just felt ... bloated. And uGet feels light, snappy, and quick.

The one feature that KGet does natively that uGet does not is *automatically* sort downloads into categories. You can *specify* what categories to use, but it won't automatically detect them.

Dammit, this is linux. I'm supposed to be able to do whatever I want. 

So I did.

And it turns out the solution to both was the same script file.

Back in 2012, a user named fehhh [wrote a script](http://ugetdm.com/forum/viewtopic.php?f=11&t=6) that you could call first. It relies on [wget](https://www.gnu.org/software/wget/) to determine what kind of file you're downloading. I added a few small - but crucial - tweaks to make this all work.

#Linux Instructions

1. Set up uGet with the following categories **in this order** (though the names don't matter)
	* Home
	* Archives
	* Docs
	* Movies
	* Music
	* Packages
	* Torrents
	* ISOs
	* Images

2. Download the [uget_preprocessor.sh](https://raw.githubusercontent.com/uriel1998/uget_autosorter/master/uget_preprocessor.sh) script.  
3. Give the script executable permissions: ```chmod a+x uget_preprocessor.sh```  
4. Make sure you don't actually have KGet installed at this point.   
5. ```sudo cp uget_preprocessor.sh /usr/bin/kget```  
6. Set FlashGot (or whatever other application) to use *KGet* as the downloader.  
7. If there's an option for commandline options, use ```[URL] --filename=[FNAME]```
8. Profit!  

Please note that all the coding credit goes to [fehhh](http://ugetdm.com/forum/memberlist.php?mode=viewprofile&u=62) and [Michael Tunnell](http://ugetdm.com/forum/memberlist.php?mode=viewprofile&u=2) - I just figured out this hack and wrote up how to do it.

#Windows Instructions

Wait! You use Windows? Guess what! You're in luck too! uGet is a portable package for Windows, so you can use it as well. The only difference is that there's two basic tools that you'll need to snag, both free and open source. (Please note that if you deviate from these instructions, you'll have to change the script; some file paths are hardcoded in the beginning.)

1. Get uGet and unzip the portable archive into **C:\uGet**. 
2. Set up uGet with the following categories **in this order** (though the names don't matter)
	* Home
	* Archives
	* Docs
	* Movies
	* Music
	* Packages
	* Torrents
	* ISOs
	* Images
3. Download the [uget_preprocessor.cmd](https://raw.githubusercontent.com/uriel1998/uget_autosorter/master/uget_preprocessor.sh) script.  


 - just download the zip file and extract the zip file (C:\uGet is what I use in the example)

http://gnuwin32.sourceforge.net/packages/wget.htm
http://gnuwin32.sourceforge.net/packages/grep.htm
Run the installer
C:\Progra~1\GnuWin32\bin\wget.exe

