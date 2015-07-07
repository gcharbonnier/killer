#ifndef GAMEDATA_H
#define GAMEDATA_H

#include <QGeoPositionInfo>
#include <QObject>

class GameData : public QObject
{
    Q_OBJECT

public:
    explicit GameData():QObject(){}
    ~GameData(){}

    uint    accountId() const{ return _accountId;}
    QString accountName() const{ return _accountName;}
    void setAccountData( uint id, QString name){
        _accountId = id;
        _accountName = name;
    }

    uint    campaignId() const{ return _campaignId;}
    QString campaignName() const{ return _campaignName;}
    void setcampaignData( uint id, QString name){
        _campaignId = id;
        _campaignName = name;
    }

    qreal lastDirection() const { return _lastDirection;}
    void setLastDirection( qreal dir) { _lastDirection = dir;}
    QGeoPositionInfo lastPosition() const { return _lastPosition;}
    void setLastPosition( QGeoPositionInfo pos) { _lastPosition = pos;}


private:

    //Owned by AccountManager
    uint _accountId = 0;
    QString _accountName = "";
    //Owned by CampaignManager
    uint _campaignId = 0;          //ID of the current campaign - 0 if no campaing is selected with startGame()
    QString _campaignName = "";


    QGeoPositionInfo _lastPosition = QGeoPositionInfo();
    qreal _lastDirection = 0.;
};


#endif // GAMEDATA_H

