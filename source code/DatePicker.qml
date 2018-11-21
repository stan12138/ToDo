import QtQuick 2.0
import QtQuick.Window 2.2
import stan.date 1.0

Window {
    id: root
    flags: Qt.Window | Qt.FramelessWindowHint
    color: "#f6aaaaaa"
    visible: false

    width: 200
    height: 230

    property int year: get_now_year()
    property int month: get_now_month()
    property int day: get_now_day()
    property int hour: get_now_hour()
    property int minute: get_now_minutes()

    signal choose_time(int year, int month, int day, int hour, int minute)



    Rectangle {
        //标题栏
        anchors.top: parent.top
        anchors.left: parent.left
        color: "#444444"
        height: 30
        width: 200
        MouseArea {
            anchors.fill: parent
            property bool press_mouse: false
            property int mx: 0
            property int my: 0
            cursorShape: press_mouse?Qt.SizeAllCursor:Qt.ArrowCursor

            onPressed: {
                mx = mouseX
                my = mouseY
                press_mouse=true
            }
            onPositionChanged: {
                root.x += mouseX-mx
                root.y += mouseY-my
            }
            onReleased: {
                press_mouse = false
            }
        }

        Image {
            //图标区
            id: done
            property bool enter_done: false
            source: enter_done?"qrc:/icon/完成_small_hover.png":"qrc:/icon/完成_small.png"
            x: 170
            y: 5
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    done.enter_done = true
                }
                onExited: {
                    done.enter_done = false
                }
                onClicked: {
                    root.choose_time(year, month, day, hour, minute);
                    root.hide();
                }
            }

        }
    }

    Text {
        id: day_label
        text: get_now_date()
        font.family: "Microsoft YaHei Ui"
        font.pointSize: 10
        anchors.horizontalCenter: day_wheel.horizontalCenter
        anchors.bottom: day_wheel.top
        anchors.bottomMargin: 15

    }

    DigitalWheel {
        id: day_wheel
        x: 18
        y: 67
        width: 80
        height: 150
        max_number: 365
        currentIndex: 182
        order_begin: 0

        delegate: DigitalItem {
            digit_falge: false
        }

        onIndex_change: {
            day_label.text = get_date_text(the_index);
        }

    }

    Text {
        id: hour_label
        text: get_now_hour_string()+"时"
        font.family: "Microsoft YaHei Ui"
        font.pointSize: 10
        anchors.horizontalCenter: hour_wheel.horizontalCenter
        anchors.bottom: hour_wheel.top
        anchors.bottomMargin: 15

    }

    DigitalWheel {
        id: hour_wheel
        x: 128
        y: 67
        width: 20
        height: 150
        max_number: 24
        currentIndex: get_now_hour()
        order_begin: 0

        delegate: DigitalItem {
            digit_falge: true
        }

        onIndex_change: {
            hour = the_index
            var a = hour.toString();
            hour_label.text = (a.length<2?"0"+a:a)+"时";
        }

    }

    Text {
        id: minute_label
        text: get_now_minutes_string()+"分"
        font.family: "Microsoft YaHei Ui"
        font.pointSize: 10
        anchors.horizontalCenter: minute_wheel.horizontalCenter
        anchors.bottom: minute_wheel.top
        anchors.bottomMargin: 15

    }

    DigitalWheel {
        id: minute_wheel
        x: 168
        y: 67
        width: 20
        height: 150
        max_number: 60
        currentIndex: get_now_minutes()
        order_begin: 0

        delegate: DigitalItem {
            digit_falge: true
        }

        onIndex_change: {
            minute = the_index;
            var a = minute.toString();
            minute_label.text = (a.length<2?"0"+a:a)+"分";
        }

    }

    onActiveChanged: {
        if(visible)
        {
            update_all_info();
            //此处应该在每次打开时间选择窗的时候更新数据，但是考虑了一下其实真的好复杂呀，todo.....
        }
    }


    DateBackEnd {
        id: date_record
    }

    function get_date_text(index)
    {
        year = date_record.date[index*3];
        month = date_record.date[index*3+1];
        day = date_record.date[index*3+2];
        var year_string = year.toString();
        var month_string = month.toString().length<2?"0"+month.toString():month.toString();
        var day_string = day.toString().length<2?"0"+day.toString():day.toString();
        return year_string+"年"+month_string+"月"+day_string+"日";
    }

    function get_now_date()
    {
        var date = new Date;
        var a = date.getFullYear().toString();
        var b = (date.getMonth()+1).toString();
        var c = date.getDate().toString();
        b = b.length<2?"0"+b:b;
        c = c.length<2?"0"+c:c;
        return a+"年"+b+"月"+c+"日";
    }
    function get_now_year()
    {
        var date = new Date;
        return date.getFullYear()
    }
    function get_now_month()
    {
        var date = new Date;
        return date.getMonth()+1
    }
    function get_now_day()
    {
        var date = new Date;
        return date.getDate()
    }

    function get_now_hour()
    {
        var date = new Date;
        return date.getHours();
    }
    function get_now_hour_string()
    {
        var a = get_now_hour().toString();
        return a.length<2?"0"+a:a;

    }

    function get_now_minutes()
    {
        var date = new Date;
        return date.getMinutes();
    }

    function get_now_minutes_string()
    {
        var a = get_now_minutes().toString();
        return a.length<2?"0"+a:a;

    }

    function update_all_info()
    {
        //此处应该在每次打开时间选择窗的时候更新数据，但是考虑了一下其实真的好复杂呀，todo.....
    }

}
