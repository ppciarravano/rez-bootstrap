# rez-bootstrap
Rez Bootstrap with Gcc, Python and CMake for VFX Reference Patform 2021/2022

To build and install, just run:
```
./bootstrap.sh
```

Requirements:
```
dnf group install "Development Tools"

dnf install \
bzip2 \
flex \
fontconfig \
freeglut \
freetype \
gdbm \
libffi \
libnsl \
libnsl2 \
libtirpc \
libuuid \
libxcb \
libXcursor \
libXi \ 
libXinerama \ 
libxkbcommon \ 
libxkbcommon-x11 \
libXrandr \
libXScrnSaver \
libXxf86vm \
mesa-libGLU \
openssl \
openssl3-libs \
openssl-libs \
readline \
sqlite \
xcb-util \
xcb-util-cursor \
xcb-util-keysyms \
xcb-util-renderutil \
xcb-util-wm \
\
bzip2-devel \
fontconfig-devel \
freeglut-devel \
freetype-devel \
gdbm-devel \
libffi-devel \
libtirpc-devel \
libuuid-devel \
libxcb-devel \
libXcursor-devel \
libXi-devel \
libXinerama-devel \
libxkbcommon-devel \
libxkbcommon-x11-devel \
libXrandr-devel \
libXxf86vm-devel \
mesa-libGLU-devel \
openssl-devel \
readline-devel \
sqlite-devel \
xcb-util-cursor-devel \
xcb-util-devel \
xcb-util-keysyms-devel \
xcb-util-renderutil-devel \
xcb-util-wm-devel \
uuid-devel \
libsqlite3-devel \
libsq3-devel

dnf install --enablerepo=powertools install libnsl2-devel
dnf install --enablerepo=powertools install openssl3-devel
dnf --enablerepo=powertools install libxkbcommon-x11-devel xcb-util-devel xcb-util-cursor-devel xcb-util-keysyms-devel xcb-util-renderutil-devel xcb-util-wm-devel freetype freetype-devel

```
