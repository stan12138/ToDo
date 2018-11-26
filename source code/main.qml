import QtQuick 2.6
import QtQuick.Window 2.2
import stan.date 1.0

QtObject {
    property var main_window: Window {
        id: root
        visible: true
        width: 370
        height: 415

        color: "#44222222"
        flags: Qt.Window | Qt.FramelessWindowHint

        property int current_order: 0

        MouseArea {
            //覆盖整个窗口的主鼠标区，主要负责窗口的移动
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
                focus = true;
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
                //右侧竖条鼠标区，负责窗口的横向拉伸
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
                //右下角方块鼠标区，负责窗口的全向拉伸
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
                //底部横条条鼠标区，负责窗口的纵向拉伸
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
                //关闭按钮的鼠标区
                anchors.fill: parent
                hoverEnabled: true
                onEntered: close_button.hover=true
                onExited: close_button.hover=false
                onClicked: {
                    database.database_close();
                    Qt.quit();
                }
            }
        }

        ListModel {
            id: item_model
        }
        Rectangle {
            //清单界面
            id: list_rect
            width: root.width-40
            height: root.height-70
            anchors.centerIn: parent
            color: "#00ffffff"

            property bool could_add_another_plan: true


            ListView {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5

                clip: true
                model: item_model
                delegate: Plan_item {
                    id: plan_delegate
                    width: parent.width
                    my_order: item_order
                    my_content: item_content
                    my_type: item_type
                    aim_year: item_year
                    aim_month: item_month
                    aim_day: item_day
                    aim_hour: item_hour
                    aim_minute: item_minute

                    onChange_content: {
                        console.log(order, text);
                        if(order==root.current_order-1)
                        {
                            list_rect.could_add_another_plan = true;
                        }
                        var data = [order, text, type, year, month, day, hour, minute];
                        database.update_item(data);
                    }
                    onChange_type: {
                        console.log(order, type);
                        var data = [order, text, type, year, month, day, hour, minute];
                        database.update_item(data);
                        root.remove_item_from_model(order);
                    }
                    onSet_time: {
                        console.log(order, year, month, day, hour, minute);
                        var data = [order, text, type, year, month, day, hour, minute];
                        database.update_item(data);
                    }
                    onNeed_show_alarm_window: {
                        main_alarm_window.visible = true;
                        main_alarm_window.text = content;
                    }

//                    list_blank.clicked.connect(plan_content_lose_focus);
                }

                MouseArea {
                    //清单区空白位置的鼠标区，点击之后增加新的清单项
                    z: -1
                    id: mo
                    anchors.fill: parent
                    onClicked: {
                        if(list_rect.could_add_another_plan)
                        {
                            item_model.append({"item_order":root.current_order, "item_content":"", "item_type":0, "item_year":-1, "item_month":-1, "item_day":-1, "item_hour":-1, "item_minute":-1});
                            list_rect.could_add_another_plan = false;
                            var data = [root.current_order, "", 0, -1, -1, -1 ,-1 ,-1];
                            database.insert(data);
                            root.current_order += 1;

                        }
                        focus = true;

                    }
//
                }

            }


        }

        MouseArea {
            //窗口底部清单界面之上的狭窄鼠标区，负责点击之后增加新的清单项
            width: root.width-40
            height: 25
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: 10
            anchors.leftMargin: 20
            onClicked: {
                if(list_rect.could_add_another_plan)
                {
                    item_model.append({"item_order":root.current_order, "item_content":"", "item_type":0, "item_year":-1, "item_month":-1, "item_day":-1, "item_hour":-1, "item_minute":-1});
                    list_rect.could_add_another_plan = false;
                    var data = [root.current_order, "", 0, -1, -1, -1 ,-1 ,-1];
                    database.insert(data);
                    root.current_order += 1;
                }
                focus = true;
            }
        }


        Window {
            //此处为窗口隐藏在边栏之后的小圆点
            id: hidden_area
            height: 50
            width: height
            visible: false
            flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
            color: "transparent"
            onActiveChanged: {
                if(!active)
                {
                    hidden_area.visible = false
                }
            }

            Rectangle {
                color: "#44222222"
                anchors.fill: parent
                radius: hidden_area.width/2

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        //此处需要解决双屏的显示问题，todo.....
                        console.log(Screen.desktopAvailableWidth, Screen.width)
                        console.log("origin location", root.x, root.width, Screen.width);
                        root.x = Math.min(Math.max(0, root.x), Screen.width-root.width);
                        root.y = Math.max(0, root.y);
                        console.log("will show in", root.x, root.y);
                        root.show();
                        hidden_area.hide();
                    }
                }
            }


        }

        DataMaster {
            id: database
        }

        Component.onCompleted: {
            database.database_init();
            root.current_order = database.get_id();
            var item_data = database.get_data();
            if(item_data.length>0)
            {
                add_old_items(item_data);
            }
        }

        function add_old_items(items_list)
        {
            var length = items_list.length/8;
            for(var i=0; i<length; i++)
            {
                if(items_list[i*8+2]===0)
                {
                    item_model.append({"item_order":items_list[i*8], "item_content":items_list[i*8+1], "item_type":items_list[i*8+2], "item_year":items_list[i*8+3], "item_month":items_list[i*8+4], "item_day":items_list[i*8+5], "item_hour":items_list[i*8+6], "item_minute":items_list[i*8+7]});

                }
                else
                {
                    console.log(items_list[i*8+0], items_list[i*8+1], items_list[i*8+2], items_list[i*8+3], items_list[i*8+4], items_list[i*8+5], items_list[i*8+6], items_list[i*8+7]);
                }

            }
        }

        function remove_item_from_model(item_order)
        {
            for(var i=0; i<item_model.count; i++)
            {
                if(item_model.get(i).item_order===item_order)
                {
                    item_model.remove(i);
                    break;
                }
            }
        }
    }

    property var main_alarm_window: AlarmWindow {
        x: Screen.width-width-20
        y: 100
        text: "test test test"
    }
}



