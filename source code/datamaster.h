#ifndef DATAMASTER_H
#define DATAMASTER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>

#include <QVariant>
#include <QVariantList>

class DataMaster : public QObject
{
    Q_OBJECT
public:
    explicit DataMaster(QObject *parent = nullptr);
    QSqlDatabase db;
    QSqlQuery query;

    Q_INVOKABLE bool database_init();
    Q_INVOKABLE bool insert(QVariantList item);
    Q_INVOKABLE QVariantList get_data();
    Q_INVOKABLE bool update_item(QVariantList item);
    Q_INVOKABLE int get_id();
    Q_INVOKABLE bool update_id(int id);

    Q_INVOKABLE void database_close();




signals:

public slots:
};

#endif // DATAMASTER_H
