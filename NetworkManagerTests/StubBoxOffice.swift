//
//  StubBoxOffice.swift
//  NetworkManagerTests
//
//  Created by Rhode, Rilla on 2023/03/29.
//

import UIKit

struct StubBoxOffice {
    var data: Data {
        return NSDataAsset(name: "box_office_sample")!.data
    }
}
