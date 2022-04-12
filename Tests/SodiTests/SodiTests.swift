import XCTest
@testable import Sodi

final class SodiTests: XCTestCase, ISodi {
    
    func testProviderBinded() throws {
        bindProvider(to: ProviderBinded.self) {
            ProviderBindedInstance()
        }
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let providerInstance: ProviderBinded = instance()
        XCTAssertEqual(providerInstance.sayHello(), providerInstance.keyWord)
    }
    
    func testSingleBinded() throws {
        bindSingle(to: SingleBinded.self) {
            SingleBindedInstance()
        }
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let singleInstance: SingleBinded = instance()
        XCTAssertEqual(singleInstance.sayHello(), singleInstance.keyWord)
    }
}
