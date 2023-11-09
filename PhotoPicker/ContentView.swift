//
//  PhotoPicker.swift
//  HackingSwfit
//
//  Created by Montserrat Gomez on 2023-11-01.
//

import SwiftUI
import PhotosUI


struct PhotoPicker: View {
	
	@State var avatarImage: UIImage?
	@State var imageSelection: PhotosPickerItem?
	
	var body: some View {
		VStack{
			HStack(spacing: 20){
				Image(uiImage: avatarImage  ?? UIImage(resource: .avatar))
					.resizable()
					.aspectRatio(contentMode: .fit)
					.cornerRadius(20)
					.frame(width: 100, height: 100, alignment: .center)
					.overlay(alignment: .bottomTrailing) {
						
						/// El PhotoPicker tiene varios argumentos
						/// matching: .images (puede ser .videos, etc) es como un filtro
						///se tiene que convertir a un objeto Imagen
						///
						PhotosPicker(selection: $imageSelection,
									 matching: .images,
									 photoLibrary: .shared()) {
							Image(systemName: "pencil.circle.fill")
								.symbolRenderingMode(.multicolor)
								.font(.system(size: 30))
								.foregroundColor(.accentColor)
						}
					}
				VStack(alignment: .leading, spacing: 10){
					Text("Montserrat Gomez")
						.font(.title)
					Text("iOS Developer")
						.font(.caption)
				}
				
			}
			Spacer()
		}
		.padding(10)
		.onChange(of: imageSelection) { _ , _ in
			Task{
				/// Revisar si es null o no la imageSelection
				/// Data.self es para que lea la misma data de ImageSelection
				if let imageSelection,
				   let data = try? await imageSelection.loadTransferable(type: Data.self){
					if let image = UIImage(data: data){
						avatarImage = image
					}
				}
				imageSelection = nil
				
			}
		}
	}
}

#Preview {
	PhotoPicker()
}

