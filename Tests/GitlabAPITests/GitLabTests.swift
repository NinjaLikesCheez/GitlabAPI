import Foundation
@testable import GitLabAPI
import Testing
import Logging

@Suite class GitLabTests: GitLabTest {
	@Test
	func listRegistryRepositories() async throws {
		LoggingSystem.bootstrap { label in
			var logger = StreamLogHandler.standardOutput(label: label)
			logger.logLevel = .debug
			return logger
		}
		print(try await client.request(.listRegistryRepositories(id: Secrets.repoID)))
	}
}
