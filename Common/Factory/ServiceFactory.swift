func fileExtensionServiceFactory() -> FileExtensionService {
    return FileExtensionService(userDefaultsModel: UserDefaultsModel())
}
