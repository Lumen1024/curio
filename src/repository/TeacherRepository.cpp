#include "TeacherRepository.h"
#include <QJsonObject>
#include <QDebug>

TeacherRepository::TeacherRepository(QObject* parent)
    : QObject(parent)
{
}

int TeacherRepository::generateId() {
    return m_nextId++;
}

int TeacherRepository::create(const QString& fullName, const QString& phone) {
    int id = generateId();
    Teacher teacher(id, fullName, phone);
    m_teachers.append(teacher);
    emit dataChanged();
    return id;
}

Teacher TeacherRepository::getById(int id) const {
    for (const auto& teacher : m_teachers) {
        if (teacher.id == id) {
            return teacher;
        }
    }
    return Teacher();
}

QList<Teacher> TeacherRepository::getAll() const {
    return m_teachers;
}

bool TeacherRepository::update(int id, const QString& fullName, const QString& phone) {
    for (auto& teacher : m_teachers) {
        if (teacher.id == id) {
            teacher.fullName = fullName;
            teacher.phone = phone;
            emit dataChanged();
            return true;
        }
    }
    return false;
}

bool TeacherRepository::remove(int id) {
    for (int i = 0; i < m_teachers.size(); ++i) {
        if (m_teachers[i].id == id) {
            m_teachers.removeAt(i);
            emit dataChanged();
            return true;
        }
    }
    return false;
}

void TeacherRepository::loadFromJson(const QJsonArray& jsonArray) {
    m_teachers.clear();
    m_nextId = 1;

    for (const QJsonValue& value : jsonArray) {
        QJsonObject obj = value.toObject();
        Teacher teacher;
        teacher.id = obj["id"].toInt();
        teacher.fullName = obj["fullName"].toString();
        teacher.phone = obj["phone"].toString();
        m_teachers.append(teacher);

        if (teacher.id >= m_nextId) {
            m_nextId = teacher.id + 1;
        }
    }

    emit dataChanged();
}
