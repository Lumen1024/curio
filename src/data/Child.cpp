#include "Child.h"

QJsonObject Child::toJson() const {
    QJsonObject obj;
    obj["id"] = id;
    obj["fullName"] = fullName;
    obj["grade"] = grade;
    return obj;
}

Child Child::fromJson(const QJsonObject& json) {
    Child child;
    child.id = json["id"].toInt();
    child.fullName = json["fullName"].toString();
    child.grade = json["grade"].toInt();
    return child;
}
