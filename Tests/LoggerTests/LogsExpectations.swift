import Foundation

private let sessionDayDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM d"
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

    return dateFormatter
}()

enum LogsExpectations {
    static let logsWithDifferentDomainsAndMessages = """
    ╭────────────────────────────────────────────────────────────────╮
    │ 01:47:21 [shortDomain]              Really really long message │
    │ 01:47:21 [reallyReallyLongDomain]   Short message              │
    │ 01:47:21 [shortDomain]              Really really long message │
    ├──────────────────────┬─────────────────────────────────────────╯
    │ Date: February 13    │
    │ Session: 1           │
    │ Time spent: 00:00:00 │
    ╰──────────────────────╯
    """

    static let logsWithWarningsAndErrors = """
    ╭──────────────────────────────╮
    │ 01:47:21 [log]       Message │
    │ 01:47:21 [warning]   Message │ 🟡 LoggerTests 7
    │ 01:47:21 [error]     Message │ 🔴 LoggerTests 7
    ├──────────────────────┬───────╯
    │ Date: February 13    │
    │ Session: 1           │
    │ Time spent: 00:00:00 │
    ╰──────────────────────╯
    """

    static let logsWithManySessions = """
    ╭─────────────────────────────╮
    │ 01:47:21 [domain]   Message │
    ├──────────────────────┬──────╯
    │ Date: February 13    │
    │ Session: 1           │
    │ Time spent: 00:00:00 │
    ╰──────────────────────╯

    ╭─────────────────────────────╮
    │ 01:47:21 [domain]   Message │
    ├──────────────────────┬──────╯
    │ Date: February 13    │
    │ Session: 2           │
    │ Time spent: 00:00:00 │
    ╰──────────────────────╯

    ╭─────────────────────────────╮
    │ 01:47:21 [domain]   Message │
    ├──────────────────────┬──────╯
    │ Date: February 13    │
    │ Session: 3           │
    │ Time spent: 00:00:00 │
    ╰──────────────────────╯
    """
}
