if not exist Output mkdir Output
if not exist Output\html mkdir Output\html
if not exist Output\icons mkdir Output\icons
if not exist Output\scripts mkdir Output\scripts
if not exist Output\styles mkdir Output\styles
REM: if not exist Output\media mkdir Output\media
copy "%DXROOT%\Presentation\hana\icons\*" Output\icons
copy "%DXROOT%\Presentation\hana\scripts\*" Output\scripts
copy "%DXROOT%\Presentation\hana\styles\*" Output\styles
if not exist Intellisense mkdir Intellisense

