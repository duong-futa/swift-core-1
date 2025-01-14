//  File name   : Cell.swift
//
//  Author      : Dung Vu
//  Created date: 8/10/16
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

#if canImport(UIKit) && (os(iOS) || os(tvOS))
    import UIKit

    /// Cell defines instruction on how to load a cell.
    public protocol Cell {
        /// Return cell's identifier.
        static var identifier: String { get }

        /// Return cell's nib from main bundle.
        static var nib: UINib { get }
    }

    /// Default implementation for Cell.
    public extension Cell {
        static var identifier: String {
            return "\(self)"
        }
    }

    /// Default added Cell to UICollection view cell.
    extension UICollectionViewCell: Cell {
        public static var nib: UINib {
            return loadNib()
        }
    }

    /// Cell has addon function only when self is UICollectionViewCell.
    public extension Cell where Self: UICollectionViewCell {
        /// Load nib from bundle.
        ///
        /// - Parameter bundle: a bundle which contains cell's xib.
        static func loadNib(_ fromBundle: Bundle? = nil) -> UINib {
            let b = fromBundle ?? Bundle.main

            guard b.path(forResource: identifier, ofType: "nib") != nil else {
                fatalError("Could not load nib: \(identifier) from bundle: \(b.bundleURL.lastPathComponent).")
            }
            return UINib(nibName: identifier, bundle: b)
        }

        /// Dequeue and cast to self.
        ///
        /// - parameter collectionView (required): collectionView instance
        /// - parameter indexPath (required): indexPath
        static func dequeueCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> Self {
            return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! Self
        }
    }

    /// Default added FwiCell to UITableView view cell.
    extension UITableViewCell: Cell {
        public static var nib: UINib {
            return loadNib()
        }
    }

    /// Cell has addon function only when self is UITableViewCell.
    public extension Cell where Self: UITableViewCell {
        /// Load nib from bundle.
        ///
        /// - Parameter bundle: a bundle which contains cell's xib.
        static func loadNib(_ fromBundle: Bundle? = nil) -> UINib {
            let b = fromBundle ?? Bundle.main

            guard b.path(forResource: identifier, ofType: "nib") != nil else {
                fatalError("Could not load nib: \(identifier) from bundle: \(b.bundleURL.lastPathComponent).")
            }
            return UINib(nibName: identifier, bundle: b)
        }

        /// Dequeue and cast to self.
        ///
        /// - parameter tableView (required): tableView instance
        static func dequeueCell(_ tableView: UITableView) -> Self {
            return tableView.dequeueReusableCell(withIdentifier: identifier) as! Self
        }
    }
#endif
