@_exported import APIClient
import Foundation
import Logging

/// Used for mocking requests in Tests
public protocol URLSessionProtocol: Sendable {
	func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

public extension JSONDecoder {
	/// A decoder for that supports Zulu-based ISO8601 dates.
	static let iso8601Z: JSONDecoder = {
		let decoder = JSONDecoder()
		let formatter = DateFormatter()
		formatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss.SSS'Z'"
		decoder.dateDecodingStrategy = .formatted(formatter)
		return decoder
	}()
}

public extension JSONEncoder {
	/// An encoder for that encodes dates as Zulu-based ISO8601 dates.
	static let iso8601Z: JSONEncoder = {
		let encoder = JSONEncoder()
		let formatter = DateFormatter()
		formatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss.SSS'Z'"
		encoder.dateEncodingStrategy = .formatted(formatter)
		return encoder
	}()
}

public enum GitLabResponseError: Error {
	/// The request failed with a non-2xx status code.
	case invalidStatusCode(code: Int, response: HTTPURLResponse)
}

public struct GitLab: Client {
	public typealias ResponseError = GitLabResponseError
	public typealias Error = ClientError<ResponseError>

	/// The base URL for the GitLab API.
	public let baseURL: URL

	/// The token to use for authentication.
	let token: String

	public let defaultHeaders: APIClient.HTTPFields?
	public let decoder: JSONDecoder = .iso8601Z
	public let basicAuthentication: APIClient.BasicAuthentication? = nil

	public let prepare: @Sendable (URLRequest) -> URLRequest = { $0 }
	public let validate: @Sendable (Data, HTTPURLResponse) throws(APIClient.ClientError<GitLabResponseError>) -> Void

	public let session: URLSession

	private let logger = Logger(label: "GitLab")

	public init(baseURL: URL, token: String, session: URLSession = .shared) {
		self.baseURL = baseURL
		self.token = token
		self.session = session

		self.defaultHeaders = [
			"Content-Type": "application/json",
			"Authorization": "Bearer \(token)"
		]

		validate = Self.validate
	}

	private static func validate(data: Data, response: HTTPURLResponse) throws(GitLab.Error) {
		if !(200...299).contains(response.statusCode) {
			throw GitLab.Error.response(.invalidStatusCode(code: response.statusCode, response: response))
		}
	}

	/// Execute a request and return the decoded value.
	/// - Parameters request: The request to execute.
	/// - Returns: The decoded value.
	public func request<Value: Decodable>(_ request: GitLabRequest<Value>) async throws(GitLab.Error) -> Value {
		try await send(request: request)
	}
}
