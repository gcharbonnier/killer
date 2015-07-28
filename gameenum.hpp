#ifndef GAMEENUM_HPP
#define GAMEENUM_HPP


#include <QObject>

class GameEnums : public QObject
{
Q_OBJECT

Q_ENUMS(StuffType)
Q_ENUMS(AmmoType)

public:
enum StuffType
{
    Weapon,
    Ammo,
    Consumable,
    Special
};
enum AmmoType
{
    AmmoQty,
    AmmoGun,
    AmmoShotgun
};

// This is a wrapper, uncreatable type
GameEnums() = delete;
GameEnums(const GameEnums&) = delete;
GameEnums& operator=(const GameEnums&) = delete;
};
#endif // GAMEENUM_HPP

