// Code reused from JavaScript Subnet Calculator written by John Thaemltiz

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    Popup {
        id: banner
    }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            if (mainapp.fromSubnetPage) {
                calculateAll()
                mainapp.fromSubnetPage = false
            }
        }
    }

    function calculateAll()
    {
        if ( ip_address_1.text !== "" && ip_address_2.text !== "" && ip_address_3.text !== "" && ip_address_4.text !== "" ) {
            var ipaddress = ip_address_1.text + "." + ip_address_2.text + "." + ip_address_3.text + "." + ip_address_4.text
            if (validateIPaddress(ipaddress)) {
                mainapp.globalIP = ipaddress
                calculateWildcard(mainapp.globalMask)
                // calculateBroadcast(ipaddress,wildcard.text)
                caluclateStartingIP(ipaddress,mainapp.globalMask)
                calculateEndingIP(ipaddress,wildcard.text)
                hostCount(mainapp.globalMask)
                isPrivateIP(ipaddress)
                var bits = parseInt(mainapp.globalMask.replace(/^.+\//g, ""))
                calculateNumberOfSubnets(netw_class.text, bits)
            }
        }
    }

    function validateIPaddress(ipaddress)
    {
        var ipformat
        if ( ipaddress === "" ) {
            return false
        }
        // class A
        ipformat = /^(12[0-7]|1[0-1][0-9]|[0]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
        if (ipaddress.match(ipformat)) {
            netw_class.text = "A"
            if (!mainapp.fromSubnetPage) {
                // set initial default value
                mainapp.globalMask = "255.0.0.0/8"
            }
        }
        // class B
        ipformat = /^(19[0-1]|1[0-8][0-9]|[1][0-2][0-8])\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
        if (ipaddress.match(ipformat)) {
            netw_class.text = "B"
            if (!mainapp.fromSubnetPage) {
                // set initial default value
                mainapp.globalMask = "255.255.0.0/16"
            }
        }
        // class C
        ipformat = /^(2[0-2][0-3]|[1][9][0-9])\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
        if (ipaddress.match(ipformat)) {
            netw_class.text = "C"
            if (!mainapp.fromSubnetPage) {
                // set initial default value
                mainapp.globalMask = "255.255.255.0/24"
            }
        }
        ipformat = /^(22[4-9]|23[0-9])\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
        if (ipaddress.match(ipformat)) {
            netw_class.text = "D"
        }
        ipformat = /^(25[0-5]|24[0-9])\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
        if (ipaddress.match(ipformat)) {
            netw_class.text = "E"
        }
        ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
        if (ipaddress.match(ipformat)) {
            return true
        } else {
            banner.notify("Invalid IP address")
            return false
        }
    }

    function calculateBroadcast(ipaddress,wildcardaddr) {
        // Calculate the broadcast address (the last ip address in the network) and
        //  return it as an int array.
        //  We need the network address and the wildcard mask for this.
        // work around int32
        var nAddr = ipaddress.split('.')
        var nWild = wildcardaddr.split('.')
        var a = new Array(0,0,0,0);
        for(var i=0;i<4;i++){
            a[i] = nAddr[i] | nWild[i];
        }
        broadcast.text = a.join('.')
        return a
    }

    function calculateWildcard(subnetmask)
    {
        // subnet mask bits flipped
        subnetmask = subnetmask.replace(/\/.+$/g, "")
        var nAddr = subnetmask.split('.')
        var a = new Array(0,0,0,0);
        for(var i=0;i<4;i++){
            a[i] = 255 - nAddr[i];
        }
        wildcard.text = a.join('.')
    }

    function subnetID(ipaddress,subnetmask){
        // Calculate the subnet id  (the first address in the network) and return it as an
        //  int array.
        //  We need the network address and the subnet mask for this.
        var nAddr = ipaddress.split('.')
        subnetmask = subnetmask.replace(/\/.+$/g, "")
        var nMask = subnetmask.split('.')
        var a = new Array(0,0,0,0);
        for(var i=0;i<4;i++){
            a[i] = nAddr[i] & nMask[i];
        }
        subnetid.text = a.join('.')
        return a
    }

    function caluclateStartingIP(aNet,aMask){
        // Calculate the subnet id available address in the network and return it as an
        //  int array.  This is basically one more than the network address (subnet ID).
        //  We need the network address and the subnet mask for this.
        var a = subnetID(aNet,aMask);
        var d = octet2dec(a);
        d = d+1;
        startaddr.text = dec2octet(d).join('.')
    }

    function calculateEndingIP(aNet,aWild){
        // Calculate the last available ip address in the network and return it as
        //  an int array.  This is basically one less than the broadcast address.
        //  We need the network address and the wildcard mask for this.
        // work around int32
        var a = new calculateBroadcast(aNet,aWild)
        var d = octet2dec(a);
        d = d-1;
        endaddr.text = dec2octet(d).join('.')
        // return dec2octet(d);
    }

    function hostCount(aMask) {
        // Count the number of hosts based on a subnet mask
        // take the bits from the mask string
        var bits = 32 - aMask.replace(/^.+\//g, "")
        tot_hosts.text = Math.pow(2,bits) -2
        return Math.pow(2,bits) -2;
    }

    function octet2cidr(aMask) {
        // Convert a subnet mask array into CIDR (# of bits) (255.255.255.0 = 24 etc.)
        var mask = octet2dec(aMask);
        // get binary string
        mask = mask.toString(2);
        // return mask length
        return mask.indexOf(0);
    }

    function dec2octet(d){
        // Convert decimal to our array of 4 ints.
        //alert("d="+d+" "+d.toString(2)+"="+d.toString(2).substring(0,8)+"="+parseInt(d.toString(2).substring(0,8),2));
        var zeros = "00000000000000000000000000000000"
        var b = d.toString(2)
        var b = zeros.substring(0,32-b.length) + b
        var a = new Array(
            parseInt(b.substring(0,8),2)    // 32 bit integer issue (d & 4278190080)/16777216   //Math.pow(2,32) - Math.pow(2,24);
            , (d & 16711680)/65536    //Math.pow(2,24) - Math.pow(2,16);
            , (d & 65280)/256        //Math.pow(2,16) - Math.pow(2,8);
            , (d & 255)
            );        //Math.pow(2,8);
        return a
    }

    function octet2dec(a){
        // Convert our array of 4 ints into a decimal (watch out for 16 bit JS integers here)
        //alert("octet2dec1 "+a[0]+"\n"+dec2bin(a[0])+"\n"+dec2bin(a[0] * 16777216));
        // poor mans bit shifting (Int32 issue)
        var d = 0;
        d = d + parseInt(a[0]) * 16777216 ;  //Math.pow(2,24);
        d = d + a[1] * 65536;     //Math.pow(2,16);
        d = d + a[2] * 256;    //Math.pow(2,8);
        d = d + a[3];
        return d;
    }

    function isPrivateIP(ip) {
        var parts = ip.split('.');
        if (parts[0] === '10' ||
            (parts[0] === '172' && (parseInt(parts[1], 10) >= 16 && parseInt(parts[1], 10) <= 31)) ||
            (parts[0] === '192' && parts[1] === '168')) {
            pub_priv.text = "private IP"
            return true;
        }
        pub_priv.text = "public IP"
        return false;
    }

    function calculateNumberOfSubnets(nwClass, ones) {
        // (/24 means 24 zeros in the bin string)
        var subnets = 0
        if (nwClass === 'A') {
            subnets = Math.pow(2, (ones-8))
        } else if (nwClass === 'B') {
            subnets = Math.pow(2, (ones-16))
        } else if (nwClass === 'C') {
            subnets = Math.pow(2, (ones-24))
        }
        tot_subnets.text = Math.round(subnets)
    }

    function resetValues() {
        ip_address_1.text = ""
        ip_address_2.text = ""
        ip_address_3.text = ""
        ip_address_4.text = ""
        netw_class.text = "-"
        wildcard.text = "-"
        subnetid.text = "-"
        startaddr.text = "-"
        endaddr.text = "-"
        tot_hosts.text = "-"
        tot_subnets.text = "-"
        broadcast.text = "-"
        pub_priv.text = "-"
        globalMask = "255.255.255.0 /24"
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
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height


        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: page.height / page.width > 1.6 ? Theme.paddingMedium : Theme.paddingSmall
            PageHeader {
                title: qsTr("subnet-calc")
            }
                IconButton {
                    icon.source: "image://theme/icon-l-cancel"
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingMedium
                    onClicked: {
                        resetValues()
                    }
                }
            Row {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                spacing: 0
                width: parent.width
                Label {
                    text: "IP address"
                    width: (column.width - (Theme.paddingLarge * 2)) / 4
                }
                TextField {
                    id: ip_address_1

                    placeholderText: "---"
                    width: (column.width + Theme.paddingLarge)  / 6
                    validator: RegExpValidator {
                        regExp: /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
                    }
                    color: errorHighlight ? "red" : Theme.highlightColor
                    inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText
                    horizontalAlignment: Text.AlignRight
                    text: ""
                    EnterKey.enabled: text.trim().length > 0
                    EnterKey.highlighted: true
                    EnterKey.text: "OK"
                    EnterKey.onClicked: {
                        calculateAll()
                        ip_address_1.focus = false
                    }
                    onFocusChanged: {
                        if (ip_address_1.text !== "") {
                            // remove leading zero's
                            ip_address_1.text = ip_address_1.text.replace(/^0+([1-9])/, '$1')
                            calculateAll()
                        }
                    }
                    onTextChanged: {
                        if (text.length === 3) {
                            ip_address_2.focus = true
                        }
                    }
                }
                Label {
                    text: "."
                    width: 4
                }
                TextField {
                    id: ip_address_2

                    placeholderText: "---"
                    width: (column.width + Theme.paddingLarge)  / 6
                    validator: RegExpValidator {
                        regExp: /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
                    }
                    color: errorHighlight ? "red" : Theme.highlightColor
                    inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText
                    horizontalAlignment: Text.AlignRight
                    text: ""
                    EnterKey.enabled: text.trim().length > 0
                    EnterKey.highlighted: true
                    EnterKey.text: "OK"
                    EnterKey.onClicked: {
                        calculateAll()
                        ip_address_2.focus = false
                    }
                    onFocusChanged: {
                        if (ip_address_2.text !== "") {
                            // remove leading zero's
                            ip_address_2.text = ip_address_2.text.replace(/^0+([1-9])/, '$1')
                            calculateAll()
                        }
                    }
                    onTextChanged: {
                        if (text.length === 3) {
                            ip_address_3.focus = true
                        }
                    }
                }
                Label {
                    text: "."
                }
                TextField {
                    id: ip_address_3

                    placeholderText: "---"
                    width: (column.width + Theme.paddingLarge)  / 6
                    validator: RegExpValidator {
                        regExp: /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
                    }
                    color: errorHighlight ? "red" : Theme.highlightColor
                    inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText
                    horizontalAlignment: Text.AlignRight
                    text: ""
                    EnterKey.enabled: text.trim().length > 0
                    EnterKey.highlighted: true
                    EnterKey.text: "OK"
                    EnterKey.onClicked: {
                        calculateAll()
                        ip_address_3.focus = false
                    }
                    onFocusChanged: {
                        if (ip_address_3.text !== "") {
                            // remove leading zero's
                            ip_address_3.text = ip_address_3.text.replace(/^0+([1-9])/, '$1')
                            calculateAll()
                        }
                    }
                    onTextChanged: {
                        if (text.length === 3) {
                            ip_address_4.focus = true
                        }
                    }
                }
                Label {
                    text: "."
                    anchors.margins : 0
                }
                TextField {
                    id: ip_address_4

                    placeholderText: "---"
                    width: (column.width - (Theme.paddingLarge * 2)) / 5
                    validator: RegExpValidator {
                        regExp: /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
                    }
                    color: errorHighlight ? "red" : Theme.highlightColor
                    inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText
                    horizontalAlignment: Text.AlignRight
                    text: ""
                    EnterKey.enabled: text.trim().length > 0
                    EnterKey.highlighted: true
                    EnterKey.text: "OK"
                    EnterKey.onClicked: {
                        calculateAll()
                        ip_address_4.focus = false
                    }
                    onFocusChanged: {
                        if (ip_address_4.text !== "") {
                            // remove leading zero's
                            ip_address_4.text = ip_address_4.text.replace(/^0+([1-9])/, '$1')
                            calculateAll()
                        }
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
                        pageStack.push(Qt.resolvedUrl("Mask.qml"))
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
                    text: "Network Class"
                    width: (column.width - (Theme.paddingLarge * 2)) / 2
                }
                Label {
                    id: netw_class
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
                    text: "Wildcard mask"
                    width: (column.width - (Theme.paddingLarge * 2)) / 2
                }
                Label {
                    id: wildcard
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
/*            Row {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                width: parent.width
                Label {
                    text: "Available subnets"
                    width: (column.width - (Theme.paddingLarge * 2)) / 2
                }
                Label {
                    id: avail_sub
                    text: "-"
                    horizontalAlignment: Text.AlignRight
                    width: (column.width - (Theme.paddingLarge * 2)) / 2
                    color: Theme.secondaryColor
                }
            } */
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

