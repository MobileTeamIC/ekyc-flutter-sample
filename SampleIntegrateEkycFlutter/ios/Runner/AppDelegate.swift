import UIKit
import Flutter
import ICSdkEKYC




@main
@objc class AppDelegate: FlutterAppDelegate {
    
    var methodChannel: FlutterResult?

    let channelName = "flutter.sdk.ekyc/integrate"
    
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UIDevice.current.isProximityMonitoringEnabled = false
        
        self.setupMethodChannel()
        
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func setupMethodChannel() {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: channelName,
                                           binaryMessenger: controller.binaryMessenger)
           
           channel.setMethodCallHandler({
               [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
               guard let self = self else { return }
               self.methodChannel = result
               
               guard let args = call.arguments as? [String: Any] else { return }
               switch call.method {
               case "startEkycFull":
                   self.startEkycFull(controller, args: args)
               case "startEkycOcr":
                   self.startEkycOcr(controller, args: args)
               case "startEkycOcrFront":
                   self.startEkycOcrFront(controller, args: args)
               case "startEkycOcrBack":
                   self.startEkycOcrBack(controller, args: args)
               case "startEkycFace":
                   self.startEkycFace(controller, args: args)
               case "startEkycScanQRCode":
                   self.startEkycScanQRCode(controller, args: args)
               default:
                   break
               }
           })
       }
    
