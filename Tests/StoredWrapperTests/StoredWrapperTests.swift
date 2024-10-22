import XCTest
@testable import StoredWrapper


extension Stored<String>.Keys {
    static let stringKey = Key(name: "stringKey")
}
extension Stored<String?>.Keys {
    static let stringKey = Key(name: "stringKey")
}
extension Stored<Num>.Keys {
    static let enumKey = Key(name: "enumKey")
}
extension Stored<Num?>.Keys {
    static let enumKey = Key(name: "enumKey")
}

enum Num: Codable { case one, two, three }

final class StoredTests: XCTestCase {
    
    var sut1: SUT1!
    var sut2: SUT2!
    
    override func setUpWithError() throws {
        Stored.removeAll(store: .standard)
    }
    
    override func tearDownWithError() throws {
        Stored.removeAll(store: .standard)
        sut1 = nil
        sut2 = nil
    }
    
    // MARK: - Test Double
    
    
    struct SUT1 {
        
        @Stored("stringKey")
        var stringExplicit: String = "defaultValue"
        
        @Stored("stringKey")
        var stringImplicit: String
        
        @Stored("stringKey")
        var stringOptional: String?
        
        @Stored("enumKey")
        var enumExplicit: Num = .one
        
        @Stored("enumKey")
        var enumImplicit: Num
        
        @Stored("enumKey")
        var enumOptional: Num?
    }
    
    struct SUT2 {
        
        @Stored(.stringKey)
        var stringExplicit: String = "defaultValue"
        
        @Stored(.stringKey)
        var stringImplicit: String
        
        @Stored(.stringKey)
        var stringOptional: String?
        
        @Stored(.enumKey)
        var enumExplicit: Num = .one
        
        @Stored(.enumKey)
        var enumImplicit: Num
        
        @Stored(.enumKey)
        var enumOptional: Num?
    }
    
    // MARK: - Test Cases
    
    func _testSUTsIsEquals() {
        XCTAssert(sut1.stringExplicit == sut2.stringExplicit)
        XCTAssert(sut1.stringImplicit == sut2.stringImplicit)
        XCTAssert(sut1.stringOptional == sut2.stringImplicit)

        XCTAssert(sut1.enumExplicit == sut2.enumExplicit)
        XCTAssert(sut1.enumImplicit == sut2.enumImplicit)
        XCTAssert(sut1.enumOptional == sut2.enumOptional)
    }
    
    func _testSUTsPropertiesIsChanged(string: String, num: Num) {
        XCTAssert(sut1.stringExplicit == string)
        XCTAssert(sut2.stringExplicit == string)
        
        XCTAssert(sut1.stringImplicit == string)
        XCTAssert(sut2.stringImplicit == string)
        
        XCTAssert(sut1.stringOptional == Optional(string))
        XCTAssert(sut2.stringImplicit == Optional(string))
        
        XCTAssert(sut1.enumExplicit == num)
        XCTAssert(sut2.enumExplicit == num)
        
        XCTAssert(sut1.enumImplicit == num)
        XCTAssert(sut2.enumImplicit == num)
        
        XCTAssert(sut1.enumOptional == Optional(num))
        XCTAssert(sut2.enumOptional == Optional(num))
    }
    
    func testInitialValue() {
        sut1 = SUT1()
        sut2 = SUT2()
        
        let defaultString = "defaultValue"
        let defaultNum = Num.one
        
        _testSUTsIsEquals()
        _testSUTsPropertiesIsChanged(string: defaultString, num: defaultNum)
    }
    
    func testSetValueToExplicit() {
        sut1 = SUT1()
        sut2 = SUT2()
        
        // Given
        let newString1 = "newValueExplicit"
        let newString2 = "newValueExplicit2"
        
        let newNum1 = Num.two
        let newNum2 = Num.three
        
        // When
        sut1.stringExplicit = newString1
        sut1.enumExplicit = newNum1
        
        // Then
        _testSUTsIsEquals()
        _testSUTsPropertiesIsChanged(string: newString1, num: newNum1)
        
        // When
        sut2.stringExplicit = newString2
        sut2.enumExplicit = newNum2
        
        // Then
        _testSUTsIsEquals()
        _testSUTsPropertiesIsChanged(string: newString2, num: newNum2)
    }
    
    func testSetValueToImplicit() {
        sut1 = SUT1()
        sut2 = SUT2()
        
        // Given
        let newString1 = "newValueImplicit"
        let newString2 = "newValueImplicit2"
        
        let newNum1 = Num.two
        let newNum2 = Num.three
        
        // When
        sut1.stringImplicit = newString1
        sut1.enumImplicit = newNum1
        
        // Then
        _testSUTsIsEquals()
        _testSUTsPropertiesIsChanged(string: newString1, num: newNum1)
        
        // When
        sut2.stringImplicit = newString2
        sut2.enumImplicit = newNum2
        
        // Then
        _testSUTsIsEquals()
        _testSUTsPropertiesIsChanged(string: newString2, num: newNum2)
    }
    
