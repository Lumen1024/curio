#pragma once

#include <QObject>
#include <QList>
#include <QString>
#include <QJsonArray>
#include "../data/Teacher.h"

class TeacherRepository : public QObject {
    Q_OBJECT

public:
    explicit TeacherRepository(QObject* parent = nullptr);

    Q_INVOKABLE int create(const QString& fullName, const QString& phone);
    Q_INVOKABLE Teacher getById(int id) const;
    Q_INVOKABLE QList<Teacher> getAll() const;
    Q_INVOKABLE bool update(int id, const QString& fullName, const QString& phone);
    Q_INVOKABLE bool remove(int id);

    void loadFromJson(const QJsonArray& jsonArray);

signals:
    void dataChanged();

private:
    QList<Teacher> m_teachers;
    int m_nextId = 1;

    int generateId();
};