    //MARK: - Full
    /// Luồng đầy đủ: OCR + Face Verification
    /// 
    /// Thực hiện eKYC đầy đủ các bước: chụp giấy tờ và chụp ảnh chân dung
    /// 
    /// - Parameters:
    ///   - controller: Root view controller để present eKYC SDK
    ///   - info: Dictionary chứa các thông số cấu hình eKYC
    /// 
    /// - Required Parameters (info):
    ///   - access_token: Mã truy cập từ eKYC admin dashboard
    ///   - token_id: Token ID từ eKYC admin dashboard
    ///   - token_key: Token key từ eKYC admin dashboard
    /// 
    /// - Optional Parameters (info):
    ///   - flow_type: Loại luồng thực hiện ("full", "none", "scanqr", "ocrfront", "ocrback", "ocr", "face")
    ///   - version_sdk: Phiên bản SDK cho chụp ảnh chân dung ("normal", "prooval")
    ///   - document_type: Loại giấy tờ ("identitycard", "idcardchipbased", "passport", "driverlicense", "militaryidcard")
    ///   - is_show_tutorial: Hiển thị màn hình hướng dẫn ("true"/"false")
    ///   - is_enable_compare: Bật/tắt chức năng so sánh ảnh chân dung ("true"/"false")
    ///   - is_check_masked_face: Bật/tắt chức năng kiểm tra che mặt ("true"/"false")
    ///   - check_liveness_face: Chức năng kiểm tra ảnh chân dung chụp trực tiếp ("nonecheckface", "ibeta", "standard")
    ///   - is_check_liveness_card: Bật/tắt chức năng kiểm tra ảnh giấy tờ chụp trực tiếp ("true"/"false")
    ///   - is_validate_postcode: Bật/tắt chức năng kiểm tra mã bưu điện ("true"/"false")
    ///   - validate_document_type: Chế độ kiểm tra ảnh giấy tờ ("none", "basic", "medium", "advance")
    ///   - change_base_url: Đường dẫn API tùy chỉnh
    ///   - is_enable_gotit: Bật/tắt nút "Bỏ qua hướng dẫn" ("true"/"false")
    ///   - language_sdk: Ngôn ngữ SDK ("icekyc_vi", "icekyc_en")
    ///   - is_show_logo: Bật/tắt hiển thị LOGO thương hiệu ("true"/"false")
    func startEkycFull(_ controller: UIViewController, args: [String: Any]) {
        let ICEkycCamera = ICEkycCameraRouter.createModule() as! ICEkycCameraViewController

        let accessToken = (args["access_token"] as? String) ?? ""
        let tokenId = (args["token_id"] as? String) ?? ""
        let tokenKey = (args["token_key"] as? String) ?? ""
        let versionSdk = (args["version_sdk"] as? String) ?? ""
        let documentType = (args["document_type"] as? String) ?? ""
        let isShowTutorial = (args["is_show_tutorial"] as? Bool) ?? false
        let isEnableCompare = (args["is_enable_compare"] as? Bool) ?? false
        let isCheckMaskedFace = (args["is_check_masked_face"] as? Bool) ?? false
        let checkLivenessFace = (args["check_liveness_face"] as? String) ?? ""
        let isCheckLivenessCard = (args["is_check_liveness_card"] as? Bool) ?? false
        let isValidatePostcode = (args["is_validate_postcode"] as? Bool) ?? false
        let validateDocumentType = (args["validate_document_type"] as? String) ?? ""
        let changeBaseUrl = (args["change_base_url"] as? String) ?? ""
        let isEnableGotIt = (args["is_enable_gotit"] as? Bool) ?? false
        let languageSdk = (args["language_sdk"] as? String) ?? ""
        let isShowLogo = (args["is_show_logo"] as? Bool) ?? false

        
        ICEkycCamera.cameraDelegate = self
        ICEkycCamera.flowType = full
        ICEkycCamera.accessToken = accessToken
        ICEkycCamera.tokenId = tokenId
        ICEkycCamera.tokenKey = tokenKey
        ICEkycCamera.versionSdk = convertToVersionSdk(versionSdk)
        ICEkycCamera.documentType = convertToDocumentType(documentType)
        ICEkycCamera.isShowTutorial = isShowTutorial
        ICEkycCamera.isEnableCompare = isEnableCompare
        ICEkycCamera.isCheckMaskedFace = isCheckMaskedFace
        ICEkycCamera.checkLivenessFace = convertToLivenessFaceMode(checkLivenessFace)
        ICEkycCamera.isCheckLivenessCard = isCheckLivenessCard
        ICEkycCamera.isValidatePostcode = isValidatePostcode
        ICEkycCamera.validateDocumentType = convertToValidateDocumentType(validateDocumentType)
        ICEkycCamera.changeBaseUrl = changeBaseUrl
        ICEkycCamera.isEnableGotIt = isEnableGotIt
        ICEkycCamera.languageSdk = convertLanguageSdk(languageSdk)
        ICEkycCamera.isShowLogo = isShowLogo
        
        ICEkycCamera.challengeCode = "INNOVATIONCENTER"
        ICEkycCamera.cameraPositionForPortrait = PositionFront
        ICEkycCamera.isEnableScanQRCode = true
        
        DispatchQueue.main.async {
            ICEkycCamera.modalTransitionStyle = .coverVertical
            ICEkycCamera.modalPresentationStyle = .fullScreen
            controller.present(ICEkycCamera, animated: true)
        }
    }
    
