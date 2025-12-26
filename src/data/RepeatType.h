#pragma once

#include <QObject>

namespace RepeatTypeNS {
    Q_NAMESPACE

    enum class RepeatType {
        Day,
        Week,
        Month
    };
    Q_ENUM_NS(RepeatType)
}

using RepeatType = RepeatTypeNS::RepeatType;
