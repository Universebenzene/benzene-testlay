# benzene-overlay
Universebenzene's own Gentoo overlay.

Including some old software that no longer supported by official portage.

To add this overlay, just run `layman -o https://raw.githubusercontent.com/Universebenzene/benzene-overlay/master/repositories.xml -f -a benzene-overlay`.

### Available packages

Package name | Available version | Additional information
------------ | :---------------: | ----------------------
app-text/ydcv             | 0.7          | Need the [HomeAssistantRepository](https://git.edevau.net/onkelbeh/HomeAssistantRepository) overlay if you enable `pkginfo` use. Some other issues [here](https://forums.gentoo.org/viewtopic-p-8352006.html)
media-video/gnome-mplayer | 1.0.9-r1     | Dropped by official portage
media-gfx/gpaint          | 0.3.3        | With patches from Debian
net-misc/baidunetdisk     | 2.0.1; 2.0.2 | Converted from [AUR](https://aur.archlinux.org/packages/baidunetdisk-bin)
net-misc/baidupcs-go      | 3.5.6        |
net-misc/baidupcs-go-bin  | 3.5.6        |
net-wireless/blueman      | 2.0.4; 2.1.1 | Without conflicting with net-wireless/gnome-bluetooth
