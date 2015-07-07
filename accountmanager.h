#ifndef ACCOUNTMANAGER_H
#define ACCOUNTMANAGER_H

#include "gamedata.h"
#include <QObject>

class AccountManager : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY(uint accountId      READ accountId     NOTIFY loggedChanged)
    Q_PROPERTY(QString accountName      READ accountName     NOTIFY loggedChanged)
    Q_PROPERTY(QString password      READ password     NOTIFY loggedChanged)
    Q_PROPERTY(bool isLogged      READ isLogged      NOTIFY loggedChanged)

    explicit AccountManager(GameData& gameData, QObject *parent = 0);
    ~AccountManager();


    uint accountId() const{ return m_accountId; }
    static uint accountId(QString alias);
    static uint checkPassword(QString alias, QString password);
    Q_INVOKABLE static bool accountExists(QString alias);
    Q_INVOKABLE static uint createAccount( QString alias, QString password);

    Q_INVOKABLE uint logIn(QString alias, QString m_sPassword);
    uint logIn();
    Q_INVOKABLE void logOut();

    bool isLogged() const{ return accountId(); }
    QString accountName() const{ return m_accountName; }
    QString password() const{ return m_sPassword;}


signals:
    void loggedChanged();
public slots:

private:
    GameData& m_gameData;

    uint m_accountId = 0;
    QString m_accountName = "";
    QString m_sPassword = "";

};

#endif // ACCOUNTMANAGER_H
