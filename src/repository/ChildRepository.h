#pragma once

#include <QObject>
#include <QList>
#include <QString>
#include <QJsonArray>
#include "../data/Child.h"

class ChildRepository : public QObject {
    Q_OBJECT

public:
    explicit ChildRepository(QObject* parent = nullptr);

    Q_INVOKABLE int create(const QString& fullName, int grade);
    Q_INVOKABLE Child getById(int id) const;
    Q_INVOKABLE QList<Child> getAll() const;
    Q_INVOKABLE bool update(int id, const QString& fullName, int grade);
    Q_INVOKABLE bool remove(int id);

    void loadFromJson(const QJsonArray& jsonArray);

signals:
    void dataChanged();

private:
    QList<Child> m_children;
    int m_nextId = 1;

    int generateId();
};
