Text For Teh Win

A stupid name for a simple thing.

Edit text from any GUI object in Windows via a text editor 
(currently hard-coded to gvim, but can be configured in 
%USERPROFILE%\\.config\text-for-teh-win\config.ini).

Run tftw.exe.
Hit Windows-v to edit the current panel in your chosen editor.
Hit Windows-z to exit tftw.

This currently has basic funcionality.
There is no installer, and no post-hooks.

Customize editor behavior for different target window types by putting editor
configurations in 
%USERPROFILE%\\.config\text-for-teh-win\\{EDITOR}\.
There are folders for class, process, and title. 
A few samples have been provided for gvim.

If you use emacs, be sure to use emacs.exe, not runemacs.exe.
The editor needs to not return an exit status until you have quit.
