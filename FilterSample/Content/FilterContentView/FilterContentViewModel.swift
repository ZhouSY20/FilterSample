//
//  FilterContentViewModel.swift
//  FilterSample
//
//  Created by cmStudent on 2022/07/01.
//
import SwiftUI
import Combine
import SwiftUI

final class FilterContentViewModel: NSObject, ObservableObject {
    enum Inputs {
        case onAppear
        case tappedActionSheet(selectType: UIImagePickerController.SourceType)
        case tappedSaveIcon
        case tappedImageIcon
    }
    @Published var image: UIImage?
    @Published var filterdImage: UIImage?
    //@Published var filterdImage: UIImage? = UIImage(named: "marumattarou")
    
    @Published var isShowActionSheet = false
    @Published var isShowImagePickerView = false
    
    @Published var selectedSourceType: UIImagePickerController.SourceType = .camera
    // フィルターバナー表示用フラグ
    @Published var isShowBanner = false
    
    // フィルターを適用するFilterType
    @Published var applyingFilter: FilterType?
    
    // Combineを実行するためのCancellable
    var cancellables: [Cancellable] = []
    
    var alertTitle: String = ""
    
    @Published var isShowAlert = false
    
    override init() {
        super.init()
        // $を付けている（状態変数として使う→今回はPublished→Publisher)
        let imageCancellable = $image.sink { [weak self] uiimage in
            guard let self = self, let uiimage = uiimage else { return }
            
            self.filterdImage = uiimage
        }
        
        let filterCancellable = $applyingFilter.sink { [weak self] filterType in
            guard let self = self,
                  let filterType = filterType,
                    let image = self.image else {
                        return
                    }
            
            guard let filterdUIImage = self.updateImage(with: image, type: filterType) else { return }
            self.filterdImage = filterdUIImage
        }
        
        cancellables.append(imageCancellable)
        cancellables.append(filterCancellable)
    }
    
    
    
    func apply(_ inputs: Inputs) {
        switch inputs {
        case .onAppear:
            if image == nil {
                isShowActionSheet = true
            }
        case .tappedActionSheet(let sourceType):
            // フォトライブラリーを起動する（あるいはカメラを起動する？）
            selectedSourceType = sourceType
            isShowImagePickerView = true
        case .tappedImageIcon:
            //applyingFilter = nil
            isShowActionSheet = true
        case .tappedSaveIcon:
            UIImageWriteToSavedPhotosAlbum(filterdImage!,
                                           self, #selector(imageSaveCompletion(_:
                                                                                didFinishSavingWithError:contextInfo:)), nil)
            //  1break
        }
    }
    private func updateImage (with image: UIImage, type filter: FilterType) -> UIImage? {
        return filter.filter(inputImage: image)
    }
    @objc func imageSaveCompletion(_ image: UIImage,
                                   didFinishSavingWithError error: Error?,
                                   contextInfo: UnsafeRawPointer) {
        alertTitle = error == nil ? "画像を保存されました" : error?.localizedDescription ?? ""
        isShowAlert = true
    }
}
