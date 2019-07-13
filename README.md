# benzene-overlay
Universebenzene's own Gentoo overlay.

Including some old software that no longer supported by official portage.

To add this overlay, just run `layman -o https://raw.githubusercontent.com/Universebenzene/benzene-overlay/master/repositories.xml -f -a benzene-overlay`.

### Available packages

Package name | Available version | Additional information
------------ | :---------------: | ----------------------
media-video/gnome-mplayer | 1.0.9-r1     | Dropped by official portage
net-misc/baidupcs-go-bin  | 3.5.6        |
net-wireless/blueman      | 2.0.4; 2.1.1 | Without conflicting with net-wireless/gnome-bluetooth
