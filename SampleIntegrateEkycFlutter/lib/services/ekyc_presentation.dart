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
        languageSdk: languageSdk,
        isShowLogo: isShowLogo,
        versionSdk: versionSdk,
      );

  /// Create configuration for OCR only flow
  static EkycConfig ocrOnly({
    required String accessToken,
    required String tokenId,
    required String tokenKey,
  }) =>
      EkycConfig(
        accessToken: accessToken,
        tokenId: tokenId,
        tokenKey: tokenKey,
        documentType: DocumentType.identityCard,
        isShowTutorial: true,
        isCheckLivenessCard: true,
        validateDocumentType: ValidateDocumentType.basic,
        isValidatePostcode: true,
        isEnableGotIt: true,
        languageSdk: LanguageSdk.icekyc_vi,
        isShowLogo: true,
      );

  /// Create configuration for OCR front side only flow
  static EkycConfig ocrFront({
    required String accessToken,
    required String tokenId,
    required String tokenKey,
  }) =>
      EkycConfig(
        accessToken: accessToken,
        tokenId: tokenId,
        tokenKey: tokenKey,
        documentType: DocumentType.identityCard,
        isShowTutorial: true,
        isCheckLivenessCard: true,
        validateDocumentType: ValidateDocumentType.basic,
        isValidatePostcode: true,
        isEnableGotIt: true,
        languageSdk: LanguageSdk.icekyc_vi,
        isShowLogo: true,
      );

  /// Create configuration for OCR back side only flow
  static EkycConfig ocrBack({
    required String accessToken,
    required String tokenId,
    required String tokenKey,
    required String hashFrontOcr,
  }) =>
      EkycConfig(
        accessToken: accessToken,
        tokenId: tokenId,
        tokenKey: tokenKey,
        documentType: DocumentType.identityCard,
        isShowTutorial: true,
        hashFrontOcr: hashFrontOcr,
        isCheckLivenessCard: true,
        validateDocumentType: ValidateDocumentType.basic,
        isValidatePostcode: true,
        isEnableGotIt: true,
        languageSdk: LanguageSdk.icekyc_vi,
        isShowLogo: true,
      );

  /// Create configuration for face verification only
  static EkycConfig faceVerification({
    required String accessToken,
    required String tokenId,
    required String tokenKey,
  }) =>
      EkycConfig(
        accessToken: accessToken,
        tokenId: tokenId,
        tokenKey: tokenKey,
        versionSdk: VersionSdk.proOval,
        isShowTutorial: true,
        isEnableCompare: true,
        isCheckMaskedFace: true,
        checkLivenessFace: LivenessFaceMode.ibeta,
        isEnableGotIt: true,
        languageSdk: LanguageSdk.icekyc_vi,
        isShowLogo: true,
      );

  /// Create configuration for scan QR code flow
  static EkycConfig scanQRCode({
    required String accessToken,
    required String tokenId,
    required String tokenKey,
  }) =>
      EkycConfig(
        accessToken: accessToken,
        tokenId: tokenId,
        tokenKey: tokenKey,
        isShowTutorial: true,
        isEnableGotIt: true,
        languageSdk: LanguageSdk.icekyc_vi,
        isShowLogo: true,
        versionSdk: VersionSdk.normal,
      );
}