    //MARK: - OCR
    /// Luồng chỉ thực hiện đọc giấy tờ: OCR
    /// 
    /// Thực hiện OCR giấy tờ (cả mặt trước và mặt sau)
    /// 
    /// - Parameters:
    ///   - controller: Root view controller để present eKYC SDK
    ///   - info: Dictionary chứa các thông số cấu hình eKYC
    /// 
    /// - Required Parameters (info):
    ///   - access_token: Mã truy cập từ eKYC admin dashboard
    ///   - token_id: Token ID từ eKYC admin dashboard
    ///   - token_key: Token key từ eKYC admin dashboard
    /// 
    /// - Optional Parameters (info):
    ///   - flow_type: Loại luồng thực hiện ("ocr", "none", "scanqr", "ocrfront", "ocrback", "full", "face")
    ///   - document_type: Loại giấy tờ ("identitycard", "idcardchipbased", "passport", "driverlicense", "militaryidcard")
    ///   - is_show_tutorial: Hiển thị màn hình hướng dẫn ("true"/"false")
    ///   - is_check_liveness_card: Bật/tắt chức năng kiểm tra ảnh giấy tờ chụp trực tiếp ("true"/"false")
    ///   - validate_document_type: Chế độ kiểm tra ảnh giấy tờ ("none", "basic", "medium", "advance")
    ///   - is_validate_postcode: Bật/tắt chức năng kiểm tra mã bưu điện ("true"/"false")
    ///   - change_base_url: Đường dẫn API tùy chỉnh
    ///   - is_enable_gotit: Bật/tắt nút "Bỏ qua hướng dẫn" ("true"/"false")
    ///   - language_sdk: Ngôn ngữ SDK ("icekyc_vi", "icekyc_en")
    ///   - is_show_logo: Bật/tắt hiển thị LOGO thương hiệu ("true"/"false")
    func startEkycOcr(_ controller: UIViewController, args: [String: Any]) {
        let ICEkycCamera = ICEkycCameraRouter.createModule() as! ICEkycCameraViewController

        let accessToken = (args["access_token"] as? String) ?? ""
        let tokenId = (args["token_id"] as? String) ?? ""
        let tokenKey = (args["token_key"] as? String) ?? ""
        let documentType = (args["document_type"] as? String) ?? ""
        let isShowTutorial = (args["is_show_tutorial"] as? Bool) ?? false
        let isCheckLivenessCard = (args["is_check_liveness_card"] as? Bool) ?? false
        let validateDocumentType = (args["validate_document_type"] as? String) ?? ""
        let changeBaseUrl = (args["change_base_url"] as? String) ?? ""
        let isEnableGotIt = (args["is_enable_gotit"] as? Bool) ?? false
        let languageSdk = (args["language_sdk"] as? String) ?? ""
        let isShowLogo = (args["is_show_logo"] as? Bool) ?? false
        let isValidatePostcode = (args["is_validate_postcode"] as? Bool) ?? false

        ICEkycCamera.cameraDelegate = self
        
        ICEkycCamera.accessToken = accessToken
        ICEkycCamera.tokenId = tokenId
        ICEkycCamera.tokenKey = tokenKey
        ICEkycCamera.documentType = convertToDocumentType(documentType)
        ICEkycCamera.flowType = ocr
        ICEkycCamera.isShowTutorial = isShowTutorial
        ICEkycCamera.isValidatePostcode = isValidatePostcode
        ICEkycCamera.isCheckLivenessCard = isCheckLivenessCard
        ICEkycCamera.validateDocumentType = convertToValidateDocumentType(validateDocumentType)
        ICEkycCamera.changeBaseUrl = changeBaseUrl
        ICEkycCamera.isEnableGotIt = isEnableGotIt
        ICEkycCamera.languageSdk = convertLanguageSdk(languageSdk)
        ICEkycCamera.isShowLogo = isShowLogo
        
        ICEkycCamera.challengeCode = "INNOVATIONCENTER"
        ICEkycCamera.cameraPositionForPortrait = PositionFront
        ICEkycCamera.isEnableScanQRCode = true
        
        DispatchQueue.main.async {
            ICEkycCamera.modalTransitionStyle = .coverVertical
            ICEkycCamera.modalPresentationStyle = .fullScreen
            controller.present(ICEkycCamera, animated: true)
        }
        
    }
    
