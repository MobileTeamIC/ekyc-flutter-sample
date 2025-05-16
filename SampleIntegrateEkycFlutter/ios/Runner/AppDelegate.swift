import UIKit
import Flutter
import ICSdkEKYC


@main
@objc class AppDelegate: FlutterAppDelegate {
    
    var methodChannel: FlutterResult?
    
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UIDevice.current.isProximityMonitoringEnabled = false
        
    
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        // let controller = FlutterViewController()
        // let nav = UINavigationController.init(rootViewController: controller)
        // nav.isNavigationBarHidden = true
        // self.window.rootViewController = nav
        let channel = FlutterMethodChannel(name: "flutter.sdk.ekyc/integrate",
                                           binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            // Handle battery messages.
            self.methodChannel = result
            if let info = call.arguments as? [String: String] {
                //print(self.convertToDictionary(text: info))
                DispatchQueue.main.async {
                    if call.method == "startEkycFull" {
                        self.startEkycFull(controller, info: info)
                    } else if call.method == "startEkycOcr" {
                        self.startEkycOcr(controller, info: info)
                    } else if call.method == "startEkycFace" {
                        self.startEkycFace(controller, info: info)
                    } else if call.method == "startEkycOcrFront" {
                        self.startEkycOcrFront(controller, info: info)
                    } else if call.method == "startEkycOcrBack" {
                        self.startEkycOcrBack(controller, info: info)
                    }
                }
            }
            
            print("channel.setMethodCallHandler")
            
        })
        
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    /// Luồng đầy đủ: Ocr + Face
    /// - Parameter controller: root viewcontroller
    func startEkycFull(_ controller: UIViewController, info: [String: String]) {
        let camera = ICEkycCameraRouter.createModule() as! ICEkycCameraViewController
        
        /// Đăng ký nhận kết quả
        camera.cameraDelegate = self
        
        /// Nhập thông tin bộ mã truy cập. Lấy tại mục Quản lý Token https://ekyc.vnpt.vn/admin-dashboard/console/project-manager
        camera.accessToken = info["access_token"] ?? ""
        camera.tokenId = info["token_id"] ?? ""
        camera.tokenKey = info["token_key"] ?? ""
        
        /// Thay đổi đường dẫn mặc định
        // camera.changeBaseUrl = ""
        
        /// Giá trị này xác định kiểu giấy tờ để sử dụng:
        /// - IDENTITY_CARD: Chứng minh thư nhân dân, Căn cước công dân
        /// - IDCardChipBased: Căn cước công dân gắn Chip
        /// - Passport: Hộ chiếu
        /// - DriverLicense: Bằng lái xe
        /// - MilitaryIdCard: Chứng minh thư quân đội
        camera.documentType = IdentityCard
        
        /// Xác định luồng thực hiện eKYC
        /// Giá trị mặc định là none
        /// - none: không thực hiện luồng nào cả
        /// - full: thực hiện eKYC đầy đủ các bước: chụp giấy tờ và chụp ảnh chân dung
        /// - scanQR: thực hiện quét QR và trả ra kết quả
        /// - ocrFront: thực hiện OCR giấy tờ một bước: chụp mặt trước giấy tờ
        /// - ocrBack: thực hiện OCR giấy tờ một bước: chụp mặt sau giấy tờ
        /// - ocr: thực hiện OCR giấy tờ
        /// - face: thực hiện chụp ảnh Oval xa gần và thực hiện các chức năng tuỳ vào Bật/Tắt: Compare, Verify, Mask, Liveness Face
        camera.flowType = full
        
        /// Bật/Tắt chức năng kiểm tra ảnh giấy tờ chụp trực tiếp (liveness card)
        camera.isCheckLivenessCard = true
        
        /// Lựa chọn chế độ kiểm tra ảnh giấy tờ ngay từ SDK
        /// - None: Không thực hiện kiểm tra ảnh khi chụp ảnh giấy tờ
        /// - Basic: Kiểm tra sau khi chụp ảnh
        /// - MediumFlip: Kiểm tra ảnh hợp lệ trước khi chụp (lật giấy tờ thành công → hiển thị nút chụp)
        /// - Advance: Kiểm tra ảnh hợp lệ trước khi chụp (hiển thị nút chụp)
        camera.validateDocumentType = Basic
        
        /// Giá trị này xác định việc có xác thực số ID với mã tỉnh thành, quận huyện, xã phường tương ứng hay không.
        camera.isValidatePostcode = true
        
        /// Giá trị này dùng để đảm bảo mỗi yêu cầu (request) từ phía khách hàng sẽ không bị thay đổi.
        camera.challengeCode = "INNOVATIONCENTER"
        
        /// Ngôn ngữ sử dụng trong SDK
        /// - icekyc_vi: Tiếng Việt
        /// - icekyc_en: Tiếng Anh
        camera.languageSdk = "icekyc_vi"
        
        /// Bật/Tắt Hiển thị màn hình hướng dẫn
        camera.isShowTutorial = true
        
        /// Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video
        camera.isEnableGotIt = true
        
        /// Sử dụng máy ảnh mặt trước
        /// - PositionFront: Camera trước
        /// - PositionBack: Camera sau
        camera.cameraPositionForPortrait = PositionFront
        
        /// Cho phép quét QRCode
        camera.isEnableScanQRCode = true
        
        DispatchQueue.main.async {
            camera.modalTransitionStyle = .coverVertical
            camera.modalPresentationStyle = .fullScreen
            controller.present(camera, animated: true)
        }
    }
    
    /// Luồng chỉ thực hiện đọc giấy tờ: Ocr
    /// - Parameters:
    ///   - controller: root viewcontroller
    ///   - info: thông tin truyền vào
    func startEkycOcr(_ controller: UIViewController, info: [String: String]) {
        let camera = ICEkycCameraRouter.createModule() as! ICEkycCameraViewController
        
        /// Đăng ký nhận kết quả
        camera.cameraDelegate = self
        
        /// Nhập thông tin bộ mã truy cập. Lấy tại mục Quản lý Token https://ekyc.vnpt.vn/admin-dashboard/console/project-manager
        camera.accessToken = info["access_token"] ?? ""
        camera.tokenId = info["token_id"] ?? ""
        camera.tokenKey = info["token_key"] ?? ""
        
        /// Thay đổi đường dẫn mặc định
        // camera.changeBaseUrl = ""
        
        /// Giá trị này xác định kiểu giấy tờ để sử dụng:
        /// - IDENTITY_CARD: Chứng minh thư nhân dân, Căn cước công dân
        /// - IDCardChipBased: Căn cước công dân gắn Chip
        /// - Passport: Hộ chiếu
        /// - DriverLicense: Bằng lái xe
        /// - MilitaryIdCard: Chứng minh thư quân đội
        camera.documentType = IdentityCard
        
        /// Xác định luồng thực hiện eKYC
        /// Giá trị mặc định là none
        /// - none: không thực hiện luồng nào cả
        /// - full: thực hiện eKYC đầy đủ các bước: chụp giấy tờ và chụp ảnh chân dung
        /// - scanQR: thực hiện quét QR và trả ra kết quả
        /// - ocrFront: thực hiện OCR giấy tờ một bước: chụp mặt trước giấy tờ
        /// - ocrBack: thực hiện OCR giấy tờ một bước: chụp mặt sau giấy tờ
        /// - ocr: thực hiện OCR giấy tờ
        /// - face: thực hiện chụp ảnh Oval xa gần và thực hiện các chức năng tuỳ vào Bật/Tắt: Compare, Verify, Mask, Liveness Face
        camera.flowType = ocr
        
        /// Bật/Tắt chức năng kiểm tra ảnh giấy tờ chụp trực tiếp (liveness card)
        camera.isCheckLivenessCard = true
        
        /// Lựa chọn chế độ kiểm tra ảnh giấy tờ ngay từ SDK
        /// - None: Không thực hiện kiểm tra ảnh khi chụp ảnh giấy tờ
        /// - Basic: Kiểm tra sau khi chụp ảnh
        /// - MediumFlip: Kiểm tra ảnh hợp lệ trước khi chụp (lật giấy tờ thành công → hiển thị nút chụp)
        /// - Advance: Kiểm tra ảnh hợp lệ trước khi chụp (hiển thị nút chụp)
        camera.validateDocumentType = Basic
        
        /// Giá trị này xác định việc có xác thực số ID với mã tỉnh thành, quận huyện, xã phường tương ứng hay không.
        camera.isValidatePostcode = true
        
        /// Giá trị này dùng để đảm bảo mỗi yêu cầu (request) từ phía khách hàng sẽ không bị thay đổi.
        camera.challengeCode = "INNOVATIONCENTER"
        
        /// Ngôn ngữ sử dụng trong SDK
        /// - icekyc_vi: Tiếng Việt
        /// - icekyc_en: Tiếng Anh
        camera.languageSdk = "icekyc_vi"
        
        /// Bật/Tắt Hiển thị màn hình hướng dẫn
        camera.isShowTutorial = true
        
        /// Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video
        camera.isEnableGotIt = true
        
        /// Sử dụng máy ảnh mặt trước
        /// - PositionFront: Camera trước
        /// - PositionBack: Camera sau
        camera.cameraPositionForPortrait = PositionFront
        
        /// Cho phép quét QRCode
        camera.isEnableScanQRCode = true
        
        DispatchQueue.main.async {
            camera.modalTransitionStyle = .coverVertical
            camera.modalPresentationStyle = .fullScreen
            controller.present(camera, animated: true)
        }
        
    }
    
    /// Luồng chỉ thực hiện đọc giấy tờ chỉ mặt trước: OcrFont
    /// - Parameters:
    ///   - controller: root viewcontroller
    ///   - info: thông tin truyền vào
    func startEkycOcrFront(_ controller: UIViewController, info: [String: String]) {
        let camera = ICEkycCameraRouter.createModule() as! ICEkycCameraViewController
        
        /// Đăng ký nhận kết quả
        camera.cameraDelegate = self
        
        /// Nhập thông tin bộ mã truy cập. Lấy tại mục Quản lý Token https://ekyc.vnpt.vn/admin-dashboard/console/project-manager
        camera.accessToken = info["access_token"] ?? ""
        camera.tokenId = info["token_id"] ?? ""
        camera.tokenKey = info["token_key"] ?? ""
        
        /// Thay đổi đường dẫn mặc định
        // camera.changeBaseUrl = ""
        
        /// Giá trị này xác định kiểu giấy tờ để sử dụng:
        /// - IDENTITY_CARD: Chứng minh thư nhân dân, Căn cước công dân
        /// - IDCardChipBased: Căn cước công dân gắn Chip
        /// - Passport: Hộ chiếu
        /// - DriverLicense: Bằng lái xe
        /// - MilitaryIdCard: Chứng minh thư quân đội
        camera.documentType = IdentityCard
        
        /// Xác định luồng thực hiện eKYC
        /// Giá trị mặc định là none
        /// - none: không thực hiện luồng nào cả
        /// - full: thực hiện eKYC đầy đủ các bước: chụp giấy tờ và chụp ảnh chân dung
        /// - scanQR: thực hiện quét QR và trả ra kết quả
        /// - ocrFront: thực hiện OCR giấy tờ một bước: chụp mặt trước giấy tờ
        /// - ocrBack: thực hiện OCR giấy tờ một bước: chụp mặt sau giấy tờ
        /// - ocr: thực hiện OCR giấy tờ
        /// - face: thực hiện chụp ảnh Oval xa gần và thực hiện các chức năng tuỳ vào Bật/Tắt: Compare, Verify, Mask, Liveness Face
        camera.flowType = ocrFront
        
        /// Bật/Tắt chức năng kiểm tra ảnh giấy tờ chụp trực tiếp (liveness card)
        camera.isCheckLivenessCard = true
        
        /// Lựa chọn chế độ kiểm tra ảnh giấy tờ ngay từ SDK
        /// - None: Không thực hiện kiểm tra ảnh khi chụp ảnh giấy tờ
        /// - Basic: Kiểm tra sau khi chụp ảnh
        /// - MediumFlip: Kiểm tra ảnh hợp lệ trước khi chụp (lật giấy tờ thành công → hiển thị nút chụp)
        /// - Advance: Kiểm tra ảnh hợp lệ trước khi chụp (hiển thị nút chụp)
        camera.validateDocumentType = Basic
        
        /// Giá trị này xác định việc có xác thực số ID với mã tỉnh thành, quận huyện, xã phường tương ứng hay không.
        camera.isValidatePostcode = true
        
        /// Giá trị này dùng để đảm bảo mỗi yêu cầu (request) từ phía khách hàng sẽ không bị thay đổi.
        camera.challengeCode = "INNOVATIONCENTER"
        
        /// Ngôn ngữ sử dụng trong SDK
        /// - icekyc_vi: Tiếng Việt
        /// - icekyc_en: Tiếng Anh
        camera.languageSdk = "icekyc_vi"
        
        /// Bật/Tắt Hiển thị màn hình hướng dẫn
        camera.isShowTutorial = true
        
        /// Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video
        camera.isEnableGotIt = true
        
        /// Sử dụng máy ảnh mặt trước
        /// - PositionFront: Camera trước
        /// - PositionBack: Camera sau
        camera.cameraPositionForPortrait = PositionFront
        
        /// Cho phép quét QRCode
        camera.isEnableScanQRCode = true
        
        DispatchQueue.main.async {
            camera.modalTransitionStyle = .coverVertical
            camera.modalPresentationStyle = .fullScreen
            controller.present(camera, animated: true)
        }
        
    }
    
    /// Luồng chỉ thực hiện đọc giấy tờ chỉ mặt sau: OcrBack
    /// - Parameters:
    ///   - controller: root viewcontroller
    ///   - info: thông tin truyền vào
    func startEkycOcrBack(_ controller: UIViewController, info: [String: String]) {
        let camera = ICEkycCameraRouter.createModule() as! ICEkycCameraViewController
        
        /// Đăng ký nhận kết quả
        camera.cameraDelegate = self
        
        /// Nhập thông tin bộ mã truy cập. Lấy tại mục Quản lý Token https://ekyc.vnpt.vn/admin-dashboard/console/project-manager
        camera.accessToken = info["access_token"] ?? ""
        camera.tokenId = info["token_id"] ?? ""
        camera.tokenKey = info["token_key"] ?? ""
        
        /// Thay đổi đường dẫn mặc định
        // camera.changeBaseUrl = ""
        
        /// Giá trị này xác định kiểu giấy tờ để sử dụng:
        /// - IDENTITY_CARD: Chứng minh thư nhân dân, Căn cước công dân
        /// - IDCardChipBased: Căn cước công dân gắn Chip
        /// - Passport: Hộ chiếu
        /// - DriverLicense: Bằng lái xe
        /// - MilitaryIdCard: Chứng minh thư quân đội
        camera.documentType = IdentityCard
        
        /// Xác định luồng thực hiện eKYC
        /// Giá trị mặc định là none
        /// - none: không thực hiện luồng nào cả
        /// - full: thực hiện eKYC đầy đủ các bước: chụp giấy tờ và chụp ảnh chân dung
        /// - scanQR: thực hiện quét QR và trả ra kết quả
        /// - ocrFront: thực hiện OCR giấy tờ một bước: chụp mặt trước giấy tờ
        /// - ocrBack: thực hiện OCR giấy tờ một bước: chụp mặt sau giấy tờ
        /// - ocr: thực hiện OCR giấy tờ
        /// - face: thực hiện chụp ảnh Oval xa gần và thực hiện các chức năng tuỳ vào Bật/Tắt: Compare, Verify, Mask, Liveness Face
        camera.flowType = ocrBack
        
        /// Bật/Tắt chức năng kiểm tra ảnh giấy tờ chụp trực tiếp (liveness card)
        camera.isCheckLivenessCard = true
        
        /// Lựa chọn chế độ kiểm tra ảnh giấy tờ ngay từ SDK
        /// - None: Không thực hiện kiểm tra ảnh khi chụp ảnh giấy tờ
        /// - Basic: Kiểm tra sau khi chụp ảnh
        /// - MediumFlip: Kiểm tra ảnh hợp lệ trước khi chụp (lật giấy tờ thành công → hiển thị nút chụp)
        /// - Advance: Kiểm tra ảnh hợp lệ trước khi chụp (hiển thị nút chụp)
        camera.validateDocumentType = Basic
        
        /// Giá trị này xác định việc có xác thực số ID với mã tỉnh thành, quận huyện, xã phường tương ứng hay không.
        camera.isValidatePostcode = true
        
        /// Giá trị này dùng để đảm bảo mỗi yêu cầu (request) từ phía khách hàng sẽ không bị thay đổi.
        camera.challengeCode = "INNOVATIONCENTER"
        
        /// Ngôn ngữ sử dụng trong SDK
        /// - icekyc_vi: Tiếng Việt
        /// - icekyc_en: Tiếng Anh
        camera.languageSdk = "icekyc_vi"
        
        /// Bật/Tắt Hiển thị màn hình hướng dẫn
        camera.isShowTutorial = true
        
        /// Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video
        camera.isEnableGotIt = true
        
        /// Sử dụng máy ảnh mặt trước
        /// - PositionFront: Camera trước
        /// - PositionBack: Camera sau
        camera.cameraPositionForPortrait = PositionFront
        
        DispatchQueue.main.async {
            camera.modalTransitionStyle = .coverVertical
            camera.modalPresentationStyle = .fullScreen
            controller.present(camera, animated: true)
        }
        
    }
    
    
    /// Luồng chỉ thực hiện xác thực khuôn mặt
    /// - Parameters:
    ///   - controller: root viewcontroller
    ///   - info: thông tin truyền vào
    func startEkycFace(_ controller: UIViewController, info: [String: String]) {
        let camera = ICEkycCameraRouter.createModule() as! ICEkycCameraViewController
        
        /// Đăng ký nhận kết quả
        camera.cameraDelegate = self
        
        /// Nhập thông tin bộ mã truy cập. Lấy tại mục Quản lý Token https://ekyc.vnpt.vn/admin-dashboard/console/project-manager
        camera.accessToken = info["access_token"] ?? ""
        camera.tokenId = info["token_id"] ?? ""
        camera.tokenKey = info["token_key"] ?? ""
        
        /// Thay đổi đường dẫn mặc định
        // camera.changeBaseUrl = ""
        
        /// Giá trị này xác định kiểu giấy tờ để sử dụng:
        /// - IDENTITY_CARD: Chứng minh thư nhân dân, Căn cước công dân
        /// - IDCardChipBased: Căn cước công dân gắn Chip
        /// - Passport: Hộ chiếu
        /// - DriverLicense: Bằng lái xe
        /// - MilitaryIdCard: Chứng minh thư quân đội
        camera.documentType = IdentityCard
        
        /// Xác định luồng thực hiện eKYC
        /// Giá trị mặc định là none
        /// - none: không thực hiện luồng nào cả
        /// - full: thực hiện eKYC đầy đủ các bước: chụp giấy tờ và chụp ảnh chân dung
        /// - scanQR: thực hiện quét QR và trả ra kết quả
        /// - ocrFront: thực hiện OCR giấy tờ một bước: chụp mặt trước giấy tờ
        /// - ocrBack: thực hiện OCR giấy tờ một bước: chụp mặt sau giấy tờ
        /// - ocr: thực hiện OCR giấy tờ
        /// - face: thực hiện chụp ảnh Oval xa gần và thực hiện các chức năng tuỳ vào Bật/Tắt: Compare, Verify, Mask, Liveness Face
        camera.flowType = face
        
        /// xác định xác thực khuôn mặt bằng oval xa gần
        /// - Normal: chụp ảnh chân dung 1 hướng
        /// - ProOval: chụp ảnh chân dung xa gần
        camera.versionSdk = ProOval
        
        /// Bật/Tắt chức năng So sánh ảnh trong thẻ và ảnh chân dung
        camera.isEnableCompare = true
        
        /// Bật/Tắt chức năng kiểm tra che mặt
        camera.isCheckMaskedFace = true
        
        /// Lựa chọn chức năng kiểm tra ảnh chân dung chụp trực tiếp (liveness face)
        /// - NoneCheckFace: Không thực hiện kiểm tra ảnh chân dung chụp trực tiếp hay không
        /// - iBETA: Kiểm tra ảnh chân dung chụp trực tiếp hay không iBeta (phiên bản hiện tại)
        /// - Standard: Kiểm tra ảnh chân dung chụp trực tiếp hay không Standard (phiên bản mới)
        camera.checkLivenessFace = IBeta
        
        /// Giá trị này dùng để đảm bảo mỗi yêu cầu (request) từ phía khách hàng sẽ không bị thay đổi.
        camera.challengeCode = "INNOVATIONCENTER"
        
        /// Ngôn ngữ sử dụng trong SDK
        /// - icekyc_vi: Tiếng Việt
        /// - icekyc_en: Tiếng Anh
        camera.languageSdk = "icekyc_vi"
        
        /// Bật/Tắt Hiển thị màn hình hướng dẫn
        camera.isShowTutorial = true
        
        /// Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video
        camera.isEnableGotIt = true
        
        /// Sử dụng máy ảnh mặt trước
        /// - PositionFront: Camera trước
        /// - PositionBack: Camera sau
        camera.cameraPositionForPortrait = PositionFront;
        
        DispatchQueue.main.async {
            camera.modalTransitionStyle = .coverVertical
            camera.modalPresentationStyle = .fullScreen
            controller.present(camera, animated: true)
        }
    }
    
    private func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension AppDelegate: ICEkycCameraDelegate {
    
    func icEkycGetResult() {
        UIDevice.current.isProximityMonitoringEnabled = false /// tắt cảm biến làm tối màn hình
        let dataInfoResult = ICEKYCSavedData.shared().ocrResult;
        let dataLivenessCardFrontResult = ICEKYCSavedData.shared().livenessCardFrontResult;
        let dataLivenessCardRearResult = ICEKYCSavedData.shared().livenessCardBackResult;
        let dataCompareResult = ICEKYCSavedData.shared().compareFaceResult;
        let dataLivenessFaceResult = ICEKYCSavedData.shared().livenessFaceResult;
        let dataMaskedFaceResult = ICEKYCSavedData.shared().maskedFaceResult;
        
        let dict = [
            "INFO_RESULT": dataInfoResult,
            "LIVENESS_CARD_FRONT_RESULT": dataLivenessCardFrontResult,
            "LIVENESS_CARD_REAR_RESULT": dataLivenessCardRearResult,
            "COMPARE_RESULT": dataCompareResult,
            "LIVENESS_FACE_RESULT": dataLivenessFaceResult,
            "MASKED_FACE_RESULT": dataMaskedFaceResult]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
            self.methodChannel!(jsonString)
            
        } catch {
            print(error.localizedDescription)
            self.methodChannel!(FlutterMethodNotImplemented)
        }
      
    }
    
    func icEkycCameraClosed(with type: ScreenType) {
        UIDevice.current.isProximityMonitoringEnabled = false
        self.methodChannel!(FlutterMethodNotImplemented)
    }
    
}


