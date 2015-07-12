import QtQuick 2.0
import QtSensors 5.4

Item{
    //height: parent.height
    //width: parent.width*0.5


    Flipable{
        id:flipable
        anchors.fill: parent


        /*
        back:Radar_SPS{
            id:radar
            anchors.fill: flipable
            heading: gameManager.direction
            showCompass: true
            maxRange: 200.0
            model: playerModel
            showZoomControl : true

        }*/

        front:Map_SPS{
            id:myMap
            anchors.fill: flipable
            model: playerModel
        }

        transform: Rotation {
            id: rotation
            origin.x: flipable.width/2
            origin.y: flipable.height/2
            axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
            angle: 0    // the default angle
        }
        states: State {
            name: "back"
            PropertyChanges { target: rotation; angle: 180 }

        }

        transitions: Transition {
            NumberAnimation { target: rotation; property: "angle"; duration: 1000 }

        }


        /*
        MouseArea{
            anchors.fill: flipable
            propagateComposedEvents: true
            onDoubleClicked: {

                if ( flipable.side == Flipable.Back)
                    flipable.state = ""
                else flipable.state = "back"
            }


        }

        OrientationSensor{
            active: true
            onReadingChanged: {
                if (reading.orientation === OrientationReading.RightUp)
                    flipable.state = "back";
                else flipable.state = "";
            }
        }
        */
    }
}