    //MARK: - OCR FONT
    /// Luồng chỉ thực hiện đọc giấy tờ chỉ mặt trước: OCR Front
    /// 
    /// Thực hiện OCR giấy tờ một bước: chụp mặt trước giấy tờ
    /// 
    /// - Parameters:
    ///   - controller: Root view controller để present eKYC SDK
    ///   - info: Dictionary chứa các thông số cấu hình eKYC
    /// 
    /// - Required Parameters (info):
    ///   - access_token: Mã truy cập từ eKYC admin dashboard
    ///   - token_id: Token ID từ eKYC admin dashboard
    ///   - token_key: Token key từ eKYC admin dashboard
    /// 
    /// - Optional Parameters (info):
    ///   - flow_type: Loại luồng thực hiện ("ocrfront", "none", "scanqr", "ocrback", "ocr", "full", "face")
    ///   - document_type: Loại giấy tờ ("identitycard", "idcardchipbased", "passport", "driverlicense", "militaryidcard")
    ///   - is_show_tutorial: Hiển thị màn hình hướng dẫn ("true"/"false")
    ///   - is_check_liveness_card: Bật/tắt chức năng kiểm tra ảnh giấy tờ chụp trực tiếp ("true"/"false")
    ///   - validate_document_type: Chế độ kiểm tra ảnh giấy tờ ("none", "basic", "medium", "advance")
    ///   - change_base_url: Đường dẫn API tùy chỉnh
    ///   - is_enable_gotit: Bật/tắt nút "Bỏ qua hướng dẫn" ("true"/"false")
    ///   - language_sdk: Ngôn ngữ SDK ("icekyc_vi", "icekyc_en")
    ///   - is_show_logo: Bật/tắt hiển thị LOGO thương hiệu ("true"/"false")
    func startEkycOcrFront(_ controller: UIViewController, args: [String: Any]) {
        let ICEkycCamera = ICEkycCameraRouter.createModule() as! ICEkycCameraViewController

        let accessToken = (args["access_token"] as? String) ?? ""
        let tokenId = (args["token_id"] as? String) ?? ""
        let tokenKey = (args["token_key"] as? String) ?? ""
        let documentType = (args["document_type"] as? String) ?? ""
        let isShowTutorial = (args["is_show_tutorial"] as? Bool) ?? false
        let isCheckLivenessCard = (args["is_check_liveness_card"] as? Bool) ?? false
        let validateDocumentType = (args["validate_document_type"] as? String) ?? ""
        let changeBaseUrl = (args["change_base_url"] as? String) ?? ""
        let isEnableGotIt = (args["is_enable_gotit"] as? Bool) ?? false
        let languageSdk = (args["language_sdk"] as? String) ?? ""
        let isShowLogo = (args["is_show_logo"] as? Bool) ?? false
        let isValidatePostcode = (args["is_validate_postcode"] as? Bool) ?? false

        ICEkycCamera.cameraDelegate = self
        ICEkycCamera.flowType = ocrFront
        
        ICEkycCamera.accessToken = accessToken
        ICEkycCamera.tokenId = tokenId
        ICEkycCamera.tokenKey = tokenKey
        ICEkycCamera.documentType = convertToDocumentType(documentType)
        ICEkycCamera.isShowTutorial = isShowTutorial
        ICEkycCamera.isValidatePostcode = isValidatePostcode
        ICEkycCamera.isCheckLivenessCard = isCheckLivenessCard
        ICEkycCamera.validateDocumentType = convertToValidateDocumentType(validateDocumentType)
        ICEkycCamera.changeBaseUrl = changeBaseUrl
        ICEkycCamera.isEnableGotIt = isEnableGotIt
        ICEkycCamera.languageSdk = convertLanguageSdk(languageSdk)
        ICEkycCamera.isShowLogo = isShowLogo
        
        ICEkycCamera.challengeCode = "INNOVATIONCENTER"
        ICEkycCamera.cameraPositionForPortrait = PositionFront
        ICEkycCamera.isEnableScanQRCode = true
        
        DispatchQueue.main.async {
            ICEkycCamera.modalTransitionStyle = .coverVertical
            ICEkycCamera.modalPresentationStyle = .fullScreen
            controller.present(ICEkycCamera, animated: true)
        }
        
    }
    
