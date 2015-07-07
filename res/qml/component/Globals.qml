import QtQuick 2.0
import QtMultimedia 5.0
import QtQuick.Controls.Styles 1.3
//pragma Singleton
Item {

    property var sounds:sounds
    property var ui:ui
    property var currentTarget:currentTarget
    property var stuff:stuff


    Item{
        id:ui
        property color background:"lightgrey"
        property color menuBackground:"orange"
        property color textcolor:"white"
        property color textEditColor:"black"
        property color buttonMenuBkColor:"lightgrey"
        property color buttonMenuBkColorDisabled:"grey"
        property color buttonBkColor:"orange"
        property color buttonBkColorDisabled:"grey"
        property color borderColor:"grey"
        property color textInputBackground:"orange"
        property real buttonRadiusPercHeight: 0.2 //Defines the perc of height to compute the corner radius
        property real backgroundRadiusPercHeight: 0.1
        property int buttonMargin: 10
        property real buttonBkOpacity:0.7
        property int minimumPixelSize:1
        property int textInputDynSize: Math.floor( Math.max(10 , mainWnd.height / 30))
        property int textS:24
        property int textM:32
        property int textXL:48
        property int textXXL:70
        property int textXXXL:100
        property int textGodzilla:300
        property Gradient backgradient: Gradient{
            GradientStop{ position: 0; color:"red";}
            GradientStop{ position: 0.6; color:"black";}
        }


    }
    Item{
        id:currentTarget
        property string id:""
        property string name:""
        property int distance:0
        property int azimuth:0

    }

    Item{
        id:stuff
        property int gunAmmonition:10


    }

    Item{
        id:sounds
        property var shoot:shoot
        SoundEffect {
            id: shoot
            source: "/res/audio/shooter-action.wav"
        }
    }

}



