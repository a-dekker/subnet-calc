//
// Code reused from JavaScript Subnet Calculator written by John Thaemltiz
//
import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import Nemo.Notifications 1.0

Page {
    id: page

    function banner(category, message) {
        notification.close()
        notification.previewBody = "subnet-calc"
        notification.previewSummary = message
        notification.publish()
    }

    Notification {
        id: notification
        itemCount: 1
    }

    Component.onCompleted: {
        ipv6_address.focus = true
        globalMask = "255.255.255.0 /64"
    }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            if (mainapp.fromSubnetPage) {
                calculateAll()
                mainapp.fromSubnetPage = false
            }
        }
    }


    function validateIPaddress(ipaddress) {
        var ipformat
        ipformat = /(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))/
        // (
        // ([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|          # 1:2:3:4:5:6:7:8
        // ([0-9a-fA-F]{1,4}:){1,7}:|                         # 1::                              1:2:3:4:5:6:7::
        // ([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|         # 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
        // ([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|  # 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
        // ([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|  # 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
        // ([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|  # 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
        // ([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|  # 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
        // [0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|       # 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
        // :((:[0-9a-fA-F]{1,4}){1,7}|:)|                     # ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
        // fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|     # fe80::7:8%eth0   fe80::7:8%1     (link-local IPv6 addresses with zone index)
        // ::(ffff(:0{1,4}){0,1}:){0,1}
        // ((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}
        // (25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|          # ::255.255.255.255   ::ffff:255.255.255.255  ::ffff:0:255.255.255.255  (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
        // ([0-9a-fA-F]{1,4}:){1,4}:
        // ((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}
        // (25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])           # 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
        // )
        if (ipaddress.match(ipformat)) {
            return true
        } else {
            banner("WARNING", qsTr("Invalid IPv6 address"))
            return false
        }
    }

    function compactIP(ip) {
        // (       # Match and capture in backreference 1:
        //  (?:    #  Match this group:
        //   :0    #  :0
        //   \b    #  word boundary
        //  ){2,}  # twice or more
        // )       # End of capturing group 1
        // :?      # Match a : if present (not at the end of the address)
        // (?!     # Now assert that we can't match the following here:
        //  \S*    #  Any non-space character sequence
        //  \b     #  word boundary
        //  \1     #  the previous match
        //  :0     #  followed by another :0
        //  \b     #  word boundary
        // )       # End of lookahead. This ensures that there is not a longer
        // # sequence of ":0"s in this address.
        // (\S*)   # Capture the rest of the address in backreference 2.
        // # This is necessary to jump over any sequences of ":0"s
        // # that are of the same length as the first one.

        // and finally remove all leading zero's

        // var compressedString = ip.replace("((?:(?:^|:)0+\\b){2,}):?(?!\\S*\\b\\1:0+\\b)(\\S*)", "::$2")
        var compressedString = ip.replace(/((?:(?:^|:)0+\b){2,}):?(?!\S*\b\1:0+\b)(\S*)/g, "::$2").replace(/(:0{1,})/g, ":")
        return compressedString
    }

    // expand an IPv6 IP with double-colons
    function expandIP(ip) {

        // first expand '::' parts
        var parts = ip.split(/:+/);
        var newParts = [];
        var i;
        for(i=0; i < parts.length; i++) {
            if(parts[i]) {
                newParts.push(parts[i]);
            }
        }

        var missing;
        if(newParts.length < 8) {
            if(ip.indexOf('::') < 0) { // no way to expand
                return null;
            }
            missing = 8 - newParts.length;
            var expansion = ':';
            for(i=0; i < missing; i++) {
                expansion += '0:';
            }
            ip = ip.replace('::', expansion);
        }
        ip = ip.replace(/^:/, '').replace(/:$/, '');

        // then expand zeroes
        parts = ip.split(':');
        for(i=0; i < parts.length; i++) {
            missing = 4 - parts[i].length;
            while(missing--) {
                parts[i] = '0'+parts[i];
            }
        }
        return parts.join(':');
    }


    function resetValues() {
        ipv6_address.text = ""
        ipExpanded.text = "-"
        ipCompacted.text = "-"
        subnetid.text = "-"
        startaddr.text = "-"
        endaddr.text = "-"
        tot_hosts.text = "-"
        tot_subnets.text = "-"
        broadcast.text = "-"
        pub_priv.text = "-"
        globalMask = "255.255.255.0 /64"
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
            MenuItem {
                text: qsTr("Help")
                onClicked: pageStack.push(Qt.resolvedUrl("Help.qml"))
            }
            MenuItem {
                text: qsTr("IPv4")
                onClicked: pageStack.replace(Qt.resolvedUrl("MainPage.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        VerticalScrollDecorator {
        }

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: page.height / page.width > 1.6 ? Theme.paddingMedium : Theme.paddingSmall
            PageHeader {
                title: qsTr("subnet-calc (IPv6)")
            }
            IconButton {
                icon.source: "image://theme/icon-m-clear"
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingMedium
                visible: isPortrait
                onClicked: {
                    resetValues()
                }
            }
            Row {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                // spacing: 0
                width: parent.width
                TextField {
                    width: isPortrait ? parent.width - Theme.paddingLarge : parent.width - ( 2 * Theme.paddingLarge) - iconButtonLandscape.width
                    id: ipv6_address
                    maximumLength: 45

                    placeholderText: "IPv6 address"
                    inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhPreferLowercase | Qt.ImhNoAutoUppercase
                    horizontalAlignment: Text.AlignRight
                    text: ""
                    EnterKey.enabled: text.trim().length > 0
                    EnterKey.highlighted: true
                    EnterKey.text: "OK"
                    EnterKey.onClicked: {
                        ipv6_address.text = ipv6_address.text.toLowerCase()
                        if (validateIPaddress(ipv6_address.text)) {
                            ipExpanded.text = expandIP(ipv6_address.text)
                            ipCompacted.text = compactIP(ipv6_address.text)
                            ipv6_address.focus = false
                        }
                    }
                    onFocusChanged: {
                        if (ipv6_address.text !== "") {
                            // remove leading zero's
                            calculateAll()
                        }
                    }
                }
                IconButton {
                    id: iconButtonLandscape
                    icon.source: "image://theme/icon-m-clear"
                    visible: isLandscape
                    onClicked: {
                        resetValues()
                    }
                }
            }
            Row {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                width: parent.width
                Label {
                    text: "Network mask"
                    width: (column.width - (Theme.paddingLarge * 4)) / 2
                }
                TextField {
                    id: subnetmask
                    readOnly: true
                    text: mainapp.globalMask
                    color: Theme.highlightColor
                    width: (column.width + (Theme.paddingLarge * 2)) / 2
                    horizontalAlignment: Text.AlignRight
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("MaskIPv6.qml"))
                    }
                }
            }
            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
            }
            Row {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                width: parent.width
                Label {
                    text: isPortrait ? "IP exp." : "IP expanded"
                    width: (column.width - (Theme.paddingLarge * 2)) / 2
                }
                Label {
                    id: ipExpanded
                    text: "-"
                    horizontalAlignment: Text.AlignRight
                    width: (column.width - (Theme.paddingLarge * 2)) / 2
                    color: Theme.secondaryColor
                    font.pixelSize: isPortrait ? Theme.fontSizeExtraSmall : Theme.fontSizeMedium
                }
            }
            Row {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                width: parent.width
                Label {
                    text: isPortrait ? "IP comp." : "IP compacted"
                    width: (column.width - (Theme.paddingLarge * 2)) / 2
                }
                Label {
                    id: ipCompacted
                    text: "-"
                    horizontalAlignment: Text.AlignRight
                    width: (column.width - (Theme.paddingLarge * 2)) / 2
                    color: Theme.secondaryColor
                    font.pixelSize: isPortrait ? Theme.fontSizeExtraSmall : Theme.fontSizeMedium
                }
            }
            Row {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                width: parent.width
                Label {
                    text: "Subnet ID"
                    width: (column.width - (Theme.paddingLarge * 2)) / 2
                }
                Label {
                    id: subnetid
                    text: "-"
                    horizontalAlignment: Text.AlignRight
                    width: (column.width - (Theme.paddingLarge * 2)) / 2
                    color: Theme.secondaryColor
                }
            }
            Row {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                width: parent.width
                Label {
                    text: "Start address"
                    width: (column.width - (Theme.paddingLarge * 2)) / 2
                }
                Label {
                    id: startaddr
                    text: "-"
                    horizontalAlignment: Text.AlignRight
                    width: (column.width - (Theme.paddingLarge * 2)) / 2
                    color: Theme.secondaryColor
                }
            }
            Row {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                width: parent.width
                Label {
                    text: "End address"
                    width: (column.width - (Theme.paddingLarge * 2)) / 2
                }
                Label {
                    id: endaddr
                    text: "-"
                    horizontalAlignment: Text.AlignRight
                    width: (column.width - (Theme.paddingLarge * 2)) / 2
                    color: Theme.secondaryColor
                }
            }
            Row {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                width: parent.width
                Label {
                    text: "Max hosts"
                    width: (column.width - (Theme.paddingLarge * 2)) / 2
                }
                Label {
                    id: tot_hosts
                    text: "-"
                    horizontalAlignment: Text.AlignRight
                    width: (column.width - (Theme.paddingLarge * 2)) / 2
                    color: Theme.secondaryColor
                }
            }
            Row {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                width: parent.width
                Label {
                    text: "Max subnets"
                    width: (column.width - (Theme.paddingLarge * 2)) / 2
                }
                Label {
                    id: tot_subnets
                    text: "-"
                    horizontalAlignment: Text.AlignRight
                    width: (column.width - (Theme.paddingLarge * 2)) / 2
                    color: Theme.secondaryColor
                }
            }
            Row {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                width: parent.width
                Label {
                    text: "Broadcast"
                    width: (column.width - (Theme.paddingLarge * 2)) / 2
                }
                Label {
                    id: broadcast
                    text: "-"
                    horizontalAlignment: Text.AlignRight
                    width: (column.width - (Theme.paddingLarge * 2)) / 2
                    color: Theme.secondaryColor
                }
            }
            Row {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                width: parent.width
                Label {
                    text: "Address space"
                    width: (column.width - (Theme.paddingLarge * 2)) / 2
                }
                Label {
                    id: pub_priv
                    text: "-"
                    horizontalAlignment: Text.AlignRight
                    width: (parent.width - (Theme.paddingLarge * 2)) / 2
                    color: Theme.secondaryColor
                }
            }
        }
    }
}
