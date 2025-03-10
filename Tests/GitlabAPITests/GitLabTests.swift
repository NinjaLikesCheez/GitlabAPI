import Foundation
@testable import GitLabAPI
import Testing
import Logging

@Suite class GitLabTests: GitLabTest {

	override init() {
		LoggingSystem.bootstrap { label in
			var logger = StreamLogHandler.standardOutput(label: label)
			logger.logLevel = .debug
			return logger
		}
	}

//	@Test
//	func listRegistryRepositories() async throws {
//		print(try await client.request(.listRegistryRepositories(id: Secrets.repoID)))
//	}
//
//	@Test func listPackages() async throws {
//		let packages = try await client.request(.packages(id: Secrets.repoID))
//		print(packages[0])
//	}
//
//	@Test func listPackageFiles() async throws {
//		let packages = try await client.request(.packages(id: Secrets.repoID, version: "merge-request"))
//		let files = try await client.request(.packageFiles(projectID: Secrets.repoID, packageID: 2660))
//		print(files)
//	}
}
