Text For Teh Win

A stupid name for a simple thing.

Edit text from any GUI object in Windows via a text editor 
(currently defaults to notepad, but can be configured in 
%USERPROFILE%\\.config\text-for-teh-win\config.ini).

Run tftw.exe.
Hit Windows-v to edit the current panel in your chosen editor.
Hit Windows-Shift-v to cancel a paste.
Hit Windows-z to exit tftw.

This currently has basic funcionality.
There is no copy / paste customization for different window types,
and other niceties are missing. See the TODO file for some thoughts.

Customize editor behavior for different target window types by putting editor
configurations in 
%USERPROFILE%\\.config\text-for-teh-win\\{EDITOR}\.
There are folders for class, process, and title. 
A few samples have been provided for gvim.

If you use emacs, be sure to use emacs.exe, not runemacs.exe.
The editor needs to not return an exit status until you have quit.

There is a 
[home page](http://www.birnel.org/~noah/software/text-for-teh-win/index.html),
where you can get an installer.
