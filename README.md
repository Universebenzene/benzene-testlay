# benzene-testlay
Universebenzene's personal Gentoo overlay for testing.

Including some old software that no longer supported by official portage.

For some packages you'd better use [THIS OVERLAY](https://github.com/Universebenzene/benzene-overlay) instead.

To add this overlay, just run `layman -o https://raw.githubusercontent.com/Universebenzene/benzene-testlay/master/repositories.xml -f -a benzene-testlay`.

### Available packages

Package name | Available version | Additional information
------------ | :---------------: | ----------------------
app-i18n/fcitx               | 4.2.9.8-r1; 5.1.6; 5.1.7       | Use patch from [@bekcpear](https://github.com/bekcpear) to let fcitx:5 not to be conflict with :4; also modify icons name for fcitx:4
app-i18n/fcitx-chinese-addon | 5.1.0-r1; 5.1.1; 5.1.2; (live) | Change icon name to install along with fcitx:4 (need more testing)
app-i18n/fcitx-table-extra   | 0.3.8-r1; 5.0.13; 5.1.3        | Change icon name to install along with slot 4 (need more testing)
app-i18n/fcitx-table-other   | 5.0.11; 5.1.1;                 | Change icon name to install along with slot 4 (need more testing)
app-portage/repoman          | 3.0.3-r2                       | Dropped by official portage
app-text/ydcv                | 0.7                            | Need the [HomeAssistantRepository](https://git.edevau.net/onkelbeh/HomeAssistantRepository) overlay if you enable `pkg-info` use. Some other issues [here](https://forums.gentoo.org/viewtopic-p-8352006.html)
media-video/gnome-mplayer    | 1.0.9-r1                       | Dropped by official portage
media-gfx/gpaint             | 0.3.3                          | With patches from Debian
media-sound/pulseaudio-alsa  | 2                              | Directly from [Arch](https://www.archlinux.org/packages/extra/any/pulseaudio-alsa) (Not needed as I have switched completely to PA)
net-misc/baidunetdisk        | 2.0.1; 2.0.2; 3.0.1            | Converted from [AUR](https://aur.archlinux.org/packages/baidunetdisk-bin)
net-misc/baidupcs-go         | 3.6; 3.6.1; (live)             |
net-misc/baidupcs-go-bin     | 3.6; 3.6.1                     |
net-misc/sunloginclient      | 11.0.1.44968{,-r1}             | CANNOT PROPERLY WORK ON GENTOO WITH OPENRC YET. More tests are needed.
net-wireless/blueman         | 2.0.4; 2.1.1-r1; 2.1.2         | Without conflicting with net-wireless/gnome-bluetooth
sys-auth/elogind             | 241.3; 241.4                   | Add support for shotdown & reboot under `openrc-init`, which can be controlled by that USE flag (not needed for `sys-apps/openrc[sysv-utils]>=0.42`)
x11-libs/lain                | (live version)                 |
x11-misc/arch-xdg-menu       | 0.7.6.3                        |
dev-python/astropy           | 3.2.3; 4.0                     | Only for testing. Better use [THIS OVERLAY](https://github.com/Universebenzene/benzene-overlay#benzene-overlay) instead
dev-python/astropy-helpers   | 3.2.2; 4.0.1                   | Only for testing. Better use [THIS OVERLAY](https://github.com/Universebenzene/benzene-overlay#benzene-overlay) instead
dev-python/astropy-healpix   | 0.5                            | Only for testing. Better use [THIS OVERLAY](https://github.com/Universebenzene/benzene-overlay#benzene-overlay) instead
dev-python/gwcs              | 0.12.0                         | Only for testing. Better use [THIS OVERLAY](https://github.com/Universebenzene/benzene-overlay#benzene-overlay) instead
dev-python/pyvo              | 1.0                            | Only for testing. Better use [THIS OVERLAY](https://github.com/Universebenzene/benzene-overlay#benzene-overlay) instead
dev-python/reproject         | 0.6                            | Only for testing. Better use [THIS OVERLAY](https://github.com/Universebenzene/benzene-overlay#benzene-overlay) instead
