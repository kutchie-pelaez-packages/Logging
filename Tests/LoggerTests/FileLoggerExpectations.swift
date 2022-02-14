enum FileLoggerExpectations {
    static let logsWithDifferentDomainsAndMessages = """
    ╭────────────────────────────────────────────────────────────────╮
    │ 12:00:00 [shortDomain]              Really really long message │
    │ 12:05:25 [reallyReallyLongDomain]   Short message              │
    │ 13:40:01 [shortDomain]              Really really long message │
    ├──────────────────────┬─────────────────────────────────────────╯
    │ Date: January 1      │
    │ Session: 1           │
    │ Time spent: 02:45:01 │
    ╰──────────────────────╯
    """

    static let logsWithAdditionalParameters = """
    ╭─────────────────────────────╮
    │ 12:00:00 [domain]   Message │
    ├────────────────────────────┬╯
    │ Date: January 1            │
    │ Session: 1                 │
    │ Time spent: 00:00:00       │
    │ Some parameter 1           │
    │ Some parameter 2           │
    │ Some really long parameter │
    ╰────────────────────────────╯
    """

    static let logsWithBoxNarrowerThanFooter = """
    ╭─────────────────────────────╮
    │ 12:00:00 [domain]   Message │
    ├─────────────────────────────┴─────╮
    │ Date: January 1                   │
    │ Session: 1                        │
    │ Time spent: 00:00:00              │
    │ Some really really long parameter │
    ╰───────────────────────────────────╯
    """

    static let logsWithBoxEqualToFooter = """
    ╭─────────────────────────────╮
    │ 12:00:00 [domain]   Message │
    ├─────────────────────────────┤
    │ Date: January 1             │
    │ Session: 1                  │
    │ Time spent: 00:00:00        │
    │ Some parameter 123456789012 │
    ╰─────────────────────────────╯
    """

    static let logsWithWarningsAndErrors = """
    ╭──────────────────────────────╮
    │ 12:00:00 [log]       Message │
    │ 12:00:00 [warning]   Warning │ 🟡 FileLoggerTests::test5_withWarningsAndErrors() 165
    │ 12:00:00 [error]     Error   │ 🔴 FileLoggerTests::test5_withWarningsAndErrors() 167
    ├──────────────────────┬───────╯
    │ Date: January 1      │
    │ Session: 1           │
    │ Time spent: 00:00:00 │
    ╰──────────────────────╯
    """

    static let logsWithManySessions = """
    ╭─────────────────────────────╮
    │ 12:00:00 [domain]   Message │
    ├──────────────────────┬──────╯
    │ Date: January 1      │
    │ Session: 1           │
    │ Time spent: 01:00:00 │
    ╰──────────────────────╯

    ╭─────────────────────────────╮
    │ 12:00:00 [domain]   Message │
    ├──────────────────────┬──────╯
    │ Date: January 4      │
    │ Session: 2           │
    │ Time spent: 03:00:00 │
    ╰──────────────────────╯

    ╭─────────────────────────────╮
    │ 12:00:00 [domain]   Message │
    ├──────────────────────┬──────╯
    │ Date: January 10     │
    │ Session: 3           │
    │ Time spent: 05:00:00 │
    ╰──────────────────────╯
    """
}