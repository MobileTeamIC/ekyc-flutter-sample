import 'ekyc_config.dart';
import 'enum_ekyc.dart';

/// Predefined configurations for common use cases
class EkycPresets {
  /// Create default configuration for full eKYC flow
  static EkycConfig fullEkyc({
    required String accessToken,
    required String tokenId,
    required String tokenKey,
    DocumentType documentType = DocumentType.identityCard,
    ValidateDocumentType validateDocumentType = ValidateDocumentType.basic,
    VersionSdk versionSdk = VersionSdk.normal,
    LivenessFaceMode checkLivenessFace = LivenessFaceMode.noneCheckFace,
    bool isShowTutorial = true,
    bool isEnableCompare = false,
    bool isCheckMaskedFace = true,
    bool isCheckLivenessCard = true,
    bool isValidatePostcode = true,
    bool isEnableGotIt = true,
    String changeBaseUrl = '',
    LanguageSdk languageSdk = LanguageSdk.icekyc_vi,
    bool isShowLogo = true,
  }) =>
      EkycConfig(
        accessToken: accessToken,
        tokenId: tokenId,
        tokenKey: tokenKey,
        documentType: documentType,
        isShowTutorial: isShowTutorial,
        isEnableCompare: isEnableCompare,
        isCheckMaskedFace: isCheckMaskedFace,
        checkLivenessFace: checkLivenessFace,
        isCheckLivenessCard: isCheckLivenessCard,
        isValidatePostcode: isValidatePostcode,
        validateDocumentType: validateDocumentType,
        isEnableGotIt: isEnableGotIt,
        changeBaseUrl: changeBaseUrl,
        languageSdk: languageSdk,
        isShowLogo: isShowLogo,
        versionSdk: versionSdk,
      );

  /// Create configuration for OCR only flow
  static EkycConfig ocrOnly({
    required String accessToken,
    required String tokenId,
    required String tokenKey,
    DocumentType documentType = DocumentType.identityCard,
    String changeBaseUrl = '',
    bool isShowTutorial = true,
    bool isCheckLivenessCard = true,
    ValidateDocumentType validateDocumentType = ValidateDocumentType.basic,
    bool isValidatePostcode = true,
    bool isEnableGotIt = true,
    LanguageSdk languageSdk = LanguageSdk.icekyc_vi,
    bool isShowLogo = true,
  }) =>
      EkycConfig(
        accessToken: accessToken,
        tokenId: tokenId,
        tokenKey: tokenKey,
        documentType: documentType,
        isShowTutorial: isShowTutorial,
        isCheckLivenessCard: isCheckLivenessCard,
        validateDocumentType: validateDocumentType,
        isValidatePostcode: isValidatePostcode,
        isEnableGotIt: isEnableGotIt,
        changeBaseUrl: changeBaseUrl,
        languageSdk: languageSdk,
        isShowLogo: isShowLogo,
      );

  /// Create configuration for OCR front side only flow
  static EkycConfig ocrFront({
    required String accessToken,
    required String tokenId,
    required String tokenKey,
    DocumentType documentType = DocumentType.identityCard,
    String changeBaseUrl = '',
    bool isShowTutorial = true,
    bool isCheckLivenessCard = true,
    ValidateDocumentType validateDocumentType = ValidateDocumentType.basic,
    bool isValidatePostcode = true,
    bool isEnableGotIt = true,
    LanguageSdk languageSdk = LanguageSdk.icekyc_vi,
    bool isShowLogo = true,
  }) =>
      EkycConfig(
        accessToken: accessToken,
        tokenId: tokenId,
        tokenKey: tokenKey,
        documentType: documentType,
        isShowTutorial: isShowTutorial,
        isCheckLivenessCard: isCheckLivenessCard,
        validateDocumentType: validateDocumentType,
        isValidatePostcode: isValidatePostcode,
        isEnableGotIt: isEnableGotIt,
        changeBaseUrl: changeBaseUrl,
        languageSdk: languageSdk,
        isShowLogo: isShowLogo,
      );

  /// Create configuration for OCR back side only flow
  static EkycConfig ocrBack({
    required String accessToken,
    required String tokenId,
    required String tokenKey,
    required String hashFrontOcr,
    DocumentType documentType = DocumentType.identityCard,
    String changeBaseUrl = '',
    bool isShowTutorial = true,
    bool isCheckLivenessCard = true,
    ValidateDocumentType validateDocumentType = ValidateDocumentType.basic,
    bool isValidatePostcode = true,
    bool isEnableGotIt = true,
    LanguageSdk languageSdk = LanguageSdk.icekyc_vi,
    bool isShowLogo = true,
  }) =>
      EkycConfig(
        accessToken: accessToken,
        tokenId: tokenId,
        tokenKey: tokenKey,
        documentType: documentType,
        isShowTutorial: isShowTutorial,
        hashFrontOcr: hashFrontOcr,
        isCheckLivenessCard: isCheckLivenessCard,
        validateDocumentType: validateDocumentType,
        isValidatePostcode: isValidatePostcode,
        isEnableGotIt: isEnableGotIt,
        changeBaseUrl: changeBaseUrl,
        languageSdk: languageSdk,
        isShowLogo: isShowLogo,
      );

  /// Create configuration for face verification only
  static EkycConfig faceVerification({
    required String accessToken,
    required String tokenId,
    required String tokenKey,
    DocumentType documentType = DocumentType.identityCard,
    String changeBaseUrl = '',
    bool isShowTutorial = true,
    bool isCheckLivenessCard = true,
    bool isCheckMaskedFace = true,
    LivenessFaceMode checkLivenessFace = LivenessFaceMode.noneCheckFace,
    ValidateDocumentType validateDocumentType = ValidateDocumentType.basic,
    bool isValidatePostcode = true,
    bool isEnableGotIt = true,
    LanguageSdk languageSdk = LanguageSdk.icekyc_vi,
    bool isShowLogo = true,
  }) =>
      EkycConfig(
        accessToken: accessToken,
        tokenId: tokenId,
        tokenKey: tokenKey,
        versionSdk: VersionSdk.proOval,
        isShowTutorial: isShowTutorial,
        isEnableCompare: true,
        isCheckMaskedFace: isCheckMaskedFace,
        checkLivenessFace: checkLivenessFace,
        isEnableGotIt: isEnableGotIt,
        changeBaseUrl: changeBaseUrl,
        languageSdk: languageSdk,
        isShowLogo: isShowLogo,
      );

  /// Create configuration for scan QR code flow
  static EkycConfig scanQRCode({
    required String accessToken,
    required String tokenId,
    required String tokenKey,
    bool isShowTutorial = true,
    bool isEnableGotIt = true,
    LanguageSdk languageSdk = LanguageSdk.icekyc_vi,
    bool isShowLogo = true,
  }) =>
      EkycConfig(
        accessToken: accessToken,
        tokenId: tokenId,
        tokenKey: tokenKey,
        isShowTutorial: isShowTutorial,
        isEnableGotIt: isEnableGotIt,
        languageSdk: languageSdk,
        isShowLogo: isShowLogo,
      );
}
