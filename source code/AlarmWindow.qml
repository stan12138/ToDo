import QtQuick 2.0
import QtQuick.Window 2.2

Window {
    id: nothing
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    color: "transparent"
    visible: false
    property alias text: message_area.text
    property alias time: window_timer.interval
    width: 200
    height: 50

    onActiveChanged: {
        console.log("I am active")
        window_timer.start()
    }

    Rectangle {
        anchors.fill: parent
        id: window_mask
        color: "#dd7cfc00"
        radius: 5


        TextEdit {
            id: message_area
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            width: parent.width-50
            height: 25
            readOnly: true
            text: "this is test message stan hahahahah"
            font.family: "Microsoft YaHei Ui"
            verticalAlignment: TextEdit.AlignVCenter
            horizontalAlignment: paintedWidth>width?TextEdit.AlignLeft:TextEdit.AlignHCenter
            clip: true

        }

        Image {
            width: 20
            height: 20
            property bool enter: false
            source: enter?"qrc:/icon/close_hover.png":"qrc:/icon/close.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 5

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.enter=true
                }
                onExited: {
                    parent.enter=false
                }

                onClicked: {
                    nothing.visible = false;
                }
            }
        }

    }

    Timer {
        id: window_timer
        interval: 30000
        repeat: false
        running: false
        onTriggered:
        {
            nothing.visible = false;
        }
    }



}
