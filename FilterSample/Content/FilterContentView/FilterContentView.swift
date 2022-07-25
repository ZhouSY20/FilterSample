//
//  FilterContentView.swift
//  FilterSample
//
//  Created by cmStudent on 2022/07/01.
//

import SwiftUI

struct FilterContentView: View {

    @StateObject private var viewModel = FilterContentViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                if let filterdImage = viewModel.filterdImage {
                    Image(uiImage: filterdImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .onTapGesture {
                            withAnimation {
                                viewModel.isShowBanner = true
                            }
                        }
                } else {
                    EmptyView()
                }
                FilterBannerView(isShowBanner: $viewModel.isShowBanner, applyingFilter: $viewModel.applyingFilter)

            }// ZStackの終わり
            // Navigation Titleの設定
            .navigationTitle("Filter App")
            // Navigation Item
            // trailingにHStackでButtonを２つ置く
            .navigationBarItems(leading: EmptyView(), trailing:
                                    HStack {
//                Button {} label: {
//                    Image(systemName: "square.and.arrow.down")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 30, height: 30)
//                }
                Button(action: {
                    viewModel.apply(.tappedSaveIcon)
                }, label: {
                    Image(systemName: "square.and.arrow.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                })
//                Button {} label: {
//                    Image(systemName: "photo")
//                }
                Button(action: {
                    viewModel.apply(.tappedImageIcon)
                }, label: {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                })
            })
            .onAppear{
                // 画面表示時の処理
                viewModel.apply(.onAppear)
            }
            .actionSheet(isPresented: $viewModel.isShowActionSheet) {
                actionSheet
            }
            .sheet(isPresented: $viewModel.isShowImagePickerView) {
                ImagePicker(isShown: $viewModel.isShowImagePickerView, image: $viewModel.image, sourceType: viewModel.selectedSourceType)
            }
            .alert(isPresented: $viewModel.isShowAlert) {
                Alert(title: Text(viewModel.alertTitle))
            }
        } // NavigationViewの終わり
    }
    
    var actionSheet: ActionSheet {
        var buttons: [ActionSheet.Button] = []
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // カメラが利用できるからカメラボタンを追加
            let cameraButton = ActionSheet.Button.default(Text("写真を撮る")){
                viewModel.apply(.tappedActionSheet(selectType: .camera))
            }
            buttons.append(cameraButton)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // フォトライブラリーが使えるならばフォトライブラリーボタンを追加
            let photoLibraryButton = ActionSheet.Button.default(Text("アルバムから選択")) {
                viewModel.apply(.tappedActionSheet(selectType: .photoLibrary))
            }
            buttons.append(photoLibraryButton)
        }
        // キャンセルボタン
        let cancelButton = ActionSheet.Button.cancel(Text("キャンセル"))
        buttons.append(cancelButton)
        
        let actionSheet = ActionSheet(title: Text("画像選択"), message: nil, buttons: buttons)
        
        return actionSheet
        
    }
}

struct FilterContentView_Previews: PreviewProvider {
    static var previews: some View {
        FilterContentView()
    }
}
