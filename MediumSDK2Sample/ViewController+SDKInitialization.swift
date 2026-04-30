//
//  ViewController+SDKInitialization.swift
//  MediumSDK2Sample
//
//  Created by Amol Deshmukh on 22/01/25.
//

import IDentityMediumSDK
import IDCaptureMedium
import SelfieCaptureMedium

//MARK: - SDK Initialization Method
extension ViewController {
    
    func SDKInitializationAPICall() {
        
        guard let apiBaseUrl = apiBaseURL_Textfield.text, apiBaseUrl != "" else {
            displayAlert(title: "", Message: "Please enter valid ApiBaseUrl.")
            return
        }
        guard let generatedToken = token_Textfield.text, apiBaseUrl != "" else {
            displayAlert(title: "", Message: "Please enter valid token.")
            return
        }
        
        self.activityIndicator.startAnimating()
        
        //1. Customize SDK properties
        SDKCustomization()
        
        //2. initialize SDK
        IDentitySDK.delegate = self
        IDentitySDK.apiBaseUrl = apiBaseUrl
        IDentitySDK.initializeSDK(accessToken: generatedToken) { error in
            if let error = error {
                self.activityIndicator.stopAnimating()
                print("!!! initialize SDK ERROR: \(error.localizedDescription)")
                self.displayAlert(title: "Error", Message: "SDK initialization credentials are not correct")
            } else {
                print("!!! initialize SDK SUCCESS")
//                self.performSegue(withIdentifier: "CompleteKYC_SegueID", sender: nil)
            }
        }
        
    }
    
    func displayAlert(title : String, Message:String){
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}

extension ViewController: InitializationDelegate {
    func updateInitialization(stage: IDentityMediumSDK.InitializationStage, state: IDentityMediumSDK.InitializationState) {
                
        //1. Debug-Purpose : Just to print information in logs
        let stage_state_Value = "\(stage.rawValue) \(state.rawValue)"
        switch stage {
        case .login:
            print("Login Status :", stage_state_Value)
            
        case .getXsltData:
            print("XSLT Download Status :", stage_state_Value)
            
        case .searchCompanyTemplateDetails:
            print("Template Download Status :", stage_state_Value)
            
        case .passiveFaceTrainingModelLabel:
            print("PassiveFaceModel Download Status :", stage_state_Value)
            
        case .focusFaceTrainingModelLabel:
            print("FaceFocusModel Download Status :", stage_state_Value)
            
        case .faceFullRangeSparseTrainingModelLabel:
            print("FaceFullRangeSparseModel Download Status :", stage_state_Value)
            
        case .faceLandmarksDetectorTrainingModelLabel:
            print("FaceLandmarksDetectorModel Download Status :", stage_state_Value)
            
        case .faceBlendshapesDetectorTrainingModelLabel:
            print("FaceBlendshapesModel Download Status :", stage_state_Value)
            
        case .faceMaskTrainingModelLabel:
            print("FaceMaskModel Download Status :", stage_state_Value)
            
        case .idCaptureTrainingModelLabel:
            print("IDCaptureModel Download Status :", stage_state_Value)
        
        case .docDetectionTrainingModelLabel:
            print("DocDetectModel Download Status :", stage_state_Value)
                
        case .focusTrainingModelLabel:
            print("IDFocusModel Download Status :", stage_state_Value)
            
        case .fingerprintDetectionTrainingModelLabel:
            print("FingerPrintModel Download Status :", stage_state_Value)
        
        @unknown default:
            print("Unknown Status :", stage_state_Value)
        }
        
        //2. check for completion of the stage states
        states[stage] = state
        if states[.login] == .downloaded &&
            ([.ok, .downloaded].contains(states[.getXsltData])) &&
            ([.ok, .downloaded].contains(states[.searchCompanyTemplateDetails])) &&
            ([.ok, .downloadedFromS3].contains(states[.passiveFaceTrainingModelLabel])) &&
            ([.ok, .downloadedFromS3].contains(states[.focusFaceTrainingModelLabel])) &&
            ([.ok, .downloadedFromS3].contains(states[.faceFullRangeSparseTrainingModelLabel])) &&
            ([.ok, .downloadedFromS3].contains(states[.faceLandmarksDetectorTrainingModelLabel])) &&
            ([.ok, .downloadedFromS3].contains(states[.faceBlendshapesDetectorTrainingModelLabel])) &&
            ([.ok, .downloadedFromS3].contains(states[.faceMaskTrainingModelLabel])) &&
            ([.ok, .downloadedFromS3].contains(states[.idCaptureTrainingModelLabel])) &&
            ([.ok, .downloadedFromS3].contains(states[.docDetectionTrainingModelLabel])) &&
            ([.ok, .downloadedFromS3].contains(states[.focusTrainingModelLabel])) &&
            ([.ok, .downloadedFromS3].contains(states[.fingerprintDetectionTrainingModelLabel])) {
                
                activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "CompleteKYC_SegueID", sender: nil)
                
            } else if states[.login] == .error || states[.getXsltData] == .error || states[.searchCompanyTemplateDetails] == .error  {
                
                print("!!! initialize SDK ERROR ")
                activityIndicator.stopAnimating()
                self.displayAlert(title: "Error", Message: "SDK initialization Error")
                
            }
    }
}

