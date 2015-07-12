import QtQuick 2.0
import QtMultimedia 5.0
import QtQuick.Controls.Styles 1.3
import QtLocation 5.4
import QtPositioning 5.4

//pragma Singleton
Item {

    property var sounds:sounds
    property var ui:ui
    property var currentTarget:currentTarget
    property var stuff:stuff
    property var perso:perso
    property var currentWeapon:currentWeapon


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
        property int minimumPixelSize:8
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
        id:perso
        property int health:100
        property int xp:0
        property int credits:50
        property int level:1
        property int xpMinLevelCurrent : 0
        property int xpMaxLevelCurrent : 1000
        property int nbKilled : 0
        property int nbDead : 0


    }

    Item{
        id:currentWeapon
        property int maxDistance:150
        property int minDistance:15
        property int damageFactor : 1

    }

    Item{
        id:stuff
        property int gunAmmonition:99


    }

    Item{
        id:sounds
        property var shoot:shoot
        property var injured:injured
        property var missed:missed
        property var dead:dead
        property var succeeded:succeeded
        property var yeah:yeah
        SoundEffect {
            id: shoot
            source: "/res/audio/shooter-action.wav"
        }
        SoundEffect {
            id: injured
            source: "/res/audio/injured.wav"
        }
        SoundEffect {
            id: missed
            source: "/res/audio/missed.wav"
        }
        SoundEffect {
            id: dead
            source: "/res/audio/dead.wav"
        }
        SoundEffect {
            id: succeeded
            source: "/res/audio/succeeded.wav"
        }
        SoundEffect {
            id: yeah
            source: "/res/audio/yeah.wav"
        }
    }

}



