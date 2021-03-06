@testable import LoggerImpl
import Core
import Logger
import SessionManager
import Tweaking
import XCTest

private let loggerTestsURL = URL(fileURLWithPath: #file)

private let fixturesURL = loggerTestsURL
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .appendingPathComponent("Fixtures")

private let testsLogsURL = fixturesURL
    .appendingPathComponent("logs")

final class LoggerTests: XCTestCase {
    private let sessionManagerMock = SessionManagerMock()
    private let loggerProviderMock = LoggerProviderMock()

    private var _currentDate: Date = .now

    private var subject: Logger!

    private var logs: String {
        String(
            data: try! Data(contentsOf: testsLogsURL),
            encoding: .utf8
        )!
    }

    override class func setUp() {
        cleanup()
    }

    override class func tearDown() {
        cleanup()
    }

    private static func cleanup() {
        try? "".write(
            to: testsLogsURL,
            atomically: true,
            encoding: .utf8
        )
    }

    private func makeSubject() -> Logger {
        FileLogger(
            provider: loggerProviderMock,
            sessionManager: sessionManagerMock,
            currentDateResolver: { self._currentDate }
        )
    }

    private func testDate(shiftedBy timeInterval: TimeInterval) -> Date {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "en_US")
        let referenceDateComponents = DateComponents(
            calendar: calendar,
            timeZone: TimeZone(secondsFromGMT: 0),
            year: 2022,
            month: 1,
            day: 1,
            hour: 12,
            minute: 0,
            second: 0
        )
        let referenceDate = calendar.date(from: referenceDateComponents)!

        return referenceDate.addingTimeInterval(timeInterval)
    }

    func test1_withDifferentDomainsAndMessages() {
        _currentDate = testDate(shiftedBy: 0)
        sessionManagerMock.underlyingSession = 1
        subject = makeSubject()

        _currentDate = testDate(shiftedBy: 0)
        subject.log("Really really long message", domain: .shortDomain)

        _currentDate = testDate(shiftedBy: .minutes(5) + .seconds(25))
        subject.log("Short message", domain: .reallyReallyLongDomain)

        _currentDate = testDate(shiftedBy: .hour + .minutes(40) + .second)
        subject.log("Really really long message", domain: .shortDomain)

        XCTAssertEqual(
            logs,
            FileLoggerExpectations.logsWithDifferentDomainsAndMessages
        )

        Self.cleanup()
    }

    func test2_withAdditionalParameters() {
        _currentDate = testDate(shiftedBy: 0)
        sessionManagerMock.underlyingSession = 1
        loggerProviderMock.underlyingSessionAdditionalParams = [
            "Some parameter 1",
            "Some parameter 2",
            "Some really long parameter"
        ]
        subject = makeSubject()

        subject.log("Message", domain: .domain)

        XCTAssertEqual(
            logs,
            FileLoggerExpectations.logsWithAdditionalParameters
        )

        Self.cleanup()
    }

    func test3_withBoxNarrowerThanFooter() {
        _currentDate = testDate(shiftedBy: 0)
        sessionManagerMock.underlyingSession = 1
        loggerProviderMock.underlyingSessionAdditionalParams = [
            "Some really really really really long parameter"
        ]
        subject = makeSubject()

        subject.log("Message", domain: .domain)

        XCTAssertEqual(
            logs,
            FileLoggerExpectations.logsWithBoxNarrowerThanFooter
        )

        Self.cleanup()
    }

    func test4_withBoxEqualToFooter() {
        _currentDate = testDate(shiftedBy: 0)
        sessionManagerMock.underlyingSession = 1
        loggerProviderMock.underlyingSessionAdditionalParams = [
            "Some parameter 123456789012345678901234"
        ]
        subject = makeSubject()

        subject.log("Message", domain: .domain)

        XCTAssertEqual(
            logs,
            FileLoggerExpectations.logsWithBoxEqualToFooter
        )

        Self.cleanup()
    }

    func test5_withWarningsAndErrors() {
        _currentDate = testDate(shiftedBy: 0)
        sessionManagerMock.underlyingSession = 1
        subject = makeSubject()

        subject.log("Message", domain: .log)

        subject.warning("Warning", domain: .warning)

        subject.error("Error", domain: .error)

        XCTAssertEqual(
            logs,
            FileLoggerExpectations.logsWithWarningsAndErrors
        )

        Self.cleanup()
    }

    func test6_withManySessions() {
        _currentDate = testDate(shiftedBy: 0)
        sessionManagerMock.underlyingSession = 1
        subject = makeSubject()
        subject.log("Message", domain: .domain)
        subject = nil

        _currentDate = testDate(shiftedBy: .days(3))
        sessionManagerMock.underlyingSession = 2
        subject = makeSubject()
        subject.log("Message", domain: .domain)
        subject = nil

        _currentDate = testDate(shiftedBy: .days(9))
        sessionManagerMock.underlyingSession = 3
        subject = makeSubject()
        subject.log("Message", domain: .domain)
        subject = nil

        XCTAssertEqual(
            logs,
            FileLoggerExpectations.logsWithManySessions
        )

        Self.cleanup()
    }
}

extension LoggingDomain {
    fileprivate static let shortDomain: LoggingDomain = "LoggerTests.shortDomain"
    fileprivate static let reallyReallyLongDomain: LoggingDomain = "LoggerTests.reallyReallyLongDomain"
    fileprivate static let log: LoggingDomain = "LoggerTests.log"
    fileprivate static let warning: LoggingDomain = "LoggerTests.warning"
    fileprivate static let error: LoggingDomain = "LoggerTests.error"
    fileprivate static let domain: LoggingDomain = "LoggerTests.domain"
}

private final class SessionManagerMock: SessionManager {
    var underlyingSession = 0

    func receive(_ tweak: Tweak) { }
    var sessionValueSubject: ValueSubject<Int> { MutableValueSubject(underlyingSession) }
}

private final class LoggerProviderMock: LoggerProvider {
    var underlyingSessionAdditionalParams = [String]()

    var logsURL: URL { testsLogsURL }
    var sessionAdditionalParams: [String] { underlyingSessionAdditionalParams }
}
