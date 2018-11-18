import QtQuick 2.6
import QtQuick.Window 2.2

Window {
    id: root
    visible: true
    width: 370
    height: 415

    color: "#44222222"
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
                    hidden_area.x = Math.min(Math.max(0, root.x+root.width/2), Screen.width-hidden_area.width);
                    hidden_area.y = -hidden_area.width/2;
                    console.log(Screen.width, Screen.height);
                    console.log("上边栏",hidden_area.x, hidden_area.y);
                }
                else
                {
                    //吸附在右边栏
                    hidden_area.y = Math.min(Math.max(0, root.y+root.height/2), Screen.height-hidden_area.height);
                    hidden_area.x = Screen.width-hidden_area.width/2;
//                    console.log("右边栏",hidden_area.x, hidden_area.y);
                }
                hidden_area.visible = true
                hidden_area.requestActivate();
                root.hide()
            }

        }

        MouseArea {
            id: h_zoom_area
            width: 10
            height: root.height
            anchors.right: parent.right
            cursorShape: Qt.SizeHorCursor
            property int mx: 0
            property int my: 0
            onPressed: {
                mx = mouseX;
                my = mouseY;
            }
            onPositionChanged: {
                root.width += mouseX-mx;
            }
        }

        MouseArea {
            id: v_zoom_area
            width: root.width
            height: 10
            anchors.bottom: parent.bottom
            cursorShape: Qt.SizeVerCursor
            property int mx: 0
            property int my: 0
            onPressed: {
                mx = mouseX;
                my = mouseY;
            }
            onPositionChanged: {
                root.height += mouseY-my;
            }
        }

        MouseArea {
            id: both_zoom_area
            width: 10
            height: 10
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            cursorShape: Qt.SizeFDiagCursor
            property int mx: 0
            property int my: 0
            onPressed: {
                mx = mouseX;
                my = mouseY;
            }
            onPositionChanged: {
                root.width += mouseX-mx;
                root.height += mouseY-my;
                //console.log(root.width, root.height)
            }
        }

    }

    Rectangle { //标题栏
        id: title_rect
        width: root.width
        height: 30
        color: "#444444"
        anchors.top: parent.top
    }

    Rectangle {
        //关闭按钮
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

    ListModel {
        id: item_model
        ListElement {number: 0}
    }
    Rectangle {
        //清单界面
        width: root.width-40
        height: root.height-70
        anchors.centerIn: parent
        color: "#00ffffff"

        ListView {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 5

            clip: true
            model: item_model
            delegate: number_delegate

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
                onClick_done: {
                    item_model.remove(index);
                }
                onClick_delete: {
                    item_model.remove(index);
                }
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
        onClicked: {
            item_model.append({"number":1})
        }
    }


    Window {
        id: hidden_area
        height: 80
        width: 80
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
