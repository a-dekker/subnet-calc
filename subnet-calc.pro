# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-subnet-calc

CONFIG += sailfishapp

SOURCES += src/subnet-calc.cpp

OTHER_FILES += qml/subnet-calc.qml \
    qml/cover/CoverPage.qml \
    rpm/subnet-calc.changes.in \
    rpm/subnet-calc.spec \
    translations/*.ts \
    harbour-subnet-calc.desktop \
    qml/pages/About.qml \
    qml/pages/MainPage.qml \
    qml/pages/IPv6.qml \
    rpm/subnet-calc.spec \
    qml/pages/Popup.qml \
    qml/pages/MaskIPv4.qml \
    qml/pages/MaskIPv6.qml \
    qml/pages/Help.qml

isEmpty(VERSION) {
    VERSION = $$system( egrep "^Version:\|^Release:" rpm/subnet-calc.spec |tr -d "[A-Z][a-z]: " | tr "\\\n" "-" | sed "s/\.$//g"| tr -d "[:space:]")
    message("VERSION is unset, assuming $$VERSION")
}
DEFINES += APP_VERSION=\\\"$$VERSION\\\"
DEFINES += BUILD_YEAR=$$system(date '+%Y')

icon86.files += icons/86x86/harbour-subnet-calc.png
icon86.path = /usr/share/icons/hicolor/86x86/apps

icon108.files += icons/108x108/harbour-subnet-calc.png
icon108.path = /usr/share/icons/hicolor/108x108/apps

icon128.files += icons/128x128/harbour-subnet-calc.png
icon128.path = /usr/share/icons/hicolor/128x128/apps

icon256.files += icons/256x256/harbour-subnet-calc.png
icon256.path = /usr/share/icons/hicolor/256x256/apps

INSTALLS += icon86 icon108 icon128 icon256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
