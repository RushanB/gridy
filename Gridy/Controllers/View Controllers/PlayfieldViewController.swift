//
//  PlayfieldViewController.swift
//  Gridy
//
//  Created by Cynthia Nikolai on 12/8/20.
//  Copyright © 2020 Cynthia Nikolai. All rights reserved.
//

import UIKit

extension PlayfieldViewController {
    func canBecomeFocused() -> Bool {
        return true
    }
}

extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIImage: Equatable {
    static func ==(lhs: UIImage, rhs: UIImage) -> Bool {
        return lhs.pngData() == rhs.pngData()
    }
}

extension Array where Element: UIImage {
    static func ==(lhs: [UIImage], rhs: [UIImage]) -> Bool {
        var results: [UIImage] = []
        for l in lhs {
            for r in rhs {
                if l.pngData() == r.pngData() {
                    results.append(l)
                }
            }
        }
        return results.count == lhs.count
    }
}

// MARK: - PlayfieldViewController

class PlayfieldViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK:- Outlets
    
    @IBOutlet weak var piecesCollectionView: UICollectionView!
    @IBOutlet weak var boardCollectionView: UICollectionView!
    @IBOutlet weak var moves: UILabel!
    
    @IBAction func NewGame(_ sender: UIButton) {
        // Remove Key-Value Pair
        UserDefaults.standard.removeObject(forKey: "numMoves")
        UserDefaults.standard.removeObject(forKey: "piecesImages")
        UserDefaults.standard.removeObject(forKey: "boardImages")
        UserDefaults.standard.removeObject(forKey: "solvedImages")
        UserDefaults.standard.removeObject(forKey: "creation")
        
        UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController!.dismiss(animated: true)
    }
    
    @IBAction func showHint(_ sender: Any) {
        let popupVC = UIStoryboard(name: "Playfield", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopupViewController
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.creation = creation
        present(popupVC, animated: true)
    }
    
    // MARK: - Local Variables
    
    var creation: Creation!
    
    private var selectedIndexPath: IndexPath?
    
    private lazy var puzzle: Puzzle = {
        Puzzle.init(Image: creation.image)
    }()
    
    private lazy var blankImage: UIImage = {
        UIImage(color: .white)!
    }()
    
    private lazy var hintImage: UIImage = {
        UIImage(named: "Gridy-lookup")!
    }()
    
    private var numMoves: Int = 0 {
        didSet {
            UserDefaults.standard.set(numMoves, forKey: "numMoves")
        }
    }
    
    // MARK:- Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.valueExists(forKey:"numMoves") {
            numMoves = UserDefaults.standard.integer(forKey: "numMoves")
            self.moves.text = String(describing: numMoves)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        if !UserDefaults.standard.valueExists(forKey:"boardImages") {
            addPlaceHolderImages()
        }
        //        let storyBoard = self.storyboard?.value(forKey: "name") //get storyboard id
        //        let newViewController = self.restorationIdentifier //get identifier of view controller
        //        UserDefaults.standard.set(storyBoard, forKey: "storyBoard") // save to user defaults
        //UserDefaults.standard.set(newViewController, forKey: "newViewController")
        //view.addInteraction(UIDropInteraction(delegate: self))
    }
    
    // MARK:- Helper Functions
    func configure() {
        piecesCollectionView.dragInteractionEnabled = true
        piecesCollectionView.dataSource = self
        piecesCollectionView.delegate = self
        piecesCollectionView.dragDelegate = self
        piecesCollectionView.dropDelegate = self
        
        boardCollectionView.dragInteractionEnabled = true
        boardCollectionView.dataSource = self
        boardCollectionView.delegate = self
        boardCollectionView.dragDelegate = self
        boardCollectionView.dropDelegate = self
        
        let nib = UINib(nibName: "PuzzleImageCell", bundle: nil)
        piecesCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        boardCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
    }
    
    
    // Swipe action
    @objc private func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == UISwipeGestureRecognizer.Direction.up {
            if let view = sender.view as? UIImageView {
                numMoves+=1
                updateNumMoves(numMoves: numMoves)
                puzzle.boardImages.remove(at: view.tag)
                // turn into blank cell.
                puzzle.boardImages.insert(blankImage, at: view.tag)
                removeBlankImage()
                puzzle.piecesImages.append(view.image!)
                //replace blank cell.
                boardCollectionView.reloadData()
                let indexToRemove = IndexPath.init(row: view.tag, section: 0)
                piecesCollectionView.deleteItems(at: [indexToRemove])
                piecesCollectionView.reloadData()
                try? UserDefaults.standard.set(images: puzzle.boardImages, forKey: "boardImages")
            }
            
        }
    }
    
    private func removeBlankImage() {
        let index = puzzle.piecesImages.firstIndex { image in
            image == blankImage
        }
        guard index != nil else { return }
        puzzle.piecesImages.remove(at: index!)
    }
    
    private func addPlaceHolderImages() {
        for _ in 0 ..< puzzle.solvedImages.count {
            puzzle.boardImages.append(blankImage)
        }
        piecesCollectionView.reloadData()
        boardCollectionView.reloadData()
    }
}//end of class