    //MARK: - ORC BACK
    /// Luồng chỉ thực hiện đọc giấy tờ chỉ mặt sau: OCR Back
    /// 
    /// Thực hiện OCR giấy tờ một bước: chụp mặt sau giấy tờ
    /// 
    /// - Parameters:
    ///   - controller: Root view controller để present eKYC SDK
    ///   - info: Dictionary chứa các thông số cấu hình eKYC
    /// 
    /// - Required Parameters (info):
    ///   - access_token: Mã truy cập từ eKYC admin dashboard
    ///   - token_id: Token ID từ eKYC admin dashboard
    ///   - token_key: Token key từ eKYC admin dashboard
    /// 
    /// - Optional Parameters (info):
    ///   - flow_type: Loại luồng thực hiện ("ocrback", "none", "scanqr", "ocrfront", "ocr", "full", "face")
    ///   - document_type: Loại giấy tờ ("identitycard", "idcardchipbased", "passport", "driverlicense", "militaryidcard")
    ///   - is_show_tutorial: Hiển thị màn hình hướng dẫn ("true"/"false")
    ///   - hash_front_ocr: Hash của kết quả OCR mặt trước (bắt buộc cho ocrback)
    ///   - is_check_liveness_card: Bật/tắt chức năng kiểm tra ảnh giấy tờ chụp trực tiếp ("true"/"false")
    ///   - validate_document_type: Chế độ kiểm tra ảnh giấy tờ ("none", "basic", "medium", "advance")
    ///   - is_validate_postcode: Bật/tắt chức năng kiểm tra mã bưu điện ("true"/"false")
    ///   - change_base_url: Đường dẫn API tùy chỉnh
    ///   - is_enable_gotit: Bật/tắt nút "Bỏ qua hướng dẫn" ("true"/"false")
    ///   - language_sdk: Ngôn ngữ SDK ("icekyc_vi", "icekyc_en")
    ///   - is_show_logo: Bật/tắt hiển thị LOGO thương hiệu ("true"/"false")
    func startEkycOcrBack(_ controller: UIViewController, args: [String: Any]) {
        let ICEkycCamera = ICEkycCameraRouter.createModule() as! ICEkycCameraViewController
        
        let accessToken = (args["access_token"] as? String) ?? ""
        let tokenId = (args["token_id"] as? String) ?? ""
        let tokenKey = (args["token_key"] as? String) ?? ""
        let documentType = (args["document_type"] as? String) ?? ""
        let isShowTutorial = (args["is_show_tutorial"] as? Bool) ?? false
        let hashFrontOCR = (args["hash_front_ocr"] as? String) ?? ""
        let isCheckLivenessCard = (args["is_check_liveness_card"] as? Bool) ?? false
        let validateDocumentType = (args["validate_document_type"] as? String) ?? ""
        let changeBaseUrl = (args["change_base_url"] as? String) ?? ""
        let isEnableGotIt = (args["is_enable_gotit"] as? Bool) ?? false
        let languageSdk = (args["language_sdk"] as? String) ?? ""
        let isShowLogo = (args["is_show_logo"] as? Bool) ?? false
        let isValidatePostcode = (args["is_validate_postcode"] as? Bool) ?? false

        ICEkycCamera.cameraDelegate = self
        ICEkycCamera.flowType = ocrBack
        
        ICEkycCamera.accessToken = accessToken
        ICEkycCamera.tokenId = tokenId
        ICEkycCamera.tokenKey = tokenKey
        ICEkycCamera.documentType = convertToDocumentType(documentType)
        ICEkycCamera.isShowTutorial = isShowTutorial
        ICEkycCamera.hashFrontOCR = hashFrontOCR
        ICEkycCamera.isValidatePostcode = isValidatePostcode
        ICEkycCamera.isCheckLivenessCard = isCheckLivenessCard
        ICEkycCamera.validateDocumentType = convertToValidateDocumentType(validateDocumentType)
        ICEkycCamera.changeBaseUrl = changeBaseUrl
        ICEkycCamera.isEnableGotIt = isEnableGotIt
        ICEkycCamera.isShowLogo = isShowLogo

        ICEkycCamera.challengeCode = "INNOVATIONCENTER"
        ICEkycCamera.languageSdk = convertLanguageSdk(languageSdk)
        ICEkycCamera.cameraPositionForPortrait = PositionFront
        
        DispatchQueue.main.async {
            ICEkycCamera.modalTransitionStyle = .coverVertical
            ICEkycCamera.modalPresentationStyle = .fullScreen
            controller.present(ICEkycCamera, animated: true)
        }
        
    }
    
