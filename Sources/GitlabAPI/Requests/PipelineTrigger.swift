import Foundation

public extension GitLab {
	struct PipelineTrigger: Codable, Equatable {
		public let id, iid, projectID: Int
		public let sha, ref, status, source: String
		public let createdAt, updatedAt: Date
		public let webURL: String
		public let beforeSHA: String
		public let tag: Bool
		public let yamlErrors: String?
		public let user: User
		public let startedAt, finishedAt, committedAt: Date?
		public let duration: Int?
		public let queuedDuration: Int?
		public let coverage: Double?
		public let detailedStatus: DetailedStatus

		enum CodingKeys: String, CodingKey {
			case id, iid
			case projectID = "project_id"
			case sha, ref, status, source
			case createdAt = "created_at"
			case updatedAt = "updated_at"
			case webURL = "web_url"
			case beforeSHA = "before_sha"
			case tag
			case yamlErrors = "yaml_errors"
			case user
			case startedAt = "started_at"
			case finishedAt = "finished_at"
			case committedAt = "committed_at"
			case duration
			case queuedDuration = "queued_duration"
			case coverage
			case detailedStatus = "detailed_status"
		}

		public init(
			id: Int, iid: Int, projectID: Int,
			sha: String, ref: String, status: String, source: String,
			createdAt: Date, updatedAt: Date,
			webURL: String,
			beforeSHA: String,
			tag: Bool,
			yamlErrors: String?,
			user: User,
			startedAt: Date?, finishedAt: Date?, committedAt: Date?,
			duration: Int?,
			queuedDuration: Int?,
			coverage: Double?,
			detailedStatus: DetailedStatus
		) {
			self.id = id
			self.iid = iid
			self.projectID = projectID
			self.sha = sha
			self.ref = ref
			self.status = status
			self.source = source
			self.createdAt = createdAt
			self.updatedAt = updatedAt
			self.webURL = webURL
			self.beforeSHA = beforeSHA
			self.tag = tag
			self.yamlErrors = yamlErrors
			self.user = user
			self.startedAt = startedAt
			self.finishedAt = finishedAt
			self.committedAt = committedAt
			self.duration = duration
			self.queuedDuration = queuedDuration
			self.coverage = coverage
			self.detailedStatus = detailedStatus
		}
	}

	struct DetailedStatus: Codable, Equatable {
		public let icon: String
		public let text: String
		public let label: String
		public let group: String
		public let tooltip: String
		public let hasDetails: Bool
		public let detailsPath: String
		public let illustration: Illustration?
		public let favicon: String

		enum CodingKeys: String, CodingKey {
			case icon, text, label, group, tooltip
			case hasDetails = "has_details"
			case detailsPath = "details_path"
			case illustration, favicon
		}

		public init(
			icon: String,
			text: String,
			label: String,
			group: String,
			tooltip: String,
			hasDetails: Bool,
			detailsPath: String,
			illustration: Illustration?,
			favicon: String
		) {
			self.icon = icon
			self.text = text
			self.label = label
			self.group = group
			self.tooltip = tooltip
			self.hasDetails = hasDetails
			self.detailsPath = detailsPath
			self.illustration = illustration
			self.favicon = favicon
		}
	}

	struct Illustration: Codable, Equatable {
		public let image: String
		public let size: String
		public let title: String
		public let content: String

		public init(
			image: String,
			size: String,
			title: String,
			content: String
		) {
			self.image = image
			self.size = size
			self.title = title
			self.content = content
		}
	}

	struct User: Codable, Equatable {
		public let id: Int
		public let username: String
		public let name: String
		public let state: String
		public let avatarURL: String
		public let webURL: String

		enum CodingKeys: String, CodingKey {
			case id, username, name, state
			case avatarURL = "avatar_url"
			case webURL = "web_url"
		}

		public init(
			id: Int,
			username: String,
			name: String,
			state: String,
			avatarURL: String,
			webURL: String
		) {
			self.id = id
			self.username = username
			self.name = name
			self.state = state
			self.avatarURL = avatarURL
			self.webURL = webURL
		}
	}
}

extension GitLabRequest {
	/// Trigger a pipeline.
	/// - Parameter id: The ID of the project.
	/// - Parameter reference: The git reference to trigger the pipeline on.
	/// - Parameter token: The trigger token to use for the request.
	/// - Parameter variables: The variables to include in the request.
	/// - Returns: A request to trigger a pipeline.
	public static func triggerPipeline(
		id: Int,
		reference: String,
		token: String,
		variables: [String: String] = [:]
	) -> GitLabRequest<GitLab.PipelineTrigger> {
		.init(
			method: .post,
			path: "projects/\(id)/trigger/pipeline",
			body: {
				FormBody([
					.init(name: "ref", value: reference),
					.init(name: "token", value: token)
				] + variables.map { .init(name: "variables[\($0)]", value: $1) })
			}
		)
	}
}
