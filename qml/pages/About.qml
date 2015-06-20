import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        VerticalScrollDecorator {
        }

        Column {
            id: col
            spacing: Theme.paddingLarge
            width: parent.width
            PageHeader {
                title: qsTr("About")
            }
            SectionHeader {
                text: qsTr("Info")
            }
            Rectangle {
                color: "#999999"
                x: Theme.paddingLarge * 3
                width: parent.width - Theme.paddingLarge * 3 * 2
                height: 2
                anchors.leftMargin: 20
                anchors.topMargin: 30
            }
            Label {
                text: "subnet-calc"
                font.pixelSize: Theme.fontSizeExtraLarge
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: "/usr/share/icons/hicolor/86x86/apps/harbour-subnet-calc.png"
            }
            Label {
                text: qsTr("Version") + " " + version
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryHighlightColor
            }
            Label {
                text: qsTr("Calculate IPv4 subnet related values")
                font.pixelSize: Theme.fontSizeSmall
                width: parent.width
                horizontalAlignment: Text.Center
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                color: Theme.secondaryColor
            }
            SectionHeader {
                text: qsTr("Author")
            }
            Rectangle {
                color: "#999999"
                x: Theme.paddingLarge * 3
                width: parent.width - Theme.paddingLarge * 3 * 2
                height: 2
                anchors.leftMargin: 20
                anchors.topMargin: 30
            }
            Label {
                text: "© Arno Dekker 2015"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}