extension ViewController {
    
    func SDKCustomization() {
        
        //IDCapture Customization
        IDCapture.options.frontRealnessThreshold = 0.5
        IDCapture.options.backRealnessThreshold = 0.3
        IDCapture.options.frontDocumentConfidence = 0.7
        IDCapture.options.backDocumentConfidence = 0.7
        IDCapture.options.documentComponentConfidence = 0.5
        IDCapture.options.documentBackComponentConfidence = 0.7
        IDCapture.options.glareThreshold = 0.5
        IDCapture.options.fingerThreshold = 0.5
        IDCapture.options.lowerWidthThresholdTolerance = 0.3
        IDCapture.options.upperWidthThresholdTolerance = 0.05
        IDCapture.options.isDebugMode = false
        IDCapture.options.enableInstructionScreen = true
//        IDCapture.options.enableRealId = true
        IDCapture.options.focusThreshold = 0.2
        IDCapture.options.performIdCaptureBeforeSelfie = false
        IDCapture.options.cameraScreenBackButtonIsHidden = false
        IDCapture.options.separateIdCardCaptureSequence = true
        IDCapture.options.isIdCaptureProgressBarEnabled = true
        IDCapture.options.idCaptureProgressBarLineWidth = 10.0
        IDCapture.options.wrongDocumentTypeHandlingMode = .manualCapture
        IDCapture.options.allowOverrideWrongDocumentTypeAfterSec = 8
        IDCapture.options.wrongDocumentTypeWarningDelayInSec = 5

        //IDCapture Camera Screen UI Customization
//        IDCapture.strings.closeButtonText = "Cancel"
        IDCapture.strings.captureFront = "Capture Front Side"
        IDCapture.strings.captureBack = "Capture Back Side"
        IDCapture.strings.moveAway = "Move ID Away"
        IDCapture.strings.moveCloser = "Move ID Closer"
        IDCapture.strings.makeSurePhotoTextVisible = "Make Sure Photo & Text are Visible in ID"
        IDCapture.strings.makeSureBarcodeVisible = "Make sure Barcode is visible"
        IDCapture.strings.alignRectangle = "Align ID inside Rectangle"
        IDCapture.strings.flipToBack = "Flip To Back side"
        IDCapture.strings.backImageDetected = "ID Back image detected, please flip your ID."
        IDCapture.strings.frontImageDetected = "ID Front image detected, please flip your ID."
        IDCapture.strings.tooMuchGlare = "Too Much Glare"
        IDCapture.strings.useFront = "Scan the front of ID"
        IDCapture.strings.scanBarcode = "Scan the barcode"
        IDCapture.strings.frontBackMismatch = "ID front and back do not match. Please try again."
        IDCapture.strings.autofillPrompt = "Place the barcode or machine-readable zone of your ID in the rectangle."
        IDCapture.strings.notInFocus = "Not in focus"
        IDCapture.strings.documentDetectedHoldStill = "Document detected, hold still..."
        IDCapture.strings.glareDetected = "Move Away From Direct Light"
        IDCapture.strings.removeFinger = "Remove Finger"
        IDCapture.strings.captureAnywayButtonText = "Capture Anyway"
        IDCapture.strings.idCaptureWarningMessage = "We are having trouble identifying the correct side of your ID"
        IDCapture.strings.exitButtonText = "Exit"
        IDCapture.colors.backgroundColor = .clear
        IDCapture.colors.closeButtonColor = .clear
        IDCapture.colors.closeButtonTextColor = .black
        IDCapture.colors.closeButtonImageTintColor = .white
        IDCapture.colors.captureLabelColor = .clear
        IDCapture.colors.captureLabelTextColor = .white
        IDCapture.colors.successLabelBackgroundColor = .systemGreen
        IDCapture.colors.successLabelTextColor = .white
        IDCapture.colors.errorLabelBackgroundColor = .systemRed
        IDCapture.colors.errorLabelTextColor = .white
        IDCapture.colors.warningLabelBackgroundColor = .systemYellow
        IDCapture.colors.warningLabelTextColor = .black
        IDCapture.colors.captureAnywayButtonColor = .systemBlue
        IDCapture.colors.captureAnywayButtonTextColor = .white
        IDCapture.colors.exitButtonColor = .systemBlue
        IDCapture.colors.exitButtonTextColor = .white
        IDCapture.colors.idCaptureProgressBarColor = .systemGreen
        IDCapture.fonts.closeButtonTextFont = UIFont.systemFont(ofSize: 17)
        IDCapture.fonts.captureLabelFont = UIFont.boldSystemFont(ofSize: 20)
        IDCapture.fonts.labelFont = UIFont.systemFont(ofSize: 17)
        IDCapture.fonts.warningLabelFont = UIFont.systemFont(ofSize: 17)
        IDCapture.fonts.captureAnywayButtonTextFont = UIFont.systemFont(ofSize: 17)
        IDCapture.fonts.exitButtonTextFont = UIFont.systemFont(ofSize: 17)
        IDCapture.layout.captureLabelPosition = .center
        IDCapture.layout.labelPosition = .center
        IDCapture.images.closeButtonImage = UIImage(named: "Close")
        IDCapture.images.silhouetteImage = UIImage(named: "IdOverlay")
        IDCapture.images.frontSilhouetteImage = UIImage(named: "IdFrontOverlay")
        IDCapture.images.backSilhouetteImage = UIImage(named: "IdBackOverlay")
        IDCapture.images.bottomInfoImage = UIImage(named: "IdiInfo")
        IDCapture.style.captureAnywayButton = .style(borderWidth: 2, borderColor: .clear, cornerRadius: 10, clipsToBounds: true)
        IDCapture.style.exitButton = .style(borderWidth: 2, borderColor: .clear, cornerRadius: 10, clipsToBounds: true)

        //IDCapture Preview Screen UI Customization
        IDCapture.strings.previewScreenTitleIdFront = "ID Capture Successful"
        IDCapture.strings.previewScreenTitleIdBack = "ID Capture Successful"
        IDCapture.strings.previewScreenRetryBtnText = "Retry"
        IDCapture.strings.previewScreenDoneBtnText = "Done"
        IDCapture.colors.previewScreenBackgroundColor = .white
        IDCapture.colors.previewScreenTopViewColor = .white
        IDCapture.colors.previewScreenTitleLabelColor = .white
        IDCapture.colors.previewScreenTitleTextColor = .black
        IDCapture.colors.previewScreenRetryBtnTextColor = .white
        IDCapture.colors.previewScreenRetryBtnBackgroundColor = .black
        IDCapture.colors.previewScreenDoneBtnTextColor = .white
        IDCapture.colors.previewScreenDoneBtnBackgroundColor = .black
        IDCapture.fonts.previewScreenTitleLabelFont = UIFont.systemFont(ofSize: 17)
        IDCapture.fonts.previewScreenRetryBtnFont = UIFont.systemFont(ofSize: 20)
        IDCapture.fonts.previewScreenDoneBtnFont = UIFont.systemFont(ofSize: 20)
        IDCapture.style.previewScreenRetryButton = .style(borderWidth: 2, borderColor: .clear, cornerRadius: 10, clipsToBounds: true)
        IDCapture.style.previewScreenDoneButton = .style(borderWidth: 2, borderColor: .clear, cornerRadius: 10, clipsToBounds: true)

        //IDCapture Instruction Screen UI Customization
        IDCapture.options.instructionScreenBackButtonIsHidden = false
        IDCapture.strings.instructionScreenText = "Lorem ipsum text"
        IDCapture.strings.instructionScreenButtonText = "Continue"
        IDCapture.colors.instructionScreenBackgroundColor = .white
        IDCapture.colors.instructionScreenBackButtonColor = .clear
        IDCapture.colors.instructionScreenBackButtonImageTintColor = .orange
        IDCapture.colors.instructionScreenTextBackgroundColor = .systemGray
        IDCapture.colors.instructionScreenLabelTextColor = .black
        IDCapture.colors.instructionScreenImageTintColor = .white
        IDCapture.colors.instructionScreenButtonBackgroundColor = .black
        IDCapture.colors.instructionScreenButtonTextColor = .white
        IDCapture.fonts.instructionScreenLabelFont = UIFont.systemFont(ofSize: 17)
        IDCapture.fonts.instructionScreenButtonFont = UIFont.systemFont(ofSize: 20)
//        IDCapture.images.instructionScreenImage = UIImage(named: "IDCaptureImage")
//        IDCapture.images.instructionBackButtonImage = UIImage(named: "IDCaptureImage")
        IDCapture.style.instructionScreenContinueButton = .style(borderWidth: 2, borderColor: .clear, cornerRadius: 25, clipsToBounds: true)

        //IDCapture Retry Screen UI Customization
        IDCapture.strings.retryScreenText = "RealID not Detected. Please try again"
        IDCapture.strings.retryButtonText = "Retry"
        IDCapture.strings.cancelButtonText = "Cancel"
        IDCapture.colors.retryScreenBackgroundColor = .white
        IDCapture.colors.retryScreenLabelTextColor = .black
        IDCapture.colors.retryScreenImageTintColor = .green
        IDCapture.colors.retryScreenRetryButtonBackgroundColor = .black
        IDCapture.colors.retryScreenRetryButtonTextColor = .white
        IDCapture.colors.retryScreenCancelButtonBackgroundColor = .black
        IDCapture.colors.retryScreenCancelButtonTextColor = .white
        IDCapture.fonts.retryScreenLabelFont = UIFont.systemFont(ofSize: 17)
        IDCapture.fonts.retryScreenRetryButtonFont = UIFont.systemFont(ofSize: 20)
        IDCapture.fonts.retryScreenCancelButtonFont = UIFont.systemFont(ofSize: 20)
//        IDCapture.images.retryScreenImage = UIImage(named: "IdRetryImage")
        IDCapture.style.retryScreenRetryButton = .style(borderWidth: 2, borderColor: .clear, cornerRadius: 10, clipsToBounds: true)
        IDCapture.style.retryScreenCancelButton = .style(borderWidth: 2, borderColor: .clear, cornerRadius: 10, clipsToBounds: true)

        ////SelfieCapture Customization
        SelfieCapture.options.minFaceWidth = 0.6
        SelfieCapture.options.eyeOpenProbability = 0.4
        SelfieCapture.options.minHeadEulerAngle = -10
        SelfieCapture.options.maxHeadEulerAngle = 10
        SelfieCapture.options.minRelativeNoseHeight = 0.48
        SelfieCapture.options.maxRelativeNoseHeight = 0.67
        SelfieCapture.options.labelsConfidenceThreshold = 0.79
        SelfieCapture.options.faceMaskProbabilityThreshold = 0.98
        SelfieCapture.options.liveFaceProbabilityThreshold = 0.9
        SelfieCapture.options.consecutiveFakeFaceLimit = 10
        SelfieCapture.options.lightIntensityThreshold = 0.05
        SelfieCapture.options.focusThreshold = 0.2
        SelfieCapture.options.isDebugMode = false
        SelfieCapture.options.enableInstructionScreen = true
        SelfieCapture.options.capture4K = false
        SelfieCapture.options.uploadFaceData = true
        SelfieCapture.options.ovalScaleMultiplier = 0.7
        SelfieCapture.options.cameraPosition = .front
        SelfieCapture.options.showToggleCamera = false
        SelfieCapture.options.cameraScreenBackButtonIsHidden = false

        //SelfieCapture Camera Screen UI Customization
        SelfieCapture.strings.captureSelfie = "Capture Selfie"
        SelfieCapture.strings.multipleFacesDetected = "Multiple Faces Detected"
//        SelfieCapture.strings.closeButtonText = "Cancel"
        SelfieCapture.strings.alignOval = "Align your face inside oval"
        SelfieCapture.strings.notInFocus = "Face Not In Focus"
        SelfieCapture.strings.moveAway = "Move Face Away"
        SelfieCapture.strings.moveCloser = "Move Face Closer"
        SelfieCapture.strings.leftEyeClosed = "Left eye are closed"
        SelfieCapture.strings.rightEyeClosed = "right eye are closed"
        SelfieCapture.strings.faceMaskDetected = "Face mask detected"
        SelfieCapture.strings.sunglassesDetected = "Sunglasses Detected"
        SelfieCapture.strings.removeHat = "Hat Detected"
        SelfieCapture.strings.fakeFace = "Fake face Detected"
        SelfieCapture.strings.realFace = "Real face Detected"
        SelfieCapture.strings.straightenHead = "Make Sure your head is straight"
        SelfieCapture.strings.moveFaceDown = "Move face Down"
        SelfieCapture.strings.moveFaceUp = "Move face Up"
        SelfieCapture.strings.moveFaceDown = "Move face Down"
        SelfieCapture.strings.capturingFace = "Capturing Face"
        SelfieCapture.strings.tooMuchLight = "Too much light around face"
        SelfieCapture.colors.backgroundColor = .clear
        SelfieCapture.colors.overlayTopViewColor = .clear
        SelfieCapture.colors.closeButtonColor = .clear
        SelfieCapture.colors.closeButtonTextColor = .black
        SelfieCapture.colors.closeButtonImageTintColor = .white
        SelfieCapture.colors.captureLabelColor = .clear
        SelfieCapture.colors.captureLabelTextColor = .white
        SelfieCapture.colors.successLabelBackgroundColor = .systemGreen
        SelfieCapture.colors.errorLabelBackgroundColor = .systemRed
        SelfieCapture.colors.successLabelTextColor = .white
        SelfieCapture.colors.errorLabelTextColor = .white
        SelfieCapture.fonts.captureLabelFont = UIFont.boldSystemFont(ofSize: 20)
        SelfieCapture.fonts.labelFont = UIFont.systemFont(ofSize: 17)
        SelfieCapture.fonts.closeButtonTextFont = UIFont.systemFont(ofSize: 20)
        SelfieCapture.layout.captureLabelPosition = .top
        SelfieCapture.layout.labelPosition = .center
//        SelfieCapture.images.closeButtonImage = UIImage(named: "Close")
//        SelfieCapture.images.silhouetteImage = UIImage(named: "SelfieOverlay")
//        SelfieCapture.images.bottomInfoImage = UIImage(named: "Selfieinfo")

        //SelfieCapture Instruction Screen UI Customization
        SelfieCapture.options.instructionScreenBackButtonIsHidden = false
        SelfieCapture.strings.instructionScreenText = "Lorem ipsum text"
        SelfieCapture.strings.instructionScreenButtonText = "Continue"
        SelfieCapture.colors.instructionScreenBackgroundColor = .white
        SelfieCapture.colors.instructionScreenBackButtonColor = .clear
        SelfieCapture.colors.instructionScreenBackButtonImageTintColor = .orange
        SelfieCapture.colors.instructionScreenTextBackgroundColor = .systemGray
        SelfieCapture.colors.instructionScreenLabelTextColor = .black
        SelfieCapture.colors.instructionScreenImageTintColor = .white
        SelfieCapture.colors.instructionScreenButtonBackgroundColor = .black
        SelfieCapture.colors.instructionScreenButtonTextColor = .white
        SelfieCapture.fonts.instructionScreenLabelFont = UIFont.systemFont(ofSize: 17)
        SelfieCapture.fonts.instructionScreenButtonFont = UIFont.systemFont(ofSize: 20)
//        SelfieCapture.images.instructionScreenImage = UIImage(named: "SelfieCaptureImage")
//        SelfieCapture.images.instructionBackButtonImage = UIImage(named: "BackButtonImage")
        SelfieCapture.style.instructionScreenContinueButton = .style(borderWidth: 2, borderColor: .clear, cornerRadius: 25, clipsToBounds: true)

        //SelfieCapture Retry Screen UI Customization
        SelfieCapture.strings.retryScreenText = "Live face not Detected. Please try again"
        SelfieCapture.strings.retryButtonText = "Retry"
        SelfieCapture.strings.cancelButtonText = "Cancel"
        SelfieCapture.colors.retryScreenBackgroundColor = .white
        SelfieCapture.colors.retryScreenLabelTextColor = .black
        SelfieCapture.colors.retryScreenImageTintColor = .systemGreen
        SelfieCapture.colors.retryScreenRetryButtonBackgroundColor = .black
        SelfieCapture.colors.retryScreenRetryButtonTextColor = .white
        SelfieCapture.colors.retryScreenCancelButtonBackgroundColor = .black
        SelfieCapture.colors.retryScreenCancelButtonTextColor = .white
        SelfieCapture.fonts.retryScreenLabelFont = UIFont.systemFont(ofSize: 17)
        SelfieCapture.fonts.retryScreenRetryButtonFont = UIFont.systemFont(ofSize: 20)
        SelfieCapture.fonts.retryScreenCancelButtonFont = UIFont.systemFont(ofSize: 20)
//        SelfieCapture.images.retryScreenImage = UIImage(named: "SelfieRetryImage")
        SelfieCapture.style.retryScreenRetryButton = .style(borderWidth: 2, borderColor: .clear, cornerRadius: 10, clipsToBounds: true)
        SelfieCapture.style.retryScreenCancelButton = .style(borderWidth: 2, borderColor: .clear, cornerRadius: 10, clipsToBounds: true)
    }
}
