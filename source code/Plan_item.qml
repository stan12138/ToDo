import QtQuick 2.0

Rectangle {
    //每个条目的主矩形
    id: plan
    width: 100  //宽度是由外部进行调整的
    height: plan_content.height+6
    color: "#00ffffff"

    signal click_delete     //两个按钮的点击信号
    signal click_done

    property alias marker_id: marker



    TextEdit {   //内容编辑区
        anchors.top: parent.top
        anchors.right: parent.right
        id: plan_content
        width: parent.width-35
        height: paintedHeight+10
        text: ""
        textMargin: 6
        wrapMode: TextEdit.Wrap
        font.family: "Microsoft YaHei"
        font.pixelSize: 15

        Rectangle {
            anchors.fill: parent
            color: "#22222222"
            radius: 5
        }
    }



    MouseArea {  //条目的主鼠标区域
        anchors.fill: parent
        hoverEnabled: true
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


        Item {    //右侧三个图标的控制区
            visible: false
            id: marker
            width: 90
            height: 20
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            Row {
                anchors.fill: parent
                spacing: 10
                Image {  //定时器图标
                    id: alarm_img
                    property bool enter_alarm: false

                    property string alarm_url: item_mode.use_alarm?"qrc:/icon/cancle_arlarm_small.png":"qrc:/icon/alarm_small.png"
                    property string alarm_hover_url: item_mode.use_alarm?"qrc:/icon/cancle_arlarm_small_hover.png":"qrc:/icon/alarm_small_hover.png"

                    source: enter_alarm?alarm_hover_url:alarm_url

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            alarm_img.enter_alarm = true
                            parent.visible = true
                        }
                        onExited: {
                            alarm_img.enter_alarm = false
                        }
                        onClicked: {
                            item_mode.use_alarm = !item_mode.use_alarm
                        }
                    }

                }
                Image {   //完成图标
                    id: done_img
                    property bool enter_done: false
                    source: enter_done?"qrc:/icon/done_small_hover.png":"qrc:/icon/done_small.png"
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            done_img.enter_done = true
                            parent.visible = true
                        }
                        onExited: {
                            done_img.enter_done = false
                        }
                        onClicked: {
                            plan.click_done();
                        }
                    }
                }
                Image {  //删除图标
                    id: delete_img
                    property bool enter_delete: false
                    source: enter_delete?"qrc:/icon/delete_small_hover.png":"qrc:/icon/delete_small.png"
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            delete_img.enter_delete = true
                            parent.visible = true
                        }
                        onExited: {
                            delete_img.enter_delete = false
                        }
                        onClicked: {
                            plan.click_delete();
                        }
                    }
                }
            }
        }

    }

    Rectangle {    //左侧定时设置图标
        id: item_mode
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: 20
        height: 20
        color: "#00ffffff"
        property bool use_alarm: false
        property string clock_url: use_alarm?"qrc:/icon/clock_small.png":"qrc:/icon/dot_small.png"
        property string clock_hover_url: use_alarm?"qrc:/icon/clock_small_hover.png":"qrc:/icon/dot_small_hover.png"
        Image {
            id: clock_img
            property bool enter_clock: false
            source: enter_clock?parent.clock_hover_url:parent.clock_url
            anchors.fill: parent
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                clock_img.enter_clock = true
            }
            onExited: {
                clock_img.enter_clock = false
            }
        }
    }
}
