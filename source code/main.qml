import QtQuick 2.6
import QtQuick.Window 2.2

Window {
    id: root
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    flags: Qt.Window | Qt.FramelessWindowHint

    MouseArea {
        anchors.fill: parent
        id: move_area

        property bool move_press: false
        property int mx: 0
        property int my: 0
        cursorShape: move_press?Qt.SizeAllCursor:Qt.ArrowCursor

        onPressed: {
            mx = mouseX
            my = mouseY
            move_press=true
        }
        onPositionChanged: {
            root.x += mouseX-mx
            root.y += mouseY-my
        }

        onReleased:
        {
            move_press=false
            if(root.y<=0 || Screen.width-root.x-root.width<=0)
            {
                if(-root.y>(root.x+root.width-Screen.width))
                {
                    //吸附在上边栏
                    hidden_area.x = (root.x+root.width/2)<=Screen.width/2?(root.x+root.width):(root.x);
                    hidden_area.y = -hidden_area.width/2;
                    hidden_area.visible = true;
                    hidden_area.requestActivate();
                    root.hide();
                }
                else
                {
                    //吸附在右边栏
                    if(root.y+root.height/2<=Screen.height/2)
                    {
                        hidden_area.y = root.y+root.height;
                    }
                    else
                    {
                        hidden_area.y = root.y;
                    }
                    hidden_area.x = Screen.width-hidden_area.width/2;
                    hidden_area.visible = true
                    hidden_area.requestActivate();
                    root.hide()
                }
            }

        }

        MouseArea {
            id: h_zoom_area
            width: 10
            height: root.height
            anchors.right: parent.right
            cursorShape: Qt.SizeHorCursor
        }

        MouseArea {
            id: v_zoom_area
            width: root.width
            height: 10
            anchors.bottom: parent.bottom
            cursorShape: Qt.SizeVerCursor
        }

        MouseArea {
            id: both_zoom_area
            width: 10
            height: 10
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            cursorShape: Qt.SizeFDiagCursor
        }

    }

    Rectangle {
        id: title_rect
        width: root.width
        height: 30
        color: "#444444"
        anchors.top: parent.top
    }

    Rectangle {
        width: 20
        height: 20
        id: close_button
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 5

        property bool hover: false

        color: "#00ffffff"

        Image {
            id: close_icon
            source: close_button.hover?"qrc:/icon/search_red.png":"qrc:/icon/close_white.png"
            anchors.fill: parent
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: close_button.hover=true
            onExited: close_button.hover=false
            onClicked: Qt.quit()
        }
    }

//    TextEdit {
//        id: text
//        color: "#ff0000"
//        text: "I am here"
//        textMargin: 6
//        font.family: "Microsoft YaHei"
//        anchors.centerIn: parent
//        width: paintedWidth+12
//        height: paintedHeight+12

//        Rectangle {
//            anchors.fill: parent
//            color: "#1100ffff"
//        }
//    }
    ListModel {
        id: item_model
        ListElement {number: 0}
    }
    Rectangle {
        width: root.width-40
        height: root.height-70
        anchors.centerIn: parent
        color: "#11ffff"



        ListView {
            anchors.fill: parent
            anchors.margins: 10

            clip: true
            model: item_model
            delegate: number_delegate
            spacing: 5



            MouseArea {
                z: -1
                anchors.fill: parent
                onClicked: {
                    item_model.append({"number":1})
                }
            }
        }


        Component {
            id: number_delegate
            Plan_item {
                width: parent.width
            }
        }
    }

    MouseArea {
        width: root.width-40
        height: 25
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: 10
        anchors.leftMargin: 20
        Rectangle {
            anchors.fill: parent
            color: "#11ff0000"
        }
        onClicked: {
            item_model.append({"number":1})
        }
    }


    Window {
        id: hidden_area
        height: 100
        width: 100
        visible: false
        flags: Qt.Window | Qt.FramelessWindowHint
        color: "transparent"
        onActiveChanged: {
            if(!active)
            {
                hidden_area.visible = false
            }
        }

        Rectangle {
            color: "#220000ff"
            anchors.fill: parent
            radius: hidden_area.width/2

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.x = Math.max(0, root.x);
                    root.y = Math.max(0, root.y);
                    root.show();
                    hidden_area.hide();
                }
            }
        }


    }


}
