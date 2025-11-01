import QtQuick 2.1
import Sailfish.Silica 1.0

Page {
    id: maskPage

    function appendMask(mask, bitlength) {
        masklist.model.append({
                                  Mask: mask,
                                  Bitlength: bitlength
                              })
    }

    SilicaListView {
        id: masklist
        width: parent.width
        height: parent.height
        anchors.fill: parent
        anchors.topMargin: 40
        VerticalScrollDecorator {
        }
        model: ListModel {
        }

        function loadmaskList() {
            var i
            for (i = 12; i < 129; i++)
            appendMask("", "/"+i )
        }

        Component.onCompleted: {
            // GlobVars.myBitlength = " "
            loadmaskList()
        }
        delegate: ListItem {
            id: listItem
            //         menu: contextMenu
            contentHeight: Theme.itemSizeMedium // two line delegate
            function setmask() {
                mainapp.globalMask = Mask + Bitlength
                mainapp.fromSubnetPage = true
                pageStack.pop()
            }
            Rectangle {
                id: timeRect
                width: parent.width
                height: parent.height
                color: Theme.primaryColor
                opacity: 0.05
                visible: !(index & 1)
            }

            Item {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                Label {
                    id: label
                    opacity: (index & 1) ? 0.7 : 0.9
                    anchors.bottom: sublabel.top
                    text: Mask
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: true
                    color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
                Label {
                    id: sublabel
                    anchors.top: label.bottom
                    text: Bitlength
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: listItem.highlighted ? Theme.highlightColor : Theme.secondaryColor
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            onClicked: {
                setmask()
            }
        }
    }
}
