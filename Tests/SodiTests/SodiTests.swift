import XCTest
@testable import Sodi

final class SodiTests: XCTestCase, ISodi {
    
    let testModule = sodiModule(moduleName: "TestModule") { sodi in
        sodi.bindSingle(to: SingleBinded.self) {
            SingleBindedInstance()
        }
        sodi.bindProvider(to: ProviderBinded.self) {
            ProviderBindedInstance()
        }
    }
    
    let secondTestModule = sodiModule(moduleName: "SecondTestModule") { sodi in
        sodi.bindSingle(to: SecondSingle.self) {
            SecondSingleBindedInstance()
        }
        sodi.bindProvider(to: SecondProvider.self) {
            SecondProviderBindedInstance()
        }
    }
    
    func testProviderBinded() throws {
        _ = importModule(sodiModule: self.testModule)
        _ = importModule(sodiModule: self.secondTestModule)
        
        let providerInstance: ProviderBinded = instance()
        XCTAssertEqual(providerInstance.sayHello(), providerInstance.keyWord)
        let secondProviderInstance: SecondProvider = instance()
        XCTAssertEqual(secondProviderInstance.sayHello(), secondProviderInstance.keyWord)
    }
    
    func testSingleBinded() throws {
        importModule(sodiModule: self.testModule)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        //DispatchQueue.main.async {
        let singleInstance: SingleBinded = instance()
        XCTAssertEqual(singleInstance.sayHello(), singleInstance.keyWord)
        //}
    }
    
    func testUnbindInstance() throws {
        importModule(sodiModule: self.testModule)
        let isInstanceDeleted = unbind(from: SingleBinded.self)
        XCTAssertEqual(isInstanceDeleted, true)
        let hasSingleInstance = hasInstance(from: SingleBinded.self)
        XCTAssertEqual(hasSingleInstance, false)
    }
    
    func testImportModules() {
        let firstImport = importModule(sodiModule: testModule)
        let secondImport = importModule(sodiModule: testModule)
        XCTAssertEqual(firstImport, true)
        XCTAssertEqual(secondImport, false)
        let firstRemove = removeModule(sodiModule: testModule)
        let secondRemove = removeModule(sodiModule: testModule)
        XCTAssertEqual(firstRemove, true)
        XCTAssertEqual(secondRemove, false)
        
        let hasBindedInstance = hasInstance(from: SingleBinded.self)
        XCTAssertEqual(hasBindedInstance, false)
    }
}
