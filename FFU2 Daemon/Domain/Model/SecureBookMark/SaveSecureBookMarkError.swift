import Foundation

/// Errors that can occur while validating and saving a security-scoped bookmark.
///
/// This lives in Domain so callers can map each case to an appropriate UX.
enum SaveSecureBookMarkError: LocalizedError, Equatable {
    /// The bookmark data was nil or missing.
    case bookmarkMissing

    /// The bookmark couldn't be resolved into a security-scoped URL.
    case failedToResolveBookmark

    /// The bookmark is stale (e.g., the folder name/path changed) and shouldn't be saved.
    case bookmarkStale

    /// Post-save validation failed (the stored bookmark doesn't match the expected one).
    case failedToPersist

    /// Selected directory isn't supported by the app (currently only home directory / under it).
    case unsupportedDirectory

    /// User selected a directory under the home directory (smaller permission than recommended).
    ///
    /// This is intended to be shown with `showAlertWithUserSelect(...)`.
    case smallerPermissionThanHomeDirectory

    case someThingWrong

    var errorDescription: String? { message }

    /// A short title suitable for an NSAlert.
    var title: String {
        switch self {
        case .smallerPermissionThanHomeDirectory:
            return "権限が小さいです"
        case .unsupportedDirectory:
            return "サポートされていないディレクトリ"
        default:
            return "エラー"
        }
    }

    /// A user-facing message suitable for an NSAlert.
    var message: String {
        switch self {
        case .bookmarkMissing:
            return "ブックマークが取得できませんでした。再度実行してください。"
        case .failedToResolveBookmark:
            return "ブックマークの解決に失敗しました。再度実行してください。"
        case .bookmarkStale:
            return "フォルダ名/パスが変更された可能性があるため、保存できませんでした。再度権限を付与してください。"
        case .failedToPersist:
            return "ブックマークの保存に失敗しました。再度実行してください。"
        case .unsupportedDirectory:
            return "指定したディレクトリはサポートされていません。ホームディレクトリ、あるいはそれより下の階層を指定してください。"
        case .someThingWrong:
            return "何らかのエラーが発生しました。再度実行してください。"
        case .smallerPermissionThanHomeDirectory:
            return "ホームディレクトリより下のフォルダが指定されました。一部のフォルダでは正常に動作しない可能性があります。よろしいですか？"
        }
    }
}