    //MARK: - FACE
    /// Luồng chỉ thực hiện xác thực khuôn mặt: Face Verification
    /// 
    /// Thực hiện chụp ảnh Oval xa gần và thực hiện các chức năng tùy vào cấu hình: Compare, Verify, Mask, Liveness Face
    /// 
    /// - Parameters:
    ///   - controller: Root view controller để present eKYC SDK
    ///   - info: Dictionary chứa các thông số cấu hình eKYC
    /// 
    /// - Required Parameters (info):
    ///   - access_token: Mã truy cập từ eKYC admin dashboard
    ///   - token_id: Token ID từ eKYC admin dashboard
    ///   - token_key: Token key từ eKYC admin dashboard
    /// 
    /// - Optional Parameters (info):
    ///   - flow_type: Loại luồng thực hiện ("face", "none", "scanqr", "ocrfront", "ocrback", "ocr", "full")
    ///   - version_sdk: Phiên bản SDK cho chụp ảnh chân dung ("normal", "prooval")
    ///   - is_show_tutorial: Hiển thị màn hình hướng dẫn ("true"/"false")
    ///   - is_enable_compare: Bật/tắt chức năng so sánh ảnh chân dung ("true"/"false")
    ///   - is_check_masked_face: Bật/tắt chức năng kiểm tra che mặt ("true"/"false")
    ///   - check_liveness_face: Chức năng kiểm tra ảnh chân dung chụp trực tiếp ("nonecheckface", "ibeta", "standard")
    ///   - change_base_url: Đường dẫn API tùy chỉnh
    ///   - is_enable_gotit: Bật/tắt nút "Bỏ qua hướng dẫn" ("true"/"false")
    ///   - language_sdk: Ngôn ngữ SDK ("icekyc_vi", "icekyc_en")
    ///   - is_show_logo: Bật/tắt hiển thị LOGO thương hiệu ("true"/"false")
    func startEkycFace(_ controller: UIViewController, args: [String: Any]) {
        let ICEkycCamera = ICEkycCameraRouter.createModule() as! ICEkycCameraViewController
        
        let accessToken = (args["access_token"] as? String) ?? ""
        let tokenId = (args["token_id"] as? String) ?? ""
        let tokenKey = (args["token_key"] as? String) ?? ""
        let versionSdk = (args["version_sdk"] as? String) ?? ""
        let hashImageCompare = (args["hash_image_compare"] as? String) ?? ""
        let isShowTutorial = (args["is_show_tutorial"] as? Bool) ?? false
        let isEnableCompare = (args["is_enable_compare"] as? Bool) ?? false
        let isCheckMaskedFace = (args["is_check_masked_face"] as? Bool) ?? false
        let checkLivenessFace = (args["check_liveness_face"] as? String) ?? ""
        let changeBaseUrl = (args["change_base_url"] as? String) ?? ""
        let isEnableGotIt = (args["is_enable_gotit"] as? Bool) ?? false
        let languageSdk = (args["language_sdk"] as? String) ?? ""
        let isShowLogo = (args["is_show_logo"] as? Bool) ?? false

        ICEkycCamera.cameraDelegate = self
        ICEkycCamera.flowType = face


        ICEkycCamera.accessToken = accessToken
        ICEkycCamera.tokenId = tokenId
        ICEkycCamera.tokenKey = tokenKey
        ICEkycCamera.versionSdk = convertToVersionSdk(versionSdk)
        ICEkycCamera.isShowTutorial = isShowTutorial
        ICEkycCamera.isEnableCompare = isEnableCompare
        ICEkycCamera.hashImageCompare = hashImageCompare
        ICEkycCamera.isCheckMaskedFace = isCheckMaskedFace
        ICEkycCamera.checkLivenessFace = convertToLivenessFaceMode(checkLivenessFace)
        ICEkycCamera.changeBaseUrl = changeBaseUrl
        ICEkycCamera.isEnableGotIt = isEnableGotIt
        ICEkycCamera.isShowLogo = isShowLogo

        ICEkycCamera.challengeCode = "INNOVATIONCENTER"
        ICEkycCamera.languageSdk = convertLanguageSdk(languageSdk)
        ICEkycCamera.cameraPositionForPortrait = PositionFront

        DispatchQueue.main.async {
            ICEkycCamera.modalTransitionStyle = .coverVertical
            ICEkycCamera.modalPresentationStyle = .fullScreen
            controller.present(ICEkycCamera, animated: true)
        }
    }