// MARK: - UICollectionViewDataSource
extension PlayfieldViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == piecesCollectionView {
            return puzzle.piecesImages.count
            print("===count1",puzzle.piecesImages.count)
        }
        if collectionView == boardCollectionView {
            return puzzle.boardImages.count
            print("===count2",puzzle.boardImages.count)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PuzzleImageCell
        if collectionView == piecesCollectionView {
            cell.image = puzzle.piecesImages[indexPath.item]
        }
        if collectionView == boardCollectionView {
            cell.image = puzzle.boardImages[indexPath.item]
            // Swipe (up) gesture recognizer
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            swipeGesture.direction = UISwipeGestureRecognizer.Direction.up
            cell.imageView.addGestureRecognizer(swipeGesture)
            cell.imageView.isUserInteractionEnabled = true
            cell.imageView.tag = indexPath.row
        }
        //try? UserDefaults.standard.set(images: puzzle.piecesImages, forKey: "piecesImages")
        //try? UserDefaults.standard.set(images: puzzle.boardImages, forKey: "boardImages")
        return cell
    }
    
    func updateNumMoves(numMoves:Int) {
        self.moves.text = String(describing: numMoves)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == (puzzle.piecesImages.count - 1) {
        }
    }
}

// MARK:- CollectionView Layout
extension PlayfieldViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == piecesCollectionView {
            let width = (piecesCollectionView.frame.size.width-50)/6
            return CGSize(width: width, height: width)
        }
        else {
            let width = boardCollectionView.frame.size.width/CGFloat(puzzle.boardImages.count).squareRoot()
            return CGSize(width: width, height: width)        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == piecesCollectionView {
            return 5
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == piecesCollectionView {
            return 5
        }
        else {
            return 0
        }
    }
    
}

// MARK: - UICollectionViewDragDelegate, UICollectionViewDropDelegate
extension PlayfieldViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate, UIDropInteractionDelegate {
    
