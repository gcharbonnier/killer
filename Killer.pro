TEMPLATE = app

QT += qml quick sensors sql network positioning location
qtHaveModule(multimedia): QT += multimedia
CONFIG += c++11

SOURCES += main.cpp \
    gamemanager.cpp \
    accountmanager.cpp \
    campaignmanager.cpp \
    playermodel.cpp \
    positionlogger.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    gamemanager.h \
    accountmanager.h \
    campaignmanager.h \
    playermodel.h \
    gamedata.h \
    positionlogger.h


    ANDROID_EXTRA_LIBS = \
        $$PWD/../../../../Qt/5.4/android_armv7/plugins/sqldrivers/libmariadb.so

DISTFILES += \
    android/AndroidManifest.xml \
    android/res/values/libs.xml \
    android/build.gradle

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
