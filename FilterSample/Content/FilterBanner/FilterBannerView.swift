//
//  FilterBannerView.swift
//  FilterSample
//
//  Created by cmStudent on 2022/07/05.
//

import SwiftUI

// 部品を組み合わせてFilterBannerViewを作る
struct FilterBannerView: View {
    @State var selectedFilter: FilterType? = nil
    @Binding var isShowBanner: Bool
    @Binding var applyingFilter: FilterType?
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                VStack {
                    FilterTitleView(title: selectedFilter?.rawValue)
                    FilterIconContainerView(selectedFilter: $selectedFilter)
                    FilterButtonContainerView(isShowBanner: $isShowBanner, selectedFilter: $selectedFilter,applyingFilter: $applyingFilter)
                }
                .background(Color.black.opacity(0.5))
                .foregroundColor(.white)
                .offset(x: 0, y: isShowBanner ? 0 : geometry.size.height)
            }
        }
    }
}

struct FilterBannerView_Previews: PreviewProvider {
    static var previews: some View {
        FilterBannerView(isShowBanner: .constant(true), applyingFilter: .constant(.gaussianBlur))
    }
}

struct FilterTitleView: View {
    let title: String?
    var body: some View {
        Text("\(title ?? "フィルターを選択")")
            .font(.title)
            .fontWeight(.bold)
            .padding(.top)
    }
}

struct FilterImage: View {
    // フィルターがかかった画像を作る
    @State private var image: Image?
    // 何のフィルターか
    let filterType: FilterType // 自分自身のFilterType
    @Binding var selectedFilter: FilterType? // もしかしたら他のFilterTypeかもしれない
    

    let uiImage: UIImage = UIImage(named: "marumattarou")!
    var body: some View {
        Button {
            selectedFilter = filterType
            // フィルター処理
        } label: {
            image?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaledToFit()
        }
        .frame(width: 70, height: 70)
        .border(Color.primary, width: selectedFilter == filterType ? 4 : 0)
        .onAppear {
            // フィルターをかける
            if let outputImage = filterType.filter(inputImage: uiImage) {
                self.image = Image(uiImage: outputImage)
            }
        }
    }
}

struct FilterIconContainerView: View {
    @Binding var selectedFilter: FilterType?
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                // アイコンを並べる
                // モザイク
                FilterImage(filterType: .pixellate, selectedFilter: $selectedFilter)
                // セピア
                FilterImage(filterType: .sepiaTone, selectedFilter: $selectedFilter)
                // シャープ
                FilterImage(filterType: .sharpenLuminance, selectedFilter: $selectedFilter)
                // モノクロ
                FilterImage(filterType: .photoEffectMono, selectedFilter: $selectedFilter)
                // ぼかし
                FilterImage(filterType: .gaussianBlur, selectedFilter: $selectedFilter)
            }
            .padding([.leading, .trailing], 16)
        }
    }
}

struct FilterButtonContainerView: View {
    @Binding var isShowBanner: Bool
    @Binding var selectedFilter: FilterType?
    @Binding var applyingFilter: FilterType?
    
    var body: some View {
        HStack {
            Button {
                // 閉じる処理
                withAnimation {
                    // 閉じたい
                    isShowBanner = false
                    selectedFilter = nil
                }
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                    .padding()
            }
            
            Spacer() // 天の川
            Button {
                isShowBanner = false
                applyingFilter = selectedFilter
                selectedFilter = nil
            } label: {
                Image(systemName: "checkmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                    .padding()
            }
        }
    }
}
