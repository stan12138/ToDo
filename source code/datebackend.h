#ifndef DATEBACKEND_H
#define DATEBACKEND_H

#include <QObject>

class DateBackEnd : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<int> date READ date CONSTANT)

public:
    explicit DateBackEnd(QObject *parent = nullptr);

    QList<int> date_record;

    QList<int> date();

signals:

public slots:
};

#endif // DATEBACKEND_H
