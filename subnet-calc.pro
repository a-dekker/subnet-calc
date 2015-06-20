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
    harbour-subnet-calc.png \
    qml/pages/About.qml \
    qml/pages/MainPage.qml \
    rpm/subnet-calc.spec \
    qml/pages/Popup.qml \
    qml/pages/Mask.qml \
    qml/pages/Help.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
