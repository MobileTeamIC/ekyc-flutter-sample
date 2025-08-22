import UIKit
import ICSdkEKYC

// MARK: - eKYC Enum Conversion Extension
extension AppDelegate {
    
    /// Convert string to VersionSdk enum
    func convertToVersionSdk(_ value: String?) -> VersionSdk {
        guard let value = value?.lowercased() else { return Normal }
        
        switch value {
        case "normal":
            return Normal
        case "prooval":
            return ProOval
        default:
            return Normal
        }
    }
    
    
    /// Convert string to TypeDocument enum
    func convertToDocumentType(_ value: String?) -> TypeDocument {
        guard let value = value?.lowercased() else { return IdentityCard }
        
        switch value {
        case "identitycard":
            return IdentityCard
        case "idcardchipbased":
            return IDCardChipBased
        case "passport":
            return Passport
        case "driverlicense":
            return DriverLicense
        case "militaryidcard":
            return MilitaryIdCard
        default:
            return IdentityCard
        }
    }
    
    /// Convert string to CameraPosition enum
    func convertToCameraPosition(_ value: String?) -> CameraPosition {
        guard let value = value?.lowercased() else { return PositionFront }
        
        switch value {
        case "positionfront":
            return PositionFront
        case "positionback":
            return PositionBack
        default:
            return PositionFront
        }
    }
    
    /// Convert string to ModeCheckLivenessFace enum
    func convertToLivenessFaceMode(_ value: String?) -> ModeCheckLivenessFace {
        guard let value = value?.lowercased() else { return NoneCheckFace }
        
        switch value {
        case "nonecheckface":
            return NoneCheckFace
        case "ibeta":
            return IBeta
        case "standard":
            return Standard
        default:
            return NoneCheckFace
        }
    }
    
    /// Convert string to TypeValidateDocument enum
    func convertToValidateDocumentType(_ value: String?) -> TypeValidateDocument {
        guard let value = value?.lowercased() else { return Basic }
        
        switch value {
        case "none":
            return None
        case "basic":
            return Basic
        case "medium":
            return Medium
        case "advance":
            return Advance
        default:
            return Basic
        }
    }
    
    /// Convert string to boolean
    func convertToBool(_ value: String?) -> Bool {
        guard let value = value?.lowercased() else { return false }
        
        switch value {
        case "true", "1", "yes", "on":
            return true
        case "false", "0", "no", "off":
            return false
        default:
            return false
        }
    }

    func convertLanguageSdk(_ value: String?) -> String {
        guard let value = value?.lowercased() else { return "icekyc_vi" }

        switch value {
        case "icekyc_vi":
            return "icekyc_vi"
        case "icekyc_en":
            return "icekyc_en"
        default:
            return "icekyc_vi"
        }
    }
} 
