Rainbow UI
==========

Introduction
------------

Rainbow ui is a Qt/QML-base ui application of the instrument for water quality monitoring. A graphical user interface allows easy operation for the instrument.

It is dependent on dbus and runs both on ARM and x86 platform.

Requirements
------------

- Qt5
- GCC
- DBUS
- tslib
- libcrypt

Building
--------

1. Build main ui program, Add argument DEFINES+=TORADEX_ARM to compile binary for ARM platform, in the same way, DEFINES+=PC_X86 for x86 Platform.

		$qmake rainbow-ui.pro -spec linux-oe-g++ DEFINES+=TORADEX_ARM

		$make

2. Run

- run on local

		$./rainbow-ui -local

- run by remote

		$./rainbow-ui -tcp ipaddress

License
-------

This package is released under [GPLv3](https://opensource.org/licenses/GPL-3.0)
