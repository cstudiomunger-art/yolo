import Foundation

struct PassportCountry: Identifiable, Hashable, Codable {
    let code: String
    let name: String
    let flag: String
    let displayOrder: Int

    var id: String { code }

    init(code: String, name: String, flag: String, displayOrder: Int = 0) {
        self.code = code
        self.name = name
        self.flag = flag
        self.displayOrder = displayOrder
    }
}
