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
            appendMask("255.0.0.0", "/8")
            appendMask("255.128.0.0", "/9")
            appendMask("255.192.0.0", "/10")
            appendMask("255.224.0.0", "/11")
            appendMask("255.240.0.0", "/12")
            appendMask("255.248.0.0", "/13")
            appendMask("255.252.0.0", "/14")
            appendMask("255.254.0.0", "/15")
            appendMask("255.255.0.0", "/16")
            appendMask("255.255.128.0", "/17")
            appendMask("255.255.192.0", "/18")
            appendMask("255.255.224.0", "/19")
            appendMask("255.255.240.0", "/20")
            appendMask("255.255.248.0", "/21")
            appendMask("255.255.252.0", "/22")
            appendMask("255.255.254.0", "/23")
            appendMask("255.255.255.0", "/24")
            appendMask("255.255.255.128", "/25")
            appendMask("255.255.255.192", "/26")
            appendMask("255.255.255.224", "/27")
            appendMask("255.255.255.240", "/28")
            appendMask("255.255.255.248", "/29")
            appendMask("255.255.255.252", "/30")
            // appendMask("255.255.255.254","/31")
            // appendMask("255.255.255.255","/32")
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
