//
//  MusicaIcon.swift
//  Musica
//
//  Created by Jared Kozar on 10/6/23.
//

import SwiftUI

struct FileIcon: View {
    var color: Color
    var icon: IconPlaying
    var iconSize: FileIconSize
    
    enum IconPlaying: Equatable {
        case standardIcon(iconName: String)
        case currentlyPlaying
    }
    
    enum FileIconSize: CGFloat {
        case small
        case medium
        case large
        
        var rectangleWidthHeight: CGFloat {
            switch self {
            case .small:
                return 40.0
            case .medium:
                return 55.0
            case .large:
                return 250.0
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .small:
                return 25.0
            case .medium:
                return 35.0
            case .large:
                return 175.0
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .small:
                return 7.0
            case .medium:
                return 12.0
            case .large:
                return 25.0
            }
        }
        
        var iconWeight: Font.Weight {
            switch self {
            case .small, .medium:
                return .bold
            case .large:
                return .light
            }
        }
    }
    
    var body: some View {
        ZStack {
            switch icon {
            case .standardIcon(let iconName):
                ZStack {
                    
                    RoundedRectangle(cornerRadius: iconSize.cornerRadius)
                        .foregroundStyle(color.quaternary)
                    
                    Image(systemName: iconName)
                        .foregroundStyle(color)
                        .font(.system(size: iconSize.iconSize, weight: iconSize.iconWeight))
                }
            case .currentlyPlaying:
                ZStack {
                    
                    RoundedRectangle(cornerRadius: iconSize.cornerRadius)
                        .foregroundStyle(.black.secondary)
                    
                    Image(systemName: "waveform")
                        .foregroundStyle(.white)
                        .symbolEffect(.pulse, options: .repeating, isActive: true)
                }
            }
        }
        .frame(width: iconSize.rectangleWidthHeight, height: iconSize.rectangleWidthHeight)
    }
}

extension Image {
    func iconStyle(color: Color, size: CGFloat) -> some View {
        modifier(Title(color: color, iconSize: size))
    }
}

struct Title: ViewModifier {
    let color: Color
    let iconSize: CGFloat
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(color)
            .aspectRatio(contentMode: .fit)
    }
}
