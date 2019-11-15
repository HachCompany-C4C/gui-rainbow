TEMPLATE = app

QMAKE_CXXFLAGS += -std=gnu++0x

//QT += charts dbus qml quick widgets
QT += dbus qml quick widgets


DBUS_INTERFACES += utilities/messageoutput.xml
DBUS_ADAPTORS += utilities/termserver.xml


DEFINES +=TORATEX_TS

CONFIG += qmltestcase

CODECFORTR = UTF-8

SOURCES += main.cpp \
    utilities/systime.cpp \
    utilities/common.cpp \
    utilities/upgrade.cpp \
    utilities/logexport.cpp \
    utilities/translator.cpp \
    utilities/backlight.cpp \
    utilities/networkinterface.cpp \
    utilities/mouseevent.cpp \
    application.cpp \
    utilities/settings.cpp \
    utilities/panelleds.cpp \
    utilities/file.cpp \
    utilities/fb2bmp.cpp \
    ts_cali/calibration.cpp \
    utilities/udiskdectect.cpp \
    utilities/commterminal.cpp \
    utilities/connection.cpp \
    utilities/execscript.cpp \
    utilities/terminalserver.cpp \
    utilities/messageoutput.cpp \
    utilities/logstring.cpp \
    utilities/gpio.cpp \
    utilities/rtcdetect.cpp \
    utilities/watchdog.cpp \
    utilities/password.cpp \
    utilities/socversion.cpp


RESOURCES += qml.qrc

CONFIG += link_pkgconfig

//PKGCONFIG += glibtop-2.0

# Additional import path used to resolve QML modules in Qt Creator's code model
# QML_IMPORT_PATH =

# Default rules for deployment.
# include(deployment.pri)

TARGET = rainbow-ui

target.path = /home/root/probe/cpp/ui
INSTALLS += target

HEADERS += \
    utilities/systime.h \
    utilities/common.h \
    utilities/upgrade.h \
    utilities/logexport.h \
    utilities/translator.h \
    utilities/backlight.h \
    utilities/networkinterface.h \
    utilities/mouseevent.h \
    application.h \
    utilities/settings.h \
    utilities/panelleds.h \
    utilities/file.h \
    utilities/fb2bmp.h \
    ts_cali/calibration.h \
    utilities/udiskdectect.h \
    utilities/commterminal.h \
    utilities/connection.h \
    utilities/execscript.h \
    utilities/terminalserver.h \
    utilities/messageoutput.h \
    utilities/logstring.h \
    utilities/gpio.h \
    utilities/rtcdetect.h \
    utilities/watchdog.h \
    utilities/password.h \
    utilities/socversion.h


DISTFILES += \
    README.md \
    probe/probe_pages \
    utilities/messageoutput.xml

TRANSLATIONS += language/rainbow_zh.ts \
                language/rainbow_en.ts

if(contains(DEFINES,PC_X86)) {
    message("compile for PC")
    LIBS +=  -L$$PWD/probeinterface/release/lib/x86 -lprobeinterface -lcrypt
    INCLUDEPATH += $$PWD/probeinterface/
    DEPENDPATH += $$PWD/probeinterface/
}
else {
    if(contains(DEFINES,TORADEX_ARM)) {
        message("run build-tslib.sh(script/build-tslib.sh) to generate tslib library")
        message("compile for toradex, add tslib v1.14")
        HEADERS += \
        ts_cali/config.h \
        ts_cali/fbutils.h \
        ts_cali/font.h \
        ts_cali/testutils.h \
        ts_cali/ts_tool.h

        SOURCES += \
        ts_cali/fbutils-linux.c \
        ts_cali/testutils.c

        LIBS += -L $$PWD/../tslib-src/build/lib -lts -lsystemd -lcrypt
        LIBS += -L$$PWD/probeinterface/release/lib/arm -lprobeinterface
        INCLUDEPATH += $$PWD/../tslib-src/build
        INCLUDEPATH += $$PWD/../tslib-src/build/include
        INCLUDEPATH += $$PWD/probeinterface/
        DEPENDPATH += /usr/lib
    }
    else {
        message("for yocto building, add tslib v1.14")
        HEADERS += \
        ts_cali/config.h \
        ts_cali/fbutils.h \
        ts_cali/font.h \
        ts_cali/testutils.h \
        ts_cali/ts_tool.h

        SOURCES += \
        ts_cali/fbutils-linux.c \
        ts_cali/testutils.c

        LIBS +=  -lts -lsystemd -lcrypt
        INCLUDEPATH += /usr/lib/ts
        INCLUDEPATH += /usr/lib/include
        DEPENDPATH += /usr/lib
    }
} 