    //MARK: - SCANQR CODE
    /// Luồng chỉ thực hiện quét QR code: Scan QR Code
    /// 
    /// Thực hiện quét QR code để lấy thông tin từ QR code
    /// 
    /// - Parameters:
    ///   - controller: Root view controller để present eKYC SDK
    ///   - info: Dictionary chứa các thông số cấu hình eKYC
    /// 
    /// - Required Parameters (info):
    ///   - access_token: Mã truy cập từ eKYC admin dashboard
    ///   - token_id: Token ID từ eKYC admin dashboard
    ///   - token_key: Token key từ eKYC admin dashboard
    /// 
    /// - Optional Parameters (info):
    ///   - is_show_tutorial: Hiển thị màn hình hướng dẫn ("true"/"false")
    ///   - is_enable_gotit: Bật/tắt nút "Bỏ qua hướng dẫn" ("true"/"false")
    ///   - language_sdk: Ngôn ngữ SDK ("icekyc_vi", "icekyc_en")
    ///   - is_show_logo: Bật/tắt hiển thị LOGO thương hiệu ("true"/"false")
    func startEkycScanQRCode(_ controller: UIViewController, args: [String: Any]) {
        let ICEkycCamera = ICEkycCameraRouter.createModule() as! ICEkycCameraViewController
        
        let accessToken = (args["access_token"] as? String) ?? ""
        let tokenId = (args["token_id"] as? String) ?? ""
        let tokenKey = (args["token_key"] as? String) ?? ""
        let isShowTutorial = (args["is_show_tutorial"] as? Bool) ?? false
        let isEnableGotIt = (args["is_enable_gotit"] as? Bool) ?? false
        let languageSdk = (args["language_sdk"] as? String) ?? ""
        let isShowLogo = (args["is_show_logo"] as? Bool) ?? false

        ICEkycCamera.cameraDelegate = self
        ICEkycCamera.flowType = scanQR

        ICEkycCamera.accessToken = accessToken
        ICEkycCamera.tokenId = tokenId
        ICEkycCamera.tokenKey = tokenKey
        ICEkycCamera.isShowTutorial = isShowTutorial
        ICEkycCamera.isEnableGotIt = isEnableGotIt
        ICEkycCamera.isShowLogo = isShowLogo

        ICEkycCamera.challengeCode = "INNOVATIONCENTER"
        ICEkycCamera.languageSdk = convertLanguageSdk(languageSdk)
        ICEkycCamera.cameraPositionForPortrait = PositionFront

        DispatchQueue.main.async {
            ICEkycCamera.modalTransitionStyle = .coverVertical
            ICEkycCamera.modalPresentationStyle = .fullScreen
            controller.present(ICEkycCamera, animated: true)
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
        let qrCodeResult = ICEKYCSavedData.shared().qrCodeResult;
        let hashFrontResult = ICEKYCSavedData.shared().hashImageFront;
        
        let dict = [
            "INFO_RESULT": dataInfoResult,
            "HASH_IMAGE_FRONT_RESULT": hashFrontResult,
            "LIVENESS_CARD_FRONT_RESULT": dataLivenessCardFrontResult,
            "LIVENESS_CARD_REAR_RESULT": dataLivenessCardRearResult,
            "COMPARE_RESULT": dataCompareResult,
            "LIVENESS_FACE_RESULT": dataLivenessFaceResult,
            "MASKED_FACE_RESULT": dataMaskedFaceResult,
            "QR_CODE_RESULT": qrCodeResult
        ]
        
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


