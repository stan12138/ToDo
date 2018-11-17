import QtQuick 2.0

Rectangle {
    id: plan
    width: 100
    height: plan_content.height
    color: "#11ff0000"


    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        width: 20
        height: 20
        radius: 10
        color: "#00ffffff"
        Image {
            id: clock_img
            source: "qrc:/icon/clock_small.png"
            anchors.fill: parent
        }
    }

    Item {
        visible: false
        id: marker
        width: 90
        height: 20
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        Row {
            anchors.fill: parent
            spacing: 10
            Image {
                id: alarm_img
                source: "qrc:/icon/alarm_small.png"
            }
            Image {
                id: done_img
                source: "qrc:/icon/done_small.png"
            }
            Image {
                id: delete_img
                source: "qrc:/icon/delete_small.png"
            }
        }
    }


    TextEdit {
        anchors.top: parent.top
        anchors.right: parent.right
        id: plan_content
        width: parent.width-35
        height: paintedHeight+10
        text: ""
        wrapMode: TextEdit.Wrap
        font.family: "Microsoft YaHei"
        font.pixelSize: 15

        Rectangle {
            anchors.fill: parent
            color: "#1100ff00"
        }
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
        onEntered: {
            marker.visible = true
        }
        onExited: {
            marker.visible = false
        }
        onClicked: {
            marker.visible = false
            //mouse.accepted = false
            if (!plan_content.activeFocus) {
                plan_content.forceActiveFocus();
                plan_content.cursorPosition = plan_content.text.length;
            } else {
                plan_content.focus = false;
            }
        }

    }
}
