//
//  Packages.swift
//  GitLabAPI
//
//  Created by Thomas Hedderwick on 10/03/2025.
//
import Foundation

public struct Package: Decodable {
	let id: Int
	let name: String
	let package_type: PackageType
	let created_at: Date
	let tags: [String]?

	public enum OrderBy: String, Decodable {
		case created_at
		case name
		case version
		case type
	}

	public enum PackageType: String, Decodable {
		case generic
		case conan
		case maven
		case npm
		case pupi
		case composer
		case nuget
		case helm
		case terraform_module
		case golang
	}
}

public struct PackageFile: Decodable {
	let id: Int
	let package_id: Int
	let created_at: Date
	let file_name: String
	let size: Int
	let file_md5: String?
	let file_sha1: String?
	let file_sha256: String?
}

extension GitLabRequest {
	static public func packages(
		id: Int,
		orderBy: Package.OrderBy? = nil,
		type: Package.PackageType? = nil,
		name: String? = nil,
		version: String? = nil,
		includeVersionless: Bool? = nil
	) -> GitLabRequest<[Package]> {
		.init(
			path: "/projects/\(id)/packages",
			prepare: {
				var request = $0

				var items: [URLQueryItem] = []

				if let orderBy {
					items.append(.init(name: "order_by", value: orderBy.rawValue))
				}

				if let type {
					items.append(.init(name: "package_type", value: type.rawValue))
				}

				if let name {
					items.append(.init(name: "package_name", value: name))
				}

				if let version {
					items.append(.init(name: "package_version", value: version))
				}

				if let includeVersionless {
					items.append(.init(name: "include_versionless", value: includeVersionless ? "true" : "false"))
				}

				request.url = $0.url?.appending(queryItems: items)

				return request
			}
		)
	}

	static public func packageFiles(projectID: Int, packageID: Int) -> GitLabRequest<[PackageFile]> {
		.init(path: "/projects/\(projectID)/packages/\(packageID)/package_files")
	}

	static public func delete(projectID: Int, packageFile: PackageFile) -> GitLabRequest<EmptyResponse> {
		.init(
			method: .delete,
			path: "/projects/\(projectID)/packages/\(packageFile.package_id)/package_files/\(packageFile.id)"
		)
	}
}
