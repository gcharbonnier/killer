TEMPLATE = app

QT += qml quick sensors sql network positioning location
qtHaveModule(multimedia): QT += multimedia
CONFIG += c++11

lupdate_only{
SOURCES = *.qml \
          *.js \
          res/qml/component/*.qml \
          content/*.js
}

TRANSLATIONS = killer_fr.ts

SOURCES += main.cpp \
    gamemanager.cpp \
    accountmanager.cpp \
    campaignmanager.cpp \
    playermodel.cpp \
    positionlogger.cpp \
    messagemodel.cpp \
    geolocalitemsmodel.cpp \
    networkprobe.cpp

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
    positionlogger.h \
    messagemodel.h \
    gameenum.hpp \
    geolocalitemsmodel.h \
    networkprobe.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/res/values/libs.xml \
    android/build.gradle \
    res/appbar.magnify.minus.png \
    res/appbar.magnify.add.png \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS = /home/charby/Developpement/Projets/Killer/../../../Qt/5.5/android_armv7/plugins/sqldrivers/libmariadb.so
}
