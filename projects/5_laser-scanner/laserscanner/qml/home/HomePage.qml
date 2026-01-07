import QtQuick
import QtQuick.Layouts 2.15
import QtQuick.Effects

Rectangle {
    id: root
    color: "#F2F2F9"
    radius: 38

    Rectangle {
        id: topBar
        height: 120
        color: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {
                position: 0.0
                color: "#FFFFFF"
            }
            GradientStop {
                position: 1.0
                color: "#F1F1F9"
            }
        }
        radius: 38
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.topMargin: 0
        bottomRightRadius: 0
        bottomLeftRadius: 0
        anchors.horizontalCenter: parent.horizontalCenter
        Layout.fillWidth: true
    }

    Rectangle {
        id: rectangle
        width: 955
        height: 352
        color: "#ffffff"
        radius: 38
        anchors.top: parent.top
        anchors.topMargin: 161
        anchors.horizontalCenter: parent.horizontalCenter
        Layout.fillWidth: true

        Image {
            id: image
            width: 325
            height: 325
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 715
            source: "streamline_user-profile-focus-solid.png"
            anchors.verticalCenterOffset: 0
            fillMode: Image.PreserveAspectFit
        }

        MultiEffect {
            anchors.fill: parent
            source: rectangle
            shadowEnabled: true
            shadowColor: "#7090B0"
            shadowBlur: 0.05
            shadowVerticalOffset: 8
        }
    }

    Rectangle {
        id: rectangle1
        width: 458
        height: 256
        color: "#ffffff"
        radius: 38
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 59
        anchors.topMargin: 549
        Layout.fillWidth: true
        MultiEffect {
            anchors.fill: parent
            source: rectangle1
            shadowEnabled: true
            shadowColor: "#7090B0"
            shadowBlur: 0.5
            shadowVerticalOffset: 8
        }
    }

    Rectangle {
        id: rectangle2
        width: 458
        height: 256
        color: "#ffffff"
        radius: 38
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 549
        anchors.topMargin: 556
        Layout.fillWidth: true
        MultiEffect {
            anchors.fill: parent
            source: rectangle2
            shadowEnabled: true
            shadowColor: "#7090B0"
            shadowBlur: 0.5
            shadowVerticalOffset: 8
        }
    }

    Rectangle {
        id: rectangle3
        width: 458
        height: 256
        color: "#ffffff"
        radius: 38
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 59
        anchors.topMargin: 841
        Layout.fillWidth: true
        MultiEffect {
            anchors.fill: parent
            source: rectangle3
            shadowEnabled: true
            shadowColor: "#7090B0"
            shadowBlur: 0.5
            shadowVerticalOffset: 8
        }
    }

    Rectangle {
        id: rectangle4
        width: 458
        height: 256
        color: "#ffffff"
        radius: 38
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 549
        anchors.topMargin: 841
        Layout.fillWidth: true
        MultiEffect {
            anchors.fill: parent
            source: rectangle4
            shadowEnabled: true
            shadowColor: "#7090B0"
            shadowBlur: 0.5
            shadowVerticalOffset: 8
        }
    }

    Rectangle {
        id: bottomBar
        height: 120
        color: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {
                position: 0.0
                color: "#FFFFFF"
            }
            GradientStop {
                position: 1.0
                color: "#F1F1F9"
            }
        }
        radius: 38
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        topRightRadius: 0
        topLeftRadius: 0
        anchors.horizontalCenter: parent.horizontalCenter
        Layout.fillWidth: true
    }
}
