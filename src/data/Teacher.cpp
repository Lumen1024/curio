#include "Teacher.h"

QJsonObject Teacher::toJson() const {
    QJsonObject obj;
    obj["id"] = id;
    obj["fullName"] = fullName;
    obj["phone"] = phone;
    return obj;
}

Teacher Teacher::fromJson(const QJsonObject& json) {
    Teacher teacher;
    teacher.id = json["id"].toInt();
    teacher.fullName = json["fullName"].toString();
    teacher.phone = json["phone"].toString();
    return teacher;
}
