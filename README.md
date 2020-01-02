# benzene-testlay
Universebenzene's personal Gentoo overlay for testing.

Including some old software that no longer supported by official portage.

For some packages you'd better use [THIS OVERLAY](https://github.com/Universebenzene/benzene-overlay) instead.

To add this overlay, just run `layman -o https://raw.githubusercontent.com/Universebenzene/benzene-testlay/master/repositories.xml -f -a benzene-testlay`.

### Available packages

Package name | Available version | Additional information
------------ | :---------------: | ----------------------
app-text/ydcv               | 0.7            | Need the [HomeAssistantRepository](https://git.edevau.net/onkelbeh/HomeAssistantRepository) overlay if you enable `pkg-info` use. Some other issues [here](https://forums.gentoo.org/viewtopic-p-8352006.html)
media-video/gnome-mplayer   | 1.0.9-r1               | Dropped by official portage
media-gfx/gpaint            | 0.3.3                  | With patches from Debian
media-sound/pulseaudio-alsa | 2                      | Directly from [Arch](https://www.archlinux.org/packages/extra/any/pulseaudio-alsa)
net-misc/baidunetdisk       | 2.0.1; 2.0.2; 3.0.1    | Converted from [AUR](https://aur.archlinux.org/packages/baidunetdisk-bin)
net-misc/baidupcs-go        | 3.6; 3.6.1; (live)     |
net-misc/baidupcs-go-bin    | 3.6; 3.6.1             |
net-wireless/blueman        | 2.0.4; 2.1.1; 2.1.1-r1 | Without conflicting with net-wireless/gnome-bluetooth
sys-auth/elogind            | 241.3; 241.4           | Add support for shotdown & reboot under `openrc-init`, which can be controlled by that USE flag (not needed for `sys-apps/openrc[sysv-utils]>=0.42`)
x11-libs/lain               | (live version)         |
x11-misc/arch-xdg-menu      | 0.7.6.3                |
dev-python/astropy          | 3.2.3; 4.0             | Only for testing. Better use [THIS OVERLAY](https://github.com/Universebenzene/benzene-overlay#benzene-overlay) instead
dev-python/astropy-helpers  | 3.2.2; 4.0.1           | Only for testing. Better use [THIS OVERLAY](https://github.com/Universebenzene/benzene-overlay#benzene-overlay) instead
dev-python/astropy-healpix  | 0.5                    | Only for testing. Better use [THIS OVERLAY](https://github.com/Universebenzene/benzene-overlay#benzene-overlay) instead
dev-python/gwcs             | 0.12.0                 | Only for testing. Better use [THIS OVERLAY](https://github.com/Universebenzene/benzene-overlay#benzene-overlay) instead
dev-python/pyvo             | 1.0                    | Only for testing. Better use [THIS OVERLAY](https://github.com/Universebenzene/benzene-overlay#benzene-overlay) instead
