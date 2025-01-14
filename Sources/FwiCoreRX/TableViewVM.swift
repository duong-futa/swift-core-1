//  File name   : TableViewVM.swift
//
//  Author      : Phuc Tran
//  Created date: 7/14/18
//  --------------------------------------------------------------
//  Copyright © 2012, 2019 Fiision Studio. All Rights Reserved.
//  --------------------------------------------------------------
//
//  Permission is hereby granted, free of charge, to any person obtaining  a  copy
//  of this software and associated documentation files (the "Software"), to  deal
//  in the Software without restriction, including without limitation  the  rights
//  to use, copy, modify, merge,  publish,  distribute,  sublicense,  and/or  sell
//  copies of the Software,  and  to  permit  persons  to  whom  the  Software  is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF  ANY  KIND,  EXPRESS  OR
//  IMPLIED, INCLUDING BUT NOT  LIMITED  TO  THE  WARRANTIES  OF  MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO  EVENT  SHALL  THE
//  AUTHORS OR COPYRIGHT HOLDERS  BE  LIABLE  FOR  ANY  CLAIM,  DAMAGES  OR  OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING  FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN  THE
//  SOFTWARE.
//
//
//  Disclaimer
//  __________
//  Although reasonable care has been taken to  ensure  the  correctness  of  this
//  software, this software should never be used in any application without proper
//  testing. Fiision Studio disclaim  all  liability  and  responsibility  to  any
//  person or entity with respect to any loss or damage caused, or alleged  to  be
//  caused, directly or indirectly, by the use of this software.

#if canImport(UIKit) && !os(watchOS)
    import FwiCore
    import RxCocoa
    import RxSwift
    import UIKit

    open class TableViewVM: ViewModel {
        /// Class's public properties.
        public var currentOptionalIndexPath: Observable<IndexPath?> {
            return currentIndexPathSubject.asObservable()
        }

        public var currentIndexPath: Observable<IndexPath> {
            return currentIndexPathSubject.asObservable()
                .flatMap { indexPath -> Observable<IndexPath> in
                    guard let indexPath = indexPath else {
                        return Observable<IndexPath>.empty()
                    }
                    return Observable<IndexPath>.just(indexPath)
                }
        }

        public private(set) weak var tableView: UITableView?
        public var isEnableSelecting = false
        public var isEnableEditing = false

        /// Class's constructors.
        public init(with tableView: UITableView?) {
            super.init()
            self.tableView = tableView
        }

        // MARK: Class's public methods
        open override func setupRX() {
            tableView?.rx
                .setDataSource(self)
                .disposed(by: disposeBag)

            tableView?.rx
                .setDelegate(self)
                .disposed(by: disposeBag)
        }

        /// Deselect item at index
        ///
        /// - Parameter index: item's index
        open func deselect(itemAt index: Int) {
            let indexPath = IndexPath(row: index, section: 0)
            deselect(itemAt: indexPath)
        }

        /// Deselect item at index path
        ///
        /// - Parameter indexPath: item's index path
        open func deselect(itemAt indexPath: IndexPath) {
            guard
                let tableView = self.tableView,
                let deselectedIndex = self.tableView(tableView, willDeselectRowAt: indexPath)
            else {
                return
            }
            self.tableView(tableView, didDeselectRowAt: deselectedIndex)
        }

        /// Select item at index
        ///
        /// - Parameters:
        ///   - index: item's index
        ///   - scrollPosition: how to scroll to that item
        open func select(itemAt index: Int, scrollPosition: UITableView.ScrollPosition = .middle) {
            let indexPath = IndexPath(row: index, section: 0)
            select(itemAt: indexPath, scrollPosition: scrollPosition)
        }

        /// Select item at index path
        ///
        /// - Parameters:
        ///   - indexPath: item's index path
        ///   - scrollPosition: how to scroll to that item
        open func select(itemAt indexPath: IndexPath, scrollPosition: UITableView.ScrollPosition = .middle) {
            guard let tableView = self.tableView else {
                return
            }

            let count = self.tableView(tableView, numberOfRowsInSection: indexPath.row)
            guard indexPath.row >= 0, indexPath.row < count else {
                return
            }

            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            self.tableView(tableView, didSelectRowAt: indexPath)
        }

        /// Toggle edit mode on/off.
        open func toggleEdit() {
            guard let isEditing = tableView?.isEditing else {
                return
            }

            if isEditing {
                tableView?.setEditing(false, animated: true)
            } else {
                tableView?.setEditing(true, animated: true)
            }
        }

        /// Class's private properties.
        private let currentIndexPathSubject = ReplaySubject<IndexPath?>.create(bufferSize: 1)
    }

    // MARK: UITableViewDataSource's members
    extension TableViewVM: UITableViewDataSource {
        open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            fatalError("Child class should override func \(#function)")
        }

        open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            fatalError("Child class should override func \(#function)")
        }

        /// Editing.
        open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return (isEnableEditing || isEnableSelecting)
        }

        /// Moving/reordering
        open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return true
        }

        /// Index.
        open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
            return nil
        }

        open func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
            return 0
        }

        /// Data manipulation - insert and delete support.
        open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {}

        /// Data manipulation - reorder / moving support.
        open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {}
    }

    // MARK: UITableViewDelegate's members
    extension TableViewVM: UITableViewDelegate {
        /// Display customization.
        open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {}

        open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {}

        open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {}

        open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {}

        open func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {}

        open func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {}

        /// Variable height support.
        open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 0.1
        }

        open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 0.1
        }

        /// Section header & footer information. Views are preferred over title should you decide to provide both.
        open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            return nil
        }

        open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            return nil
        }

        open func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {}

        /// Selection.
        open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
            return true
        }

        open func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {}

        open func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {}

        open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
            return indexPath
        }

        open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            currentIndexPathSubject.on(.next(indexPath))
        }

        open func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
            return indexPath
        }

        open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            currentIndexPathSubject.bind(onNext: { [weak self] currentIndex in
                guard let currentIndex = currentIndex, currentIndex == indexPath else {
                    return
                }
                self?.currentIndexPathSubject.on(.next(nil))
            }).dispose()
        }

        /// Editing.
        open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            let option = (isEnableEditing, isEnableSelecting)
            switch option {
            case (false, true):
                return UITableViewCell.EditingStyle(rawValue: 3) ?? .none

            case (true, false):
                return .delete

            default:
                return .none
            }
        }

        #if os(iOS)
            open func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {}

            open func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {}
        #endif

        /// Copy/Paste. All three methods must be implemented by the delegate.
        open func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
            return false
        }

        open func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
            return false
        }

        open func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {}
    }
#endif
