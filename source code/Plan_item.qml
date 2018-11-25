import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2

Rectangle {
    //每个条目的主矩形
    id: plan
    width: 100  //宽度是由外部进行调整的
    height: plan_content.height+6
    color: "#00ffffff"

//    signal click_delete     //两个按钮的点击信号
//    signal click_done
    signal change_content(int order, string text, int type, int year, int month, int day, int hour, int minute)
    signal set_time(int order, string text, int type, int year, int month, int day, int hour, int minute)
    signal change_type(int order, string text, int type, int year, int month, int day, int hour, int minute)

    signal need_show_alarm_window(string content)

    property alias marker_id: marker

    property int my_order: 0
    property string my_content: ""
    property int my_type: 0
    property int aim_year: 0
    property int aim_month: 0
    property int aim_day: 0
    property int aim_hour: 0
    property int aim_minute: 0

    property bool done: false
    property date end_time: new Date()

    property bool use_alarm: false


    TextEdit {   //内容编辑区
        anchors.top: parent.top
        anchors.right: parent.right
        id: plan_content
        width: parent.width-35
        height: paintedHeight+10
        text: plan.my_content
        verticalAlignment: TextEdit.AlignVCenter
        leftPadding: 6
        wrapMode: TextEdit.Wrap
        font.family: "Microsoft YaHei"
        font.pixelSize: 15

        property string old_text: plan.my_content

        onEditingFinished: {
            if(old_text!=text)
            {
                old_text = text;
                plan.my_content = text;
                plan.change_content(plan.my_order, text, plan.my_type, plan.aim_year, plan.aim_month, plan.aim_day, plan.aim_hour, plan.aim_minute);
            }
        }

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

                    property string alarm_url: plan.use_alarm?"qrc:/icon/cancle_arlarm_small.png":"qrc:/icon/alarm_small.png"
                    property string alarm_hover_url: plan.use_alarm?"qrc:/icon/cancle_arlarm_small_hover.png":"qrc:/icon/alarm_small_hover.png"

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
                            plan.use_alarm = !plan.use_alarm
                            if(!plan.use_alarm)
                            {
                                alarm_timer.stop();
                                plan_content.color = "black"
                                plan.aim_year = -1;
                                plan.aim_month = -1;
                                plan.aim_day = -1;
                                plan.aim_hour = -1;
                                plan.aim_minute = -1;
                                plan.set_time(plan.my_order, plan.my_content, plan.my_type, -1, -1, -1, -1, -1);
                            }
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
                            plan.my_type = 1
                            plan.change_type(plan.my_order, plan.my_content, plan.my_type, plan.aim_year, plan.aim_month, plan.aim_day, plan.aim_hour, plan.aim_minute);
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
                            plan.my_type = -1
                            plan.change_type(plan.my_order, plan.my_content, plan.my_type, plan.aim_year, plan.aim_month, plan.aim_day, plan.aim_hour, plan.aim_minute);
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

        property string clock_url: plan.use_alarm?"qrc:/icon/clock_small.png":"qrc:/icon/dot_small.png"
        property string clock_hover_url: plan.use_alarm?"qrc:/icon/clock_small_hover.png":"qrc:/icon/dot_small_hover.png"
        Image {
            id: clock_img
            property bool enter_clock: false
            source: enter_clock?parent.clock_hover_url:parent.clock_url
            anchors.fill: parent
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            id: time_ma
            onEntered: {
                clock_img.enter_clock = true
            }
            onExited: {
                clock_img.enter_clock = false
            }
            onClicked: {
                if(plan.use_alarm)
                {
                    datepicker.visible=true;
                    datepicker.requestActivate();
                }
            }
        }

        ToolTip {
            id: tooltip
            text: plan.aim_day!=-1?plan.aim_year.toString()+"."+plan.aim_month.toString()+"."+plan.aim_day.toString()+" "+plan.aim_hour.toString()+":"+plan.aim_minute.toString():"无"
            visible: plan.use_alarm?time_ma.containsMouse:false
            background: Rectangle {
                color: "#22444444"
                radius: 3
            }
        }
    }

    DatePicker {
        id: datepicker
        onChoose_time: {
            plan.aim_year = year;
            plan.aim_month = month;
            plan.aim_day = day;
            plan.aim_hour = hour;
            plan.aim_minute = minute;
            plan.end_time = new Date(year, month-1, day, hour, minute);
            begin_alarm();
            plan.set_time(plan.my_order, plan.my_content, plan.my_type, plan.aim_year, plan.aim_month, plan.aim_day, plan.aim_hour, plan.aim_minute);
        }
    }

    Timer {
        id: alarm_timer
        running: false
        repeat: false
        interval: 2000
        onTriggered: {
            check_date();
            if(!plan.done)
                alarm_timer.start();
        }
    }


    function begin_alarm()
    {
        plan.done = false;
        alarm_timer.start();
        plan_content.color = "black";
        console.log("alarm begin");
    }

    function check_date()
    {
        var d = new Date();
        if(d>=plan.end_time)
        {
            plan.done = true;
            show_alarm();

        }
    }
    function show_alarm()
    {
        plan.need_show_alarm_window(plan_content.text);
        plan_content.color = "red";

    }

    Component.onCompleted: {
        if(aim_year!=-1)
        {
            plan.end_time = new Date(aim_year, aim_month-1, aim_day, aim_hour, aim_minute);
            plan.use_alarm = true;
            begin_alarm();
        }
    }
}
