import QtQuick 2.0
import QtMultimedia 5.0
import MyEnums 1.0

import "../../../GameLogic.js" as EquipmentAction

//import QtQuick.Controls.Styles 1.3
//import QtLocation 5.4
//import QtPositioning 5.4

//pragma Singleton
Item {

    property var sounds:sounds
    property var ui:ui
    property var currentTarget:currentTarget
    property var stuff:stuff
    property var perso:perso
    property var currentWeapon:currentWeapon
    property var stuffModel:stuffModel
    property var weaponModel:weaponModel
    property var skillModel:skillModel



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
        property string id:"Not defined"
        property string name:"Not defined"
        property int distance:0
        property int azimuth:0
        property int modelIndex:0
        property int health:0
        property int credits:0
        property int level:0
        property int xp:0
        property int energy:0
    }

    Item{
        id:perso
        property int health:-1
        property int maxHealth : 100
        property int xp:-1
        property variant xpLevel:[0, 100, 500, 1500, 3000, 7000, 15000, 20000 ]
        property int energy:-1
        property int maxEnergy:1000
        property int credits:-1
        property int level:1
        property int xpMinLevelCurrent : xpLevel[level-1]
        property int xpMaxLevelCurrent : xpLevel[level]
        property int nbKilled : 0
        property int nbDead : 0


    }

    Item{
        id:currentWeapon

    }

    Item{
        id:stuff
        property int gunAmmonition:10
        property int shotgunAmmonition:5
        property int riffleAmmonition:5


    }

    Item{
        id:sounds
        property var shoot:shoot
        property var injured:injured
        property var missed:missed
        property var dead:dead
        property var succeeded:succeeded
        property var yeah:yeah
        property var energy:energy
        SoundEffect {
            id: shoot
            source: "/res/audio/shooter-action.wav"
        }
        /*SoundEffect {
            id: shoot
            source: "/res/audio/shotgun.wav"
        }*/
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
        SoundEffect {
            id: energy
            source: "/res/audio/currency.wav"
        }
    }

    ListModel{
        id:weaponModel



        function recreateModel()
        {
            weaponModel.clear();
            for (var i=0; i < stuffModel.count; i++)
            {
                var stuff = stuffModel.get(i);
                if ( ( stuff.type === Enums.Weapon) && (stuff.selected))
                {
                    //console.log("add " + stuff.label);
                    weaponModel.append( {
                                           "idStuffModel" : i,
                                           "label" : stuff.label,
                                           "imageWeapon":stuff.image,
                                           "imageAmmo": stuff.customProperties.get(0).imageAmmo,//"qrc:/res/bullet.png",
                                           "health" : stuff.health,
                                           "minDistance":stuff.customProperties.get(0).minDistance,
                                           "maxDistance":stuff.customProperties.get(0).maxDistance,
                                           "damageFactor":stuff.customProperties.get(0).damageFactor,
                                           "maxAmmo" : stuff.customProperties.get(0).maxAmmo,
                                           "ammoType" : stuff.customProperties.get(0).ammoType,
                                           "imageAmmo":stuff.customProperties.get(0).imageAmmo,
                                           "sound":stuff.customProperties.get(0).sound
                                       } );
                }
            }
        }
    }

    ListModel{
        id:stuffModel
        //A dummy model to test the component
        ListElement{
            idAction: 1
            label:qsTr("gun ammo pack")
            image:"qrc:/res/bullet.png"
            cost: 50
            type : Enums.Ammo
            quantity : 1
            useQuantity : 1
            description : qsTr("A box of 10 bullets for the handgun")
            customProperties: [ ListElement{ ammo:10}]
            selectable:false
            selected: false
            health:100
            maxHealth:100
            useHealth:0
        }
        ListElement{
            idAction: 2
            label:qsTr("Shootgun ammo pack")
            image:"qrc:/res/ammo_shootgun.png"
            description : qsTr("A box of 5 bullets for the shotgun")
            cost: 100
            type : Enums.Ammo
            quantity : 1
            useQuantity : 1
            customProperties: [ ListElement{ ammo:5}]
            selectable:false
            selected: false
            health:100
            maxHealth:100
            useHealth:0
        }
        ListElement{
            idAction: 3
            label:qsTr("Riffle ammo pack")
            image:"qrc:/res/ammo_riffle.png"
            description : qsTr("A box of 10 bullets for the riffle")
            cost: 100
            type : Enums.Ammo
            quantity : 1
            useQuantity : 1
            customProperties: [ ListElement{ ammo:10}]
            selectable:false
            selected: false
            health:100
            maxHealth:100
            useHealth:0
        }
        ListElement{
            idAction: 4
            label:qsTr("gun")
            image:"qrc:/res/gun.png"
            description : qsTr("standard handgun")
            cost: 0
            type : Enums.Weapon
            quantity : 1
            useQuantity : 0
            customProperties: [
                ListElement{
                    minDistance:15
                    maxDistance:150
                    damageFactor:1
                    maxAmmo : 10
                    ammoType : Enums.AmmoGun
                    sound:"/res/audio/shooter-action.wav"
                    imageAmmo:"qrc:/res/bullet.png"
                }]
            selectable:true
            selected: true
            health:100
            maxHealth:100
            useHealth:0
        }
        ListElement{
            idAction: 5
            label:qsTr("Shotgun")
            image:"qrc:/res/shotgun.png"
            description : qsTr("A standard shootgun<br>Much easier to shoot, reduced range but higher damage")
            cost: 1000
            type : Enums.Weapon
            quantity : 1
            useQuantity : 0
            customProperties: [
                ListElement{
                    minDistance:30
                    maxDistance:300
                    damageFactor:1
                    maxAmmo : 5
                    sound:"/res/audio/shotgun.wav"
                    ammoType : Enums.AmmoShotgun
                    imageAmmo:"qrc:/res/ammo_shootgun.png"
                }]
            selectable:true
            selected: true
            health:100
            maxHealth:100
            useHealth:0
        }
        ListElement{
            idAction: 6
            label:qsTr("missile")
            image:"qrc:/res/missile.png"
            description : qsTr("No range limit, very high damage...the ultimate weapon (except if you have friends in the area)")
            cost: 5000
            type : Enums.Weapon
            quantity : 1
            useQuantity : 0
            customProperties: [
                ListElement{
                    minDistance:30000
                    maxDistance:4000000
                    damageFactor:1
                    maxAmmo : 5
                    ammoType : Enums.AmmoQty
                    sound:"/res/audio/missile.wav"
                    imageAmmo:"qrc:/res/missile.png"
                }]
            selectable:true
            selected: true
            health:100
            maxHealth:100
            useHealth:0
        }
        ListElement{
            idAction: 7
            label:qsTr("medikit")
            image:"qrc:/res/medikit.png"
            description : qsTr("A very handy item...")
            cost: 50
            type : Enums.Consumable
            quantity : 1
            useQuantity : 1
            customProperties: [ ListElement{ health:20}]
            selectable:false
            selected: false
            health:100
            maxHealth:100
            useHealth:0
        }
        ListElement{
            idAction: 8
            label:qsTr("Portal to Nantes")
            image:"qrc:/res/portal.png"
            description : qsTr("When selected your position will be ofsetted to Nantes center...")
            cost: 1
            type : Enums.Special
            quantity : 1
            useQuantity : 0
            customProperties: [ ListElement{ latitude:47.218908; longitude: -1.553766 } ]
            selectable:true
            selected: false
            health:100
            maxHealth:100
            useHealth:0
        }
    }

    ListModel{
        id:skillModel
        //A dummy model to test the component
        ListElement{
            label:qsTr("Heal !")
            image:"qrc:/res/heal.png"
            energyCost:5
            percChanceToSuccess : 50
            duration : 30
            available : true
        }
        ListElement{
            label:qsTr("Work !")
            image:"qrc:/res/work.png"
            energyCost:5
            percChanceToSuccess : 80
            duration : 300
            available : true

        }
        ListElement{
            label:qsTr("Steal !")
            percChanceToSuccess : 10
            energyCost:5
            image:"qrc:/res/steal.png"
            available : false
        }
        ListElement{
            label:qsTr("Avoid !")
            percChanceToSuccess : 10
            energyCost:5
            image:"qrc:/res/avoid.png"
            available : false
        }
        ListElement{
            label:qsTr("Repair !")
            percChanceToSuccess : 10
            energyCost:5
            image:"qrc:/res/repair.png"
            available : false
        }
        ListElement{
            label:qsTr("Build !")
            percChanceToSuccess : 10
            energyCost:5
            image:"qrc:/res/build.png"
            available : false
        }
        ListElement{
            label:qsTr("Teach !")
            percChanceToSuccess : 10
            energyCost:5
            image:"qrc:/res/teach.png"
            available : false
        }

        //TODO Tirer
        //Égorger
        //Eviter
        //Repérer embrouille (déguisement/bombe)
        //Réparer
        //Vendre
        //Enseigner

    }

}



