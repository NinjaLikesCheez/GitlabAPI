import APIClient
import Foundation

extension GitLab {
	public struct ContainerRepository: Codable, Equatable, Sendable {
		public struct Tag: Codable, Equatable, Sendable {
			public let name: String
			public let path: String
			public let location: URL

			public init(name: String, path: String, location: URL) {
				self.name = name
				self.path = path
				self.location = location
			}
		}

		public let id: Int
		public let name: String
		public let path: String
		public let location: URL
		public let createdAt: Date
		public let cleanupPolicyStartedAt: Date?
		public let tagsCount: Int?
		public let tags: [Tag]?
		public let status: String?

		enum CodingKeys: String, CodingKey {
			case id
			case name
			case path
			case location
			case createdAt = "created_at"
			case cleanupPolicyStartedAt = "cleanup_policy_started_at"
			case tagsCount = "tags_count"
			case tags
			case status
		}

		/// For testing
		public init(
			id: Int, name: String, path: String, location: URL, createdAt: Date,
			cleanupPolicyStartedAt: Date?, tagsCount: Int?, tags: [Tag]?, status: String?
		) {
			self.id = id
			self.name = name
			self.path = path
			self.location = location
			self.createdAt = createdAt
			self.cleanupPolicyStartedAt = cleanupPolicyStartedAt
			self.tagsCount = tagsCount
			self.tags = tags
			self.status = status
		}
	}
}

extension GitLabRequest {
	/// List the container repositories for a project.
	/// - Parameter id: The ID of the project.
	/// - Parameter tags: Whether to include tags in the response.
	/// - Parameter tagsCount: Whether to include the tags count in the response.
	/// - Returns: A request to list the container repositories for a project.
	public static func listRegistryRepositories(
		id: Int,
		tags: Bool = false,
		tagsCount: Bool = false
	) -> GitLabRequest<[GitLab.ContainerRepository]> {
		.init(
			path: "projects/\(id)/registry/repositories",
			prepare: {
				var request = $0
				request.url = $0.url?.appending(queryItems: [
					.init(name: "tags", value: tags ? "true" : "false"),
					.init(name: "tags_count", value: tagsCount ? "true" : "false")
				])

				return request
			}
		)
	}
}
