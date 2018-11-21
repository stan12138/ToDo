import QtQuick 2.0
import QtQuick.Window 2.2


PathView {


    property int max_number: 365
    property int order_begin: 0

    x: 320
    y: 200
    width: 20
    height: 200
    currentIndex: 0

    id: view
    signal index_change(int the_index)

    pathItemCount: 9
    preferredHighlightBegin: 0.5
    preferredHighlightEnd: 0.5
    highlightRangeMode: PathView.StrictlyEnforceRange

    property int wheelindex: -1
    property real r: view.height/2

    model: max_number

    path: Path {
        id: whole_path
        startX: view.width/2
        startY: 0

        PathAttribute { name: "sangle"; value: 90 }
        PathAttribute { name: "op"; value: 0 }
        PathAttribute { name: "zo"; value: 1 }

        PathLine {
            x: whole_path.startX
            y: whole_path.startY+view.r*(1-Math.cos(Math.PI/9))
        }

        PathAttribute { name: "sangle"; value: 70 }
        PathAttribute { name: "op"; value: 0.2 }
        PathAttribute { name: "zo"; value: 2 }

        PathPercent { value: 1/9}

        PathLine {
            x: whole_path.startX
            y: whole_path.startY+view.r*(1-Math.cos(2*Math.PI/9))
        }

        PathAttribute { name: "sangle"; value: 50 }
        PathAttribute { name: "op"; value: 0.4 }
        PathAttribute { name: "zo"; value: 3 }

        PathPercent { value: 2/9}

        PathLine {
            x: whole_path.startX
            y: whole_path.startY+view.r*(1-Math.cos(3*Math.PI/9))
        }

        PathAttribute { name: "sangle"; value: 30 }
        PathAttribute { name: "op"; value: 0.6 }
        PathAttribute { name: "zo"; value: 4 }

        PathPercent { value: 3/9}

        PathLine {
            x: whole_path.startX
            y: whole_path.startY+view.r*(1-Math.cos(4*Math.PI/9))
        }

        PathAttribute { name: "sangle"; value: 10 }
        PathAttribute { name: "op"; value: 1 }
        PathAttribute { name: "zo"; value: 5 }

        PathPercent { value: 4/9}

        PathLine {
            x: whole_path.startX
            y: whole_path.startY+view.r*(1-Math.cos(5*Math.PI/9))
        }

        PathAttribute { name: "sangle"; value: -10 }
        PathAttribute { name: "op"; value: 1 }
        PathAttribute { name: "zo"; value: 4 }

        PathPercent { value: 5/9}

        PathLine {
            x: whole_path.startX
            y: whole_path.startY+view.r*(1-Math.cos(6*Math.PI/9))
        }

        PathAttribute { name: "sangle"; value: -30 }
        PathAttribute { name: "op"; value: 0.6 }
        PathAttribute { name: "zo"; value: 3 }

        PathPercent { value: 6/9}

        PathLine {
            x: whole_path.startX
            y: whole_path.startY+view.r*(1-Math.cos(7*Math.PI/9))
        }

        PathAttribute { name: "sangle"; value: -50 }
        PathAttribute { name: "op"; value: 0.4 }
        PathAttribute { name: "zo"; value: 2 }

        PathPercent { value: 7/9}

        PathLine {
            x: whole_path.startX
            y: whole_path.startY+view.r*(1-Math.cos(8*Math.PI/9))
        }

        PathAttribute { name: "sangle"; value: -70 }
        PathAttribute { name: "op"; value: 0.2 }
        PathAttribute { name: "zo"; value: 1 }

        PathPercent { value: 8/9}

        PathLine {
            x: whole_path.startX
            y: whole_path.startY+view.r*(1-Math.cos(Math.PI))
        }

        PathAttribute { name: "sangle"; value: -90 }
        PathAttribute { name: "op"; value: 0 }
        PathAttribute { name: "zo"; value: 0 }
        PathPercent { value: 1}
    }

    MouseArea {
        anchors.fill: parent
        preventStealing: true
        propagateComposedEvents: true

        Timer {
            id: wheeltimer
            interval: 20
            running: false
            repeat: false
            onTriggered: {
                view.wheelindex=-1
            }
        }

        onWheel: {
            wheeltimer.start();
            if(view.wheelindex==-1)
            {
                view.wheelindex = view.currentIndex;
            }
            if(wheel.angleDelta.y > 0)
            {
                view.wheelindex++
            }
            else if(wheel.angleDelta.y<0)
            {
                view.wheelindex--
            }
            if(view.wheelindex>view.model.count)
            {
                view.wheelindex=0;
            }
            if(view.wheelindex<0)
            {
                view.wheelindex=view.max_number-1;
            }
            view.currentIndex=view.wheelindex;
            view.index_change(view.wheelindex+view.order_begin);
        }
    }

    Canvas {
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = 1
            ctx.strokeStyle = "black"
            ctx.beginPath()
            ctx.moveTo(0, view.r*(1-Math.sin(Math.PI/18)))
            ctx.lineTo(view.width, view.r*(1-Math.sin(Math.PI/18)))

            ctx.moveTo(0, view.r*(1+Math.sin(Math.PI/18)))
            ctx.lineTo(view.width, view.r*(1+Math.sin(Math.PI/18)))

            ctx.closePath()
            ctx.stroke()
        }
    }

}


