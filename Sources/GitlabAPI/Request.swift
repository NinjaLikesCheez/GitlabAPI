import APIClient
import Foundation

/// A request to the GitLab API.
public struct GitLabRequest<Response: Decodable>: Request {
	public let method: APIClient.HTTPMethod
	public let path: String?
	public let headers: APIClient.HTTPFields
	public let body: () throws -> (any APIClient.RequestBody)?
	public let prepare: ((URLRequest) -> URLRequest)
	public let transform: ((Data, HTTPURLResponse) throws -> Response)?

	init(
		method: APIClient.HTTPMethod = .get,
		path: String,
		headers: APIClient.HTTPFields = [:],
		body: @escaping () throws -> (any APIClient.RequestBody)? = { nil },
		prepare: @escaping ((URLRequest) -> URLRequest) = { $0 },
		transform: ((Data, HTTPURLResponse) throws -> Response)? = nil
	) {
		self.method = method
		self.path = path
		self.headers = headers
		self.body = body
		self.prepare = prepare
		self.transform = transform
	}
}
