; From:
; http://vim.wikia.com/wiki/Use_gvim_as_an_external_editor_for_Windows_apps

; Documentation {{{1

; Name: vimedit
; Version: 1.0
; Description:
; Author: Alexandre Viau (alexandreviau -at- gmail.com)
; Website:

; About {{{2
; Used to copy text from an application to vim for edition and then from vim
; (edited text) back to the application.
; Installation {{{2
; Usage {{{2
; Tips {{{2
; Todo {{{2
; - checker que le win+alt+; fonctionne, il semble que n'a pas fonctionne une fois
; Bugs {{{2
; - Sometimes the ctrl-; dosen't work and it is not the correct text that is
; pasted or it is emptied and vim says nothing in register *
; History {{{2

winId =
; Mapping: Edit all text {{{1
; ctrl-;
^`;::
    VimEditAll = True ; Edit tout le text
    VimEditLine = False ; Edit la ligne en cours
    ClipAdd = False
    Gosub, VimEdit
    Sleep 200 ; Le sleep est necessaire sinon ca copie les clips de vimedit...
              ; si ca copie les clip de vimedit augmenter cette valeur
    ClipAdd = True
return
; Mapping: Edit current line {{{1
; NOTE: C'est plus fiable d'utilise EditLine pour les textbox (search box,
; address box, etc) car la selection ne se fait pas avec ^a qui fonctionne
; pas tout le temps dans les textbox.
; NOTE2: Pour que ca fonctionne bien dans le run box et le address box de
; windows explorer, etre certain d'etre en insert mode sinon le +Space va faire un +Tab
; ctrl-shift-;
^+`;::
    VimEditAll = False ; Edit tout le text
    VimEditLine = True ; Edit la ligne en cours.
    ClipAdd = False
    Gosub, VimEdit
    Sleep 200
    ClipAdd = True
return
; Mapping: Edit selected text {{{1
; win-alt-;
#!`;::
    VimEditAll = False ; Edit seulement le text selectionne
    VimEditLine = False ; Edit la ligne en cours
    ClipAdd = False
    Gosub, VimEdit
    Sleep 200
    ClipAdd = True
return

; Sub: VimEdit {{{1
; Cette fonction sert a copier du text d'une application vers vim ou de vim
; vers un app. pour editer dans vim et ramener le text dans l'application.
; Avec notepad ca semble cree des ligne vide a la fin, mais pas avec word
; pad alors, et je ne sais pas pour les autres applications...alors laisser
; ca comme ca, ca ne le fait pas lorsque c'est une selection mais quand
; c'est tout le text qui est selectionne
VimEdit:
    ClipboardBak := Clipboard
    Clipboard =
    IfWinNotActive, ahk_class Vim
    {
        ; Direction 1 - Copy from another application {{{2
        winId := WinExist("A")
        if VimEditAll = True
        {
            Send ^{Home}
            Send ^+{End}
        }
        if VimEditLine = True
        {
            Send {Home}
            Send +{End}
        }
        Send ^{Ins}

        ; Direction 1 - Paste in vim {{{2
        IfWinNotExist, ahk_class Vim
        {
            Run, gvim.exe --servername GVIM ; gvim must be in the %PATH%
            WinWait, ahk_class Vim
        }
        WinActivate, ahk_Class Vim
        Send +`;
        ;Send {Raw}enew!
        Send {Raw}tabnew
        Send {Enter}
        Send {Raw}"*P
        Send {Raw}gg
        Send {Raw}zR ; Remove fold
    }
    else
    {
        ; Direction 2 - Copy from vim {{{2
        if VimEditAll = True
        {
            Send {Escape}
            Send {Raw}gg
            Send {Raw}V
            Send {Raw}G
        }
        else if VimEditLine = True
        {
            Send {Escape}
            Send {Raw}V
        }
        else ; Selected text only: when we paste back we copy all edited block.
             ; Selected text is only the selected text from the application, not from vim
        {
            Send {Escape}
            Send {Raw}gg
            Send {Raw}V
            Send {Raw}G
        }
        Send {Raw}"*Y
        Send +`;
        Send {Raw}close!
        Send {Enter}

        ; Direction 2 - Paste to another application {{{2
        WinActivate, ahk_id %winId%
        if VimEditAll = True
        {
            Send ^{Home}
            Send ^+{End}
        }
        if VimEditLine = True
        {
            Send {Home}
            Send +{End}
        }
        Send +{Ins}
        ;Send {Backspace} ; trouver moyen de detecter s'il y a un \r\n a la fin
                          ; de la ligne et le supprimer si oui
        if VimEditAll = True
            Send ^{Home}
        if VimEditLine = True
            Send {Home}

    } ;}}}
    Clipboard := ClipboardBak
return
