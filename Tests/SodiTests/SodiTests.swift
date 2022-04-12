import XCTest
@testable import Sodi

final class SodiTests: XCTestCase {
    
    override init() {
        super.init()
        
        bindSingle(to: SingleBinded.self) {
            SingleBindedInstance()
        }
        
        bindProvider(to: ProviderBinded.self) {
            ProviderBindedInstance()
        }
    }
    
    
    func testProviderBinded() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let providerInstance: ProviderBinded = instance()
        XCTAssertEqual(providerInstance.sayHello(), providerInstance.keyWord)
    }
    
    func testSingleBinded() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let singleInstance: SingleBinded = instance()
        XCTAssertEqual(singleInstance.sayHello(), singleInstance.keyWord)
    }
}
