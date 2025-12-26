#pragma once

#include <QString>
#include <QObject>
#include <QJsonObject>

class Teacher {
    Q_GADGET
    Q_PROPERTY(int id MEMBER id)
    Q_PROPERTY(QString fullName MEMBER fullName)
    Q_PROPERTY(QString phone MEMBER phone)

public:
    int id = 0;
    QString fullName;
    QString phone;

    Teacher() = default;
    Teacher(int id, const QString& fullName, const QString& phone)
        : id(id), fullName(fullName), phone(phone) {}

    QJsonObject toJson() const;
    static Teacher fromJson(const QJsonObject& json);
};
