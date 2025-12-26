import QtQuick

QtObject {
    id: utils

    function isSameDay(date1, date2) {
        return date1.getFullYear() === date2.getFullYear() &&
               date1.getMonth() === date2.getMonth() &&
               date1.getDate() === date2.getDate()
    }

    function getMondayOfWeek(date) {
        var result = new Date(date)
        var day = result.getDay()
        var diff = day === 0 ? 6 : day - 1
        result.setDate(result.getDate() - diff)
        return result
    }

    function getMonthName(date) {
        var monthNames = [
            "Январь", "Февраль", "Март", "Апрель", "Май", "Июнь",
            "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"
        ]
        return monthNames[date.getMonth()] + " " + date.getFullYear()
    }

    function getLessonTypeValue(typeName) {
        switch(typeName) {
            case "Умственное": return 0
            case "Спортивное": return 1
            case "Творческое": return 2
            default: return -1
        }
    }

    function isDateInRepeat(startDate, checkDate, repeatType) {
        var startDay = new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate())
        var checkDay = new Date(checkDate.getFullYear(), checkDate.getMonth(), checkDate.getDate())

        if (checkDay < startDay) {
            return false
        }

        if (repeatType === 0) {
            return true
        }

        if (repeatType === 1) {
            return startDate.getDay() === checkDate.getDay()
        }

        if (repeatType === 2) {
            return startDate.getDate() === checkDate.getDate()
        }

        return false
    }
}
