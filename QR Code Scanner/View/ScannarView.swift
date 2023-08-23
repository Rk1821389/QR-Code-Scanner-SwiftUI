//
//  ScannarView.swift
//  QR Code Scanner
//
//  Created by Rahul on 23/08/23.
//

import SwiftUI
import AVKit

struct ScannarView: View {
    /// QR Code Scanner Properties
    
    @State var isScanning: Bool = false
    @State var session: AVCaptureSession = .init()
    @State var cameraPermission: Permission = .idle
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    @State var errorMessage: String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            Button {
                
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text("Place The QR code inside the area")
                .font(.title3)
                .foregroundColor(.black.opacity(0.8))
            
            Text("Scanning will start automatically")
                .font(.callout)
                .foregroundColor(.gray)
            
            Spacer(minLength: 0)
            
            GeometryReader { proxy in
                let size = proxy.size
                
                ZStack {
                    ForEach(0..<4, id: \.self) { index in
                        let rotation = Double(index) * 90
                        
                        CameraView(frameSize: size, session: $session)
                        
                        RoundedRectangle(cornerRadius: 2, style: .circular)
                        ///Trimming to get Scanner like edges
                            .trim(from: 0.61, to: 0.64)
                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                            .rotationEffect(.degrees(rotation))
                        
                    }
                }
                .frame(width: size.width, height: size.width)
                .overlay(alignment: .top, content: {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 2.5)
                        .shadow(color: Color.black.opacity(0.8), radius: 8, x: 0, y: isScanning ? 15 : -15)
                        .offset(y: isScanning ? size.width : 0)
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, 45)
            
            Spacer(minLength: 0)
            
            Button {
                
            } label: {
                Image(systemName: "qrcode.viewfinder")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }

            
        }
        .padding(15)
        .onAppear(perform: checkCameraPermission)
        .alert(errorMessage, isPresented: $showAlert) {
            
        }
    }
    
    //Activating Scanner Animation
    private func activateScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85).delay(0.1).repeatForever(autoreverses: true)) {
            isScanning = true
        }
    }
    
    ///Chec camera permission
    private func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    //Permission Granted
                    cameraPermission = .approved
                } else {
                    //Permission Denied
                    cameraPermission = .denied
                    
                }
            case .restricted:
                cameraPermission = .denied
            case .denied:
                cameraPermission = .denied
            case .authorized:
                cameraPermission = .approved
            @unknown default:
                break
            }
        }
    }
    
}

struct ScannarView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
