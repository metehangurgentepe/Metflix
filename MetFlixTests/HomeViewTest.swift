//
//  HomeViewTest.swift
//  MetFlixTests
//
//  Created by Metehan Gürgentepe on 24.02.2024.
//

import XCTest
@testable import MetFlix

final class HomeViewModelTest: XCTestCase {
    
    private var viewModel: HomeViewModel!
    
    @MainActor func test_load_ReturnsMovieLists() {
        
        let viewModel = HomeViewModel()
        
        viewModel.load()
        
        XCTAssertNil(viewModel.delegate)
    }

}
