//import MyEnums 1.0

function startGame()
{
    loadPlayerData();
    reloadStuff();
}

function stopGame()
{
    savePlayerData();
    saveStuff();
}

function loadPlayerData(){
    var myData = playerModel.getMyData();
    globals.perso.health = myData[0];
    globals.perso.xp = myData[1];
    globals.perso.credits = myData[2];
    globals.perso.energy = myData[3];
    globals.perso.level = myData[4];
}

function reloadStuff(){
    for (var i=0; i < globals.stuffModel.count; i++)
    {
        var stuff = gameManager.getStuffItemData(i); //stuffModel.get(i);
        if (stuff[0] !== -1)
        {
            globals.stuffModel.setProperty(i, "quantity", stuff[0]);
            globals.stuffModel.setProperty(i, "selected", stuff[1] === 1 ? true : false);
        }
    }

    //update weapon model
    globals.weaponModel.recreateModel();

}
function saveStuff(){
    for (var i=0; i < globals.stuffModel.count; i++)
    {
        var stuff = globals.stuffModel.get(i);
        gameManager.saveStuffItem(i, stuff.quantity, stuff.selected);
    }

}

function savePlayerData(){
    playerModel.updateMyData( globals.perso.health,
                             globals.perso.xp,
                             globals.perso.credits,
                             globals.perso.energy,
                             globals.perso.level);
}

function updateValue( value, delta, min, max)
{
    var newValue = value;
    newValue += delta;
    newValue = Math.max(min, newValue);
    newValue = Math.min(max, newValue);
    value = newValue;
    return value;
}

function  modifyHealth( delta){
    var newValue = updateValue( globals.perso.health, delta, 0, globals.perso.maxHealth)
    if (newValue === globals.perso.health) return;

    globals.perso.health = newValue;
    if (delta < 0)
    {
        //play sound

    }else
    {
        //play sound
    }
    //Updata database
    savePlayerData();

}
function  modifyEnergy( delta){
    var newValue = updateValue( globals.perso.energy, delta, 0, globals.perso.maxEnergy)
    if (newValue === globals.perso.energy) return;

    globals.perso.energy = newValue;
    if (delta < 0)
    {
        //play sound

    }else
    {
        //play sound
    }
    //Update database
    //savePlayerData();

}

function  modifyXP( delta){
    //globals.perso.xp
    globals.perso.xp += delta;
    if (globals.perso.xp > globals.perso.xpMaxLevelCurrent)
    {
        //level up
        globals.perso.level++;
        //todo bonus

        //Update database
        savePlayerData();
    }



}

function useObject( idObject, use, customProperties) {
    switch (idObject)
    {
    case 1: //gun ammo pack
        globals.stuff.gunAmmonition += customProperties.get(0).ammo;
        break;
    case 2: //Shootgun ammo pack
        globals.stuff.shotgunAmmonition += customProperties.get(0).ammo;
        break;
    case 3: //Riffle ammo pack
        globals.stuff.riffleAmmonition += customProperties.get(0).ammo;
        break;
    case 4: //gun
        globals.weaponModel.recreateModel();
        break;
    case 5: //Shotgun
        globals.weaponModel.recreateModel();
        break;
    case 6: //missile
        globals.weaponModel.recreateModel();
        break;
    case 7: //medikit
        modifyHealth( customProperties.get(0).health );
        break;
    case 8: //Portal to Nantes
        if (use)
            gameManager.setOffsetPosition(customProperties.get(0).latitude, customProperties.get(0).longitude);
        else gameManager.setOffsetPosition( 0., 0.);

        break;
    default:
    }
}


function useSkill( skill)
{
    switch(skill)
    {
    case 0: //heal
        modifyHealth( 30 );
        break;
    case 1: //work
        globals.perso.credits += 5;
        break;
    case 2: //steal
        break;
    }
}

