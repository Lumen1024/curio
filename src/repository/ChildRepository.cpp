#include "ChildRepository.h"
#include <QJsonObject>
#include <QDebug>

ChildRepository::ChildRepository(QObject* parent)
    : QObject(parent)
{
}

int ChildRepository::generateId() {
    return m_nextId++;
}

int ChildRepository::create(const QString& fullName, int grade) {
    int id = generateId();
    Child child(id, fullName, grade);
    m_children.append(child);
    emit dataChanged();
    return id;
}

Child ChildRepository::getById(int id) const {
    for (const auto& child : m_children) {
        if (child.id == id) {
            return child;
        }
    }
    return Child();
}

QList<Child> ChildRepository::getAll() const {
    return m_children;
}

bool ChildRepository::update(int id, const QString& fullName, int grade) {
    for (auto& child : m_children) {
        if (child.id == id) {
            child.fullName = fullName;
            child.grade = grade;
            emit dataChanged();
            return true;
        }
    }
    return false;
}

bool ChildRepository::remove(int id) {
    for (int i = 0; i < m_children.size(); ++i) {
        if (m_children[i].id == id) {
            m_children.removeAt(i);
            emit dataChanged();
            return true;
        }
    }
    return false;
}

void ChildRepository::loadFromJson(const QJsonArray& jsonArray) {
    m_children.clear();
    m_nextId = 1;

    for (const QJsonValue& value : jsonArray) {
        QJsonObject obj = value.toObject();
        Child child;
        child.id = obj["id"].toInt();
        child.fullName = obj["fullName"].toString();
        child.grade = obj["grade"].toInt();
        m_children.append(child);

        if (child.id >= m_nextId) {
            m_nextId = child.id + 1;
        }
    }

    emit dataChanged();
}
