import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: helpPage
    allowedOrientations: Orientation.Portrait | Orientation.Landscape | Orientation.LandscapeInverted
    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        VerticalScrollDecorator {}

        Column {
            id: col
            spacing: Theme.paddingLarge
            width: parent.width
            PageHeader {
                title: "Info"
            }
            Label {
        width: parent.width - 40
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                text: "<html><b>Subnet-calc</b> helps you to calculate IPv4 related stuff like broadcast, subnet, netmask etc. for your network.<br> \
                <br> \
                <br><b>Subnet:</b><br> \
                A subnetwork, or subnet, is a logical, visible subdivision of an IP network. The practice of dividing a \
                network into two or more networks is called subnetting.<br> \
                Computers that belong to a subnet are addressed with a common, identical, most-significant bit-group in their \
                IP address. This results in the logical division of an IP address into two fields, a network or routing prefix \
                and the rest field or host identifier. The rest field is an identifier for a specific host or network interface.<br> \
                <br><b>Routing:</b><br> \
                The routing prefix is expressed in CIDR (Classless Inter-Domain Routing) notation. It is written as the first address \
                of a network, followed by a slash character (/), and ending with the bit-length of the prefix. For example, \
                192.168.1.0/24 is the prefix of the Internet Protocol Version 4 network starting at the given address, \
                having 24 bits allocated for the network prefix, and the remaining 8 bits reserved for host addressing.<br> \
                The IPv6 address specification 2001:db8::/32 is a large address block with 296 addresses, having a 32-bit \
                routing prefix. For IPv4, a network is also characterized by its subnet mask, which is the bitmask that when \
                applied by a bitwise AND operation to any IP address in the \
                network, yields the routing prefix. Subnet masks are also expressed in dot-decimal notation like an address. For \
                example, 255.255.255.0 is the network mask for the 192.168.1.0/24 prefix.<br>\
                Traffic is exchanged (routed) between subnetworks with special gateways (routers) when the routing prefixes of \
                the source address and the destination address differ. A router constitutes the logical or physical boundary \
                between the subnets.<br> \
                <br><b>Reasons for subnetting:</b><br> \
                The benefits of subnetting an existing network vary with each deployment scenario. In the address allocation \
                architecture of the Internet using CIDR and in large organizations, it is \
                necessary to allocate address space efficiently. It may also enhance routing efficiency, or have advantages in \
                network management when subnetworks are administratively controlled by different entities in a larger organization. \
                Subnets may be arranged logically in a hierarchical architecture, partitioning an organization's network address \
                space into a tree-like routing structure.
                "
                font.pixelSize: Theme.fontSizeExtraSmall
                wrapMode: Text.Wrap
            }
        }
    }
}