    func testSetValueToOptional() {
        sut1 = SUT1()
        sut2 = SUT2()
        
        // Given
        let newString1 = "newValueOptional"
        let newString2 = "newValueOptional2"
        
        let newNum1 = Num.two
        let newNum2 = Num.three
        
        // When
        sut1.stringOptional = newString1
        sut1.enumOptional = newNum1
        
        // Then
        _testSUTsIsEquals()
        _testSUTsPropertiesIsChanged(string: newString1, num: newNum1)
        
        // When
        sut2.stringOptional = newString2
        sut2.enumOptional = newNum2
        
        // Then
        _testSUTsIsEquals()
        _testSUTsPropertiesIsChanged(string: newString2, num: newNum2)
    }
    
    func testSetValueToNil() {
        sut1 = SUT1()
        sut2 = SUT2()
        
        // When
        sut1.stringOptional = nil
        sut1.enumOptional = nil
        
        // Then
        XCTAssert(sut1.stringOptional == nil)
        XCTAssert(sut1.enumOptional == nil)
        
        XCTAssert(sut2.stringOptional == nil)
        XCTAssert(sut2.enumOptional == nil)
    }
    
    func testSetValueToNilAndThenToSome() {
        testSetValueToNil()
        testSetValueToExplicit()
        
        testSetValueToNil()
        testSetValueToImplicit()
        
        testSetValueToNil()
        testSetValueToOptional()
    }
    
    func testWhenValueAlreadyExists() {
        // Given
        let existingString = "existingString"
        let existingNum = Num.three
        
        // When
        Stored("stringKey").set(value: existingString)
        Stored("enumKey").set(value: existingNum)
        
        // Then
        sut1 = SUT1()
        sut2 = SUT2()
        
        _testSUTsIsEquals()
        _testSUTsPropertiesIsChanged(string: existingString, num: existingNum)
    }

    func testStoredRemoveByKeyAndIsExistsFuncionality() {
        // Given
        sut1 = SUT1()
        sut2 = SUT2()
        
        XCTAssert(Stored(.stringKey).isExists == true)
        XCTAssert(Stored(.enumKey).isExists == true)
        XCTAssert(Stored<String>("stringKey").isExists == true)
        XCTAssert(Stored<String>("enumKey").isExists == true)
        
        // When
        Stored(.stringKey).remove()
        Stored(.enumKey).remove()
        
        // Then
        XCTAssert(Stored(.stringKey).isExists == false)
        XCTAssert(Stored(.enumKey).isExists == false)
        XCTAssert(Stored<String>("stringKey").isExists == false)
        XCTAssert(Stored<Num>("enumKey").isExists == false)
        
        XCTAssert(sut1.stringOptional == nil)
        XCTAssert(sut1.enumOptional == nil)
        XCTAssert(sut2.stringOptional == nil)
        XCTAssert(sut2.enumOptional == nil)
    }
    
    func testStoredRemoveByStringAndIsExistsFuncionality() {
        // Given
        sut1 = SUT1()
        sut2 = SUT2()
        
        XCTAssert(Stored(.stringKey).isExists == true)
        XCTAssert(Stored(.enumKey).isExists == true)
        XCTAssert(Stored<String>("stringKey").isExists == true)
        XCTAssert(Stored<Num>("enumKey").isExists == true)
        
        Stored<String>("stringKey").remove()
        Stored<Num>("enumKey").remove()
        
        // Then
        XCTAssert(Stored(.stringKey).isExists == false)
        XCTAssert(Stored(.enumKey).isExists == false)
        XCTAssert(Stored<String>("stringKey").isExists == false)
        XCTAssert(Stored<Num>("enumKey").isExists == false)
        
        XCTAssert(sut1.stringOptional == nil)
        XCTAssert(sut1.enumOptional == nil)
        XCTAssert(sut2.stringOptional == nil)
        XCTAssert(sut2.enumOptional == nil)
    }
    
    func testUserDefaultsSetValue() {
        // Given
        sut1 = SUT1()
        sut2 = SUT2()
        
        let newString = "newValue"
        let newNum = Num.two
        
        _testSUTsIsEquals()
        
        // When
        Stored("stringKey").set(value: newString)
        Stored("enumKey").set(value: newNum)
        
        _testSUTsPropertiesIsChanged(string: newString, num: newNum)
    }
    
    func testStoredSetValue() {
        // Given
        sut1 = SUT1()
        sut2 = SUT2()
        
        let newString = "newValue"
        let newNum = Num.two
        
        _testSUTsIsEquals()
        
        // When
        Stored(.stringKey).set(value: newString)
        Stored(.enumKey).set(value: newNum)
        
        _testSUTsIsEquals()
        _testSUTsPropertiesIsChanged(string: newString, num: newNum)
    }
}
