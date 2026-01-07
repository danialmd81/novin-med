import QtQuick
import QtQuick.Layouts
import QtQuick.Controls 2.15

Image {
    id: splashScreen
    width: parent.width
    height: parent.height
    source: "image.png"

    Text {
        color: "#ffffff"
        text: `HIGH INTENSITY
        ELECTROMAGNETIC
        STIMULATOR
        `
        anchors.top: parent.top
        anchors.topMargin: 781
        font.letterSpacing: 0.01
        font.pixelSize: 80
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        lineHeight: 1.05
        anchors.horizontalCenter: parent.horizontalCenter
        font.styleName: "Regular"
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    }

    Text {
        id: text1
        width: 481
        height: 127
        color: "#ff7f24"
        text: qsTr("QUANTA")
        anchors.top: parent.top
        anchors.topMargin: 1631
        font.letterSpacing: 0.05
        font.pixelSize: 105
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.styleName: "Bold"
        font.bold: true
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    }

    Frame {
        id: frame
        width: 414
        height: 200
        anchors.top: parent.top
        anchors.topMargin: 577
        anchors.horizontalCenter: parent.horizontalCenter

        Image {
            id: novinText
            width: 227
            height: 27
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 0
            source: "novin-text.png"
            sourceSize.height: 27
            sourceSize.width: 227
            fillMode: Image.PreserveAspectFit
            Layout.preferredWidth: 100
            Layout.preferredHeight: 100
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }

        Image {
            id: novinLogo
            width: 135
            height: 75
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 0
            source: "novin-logo.png"
            sourceSize.height: 75
            sourceSize.width: 135
            fillMode: Image.PreserveAspectFit
            Layout.preferredWidth: 100
            Layout.preferredHeight: 100
        }
    }
}
