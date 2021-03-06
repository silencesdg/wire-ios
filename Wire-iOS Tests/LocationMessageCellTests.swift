// 
// Wire
// Copyright (C) 2016 Wire Swiss GmbH
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
// 


import XCTest
@testable import Wire
import MapKit

class LocationMessageCellTests: ZMSnapshotTestCase {

    typealias CellConfiguration = MockMessage -> Void
    
    override func setUp() {
        super.setUp()
        accentColor = .VividRed
    }

    func testThatItRendersLocationCellWithAddressCorrect() {
        // This is experimental as the MKMapView might break the snapshot tests,
        // If it does we can try to use the 'withAccurancy' methods in FBSnapshotTestCase
        verify(view: cellWithConfig())
    }
    
    func testThatItRendersLocationCellWithoutAddressCorrect() {
        verify(view: cellWithConfig {
            $0.backingLocationMessageData.name = nil
        })
    }

    // MARK: - Helper

    func cellWithConfig(config: CellConfiguration? = nil) -> LocationMessageCell {
        let fileMessage = MockMessageFactory.locationMessage()
        fileMessage.backingLocationMessageData?.latitude = 9.041169
        fileMessage.backingLocationMessageData?.longitude = 48.53775
        fileMessage.backingLocationMessageData?.name = "Berlin, Germany"
        
        config?(fileMessage)
        
        let cell = LocationMessageCell(style: .Default, reuseIdentifier: String(LocationMessageCell.self))
        cell.backgroundColor = .whiteColor()
        let layoutProperties = ConversationCellLayoutProperties()
        layoutProperties.showSender = true
        layoutProperties.showBurstTimestamp = false
        layoutProperties.showUnreadMarker = false
        
        cell.prepareForReuse()
        cell.layer.speed = 0 // freeze animations for deterministic tests
        cell.bounds = CGRectMake(0.0, 0.0, 320.0, 9999)
        cell.contentView.bounds = CGRectMake(0.0, 0.0, 320, 9999)
        cell.layoutMargins = UIEdgeInsetsMake(0, CGFloat(WAZUIMagic.floatForIdentifier("content.left_margin")),
                                              0, CGFloat(WAZUIMagic.floatForIdentifier("content.right_margin")))
        
        cell.configureForMessage(fileMessage, layoutProperties: layoutProperties)
        cell.layoutIfNeeded()
        
        let size = cell.systemLayoutSizeFittingSize(CGSizeMake(320.0, 0.0) , withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityFittingSizeLevel)
        cell.bounds = CGRectMake(0.0, 0.0, size.width, size.height)
        cell.layoutIfNeeded()
        return cell
    }
    
}