    // the items that start the drag process at an index
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if collectionView == piecesCollectionView {
            // get the image
            let image = puzzle.piecesImages[indexPath.item]
            if image != blankImage {
                selectedIndexPath = indexPath
                let itemProvider = NSItemProvider(object: image as UIImage)
                let dragItem = UIDragItem(itemProvider: itemProvider)
                dragItem.localObject = image
                //try? UserDefaults.standard.set(images: puzzle.piecesImages, forKey: "piecesImages")
                //try? UserDefaults.standard.set(images: puzzle.boardImages, forKey: "boardImages")
                return [dragItem]
            }
        }
        //try? UserDefaults.standard.set(images: puzzle.piecesImages, forKey: "piecesImages")
        //try? UserDefaults.standard.set(images: puzzle.boardImages, forKey: "boardImages")
        return []
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        if collectionView == boardCollectionView {
            return true
        } else {
            return false
        }
    }
    
    // what will happen when you drop the item
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        if let destinationIndex = coordinator.destinationIndexPath {
            if destinationIndex.row >= puzzle.solvedImages.count {
                return
            } else if collectionView == boardCollectionView {
                let item = coordinator.items.first
                    // - happens in the same collection view
                if let sourceIndexPath = selectedIndexPath {
                    collectionView.performBatchUpdates ({
                        // get the dragged image
                        let dragItem = item?.dragItem.localObject as! UIImage
                        // check if destination has blank image
                        if puzzle.boardImages[destinationIndex.item] == blankImage {
                            self.puzzle.boardImages.insert(dragItem, at: destinationIndex.row)
                            //try? UserDefaults.standard.set(images: puzzle.boardImages, forKey: "boardImages")
                            boardCollectionView.insertItems(at: [destinationIndex])
                            //try? UserDefaults.standard.set(images: puzzle.boardImages, forKey: "boardImages")

                            self.puzzle.piecesImages.remove(at: sourceIndexPath.row)
                            self.puzzle.piecesImages.insert(blankImage, at: sourceIndexPath.row)
                            try? UserDefaults.standard.set(images: puzzle.piecesImages, forKey: "piecesImages")
                            //try? UserDefaults.standard.set(images: puzzle.boardImages, forKey: "boardImages")
                            piecesCollectionView.reloadData()
                        }
                        //try? UserDefaults.standard.set(images: puzzle.boardImages, forKey: "boardImages")
                    })
                    
                    collectionView.performBatchUpdates({
                        let row = destinationIndex.row + 1 == self.puzzle.boardImages.count
                            ? destinationIndex.row
                            : destinationIndex.row + 1
                        
                        self.puzzle.boardImages.remove(at: row)
                        let nextIndex = IndexPath(row: row, section: 0)
                        boardCollectionView.deleteItems(at: [nextIndex])
                        boardCollectionView.reloadData()
                        try? UserDefaults.standard.set(images: puzzle.boardImages, forKey: "boardImages")
                    })

                    coordinator.drop(item!.dragItem, toItemAt: destinationIndex)
                    numMoves+=1
                    updateNumMoves(numMoves: numMoves)
                    //try? UserDefaults.standard.set(images: puzzle.boardImages, forKey: "boardImages")

                    if (self.puzzle.solvedImages == self.puzzle.boardImages) {
                        //end the game
                        let alertController = UIAlertController(title: "You Won!", message: "Congratulations", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                            let activity = UIActivityViewController(
                                activityItems: [self.creation.image, "number of moves: \(self.numMoves)"],
                                applicationActivities: nil
                              )
                            self.present(activity, animated: true, completion: nil)
                        }
                        alertController.addAction(okAction)
                        alertController.modalPresentationStyle = .overCurrentContext
                        present(alertController, animated: true)
                    }
                }
            }
        }
        //try? UserDefaults.standard.set(images: puzzle.piecesImages, forKey: "piecesImages")
        //try? UserDefaults.standard.set(images: puzzle.boardImages, forKey: "boardImages")
        //let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        //try? UserDefaults.standard.set(image: snapshot!, forKey: "creation")
//        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        //try? UserDefaults.standard.set(image: creation.image, forKey: "creation")
    }

func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
      guard let indexPath = destinationIndexPath else {
           return UICollectionViewDropProposal(operation: .forbidden)
       }
       if indexPath.row >= puzzle.solvedImages.count {
           return UICollectionViewDropProposal(operation: .forbidden)
       } else if collectionView == boardCollectionView {
           return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
       } else {
           return UICollectionViewDropProposal(operation: .forbidden)
       }
   }
}

extension UserDefaults {

    func valueExists(forKey key: String) -> Bool {
        return object(forKey: key) != nil
    }

    func set(image: UIImage?, quality: CGFloat = 0.5, forKey defaultName: String) {
            guard let image = image else {
                set(nil, forKey: defaultName)
                return
            }
            set(image.jpegData(compressionQuality: quality), forKey: defaultName)
        }
    
    func image(forKey defaultName:String) -> UIImage? {
            guard
                let data = data(forKey: defaultName),
                let image = UIImage(data: data)
            else  { return nil }
            return image
        }

    func set(images value: [UIImage]?, forKey defaultName: String) throws {
            guard let value = value else {
                removeObject(forKey: defaultName)
                return
            }
            try set(NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false), forKey: defaultName)
        }
    
    func images(forKey defaultName: String) throws -> [UIImage] {
            guard let data = data(forKey: defaultName) else { return [] }

            let object = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            return object as? [UIImage] ?? []
        }
    
    func save<T:Encodable>(customObject object: T, inKey key: String) {
           let encoder = JSONEncoder()
           if let encoded = try? encoder.encode(object) {
               self.set(encoded, forKey: key)
           }
       }

       func retrieve<T:Decodable>(object type:T.Type, fromKey key: String) -> T? {
           if let data = self.data(forKey: key) {
               let decoder = JSONDecoder()
               if let object = try? decoder.decode(type, from: data) {
                   return object
               }else {
                   print("Couldnt decode object")
                   return nil
               }
           }else {
               print("Couldnt find key")
               return nil
           }
       
    }
}
