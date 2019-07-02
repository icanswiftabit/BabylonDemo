import Foundation
@testable import BabylonDemo

extension UserDefaults {
    static var test: UserDefaults {
        return UserDefaults(suiteName: "pl.babylonDemo.testUserDefaults")!
    }
}
