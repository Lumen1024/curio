#pragma once

#include <QString>
#include <QObject>
#include <QJsonObject>

class Child {
    Q_GADGET
    Q_PROPERTY(int id MEMBER id)
    Q_PROPERTY(QString fullName MEMBER fullName)
    Q_PROPERTY(int grade MEMBER grade)

public:
    int id = 0;
    QString fullName;
    int grade = 0;

    Child() = default;
    Child(int id, const QString& fullName, int grade)
        : id(id), fullName(fullName), grade(grade) {}

    QJsonObject toJson() const;
    static Child fromJson(const QJsonObject& json);
};
