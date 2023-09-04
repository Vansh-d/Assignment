//
//  downloadingScreen.swift
//  Assignment
//
//  Created by Vansh Dubey on 30/08/23.
//

import UIKit

class downloadingScreen: UIViewController {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var imageCollView: UICollectionView!
    
    @IBOutlet weak var downloadProgressLbl: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var progressBottomView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var downloadLbl: UILabel!
    @IBOutlet weak var appSizeLbl: UILabel!
    
    var isRunning = false
    var progressBarTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.imageIcon.image = UIImage(systemName: "gamecontroller")
        self.imageIcon.backgroundColor = .yellow
        self.bottomView.layer.cornerRadius = 25
        self.playBtn.setTitle("Play", for: .normal)
        
        self.progressBottomView.isHidden = true
        self.playBtn.isHidden = true
        self.progressView.layer.cornerRadius = 10
        self.progressView.layer.sublayers![1].cornerRadius = 10
        self.progressView.clipsToBounds = true
        self.progressView.subviews[1].clipsToBounds = true
        self.playBtn.clipsToBounds = true
        self.playBtn.layer.cornerRadius = 25

        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseIn , animations: {
            self.outerView.transform = CGAffineTransform.identity.scaledBy(x: 1.15, y: 1.1)
              })
        
        self.imageCollView.dataSource = self
        self.imageCollView.delegate = self
        self.imageCollView.register(UINib(nibName: "imageCollectionView", bundle: nil), forCellWithReuseIdentifier: "imageCollectionView")
        
        
        let bottomViewTap = UITapGestureRecognizer(target: self, action: #selector(startDownload))
        self.bottomView.addGestureRecognizer(bottomViewTap)
        let downloadLblTap = UITapGestureRecognizer(target: self, action: #selector(startDownload))
        self.downloadLbl.addGestureRecognizer(downloadLblTap)
        let appSizeLblTap = UITapGestureRecognizer(target: self, action: #selector(startDownload))
        self.appSizeLbl.addGestureRecognizer(appSizeLblTap)
        
    }
    
    
    
    @objc private func startDownload(){
        self.bottomView.isHidden = true
        self.progressBottomView.isHidden = false
        if(isRunning){
                progressBarTimer.invalidate()
                }
                else{
                progressView.progress = 0.0
                    self.progressBarTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateProgressView), userInfo: nil, repeats: true)
                    progressView.progressTintColor = UIColor.systemGreen
                    progressView.trackTintColor = UIColor.green
                    self.progressBottomView.bringSubviewToFront(self.downloadProgressLbl)
                }
                isRunning = !isRunning
        
    }

    @IBAction func crossBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func stopDownloadBtn(_ sender: Any) {
        isRunning = false
        progressView.progress = 0.0
        self.bottomView.isHidden = false
        self.progressBottomView.isHidden = true
        
    }
    @objc func updateProgressView(){
            progressView.progress += 0.1
            progressView.setProgress(progressView.progress, animated: true)
            if(progressView.progress == 1.0)
            {
                progressBarTimer.invalidate()
                isRunning = false
                self.progressBottomView.isHidden = true
                self.playBtn.isHidden = false
            }
        }
    
    @IBAction func playBtnAction(_ sender: Any) {
        let bottomSheetVC = BottomSheetViewController(childViewController: finalScreenVC())
        presentBottomSheet(bottomSheetVC, completion: nil)
    }
    
}

extension downloadingScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollView.dequeueReusableCell(withReuseIdentifier: "imageCollectionView", for: indexPath) as! imageCollectionView
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2 - 10, height: UIScreen.main.bounds.height/3 * 2 - 30
        )
    }
}
