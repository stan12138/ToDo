import QtQuick 2.0
import stan.date 1.0

Item {
    id: root
    opacity: PathView.op?PathView.op:0
    z: PathView.zo?PathView.zo:0
    property real sangle: PathView.sangle?PathView.sangle:0
    property bool current: PathView.isCurrentItem

    property bool digit_falge: true

    Text {
        id: con
        text: root.digit_falge?get_digit_text(index):get_date_text(index)
        font.pointSize: 10
        font.family: "Microsoft YaHei Ui"
        anchors.centerIn: parent
        color: root.current? "black":"#555555"
        transform: Rotation {
            origin.x: width/2
            origin.y: height/2
            axis {x: 1; y:0; z:0}
            angle: root.sangle
        }
    }

    DateBackEnd {
        id: date_record
    }

    function get_date_text(index)
    {
        return date_record.date[index*3+1].toString()+"月"+date_record.date[index*3+2].toString()+"日";
    }

    function get_digit_text(index)
    {
        return index.toString().length<2?'0'+index.toString():index.toString()
    }

}
