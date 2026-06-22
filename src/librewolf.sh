export SQLITE_WEB_BROWSER=$(command -v lbrewolf)
export BROWSER=$(command -v lbrewolf)

xdg-mime default librewolf.desktop x-scheme-handler/http
xdg-mime default librewolf.desktop x-scheme-handler/https
xdg-mime default librewolf.desktop x-scheme-handler/ftp
xdg-mime default librewolf.desktop x-scheme-handler/about
xdg-mime default librewolf.desktop x-scheme-handler/unknown
xdg-mime default librewolf.desktop x-scheme-handler/mailto
xdg-mime default librewolf.desktop x-scheme-handler/webcal
xdg-mime default librewolf.desktop x-scheme-handler/ms-outlook
xdg-mime default librewolf.desktop x-scheme-handler/msteams
xdg-settings set default-web-browser librewolf.desktop

