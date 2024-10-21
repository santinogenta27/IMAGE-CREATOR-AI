import Combine
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestore
import CoreData
import FirebaseStorage
import SwiftUI
import Firebase
import AudioToolbox

@main
struct MainApp: App {
   @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
   
   @StateObject var subscriptionManager = SubscriptionManager()
   
   var body: some Scene {
       WindowGroup {
           ContentView()
               .environmentObject(subscriptionManager)
               .onAppear {
                   setupFirestore()
               }
       }
   }
   
   func setupFirestore() {
       let settings = FirestoreSettings()
       settings.isPersistenceEnabled = false  // Puedes intentar deshabilitar la persistencia para evitar problemas de bloqueo
       Firestore.firestore().settings = settings
   }
}

struct ContentView: View {
    @State private var showWhiteOverlay = true

    var body: some View {
        ZStack {
            SubscribedUserView()
                .environmentObject(SubscriptionManager())
                .edgesIgnoringSafeArea(.all) // Asegura que ocupe toda la pantalla

            if showWhiteOverlay {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        GeometryReader { geometry in
                            VStack(spacing: 10) {
                                Image("logox6")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250, height: 250) // Ajusta el tamaño según sea necesario
                            }
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2 - 40)
                        }
                    )
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showWhiteOverlay = false
                            }
                        }
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



import SwiftUI
import StoreKit

struct AI_GodView: View {
    @ObservedObject var subscriptionManager: SubscriptionManager = SubscriptionManager()
    @Binding var dismissView: Bool // Binding to control the full-screen cover
    @State private var isShowingCustomView = false
    
    func purchaseSubscription() {
        print("purchaseSubscription - iniciada")
        subscriptionManager.subscriptionBuy()
    }
    
    func checkSubscription() {
        print("checkSubscription - Estado de suscripción antes de la verificación: \(subscriptionManager.isSubscribed)")
        if subscriptionManager.isSubscribed {
            isShowingCustomView = true
        } else {
            isShowingCustomView = false
        }
        print("checkSubscription - isShowingCustomView está ahora: \(isShowingCustomView)")
    }
    
    let customPurple = LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack {
                    Color.white.edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                dismissView = false
                                print("Botón de cierre presionado, dismissView está ahora: \(dismissView)")
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.black)
                                    .padding()
                            }
                        }
                        .padding(.top, geometry.safeAreaInsets.top * 0.1)
                        
                        Spacer().frame(height: geometry.size.height * 0.05)
                        
                        Image(systemName: "sparkles")
                            .resizable()
                            .frame(width: geometry.size.width * 0.20, height: geometry.size.width * 0.20)
                            .foregroundStyle(customPurple)
                        
                        Text("Get Visual Creator AI")
                            .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.08))
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .padding(.top, geometry.size.height * 0.02)
                        
                        Text("Access our most powerful models\nand advanced features")
                            .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.045))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, geometry.size.height * 0.01)
                        
                        Spacer().frame(height: geometry.size.height * 0.05)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            FeatureItem(icon: "checkmark.circle.fill",
                                        title: "Access to our latest models",
                                        description: "",
                                        iconColor: customPurple,
                                        iconWidth: geometry.size.width * 0.04,
                                        iconHeight: geometry.size.height * 0.03)
                            
                            FeatureItem(icon: "checkmark.circle.fill",
                                        title: "Access to advanced features",
                                        description: "",
                                        iconColor: customPurple,
                                        iconWidth: geometry.size.width * 0.04,
                                        iconHeight: geometry.size.height * 0.03)
                            
                            FeatureItem(icon: "checkmark.circle.fill",
                                        title: "Unlimited generations",
                                        description: "Multiple generations simultaneously",
                                        iconColor: customPurple,
                                        iconWidth: geometry.size.width * 0.04,
                                        iconHeight: geometry.size.height * 0.03)
                            
                            FeatureItem(icon: "checkmark.circle.fill",
                                        title: "Video Generation model",
                                        description: "",
                                        iconColor: customPurple,
                                        iconWidth: geometry.size.width * 0.04,
                                        iconHeight: geometry.size.height * 0.03)
                            
                            FeatureItem(icon: "checkmark.circle.fill",
                                        title: "Fast Mode",
                                        description: "Faster response speeds on generations",
                                        iconColor: customPurple,
                                        iconWidth: geometry.size.width * 0.04,
                                        iconHeight: geometry.size.height * 0.03)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        .padding(.horizontal, geometry.size.width * 0.1)
                        .frame(maxWidth: geometry.size.width * 1.1, alignment: .center)
                        
                        Spacer()
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black)
                                .frame(height: 60)
                                .padding(.horizontal, geometry.size.width * 0.1)
                            Text("Upgrade to Plus")
                                .foregroundColor(Color.white)
                                .font(.system(size: 18, weight: .bold))
                        }
                        .onTapGesture {
                            purchaseSubscription()
                            print("Botón de actualización presionado")
                        }
                        
                        HStack(spacing: 0) {
                            Text("Auto-renews for ")
                                .font(.system(size: 12.8))
                                .foregroundColor(Color.gray)
                            
                            Text("US$ 9,99")
                                .font(.system(size: 12.8))
                                .bold()
                                .foregroundColor(Color.black) // Aplica el color negro al precio
                              //  .fontWeight(.heavy) +
                            Text("/month")
                                .font(.system(size: 12.8))
                                .foregroundColor(Color.gray) // Mantiene el color gris para "/month"
                            
                            Text(" until canceled")
                                .font(.system(size: 12.8))
                                .foregroundColor(Color.gray)
                        }

                    }
                }
            }
            .onAppear {
                checkSubscription()
                print("Vista AI_GodView aparecida, verificando suscripción")
            }
            .fullScreenCover(isPresented: $isShowingCustomView) {
                ContentView()
            }
            .onReceive(subscriptionManager.$isSubscribed) { isSubscribed in
                if isSubscribed {
                    dismissView = false
                    print("Estado de suscripción cambiado, dismissView está ahora: \(dismissView)")
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    struct FeatureItem: View {
        var icon: String
        var title: String
        var description: String
        var iconColor: LinearGradient
        var iconWidth: CGFloat
        var iconHeight: CGFloat
        let titleFontSize: CGFloat = 16 // Tamaño de fuente fijo para los títulos
        let descriptionFontSize: CGFloat = 15.1 // Tamaño de fuente fijo para las descripciones

        var body: some View {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconWidth, height: iconHeight)
                    .foregroundStyle(iconColor)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: titleFontSize, weight: .bold)) // Usando tamaño de fuente fijo para los títulos
                        .foregroundColor(.black)
                    if !description.isEmpty {
                        Text(description)
                            .font(.system(size: descriptionFontSize)) // Usando tamaño de fuente fijo para las descripciones
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }
}

class SubscriptionManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    var productLoadedCompletion: ((SKProduct?) -> Void)?
    let productID = "God"
    @Published var isSubscribed = false
    @Published var isRestorationSuccessful = false // Nueva propiedad para rastrear el éxito de la restauración
    private let keychain = KeychainSwift()
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        loadSubscriptionStatus()
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    func subscriptionBuy() {
        print("subscriptionBuy - iniciada")
        loadProduct(withProductIdentifier: productID) { product in
            if let product = product, SKPaymentQueue.canMakePayments() {
                let payment = SKPayment(product: product)
                SKPaymentQueue.default().add(payment)
                print("subscriptionBuy - Producto añadido a la cola de pagos")
            } else {
                print("subscriptionBuy - Error al cargar el producto")
            }
        }
    }
    
    func restorePurchases() {
        print("restorePurchases - iniciada")
        isRestorationSuccessful = false // Reiniciar el estado de éxito de restauración
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func loadProduct(withProductIdentifier productIdentifier: String, completion: @escaping (SKProduct?) -> Void) {
        print("loadProduct - iniciada con ID de producto: \(productIdentifier)")
        productLoadedCompletion = completion
        let productIdentifiers: Set<String> = [productIdentifier]
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
        print("loadProduct - Solicitud de productos iniciada")
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            print("productsRequest - Producto recibido: \(product.localizedTitle)")
            productLoadedCompletion?(product)
        } else {
            print("productsRequest - No se encontraron productos")
            productLoadedCompletion?(nil)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("paymentQueue - Transacciones actualizadas: \(transactions.count)")
        NotificationCenter.default.post(name: Notification.Name("DismissAiGodView"), object: transactions)
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                print("paymentQueue - Transacción completada o restaurada: \(transaction)")
                updateSubscriptionStatus(isSubscribed: true)
                SKPaymentQueue.default().finishTransaction(transaction)
                if transaction.transactionState == .restored {
                    isRestorationSuccessful = true // Indicar éxito en la restauración
                    print("paymentQueue - Restauración exitosa")
                }
            case .failed:
                print("paymentQueue - Transacción fallida: \(transaction)")
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("paymentQueueRestoreCompletedTransactionsFinished - Restauración de compras completada")
    }
    
    func updateSubscriptionStatus(isSubscribed: Bool) {
        print("updateSubscriptionStatus - Estado de suscripción actualizado a: \(isSubscribed)")
        self.isSubscribed = isSubscribed
        keychain.set(isSubscribed, forKey: "isSubscribed")
        // Actualizar el estado de suscripción en Firebase
    }
    
    private func loadSubscriptionStatus() {
        isSubscribed = keychain.getBool("isSubscribed") ?? false
        print("loadSubscriptionStatus - Estado de suscripción cargado: \(isSubscribed)")
    }
}



struct CenteredModifier: ViewModifier {



func body(content: Content) -> some View {



  HStack {



      Spacer()



      content



      Spacer()



  }



}



}



extension View {



func centered() -> some View {



  self.modifier(CenteredModifier())



}



}







// Extensión global para customBlueColor

extension Color {

static let customBlueColor = Color(UIColor(red: 0.20, green: 0.28, blue: 0.96, alpha: 1.0))

}














import KeychainSwift

import  SwiftImage



class AttemptManager {

static let shared = AttemptManager()

private let keychain = KeychainSwift()

private let attemptsKey = "remainingAttempts"

private let maxAttempts = 3



var remainingAttempts: Int {

    get {

        Int(keychain.get(attemptsKey) ?? "3") ?? maxAttempts

    }

    set {

        keychain.set(String(newValue), forKey: attemptsKey)

    }

}



func useAttempt() {

    if remainingAttempts > 0 {

        remainingAttempts -= 1

    }

}



var hasAttemptsLeft: Bool {

    remainingAttempts > 0

}

}
//extension Color {
  //  static let customBlueColor1 = Color(red: 0, green: 122 / 255, blue: 1)
//}


extension Color {
    static let customBlueColor1 = Color(red: 48 / 255, green: 58 / 255, blue: 178 / 255)
}
import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    @Environment(\.presentationMode) private var presentationMode

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker
        let apiKey: String = "AIzaSyBAmp9Zum69ve0ciU6cOnvRt-JE6rBe3zg" // Reemplaza con tu API Key

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            print("Picker finished picking \(results.count) results")
            
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                        if let error = error {
                            print("Error loading image: \(error.localizedDescription)")
                        } else if let image = image as? UIImage {
                            print("Image loaded successfully")
                            self?.analyzeImageWithGoogleVision(image)
                        }
                    }
                } else {
                    print("Cannot load object of class UIImage")
                }
            }
            // Manually close the picker
            self.parent.presentationMode.wrappedValue.dismiss()
        }

        private func analyzeImageWithGoogleVision(_ image: UIImage) {
            guard let base64Image = image.jpegData(compressionQuality: 0.8)?.base64EncodedString() else {
                print("Error converting image to base64")
                return
            }

            let url = URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let requestBody: [String: Any] = [
                "requests": [
                    [
                        "image": ["content": base64Image],
                        "features": [["type": "SAFE_SEARCH_DETECTION"]]
                    ]
                ]
            ]

            do {
                let requestData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
                request.httpBody = requestData
                print("Request body prepared")
            } catch {
                print("Error serializing request body: \(error.localizedDescription)")
                return
            }

            print("Sending request to Google Cloud Vision API...")
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                if let error = error {
                    print("Error in response: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("No data received from Google Cloud Vision API")
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let responses = json["responses"] as? [[String: Any]],
                       let safeSearch = responses.first?["safeSearchAnnotation"] as? [String: String] {
                        
                        print("SafeSearch results: \(safeSearch)")

                        let isSafe = self?.isImageSafe(safeSearch) ?? false
                        
                        if isSafe {
                            DispatchQueue.main.async {
                                print("Adding image to selectedImages")
                                self?.parent.selectedImages.append(image)
                            }
                        } else {
                            print("Image contains inappropriate content and was not added.")
                            DispatchQueue.main.async {
                                self?.showImageRejectedAlert()
                            }
                        }
                    } else {
                        print("No safe search annotation found in the response")
                    }
                } catch {
                    print("Error parsing JSON response: \(error.localizedDescription)")
                }
            }

            task.resume()
        }

        private func isImageSafe(_ safeSearch: [String: String]) -> Bool {
            // Más estricto: Rechaza imágenes si cualquier categoría relevante es "LIKELY" o superior
            let inappropriateCategories = ["VERY_LIKELY", "LIKELY"]
            
            if inappropriateCategories.contains(safeSearch["adult"] ?? "") ||
               inappropriateCategories.contains(safeSearch["violence"] ?? "") ||
               inappropriateCategories.contains(safeSearch["racy"] ?? "") ||
               inappropriateCategories.contains(safeSearch["medical"] ?? "") {
                print("Image flagged as unsafe: \(safeSearch)")
                return false
            }
            
            print("Image passed safety checks")
            return true
        }

        private func showImageRejectedAlert() {
            let alertController = UIAlertController(title: "Image Not Accepted", message: "This image cannot be added due to content restrictions.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))

            // Find the top-most view controller to present the alert
            if let topController = UIApplication.shared.windows.first?.rootViewController {
                topController.present(alertController, animated: true, completion: nil)
            }
        }
    }

    var selectionLimit: Int = 5

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = selectionLimit

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}







struct SubscribedUserView: View {
    
    
    
    @State private var isVariationRequest: Bool = false
    @State private var selectedButtonIndex: Int? = nil
    
    
    
    
    @State private var selectedPrompt: String = ""
    
    
    
    
    
    
    
    
    @State private var prompt: String = ""
    
    
    
    @State private var isLoading: Bool = false
    
    
    
    @State private var progressValue: Float = 0.0
    
    
    
    @State private var compositeImage: UIImage?
    
    
    
    @State private var gridImages: [UIImage] = []
    
    
    
    @State private var jobID: String?
    
    
    
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingDetailView = false
    
    
    
    
    
    
    @State private var isSessionListOpen = false
    
    
    
    @State private var shouldShowSubscriptionView = false
    
    
    
    //@StateObject private var sessionManager = SessionManager.shared
    
    
    
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    
    
    
    
    
    
    
    @State private var showingPikaVideoView = false
    
    
    
    @State private var isShowingLoadingBar = false
    
    
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    
    
    @State private var isLoggedIn = false
    
    
    
    @State private var imageGenerationStarted: Bool = false
    
    
    
    
    
    
    
    
    
    @State private var allPrompts: [String] = []
    
    
    
    @State private var showLimitReachedAlert = false
    
    
    @State private var selectedVButtonIndices: Set<Int> = []
    
    
    
    
    
    @State private var scrollViewKey = UUID()
    
    
    
    
    
    
    
    // Asegúrate de cambiar esto a false cuando la imagen esté cargada
    
    
    
    let iconSize: CGFloat = 35  // Tamaño del icono
    
    
    
    let lineWidth: CGFloat = 2   // Grosor de la línea del círculo
    
    
    
    let circlePadding: CGFloat = 5
    
    
    
    @State private var isAnimating: Bool = false
    
    
    
    @State var vButtonImages: [[UIImage]] = []
    
    @State private var showLoadingIndicator = true
    
    
    
    
    
    
    
    let prohibitedWords: Set<String> = ["sex", "Kill","blood", "bloodbath", "crucifixion", "bloody", "flesh", "bruises", "car crashes", "corpse", "crucified", "cutting", "decapitate", "infested", "gruesome", "kill", "infected", "sadist",
                                        
                                        
                                        
                                        "slaughter", "teratoma", "tryphophobia", "wound", "cronenberg", "khorne", "cannibal",
                                        
                                        
                                        
                                        "cannibalism", "visceral", "guts", "bloodshot", "gory", "killing", "surgery", "vivisection",
                                        
                                        
                                        
                                        "massacre", "hemoglobin", "suicide", "ahegao", "pinup", "ballgag", "playboy", "bimbo",
                                        
                                        
                                        
                                        "delight", "fluids in the body", "enjoyments", "boudoir", "rule34", "brothel", "concocting",
                                        
                                        
                                        
                                        "dominatrix", "seductive", "sexual seduction erotica", "a fuck", "sensual", "hardcore",
                                        
                                        
                                        
                                        "sexy", "hentai", "shag", "hot and sexy", "shibari", "incest", "smut", "jav", "succubus",
                                        
                                        
                                        
                                        "jerk off", "hot", "kinbaku", "transparent", "legs spread", "twerk", "in love", "voluptuous",
                                        
                                        
                                        
                                        "naughty", "wincest", "orgy", "sultry", "xxx", "bondage", "bdsm", "dog collar", "slavegirl",
                                        
                                        
                                        
                                        "transparent and translucent", "arse", "labia", "pussy", "ass", "gluteus maximus", "mammaries",
                                        
                                        
                                        
                                        "human centipede", "badonkers", "minge", "massive chests", "big ass", "mommy milker", "booba",
                                        
                                        
                                        
                                        "nipple", "booty", "oppai", "bosom", "organs", "breasts", "ovaries", "busty", "penis",
                                        
                                        
                                        
                                        "clunge", "phallus", "crotch", "sexy female", "dick", "skimpy", "girth", "thick", "honkers",
                                        
                                        
                                        
                                        "vagina", "hooters", "veiny", "knob", "no attire", "speedo", "au naturale", "no shirt",
                                        
                                        
                                        
                                        "bare chest", "naked", "just barely dressed", "bra", "risk", "transparent", "barely",
                                        
                                        
                                        
                                        "clad", "cleavage", "stripped", "fully frontal unclothed", "invisibility of clothing",
                                        
                                        
                                        
                                        "not wearing anything", "lingerie with no shirt", "unbehaved", "without clothes", "negligee",
                                        
                                        
                                        
                                        "zero clothes", "taboo", "fascist", "nazi", "prophet mohammed", "slave", "coon", "honkey",
                                        
                                        
                                        
                                        "arrested", "jail", "handcuffs", "drugs", "cocaine", "heroin", "meth", "crack", "torture",
                                        
                                        
                                        
                                        "disturbing", "farts", "fart", "poop", "warts", "xi jinping", "shit", "pleasure", "errect",
                                        
                                        
                                        
                                        "big black", "brown pudding", "bunghole", "vomit", "voluptuous", "seductive", "sperm", "hot",
                                        
                                        
                                        
                                        "sexy", "sensored", "censored", "silenced", "deepfake", "inappropriate", "pus", "waifu",
                                        
                                        
                                        
                                        "mp5", "succubus", "1488", "surgery",
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        // Palabras adicionales PG-13
                                        
                                        
                                        
                                        "murder", "rape", "kidnapping", "abduction", "terrorism", "molestation", "nudity",
                                        
                                        
                                        
                                        "sexual assault", "pornography", "genocide", "hate speech", "racial slur", "explicit",
                                        
                                        
                                        
                                        "vulgar", "obscene", "drug abuse", "drug use", "excessive violence", "graphic violence",
                                        
                                        
                                        
                                        "intense violence", "harassment", "bullying", "extreme gore", "sadism", "masochism",
                                        
                                        
                                        
                                        "profanity", "foul language",         "strong language", "hateful language", "homophobia", "transphobia",
                                        
                                        
                                        
                                        "sexual content", "explicit content", "adult content", "mature content",
                                        
                                        
                                        
                                        "inflammatory", "extremist", "radical", "graphic sexual content",
                                        
                                        
                                        
                                        "blasphemy", "sacrilege", "profanation", "obscenity", "lewdness",
                                        
                                        
                                        
                                        "perversion", "depravity", "exploitation", "slander", "libel",
                                        
                                        
                                        
                                        "defamation", "cyberbullying", "trolling", "doxxing", "stalking",
                                        
                                        
                                        
                                        "intimidation", "threats", "violent extremism", "terrorism incitement",
                                        
                                        
                                        
                                        "radicalization", "hate crime", "discrimination", "xenophobia",
                                        
                                        
                                        
                                        "racial hatred", "ethnic hatred", "religious hatred", "gender hatred",
                                        
                                        
                                        
                                        "misogyny", "misandry", "ageism", "ableism", "body shaming",
                                        
                                        
                                        
                                        "slut shaming", "victim blaming", "gaslighting", "manipulation",
                                        
                                        
                                        
                                        "coercion", "abuse", "domestic violence", "child abuse", "elder abuse",
                                        
                                        
                                        
                                        "animal cruelty", "animal abuse", "self-harm", "self-mutilation",
                                        
                                        
                                        
                                        "eating disorders", "anorexia", "bulimia", "substance abuse",
                                        
                                        
                                        
                                        "alcoholism", "addiction", "overdose", "withdrawal", "rehabilitation",
                                        
                                        
                                        
                                        "recovery", "relapse", "mental illness", "depression", "anxiety",
                                        
                                        
                                        
                                        "bipolar disorder", "schizophrenia", "psychosis", "suicidal thoughts",
                                        
                                        
                                        
                                        "suicide attempt", "suicide prevention", "grief", "mourning",
                                        
                                        
                                        
                                        "bereavement", "loss", "trauma", "post-traumatic stress disorder",
                                        
                                        
                                        
                                        "complex trauma", "dissociation", "identity crisis", "existential crisis",
                                        
                                        
                                        
                                        "moral dilemma", "ethical dilemma", "controversy", "scandal",
                                        
                                        
                                        
                                        "corruption", "bribery", "embezzlement", "fraud", "deception",
                                        
                                        
                                        
                                        "conspiracy", "espionage", "sabotage", "treason", "sedition",
                                        
                                        
                                        
                                        "insurrection", "rebellion", "revolution", "coup d'état", "civil war",
                                        
                                        
                                        
                                        "genocide", "ethnic cleansing", "war crimes", "crimes against humanity",
                                        
                                        
                                        
                                        "human trafficking", "slavery", "forced labor", "sexual slavery",
                                        
                                        
                                        
                                        "child soldiers", "illegal arms trade", "drug trafficking", "smuggling",
                                        
                                        
                                        
                                        "black market", "organized crime", "gang violence", "mafia",
                                        
                                        
                                        
                                        "cartel", "syndicate", "extortion", "racketeering", "money laundering",
                                        
                                        
                                        
                                        "tax evasion", "cybercrime", "hacking", "phishing", "identity theft",
                                        
                                        
                                        
                                        "credit card fraud", "intellectual property theft", "piracy",
                                        
                                        
                                        
                                        "counterfeiting", "forgery", "tampering", "vandalism", "arson",
                                        
                                        
                                        
                                        "terrorism", "extremism", "radicalization", "hate speech",
                                        
                                        
                                        
                                        "propaganda", "disinformation", "fake news", "hoax", "conspiracy theory",
                                        
                                        
                                        
                                        "pseudoscience", "quackery", "charlatanism", "fraudulent claims",
                                        
                                        
                                        
                                        "snake oil", "miracle cure", "placebo effect", "nocebo effect",
                                        
                                        
                                        
                                        "psychosomatic illness", "hypochondria", "malingering", "factitious disorder",
                                        
                                        
                                        
                                        "Munchausen syndrome", "Munchausen by proxy", "self-diagnosis",
                                        
                                        
                                        
                                        "self-medication", "unproven treatment", "dangerous remedy",
                                        
                                        
                                        
                                        "toxic substance", "hazardous material", "environmental pollution",
                                        
                                        
                                        
                                        "climate change", "global warming", "ozone depletion", "deforestation",
                                        
                                        
                                        
                                        "habitat destruction", "species extinction", "biodiversity loss",
                                        
                                        
                                        
                                        "ecosystem collapse", "natural disaster", "earthquake", "volcano",
                                        
                                        
                                        
                                        "tsunami", "hurricane", "typhoon", "cyclone", "tornado",
                                        
                                        
                                        
                                        "flood", "drought", "wildfire", "avalanche", "landslide",
                                        
                                        
                                        
                                        "sinkhole", "radiation leak", "nuclear accident", "chemical spill",
                                        
                                        
                                        
                                        "oil spill", "industrial accident", "workplace hazard", "occupational disease",
                                        
                                        
                                        
                                        "repetitive strain injury", "carpal tunnel syndrome", "tendinitis",
                                        
                                        
                                        
                                        "bursitis", "back pain", "neck pain", "shoulder pain", "knee pain",
                                        
                                        
                                        
                                        "hip pain", "arthritis", "osteoporosis", "fracture", "sprain",
                                        
                                        
                                        
                                        "strain", "bruise", "contusion", "abrasion", "laceration",
                                        
                                        
                                        
                                        "puncture wound", "burn", "scald", "frostbite", "hypothermia",
                                        
                                        
                                        
                                        "heatstroke", "sunburn", "dehydration", "malnutrition",
                                        
                                        
                                        
                                        "starvation", "food poisoning", "allergic reaction", "anaphylaxis",
                                        
                                        
                                        
                                        "infection", "inflammation", "swelling", "redness", "pain",
                                        
                                        
                                        
                                        "fever", "chills", "nausea", "vomiting", "diarrhea", "constipation",
                                        
                                        
                                        
                                        "indigestion", "heartburn", "acid reflux", "ulcer", "gastroenteritis",
                                        
                                        
                                        
                                        "colitis", "irritable bowel syndrome", "Crohn's disease", "celiac disease",
                                        
                                        
                                        
                                        "food intolerance", "lactose intolerance", "gluten sensitivity",
                                        
                                        
                                        
                                        "peanut allergy", "shellfish allergy", "egg allergy", "dairy allergy",
                                        
                                        
                                        
                                        "soy allergy", "wheat allergy", "tree nut allergy", "fish allergy",
                                        
                                        
                                        
                                        "pollen allergy", "dust mite allergy", "mold allergy", "pet allergy",
                                        
                                        
                                        
                                        "latex allergy", "insect sting allergy", "drug allergy", "penicillin allergy",
                                        
                                        
                                        
                                        "aspirin allergy", "ibuprofen allergy", "acetaminophen allergy",
                                        
                                        
                                        
                                        "opioid allergy", "antibiotic allergy", "anesthetic allergy", "vaccine allergy",
                                        
                                        
                                        
                                        "contrast dye allergy", "cosmetic allergy", "fragrance allergy",
                                        
                                        
                                        
                                        "dye allergy", "preservative allergy", "additive allergy", "chemical sensitivity",
                                        
                                        
                                        
                                        "environmental illness", "multiple chemical sensitivity", "electromagnetic hypersensitivity",
                                        
                                        
                                        
                                        "radiation sickness", "sun sensitivity", "photosensitivity", "light sensitivity",
                                        
                                        
                                        
                                        "noise sensitivity", "sound sensitivity", "motion sickness", "altitude sickness",
                                        
                                        
                                        
                                        "sea sickness", "travel sickness", "jet lag", "circadian rhythm disorder",
                                        
                                        
                                        
                                        "sleep disorder", "insomnia", "sleep apnea", "narcolepsy", "restless leg syndrome",
                                        
                                        
                                        
                                        "periodic limb movement disorder", "nightmare", "night terror", "sleepwalking",
                                        
                                        
                                        
                                        "sleep talking", "bruxism", "snoring", "sleep paralysis", "hypersomnia",
                                        
                                        
                                        
                                        "excessive daytime sleepiness", "fatigue", "tiredness", "lethargy",
                                        
                                        
                                        
                                        "burnout", "stress", "anxiety", "panic attack", "phobia", "fear",
                                        
                                        
                                        
                                        "obsessive-compulsive disorder", "post-traumatic stress disorder",
                                        
                                        
                                        
                                        "acute stress disorder", "adjustment disorder", "reactive attachment disorder",
                                        
                                        
                                        
                                        "disinhibited social engagement disorder", "oppositional defiant disorder",
                                        
                                        
                                        
                                        "conduct disorder", "intermittent explosive disorder", "pyromania",
                                        
                                        
                                        
                                        "kleptomania", "pathological gambling", "trichotillomania", "skin picking disorder",
                                        
                                        
                                        
                                        "body dysmorphic disorder", "hoarding disorder", "tourette syndrome",
                                        
                                        
                                        
                                        "persistent motor or vocal tic disorder", "stereotypic movement disorder",
                                        
                                        
                                        
                                        "non-suicidal self-injury", "suicidal behavior", "suicidal ideation",
                                        
                                        
                                        
                                        "suicide attempt", "suicide pact", "suicide contagion", "copycat suicide",
                                        
                                        
                                        
                                        "suicide cluster", "suicide crisis", "suicide hotline", "suicide prevention",
                                        
                                        
                                        
                                        "suicide intervention", "suicide postvention", "bereavement support",
                                        
                                        
                                        
                                        "grief counseling", "loss support group", "trauma therapy", "trauma-focused therapy",
                                        
                                        
                                        
                                        "trauma-informed care", "crisis intervention", "emergency response",
                                        
                                        
                                        
                                        "first aid", "cardiopulmonary resuscitation", "automated external defibrillator",
                                        
                                        
                                        
                                        "basic life support", "advanced cardiac life support", "pediatric advanced life support",
                                        
                                        
                                        
                                        "neonatal resuscitation program", "wilderness first aid", "search and rescue",
                                        
                                        
                                        
                                        "disaster response", "emergency management", "emergency preparedness",
                                        
                                        
                                        
                                        "emergency shelter", "evacuation plan", "fire safety", "earthquake preparedness",
                                        
                                        
                                        
                                        "flood preparedness", "hurricane preparedness", "tornado preparedness",
                                        
                                        
                                        
                                        "volcano preparedness", "tsunami preparedness", "heatwave preparedness",
                                        
                                        
                                        
                                        "cold wave preparedness", "drought preparedness", "pandemic preparedness",
                                        
                                        
                                        
                                        "bioterrorism preparedness", "chemical terrorism preparedness",
                                        
                                        
                                        
                                        "radiological terrorism preparedness", "nuclear terrorism preparedness",
                                        
                                        
                                        
                                        "cyberterrorism preparedness", "counterterrorism measures", "anti-terrorism training",
                                        
                                        
                                        
                                        "terrorism awareness", "extremism prevention", "radicalization prevention",
                                        
                                        
                                        
                                        "violent extremism prevention", "hate crime prevention", "bias crime prevention",
                                        
                                        
                                        
                                        "discrimination prevention", "harassment prevention", "bullying prevention",
                                        
                                        
                                        
                                        "cyberbullying prevention", "internet safety", "online security",
                                        
                                        
                                        
                                        "data privacy", "identity protection", "fraud prevention", "scam prevention",
                                        
                                        
                                        
                                        "con artist prevention", "pyramid scheme prevention", "ponzi scheme prevention",
                                        
                                        
                                        
                                        "financial literacy", "consumer protection", "consumer rights",
                                        
                                        
                                        
                                        "patient rights", "healthcare access", "health equity", "health disparity reduction",
                                        
                                        
                                        
                                        "health literacy", "public health", "community health", "global health",
                                        
                                        
                                        
                                        "environmental health", "occupational health", "school health", "rural health",
                                        
                                        
                                        
                                        "urban health", "mental health", "behavioral health", "emotional health",
                                        
                                        
                                        
                                        "spiritual health", "holistic health", "integrative health", "complementary health",
                                        
                                        
                                        
                                        "alternative health", "preventive health", "proactive health", "wellness",
                                        
                                        
                                        
                                        "well-being", "self-care", "self-help", "self-improvement", "personal development",
                                        
                                        
                                        
                                        "life coaching", "motivational speaking", "inspirational speaking",
                                        
                                        
                                        
                                        "public speaking", "communication skills", "interpersonal skills",
                                        
                                        
                                        
                                        "social skills", "emotional intelligence", "cultural competence",
                                        
                                        
                                        
                                        "diversity training", "inclusion training", "equity training", "allyship training",
                                        
                                        
                                        
                                        "advocacy training", "activism training", "community organizing",
                                        
                                        
                                        
                                        "social justice", "civil rights", "human rights", "animal rights",
                                        
                                        
                                        
                                        "environmental activism", "climate activism", "sustainability",
                                        
                                        
                                        
                                        "conservation", "preservation", "restoration", "rehabilitation",
                                        
                                        
                                        
                                        "recycling", "upcycling", "reusing", "reducing", "rethinking",
                                        
                                        
                                        
                                        "reimagining", "reinventing", "reforming", "transforming", "revolutionizing",
                                        
                                        
                                        
                                        "innovating", "creating", "building", "designing", "engineering",
                                        
                                        
                                        
                                        "inventing", "discovering", "exploring", "adventuring", "traveling",
                                        
                                        
                                        
                                        "wandering", "roaming", "journeying", "questing", "seeking",
                                        
                                        
                                        
                                        "finding", "uncovering", "revealing", "exposing", "unmasking",
                                        
                                        
                                        
                                        "decrypting", "decoding", "interpreting", "translating", "converting",
                                        
                                        
                                        
                                        "adapting", "adjusting", "modifying", "customizing", "personalizing",
                                        
                                        
                                        
                                        "tailoring", "fitting", "suiting", "matching", "pairing", "complementing",
                                        
                                        
                                        
                                        "enhancing", "enriching", "embellishing", "beautifying", "decorating",
                                        
                                        
                                        
                                        "ornamenting", "adorning", "dressing", "styling", "fashioning",
                                        
                                        
                                        
                                        "crafting", "carving", "sculpting", "molding", "shaping", "forming",
                                        
                                        
                                        
                                        "forging", "fabricating", "manufacturing", "producing", "generating",
                                        
                                        
                                        
                                        "creating", "developing", "evolving", "growing", "maturing",
                                        
                                        
                                        
                                        "aging", "ripening", "blooming", "flourishing", "thriving",
                                        
                                        
                                        
                                        "succeeding", "prospering", "winning", "triumphing", "conquering",
                                        
                                        
                                        
                                        "dominating", "ruling", "governing", "leading", "guiding",
                                        
                                        
                                        
                                        "directing", "managing", "administering", "supervising", "overseeing",
                                        
                                        
                                        
                                        "coordinating", "organizing", "arranging", "planning", "preparing",
                                        
                                        
                                        
                                        "anticipating", "expecting", "predicting", "forecasting", "projecting",
                                        
                                        
                                        
                                        "envisioning", "imagining", "conceiving", "dreaming", "fantasizing",
                                        
                                        
                                        
                                        "daydreaming", "musing", "pondering", "contemplating", "reflecting",
                                        
                                        
                                        
                                        "meditating", "praying", "worshiping", "revering", "honoring",
                                        
                                        
                                        
                                        "respecting", "admiring", "appreciating", "valuing", "cherishing",
                                        
                                        
                                        
                                        "treasuring", "savoring", "enjoying", "delighting", "relishing",
                                        
                                        
                                        
                                        "indulging", "luxuriating", "basking", "soaking", "immersing", "engulfing", "embracing", "encircling", "enveloping", "wrapping",
                                        
                                        
                                        
                                        "poonany", "trim", "poon-tang", "quim", "coochie", "cooch", "cooter", "punani", "punany", "pussy", "vag", "vajayjay", "retard", "fag", "dyke", "tranny", "kike", "gook", "spic", "wetback", "chink", "raghead", "sand-n*gger", "zipperhead", "kraut", "mick", "paddy", "polack", "ruskie", "wop", "dago", "jap", "nip", "hun", "frog", "limey", "yank", "seppo", "bogan", "chav", "pikey", "gyppo", "abo", "coon", "redskin", "injun", "squaw", "nuts", "whacko", "jihad", "Zionist", "commie", "fascist", "libtard", "femnazi", "redneck", "hillbilly", "terrorist", "extremist", "radical", "heretic", "apostate", "infidel", "blasphemer", "heathen", "pagan", "idolater"]
    
    @State var allButtonImages = [[UIImage]]()
     
     
     @State private var isGeneratingImage: Bool = false
     
     @State private var isAnyImageGenerating: Bool = false
     
     @State private var canSendNewRequest = true
     
     
     
     @State private var timeRemainingForNewRequest = 22
     
     
     
     @State private var isSelectedV1 = false
     
     @State private var isSelectedV2 = false
     
     @State private var isSelectedV3 = false
     
     @State private var isSelectedV4 = false
     
     
     
     @State private var isUsingApp = true
     
     
     
     @State private var showAIGodView = false
     
     
     
     
     
     
     
     @State private var generatedImagesCount = 0
     
     
     
     @State private var showPhoneAuth = false
     
     
     
     @State private var remainingAttempts: Int = 3
     
     
     
     @State private var isSubscribed: Bool = false
     
     
     
     let userPhoneNumber: String = "userPhoneNumber" // Asumiendo que tienes el número de teléfono del usuario
     
     
     @State private var hasImages: Bool = false
     
     
     
     
     @State private var isVaryStrongSelected = false
     @State private var isVarySubtleSelected = false
     @State private var isUpscaleSubtleSelected = false
     @State private var isUpscaleCreativeSelected = false
     
    

     
     @State private var initialLoadDone = false
     
     
     
     @State private var locallyGeneratedImages = Set<String>()
     
     
     
     @State private var firestoreImageURLs = Set<String>()
     
  //   @State private var imagesLoadedFromCoreData: Bool = UserDefaults.standard.bool(forKey: "imagesLoadedFromCoreData")
     
     
   

   // @State private var firestoreImageURLs: Set<String> = []

    func loadImagesFromFirestore(completion: @escaping ([GridImage]) -> Void) {
        var gridImages = [GridImage]()
        let db = Firestore.firestore()
        
        db.collection("images").order(by: "timestamp", descending: false).addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching snapshots: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            let group = DispatchGroup()
            
            for change in snapshot.documentChanges {
                if change.type == .added {
                    let data = change.document.data()
                    if let urlString = data["url"] as? String,
                       let url = URL(string: urlString),
                       let timestamp = data["timestamp"] as? Timestamp,
                       let jobID = data["jobID"] as? String,
                       let prompt = data["prompt"] as? String { // Asegúrate de que el prompt se obtiene desde Firestore
                        if !self.firestoreImageURLs.contains(urlString) {
                            self.firestoreImageURLs.insert(urlString)
                            group.enter()
                            print("Downloading image from URL: \(urlString)")
                            self.downloadAndProcessImage(url: url, urlString: urlString, timestamp: timestamp.dateValue(), jobID: jobID, prompt: prompt, group: group)
                        }
                    }
                }
            }
            
            group.notify(queue: .main) {
                print("All images downloaded and processed")
                completion(gridImages)
            }
        }
    }

    func downloadAndProcessImage(url: URL, urlString: String, timestamp: Date, jobID: String, prompt: String, group: DispatchGroup) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            defer { group.leave() }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        // Añadir la imagen como una nueva entrada, no reemplazar placeholders
                        if !self.hasEmptyPlaceholders() {
                            if !self.allGridImages.contains(where: { $0.jobID == jobID }) {
                                let size = CGSize(width: image.size.width / 2, height: image.size.height / 2)
                                var images: [UIImage] = []
                                
                                for y in 0..<2 {
                                    for x in 0..<2 {
                                        let startX = CGFloat(x) * size.width
                                        let startY = CGFloat(y) * size.height
                                        if let slice = cropImage(image: image, rect: CGRect(x: startX, y: startY, width: size.width, height: size.height)) {
                                            images.append(slice)
                                        }
                                    }
                                }
                                
                                let gridImage = GridImage(images: images, prompt: prompt, source: "Firestore", timestamp: timestamp, jobID: jobID)
                                DispatchQueue.main.async {
                                    self.allGridImages.append(gridImage)
                                    self.sortImagesByDate()
                                }
                            }
                            print("Image downloaded and processed from Firestore.")
                        } else {
                            print("Skipped adding Firestore image to avoid replacing empty placeholders")
                        }
                    }
                }
            } else if let error = error {
                print("Error downloading image: \(error)")
            }
        }.resume()
    }

    private func hasEmptyPlaceholders() -> Bool {
        return self.allGridImages.contains { $0.images.isEmpty }
    }

    func addImagesToUI(_ images: [UIImage], prompt: String, timestamp: Date, jobID: String) {
        if !self.allGridImages.contains(where: { $0.jobID == jobID }) {
            let gridImage = GridImage(images: images, prompt: prompt, source: "Generated", timestamp: timestamp, jobID: jobID)
            self.allGridImages.append(gridImage)
            self.sortImagesByDate()
        } else {
            print("Image with the same jobID already exists in UI")
        }
    }

    func cropImage(image: UIImage, rect: CGRect) -> UIImage? {
        guard let cgImage = image.cgImage?.cropping(to: rect) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }

    func extractJobID(from urlString: String) -> String {
        guard let url = URL(string: urlString),
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return "defaultJobID"
        }
        return queryItems.first(where: { $0.name == "jobid" })?.value ?? "defaultJobID"
    }

     @State private var isV1Selected: Bool = false
     @State private var isV2Selected: Bool = false
     @State private var isV3Selected: Bool = false
     @State private var isV4Selected: Bool = false
     
     
     @State private var selectedRedoUpscaleSubtleButtonIndices: Set<Int> = []
     @State private var selectedRedoUpscaleCreativeButtonIndices: Set<Int> = []
     
     
     
     
     
     func saveImageDetailsToFirestore(imageUrl: String, prompt: String, jobID: String) {
         let db = Firestore.firestore()
         let imageData: [String: Any] = [
             "url": imageUrl,
             "prompt": prompt,
             "timestamp": FieldValue.serverTimestamp(),
             "jobID": jobID  // <-- Esta línea se agregó para almacenar el jobID
         ]
         
         db.collection("images").addDocument(data: imageData) { error in
             if let error = error {
                 print("Error al guardar los detalles de la imagen: \(error.localizedDescription)")
             } else {
                 print("Detalles de la imagen guardados exitosamente")
             }
         }
     }
     
     
     
     
     
     func sortImagesByDate() {
         
         self.allGridImages.sort { $0.timestamp < $1.timestamp }
         
     }
     
     
     
     @State private var selectedVaryStrongButtonIndex: Int? = nil
     @State private var selectedVarySubtleButtonIndex: Int? = nil
     
     
     
     
     
     
     
     
     
     
     
     
     
     @State private var allGridImages: [GridImage] = []
     
     
     
     
     
     struct GridImage: Identifiable, Equatable {
         var id = UUID()
         var images: [UIImage]
         var prompt: String
         var source: String
         var timestamp: Date
         var jobID: String
         var isV1Selected: Bool = false
         var isV2Selected: Bool = false
         var isV3Selected: Bool = false
         var isV4Selected: Bool = false
         var isU1Selected: Bool = false
         var isU2Selected: Bool = false
         var isU3Selected: Bool = false
         var isU4Selected: Bool = false
         var isUpscaleSubtleSelected: Bool = false
         var isUpscaleCreativeSelected: Bool = false
         var isUpscaleSubtleDone: Bool = false
         var isUpscaleCreativeDone: Bool = false
         var showVariations: Bool = false // <-- Añadir esta propiedad
         var selectedImage: UIImage? = nil
         var isVariationPrompt: Bool = false
         var parentJobID: String? = nil
         var isUpscaling: Bool = false
         var showScanningText: Bool = false
         var isCreatingImage: Bool = false
         var origin: String?
         var isImageLoaded: Bool = false
         var showButtons: Bool = true
         
         var uButtonStates: [String: Bool] = [:]
         
         
         
     }
     
     @State private var shouldScrollToEndOnAppear = true
     
     @State private var selectedGridPrompt: String = ""
     
     func checkAndShowAuthentication() {
         
         
         
         let isUserAuthenticated = UserDefaults.standard.bool(forKey: "isUserAuthenticated")
         
         
         
         print("Usuario autenticado: \(isUserAuthenticated)")
         
         
         
         
         
         
         
         if !isUserAuthenticated {
             
             
             
             self.showPhoneAuth = true
             
             
             
         }
         
         
         
     }
     
     
     
     @State private var scrollViewProxy: ScrollViewProxy?
     
     
     
     @State private var isGeneratingImages = false
     
     @State private var areVariationButtonsEnabled = false
     
     
     func startUsingApp() {
         
         self.isUsingApp = true
         
     }
     
     
     
     func stopUsingApp() {
         
         self.isUsingApp = false
         
     }
     
     
     
     @State private var isPromptAccepted: Bool = true
     
     
     @State private var canSendNewVariationRequest = true
     @State private var timeRemainingForNewVariationRequest = 22
     
     // Estados para controlar los temporizadores de los botones U
     @State private var canSendNewURequest = true
     @State private var timeRemainingForNewURequest = 22
     
     
     
     func formatTimestamp(_ date: Date) -> String {
         
         let calendar = Calendar.current
         
         let timeFormatter = DateFormatter()
         
         timeFormatter.dateFormat = "hh:mm a"
         
         
         
         if calendar.isDateInToday(date) {
             
             return "Today at \(timeFormatter.string(from: date))"
             
         } else if calendar.isDateInYesterday(date) {
             
             return "Yesterday at \(timeFormatter.string(from: date))"
             
         } else {
             
             let dateFormatter = DateFormatter()
             
             dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a" // Formato MM/dd/yyyy hh:mm a
             
             return dateFormatter.string(from: date)
             
         }
         
     }
     
     
     func extractProgress(from content: String) -> Int? {
         
         let regex = try? NSRegularExpression(pattern: "(\\d+)%")
         
         if let match = regex?.firstMatch(in: content, range: NSRange(location: 0, length: content.utf16.count)) {
             
             let range = match.range(at: 1)
             
             if let progressRange = Range(range, in: content) {
                 
                 return Int(content[progressRange])
                 
             }
             
         }
         
         return nil
         
     }
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     @State private var selectedButton: String? = nil
     
     
     struct ScanningTextView: View {
         var text: String
         @State private var scanPosition: CGFloat = -1.0
         
         var body: some View {
             Text(text)
                 .font(.system(size: 17))
                 .foregroundColor(Color.gray.opacity(0.6)) // Color del texto
                 .background(
                     GeometryReader { geometry in
                         Rectangle()
                             .fill(Color.black) // Color de la barra de escaneo
                             .frame(width: geometry.size.width / 3, height: geometry.size.height) // Tamaño de la barra de escaneo
                             .offset(x: geometry.size.width * scanPosition) // Posición de la barra de escaneo
                             .animation(Animation.linear(duration: 3.0).repeatForever(autoreverses: false)) // Animación de movimiento
                             .onAppear {
                                 self.scanPosition = 1.0 // Inicia la animación
                             }
                     }
                         .mask(
                             Text(text)
                                 .font(.system(size: 17)) // Hace que la barra de escaneo se enmascare dentro del texto
                         )
                 )
         }
     }
     
     @State private var creatingImageIndices: Set<Int> = []
     
     
     @State private var showScrollToBottomButton = false
     @State private var lastContentOffset: CGFloat = 0
     
     
     
     @State private var generatingVariationIndex: Int? = nil
     
     @State private var showWhiteOverlay: Bool = true
     
     
     @State private var selectedImages: [GridImage] = []
     @State private var progressValues: [String: Float] = [:]
     @State private var selectedVaryStrongButtonIndices: Set<Int> = []
     @State private var selectedVarySubtleButtonIndices: Set<Int> = []
     
     
     func clearSelectedPrompt() {
         self.selectedPrompt = ""
     }
     
     @State private var isGeneratingVariation = false
     
     
     @State private var scrollOffset: CGFloat = 0
     @State private var isShowingImagePicker = false
     
     @State private var isImageLoaded: [Bool] = []
     
     @State private var isUpscalingImage: Bool = false
     
     
     
     @State private var selectedBlendImages: [UIImage] = []
     
     @State private var scrollViewOffset: CGFloat = 0
     
     
     class ImageGenerationViewModel: ObservableObject {
         @Published var allGridImages: [GridImage] = []
         @Published var isLoading = false
         @Published var jobID: String?
         @Published var progressValue: Float = 0.0
         @Published var canSendNewRequest = true
         @Published var timeRemainingForNewRequest = 30
         
         // Otras funciones y propiedades relacionadas con la generación de imágenes y manejo de estado
     }
     //  @State private var hasLoadedAllFirestoreImages = false
     
     
     @State private var shouldScroll = true
     
     @State private var isImageGenerationInProgress: Bool = false
     
     func canGenerateNewImage() -> Bool {
         return !isImageGenerationInProgress
     }
     
     
     
     @State private var lastDragPosition: CGFloat = 0
     
     @StateObject private var imageCounter = ImageCounter()
     
     func checkIfShouldShowScrollButton(currentIndex: Int) {
         let remainingImages = allGridImages.count - currentIndex - 1
         showScrollToBottomButton = remainingImages >= 10
     }
     
     @State private var showImageCreatorText: Bool = false
     
    struct MessageBarView: View {
             @ObservedObject var imageCounter: ImageCounter
             @Binding var messageBarVisible: Bool
             
             var body: some View {
                 ZStack {
                     Color(red: 244/255, green: 244/255, blue: 244/255) // Color de fondo de la barra, ajustado a tu imagen.
                     HStack {
                         Spacer()
                         Text("\(imageCounter.count) images created") // Muestra el contador dinámico.
                             .foregroundColor(.black) // Color del texto ajustado para mejor contraste.
                             .font(.title3) // Estilo del texto más minimalista.
                             .fontWeight(.regular) // Peso del texto regular para un aspecto limpio.
                         Spacer()
                         Button(action: {
                             messageBarVisible = false
                         }) {
                             Image("equis") // Asegúrate de que "equis" es el nombre correcto de tu imagen en los assets
                                 .resizable()
                                 .frame(width: 20, height: 20) // Ajusta el tamaño según sea necesario
                                 .foregroundColor(.black)
                         }
                         .padding(.trailing, 10)
                     }
                     .padding(.horizontal, 10)
                 }
                 .frame(height: 40) // Altura de la barra de mensajes.
             }
         }
         

     
     
     
     
     class ImageCounter: ObservableObject {
         @Published var count: Int = 0  // Variable pública para observar el contador en tiempo real.
         
         private var db = Firestore.firestore()  // Referencia a la instancia de Firestore.
         
         init() {
             loadInitialCount()  // Cargar el contador inicial desde Firestore al inicializar la clase.
             observeCounterChanges()  // Observar cambios en tiempo real.
         }
         
         private func loadInitialCount() {
             let counterRef = db.collection("Counter").document("counter")  // Referencia al documento del contador.
             counterRef.getDocument { (document, error) in
                 if let document = document, let count = document.get("count") as? Int {
                     DispatchQueue.main.async {
                         self.count = count  // Actualizar el contador en el hilo principal.
                     }
                 } else {
                     print("Error fetching counter: \(error?.localizedDescription ?? "Unknown error")")
                 }
             }
         }
         
         private func observeCounterChanges() {
             let counterRef = db.collection("Counter").document("counter")  // Referencia al documento del contador.
             counterRef.addSnapshotListener { (documentSnapshot, error) in
                 guard let document = documentSnapshot else {
                     print("Error observing counter: \(error!)")
                     return
                 }
                 if let count = document.get("count") as? Int {
                     DispatchQueue.main.async {
                         self.count = count  // Actualizar el contador en el hilo principal cuando hay cambios.
                     }
                 }
             }
         }
         
         func incrementCounter() {
             let counterRef = db.collection("Counter").document("counter")  // Referencia al documento del contador.
             db.runTransaction({ (transaction, errorPointer) -> Any? in
                 let document: DocumentSnapshot
                 do {
                     try document = transaction.getDocument(counterRef)  // Intentar obtener el documento actual.
                 } catch let fetchError as NSError {
                     errorPointer?.pointee = fetchError
                     return nil
                 }
                 
                 guard let oldCount = document.data()?["count"] as? Int else {
                     let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                         NSLocalizedDescriptionKey: "Unable to retrieve count from snapshot \(document)"
                     ])
                     errorPointer?.pointee = error
                     return nil
                 }
                 
                 transaction.updateData(["count": oldCount + 1], forDocument: counterRef)  // Incrementar el contador en Firestore de manera atómica.
                 return nil
             }) { (object, error) in
                 if let error = error {
                     print("Transaction failed: \(error)")  // Mostrar error si la transacción falla.
                 } else {
                     print("Transaction successfully committed!")  // Confirmar que la transacción fue exitosa.
                 }
             }
         }
     }
     
     
     @State private var messageBarVisible = true
     
     func updateImageGeneratingState() {
         DispatchQueue.main.async {
             self.isAnyImageGenerating = !self.creatingImageIndices.isEmpty
             print("Estado de generación de imágenes actualizado: \(self.isAnyImageGenerating)")
         }
     }
     
     
     
     //    @State private var isGeneratingImage = false
     
     func updateImageGenerationState3() {
         DispatchQueue.main.async {
             let isGenerating = allGridImages.contains { creatingImageIndices.contains(allGridImages.firstIndex(of: $0)!) }
             isAnyImageGenerating = isGenerating
         }
     }
     
     @State private var canSendURequestAfterV = true // Nueva variable de estado
     
     func startUTimerAfterV() {
         self.canSendURequestAfterV = false
         Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false) { _ in
             self.canSendURequestAfterV = true
         }
     }
     
     
     // Función para verificar si ya hay un placeholder en allGridImages
     private func hasPlaceholder() -> Bool {
         return allGridImages.contains(where: { $0.images.isEmpty })
     }
     
     @State private var selectedUpscaleSubtleIndex: Int? = nil
     @State private var selectedUpscaleCreativeIndex: Int? = nil
     
     @State private var selectedImageId: UUID? = nil
     @State private var selectedImageIndex: Int? = nil
     
     @State private var scrollPosition: Int? = nil
     
     @State private var showIntroContent = true
     
     
     
     // @State private var hasImages: Bool = false
     
     var body: some View {
            NavigationView {
                ZStack {
                    Color.white.edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 0) {
                        HStack {
                            Button(action: {
                                self.isSessionListOpen = true
                            }) {
                                Image("menu1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.black)
                            }
                            .padding(.leading, 20)
                            .padding(.top, 5)
                            
                            Spacer()
                            
                            if subscriptionManager.isSubscribed {
                                Text("Visual Creator AI")
                                    .font(.system(size: 19, weight: .bold, design: .default)) // Utiliza San Francisco por defecto
                                    .foregroundColor(.black)
                                    .offset(y: 2.1) // Mueve el texto ligeramente hacia abajo
                            } else {
                                if showImageCreatorText {
                                    Text("Visual Creator AI")
                                        .font(.system(size: 19, weight: .bold, design: .default)) // Utiliza San Francisco por defecto
                                        .foregroundColor(.black)
                                        .offset(y: 2.1) // Mueve el texto ligeramente hacia abajo
                                } else {
                                    Button(action: {
                                        self.showAIGodView = true
                                    }) {
                                        HStack(spacing: 4) {
                                            Text("Get Plus")
                                                .font(.system(size: 16, weight: .bold, design: .default)) // Utiliza San Francisco por defecto
                                                .foregroundColor(Color(red: 87/255, green: 86/255, blue: 206/255))
                                            Image(systemName: "sparkle")
                                                .foregroundColor(Color(red: 87/255, green: 86/255, blue: 206/255))
                                        }
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 10.4)
                                        .background(Color(red: 241 / 255, green: 241 / 255, blue: 251 / 255))
                                        .cornerRadius(13.5)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color(red: 241 / 255, green: 241 / 255, blue: 251 / 255), lineWidth: 1)
                                        )
                                    }
                                    .font(.system(size: 16, weight: .bold, design: .default)) // Utiliza San Francisco por defecto
                                }
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                self.resetConversation()
                            }) {
                                Image("edit1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(allGridImages.isEmpty ? .gray : .black)
                            }
                            .disabled(allGridImages.isEmpty)
                            .padding(.trailing, 20)
                        }
                        .padding(.vertical, 7) // Reduce vertical padding to make the height smaller
                        
                        if messageBarVisible {
                            MessageBarView(imageCounter: imageCounter, messageBarVisible: $messageBarVisible)
                                .padding(.top, -2) // Ajustar el padding para moverlo hacia abajo
                        }
                        
                        NavigationLink(destination: SessionListView(showingPikaVideoView: $showingPikaVideoView), isActive: $isSessionListOpen) {
                            EmptyView()
                        }
                        .navigationBarBackButtonHidden(true)
                        ZStack {
                                                                   ScrollViewReader { proxy in
                                                                       ScrollView {
                                                                           VStack(spacing: -120) {
                                                                               ForEach(allGridImages.indices, id: \.self) { index in
                                                                                   let gridImage = allGridImages[index]
                                                                                   VStack {
                                                                                       HStack {
                                                                                           VStack(alignment: .leading, spacing: 4) {
                                                                                               HStack {
                                                                                                   Image("logox6")
                                                                                                       .resizable()
                                                                                                       .frame(width: 47, height: 47)
                                                                                                       .offset(y: 1)
                                                                                                       .offset(y: 10)
                                                                                                   
                                                                                                   Text("Visual Creator Bot")
                                                                                                       .font(.system(size: 12.6))
                                                                                                       .fontWeight(.bold)
                                                                                                       .foregroundColor(.black)
                                                                                                       .lineLimit(1)
                                                                                                       .fixedSize(horizontal: true, vertical: false)
                                                                                                       .padding(.leading, -11.2) // Ajusta este valor para mover el texto más hacia la izquierda
                                                                                                       .offset(y: 10)
                                                                                                   
                                                                                                   Text(formatTimestamp(gridImage.timestamp))
                                                                                                       .font(.system(size: 10))
                                                                                                       .foregroundColor(.gray)
                                                                                                       .padding(.leading, -5.7)
                                                                                                       .lineLimit(1) // Limitar a una sola línea
                                                                                                       .fixedSize(horizontal: true, vertical: false) // Ajustar tamaño para mostrar todo el contenido
                                                                                                       .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading) // Ajustar el tamaño del contenedor
                                                                                                       .offset(y: 10)
                                                                                               }
                                                                                               .frame(maxWidth: .infinity, alignment: .leading)
                                                                                               HStack {
                                                                                                   if gridImage.source == "Blend" {
                                                                                                       if !gridImage.images.isEmpty {
                                                                                                           ForEach(gridImage.images.indices, id: \.self) { imgIndex in
                                                                                                               Image(uiImage: gridImage.images[imgIndex])
                                                                                                                   .resizable()
                                                                                                                   .frame(width: 30, height: 30)
                                                                                                                   .clipShape(Circle())
                                                                                                                   .overlay(
                                                                                                                    RoundedRectangle(cornerRadius: 15)
                                                                                                                        .stroke(Color.gray, lineWidth: 1)
                                                                                                                   )
                                                                                                                   .padding(.leading, 5)
                                                                                                           }
                                                                                                       } else if gridImage.isCreatingImage {
                                                                                                           ScanningTextView(text: "Creating\nimage")
                                                                                                               .font(.system(size: 14))
                                                                                                               .foregroundColor(.red)
                                                                                                               .padding(.leading, 5)
                                                                                                               .offset(x: -5, y: -5)
                                                                                                       }
                                                                                                   } else {
                                                                                                       Text(gridImage.prompt)
                                                                                                           .font(.system(size: 14.4))
                                                                                                           .foregroundColor(.gray)
                                                                                                           .padding(.top, 2)
                                                                                                           .padding(.leading, 11.2)
                                                                                                           .lineLimit(nil) // Permitir múltiples líneas
                                                                                                           .multilineTextAlignment(.leading)
                                                                                                           .fixedSize(horizontal: false, vertical: true) // Ajustar tamaño para mostrar todo el contenido
                                                                                                       
                                                                                                       if gridImage.isUpscaling {
                                                                                                           ScanningTextView(text: "upscaling image")
                                                                                                               .font(.system(size: 14))
                                                                                                               .foregroundColor(.gray)
                                                                                                               .padding(.leading, 5)
                                                                                                       }
                                                                                                   }
                                                                                                   
                                                                                                   if isLoading && index == allGridImages.count - 1 {
                                                                                                       Text("(\(Int(progressValue * 100))%) (relax)")
                                                                                                           .foregroundColor(Color.gray.opacity(0.8))
                                                                                                           .font(.system(size: 15, weight: .thin, design: .default))
                                                                                                           .padding(.leading, 5)
                                                                                                   }

                                                                                                   
                                                                                                   if selectedPrompt == "\(gridImage.prompt)" && gridImage.isVariationPrompt && isGeneratingVariation {
                                                                                                       ScanningTextView(text: "Creating\nvariations")
                                                                                                           .font(.system(size: 14))
                                                                                                           .foregroundColor(.gray)
                                                                                                           .padding(.leading, 5)
                                                                                                   }
                                                                                                   
                                                                                                   if creatingImageIndices.contains(index) {
                                                                                                       ScanningTextView(text: "Creating\nimage")
                                                                                                           .font(.system(size: 14))
                                                                                                           .foregroundColor(.gray)
                                                                                                           .padding(.leading, 5)
                                                                                                           .offset(x: -5, y: -5)
                                                                                                   }
                                                                                               }
                                                                                           }
                                                                                       }
                                                                                       .padding(.horizontal, 1)
                                                                                       .padding(.vertical, 5)
                                                                                       .offset(x: -10)
                                                                                       .padding(.bottom, 0)
                                                                                       .frame(maxWidth: .infinity, alignment: .leading)
                                                                                       .padding(.horizontal, 39.4) // Ajusta este valor según sea necesario para mover el contenido a la derecha
                                                                                       .padding(.bottom, 0)
                                                                                       .offset(y: 10)
                                                                                       if gridImage.source == "Button U" && gridImage.isImageLoaded {
                                                                                           VStack(spacing: 0) {
                                                                                               Image(uiImage: gridImage.images.first ?? UIImage())
                                                                                                   .resizable()
                                                                                                   .scaledToFit()
                                                                                                   .frame(maxWidth: 310, maxHeight: 310)
                                                                                                   .padding(.bottom, 260)
                                                                                               
                                                                                               VStack(spacing: 4) {
                                                                                                   if gridImage.showButtons {
                                                                                                       HStack(spacing: 8) {
                                                                                                           Button("Vary (Strong)") { self.varyStrongButtonTapped(index: index) }
                                                                                                               .buttonStyle(AppleStyleButton(isSelected: selectedVaryStrongButtonIndices.contains(index)))
                                                                                                           Button("Vary (Subtle)") { self.varySubtleButtonTapped(index: index) }
                                                                                                               .buttonStyle(AppleStyleButton(isSelected: selectedVarySubtleButtonIndices.contains(index)))
                                                                                                       }
                                                                                                       .padding(4)
                                                                                                       .cornerRadius(8)
                                                                                                       
                                                                                                       if !(gridImage.isUpscaleSubtleDone || gridImage.isUpscaleCreativeDone) {
                                                                                                           HStack(spacing: 8) {
                                                                                                               Button("Upscale (Subtle)") {
                                                                                                                   guard !isAnyImageGenerating else { return }
                                                                                                                   self.selectedUpscaleSubtleIndex = index
                                                                                                                   self.upscaleSubtleButtonTapped(index: index)
                                                                                                               }
                                                                                                               .buttonStyle(AppleStyleButton(isSelected: selectedUpscaleSubtleIndex == index))
                                                                                                               
                                                                                                               Button("Upscale (Creative)") {
                                                                                                                   guard !isAnyImageGenerating else { return }
                                                                                                                   self.selectedUpscaleCreativeIndex = index
                                                                                                                   self.upscaleCreativeButtonTapped(index: index)
                                                                                                               }
                                                                                                               .buttonStyle(AppleStyleButton(isSelected: selectedUpscaleCreativeIndex == index))
                                                                                                           }
                                                                                                           .padding(4)
                                                                                                           .cornerRadius(8)
                                                                                                       }
                                                                                                       
                                                                                                       if gridImage.isUpscaleSubtleSelected || gridImage.isUpscaleCreativeSelected {
                                                                                                           HStack(spacing: 8) {
                                                                                                               Button(action: { self.redoUpscaleSubtleButtonTapped(index: index) }) {
                                                                                                                   VStack {
                                                                                                                       Text("Redo Upscale")
                                                                                                                       Text("(Subtle)")
                                                                                                                   }
                                                                                                                   .frame(maxWidth: .infinity, maxHeight: 50)
                                                                                                                   .multilineTextAlignment(.center)
                                                                                                               }
                                                                                                               .buttonStyle(AppleStyleButton(isSelected: selectedRedoUpscaleSubtleButtonIndices.contains(index)))
                                                                                                               
                                                                                                               Button(action: { self.redoUpscaleCreativeButtonTapped(index: index) }) {
                                                                                                                   VStack {
                                                                                                                       Text("Redo Upscale")
                                                                                                                       Text("(Creative)")
                                                                                                                   }
                                                                                                                   .frame(maxWidth: .infinity, maxHeight: 50)
                                                                                                                   .multilineTextAlignment(.center)
                                                                                                               }
                                                                                                               .buttonStyle(AppleStyleButton(isSelected: selectedRedoUpscaleCreativeButtonIndices.contains(index)))
                                                                                                           }
                                                                                                           .padding(4)
                                                                                                           .cornerRadius(8)
                                                                                                       }
                                                                                                   }
                                                                                               }
                                                                                               .padding(.top, -260)
                                                                                           }
                                                                                           
                                                                                           
                                                                                           
                                                                                           
                                                                                           
                                                                                       } else if (gridImage.source == "Redo Upscale" || gridImage.source == "Redo Upscale") && gridImage.isImageLoaded {
                                                                                           VStack(spacing: 0) {
                                                                                               Image(uiImage: gridImage.images.first ?? UIImage())
                                                                                                   .resizable()
                                                                                                   .scaledToFit()
                                                                                                   .frame(maxWidth: 310, maxHeight: 310)
                                                                                                   .padding(.bottom, 260)
                                                                                               
                                                                                               VStack(spacing: 4) {
                                                                                                   if gridImage.showButtons {
                                                                                                       HStack(spacing: 8) {
                                                                                                           Button("Vary (Strong)") { self.varyStrongButtonTapped(index: index) }
                                                                                                               .buttonStyle(AppleStyleButton(isSelected: selectedVaryStrongButtonIndices.contains(index)))
                                                                                                           Button("Vary (Subtle)") { self.varySubtleButtonTapped(index: index) }
                                                                                                               .buttonStyle(AppleStyleButton(isSelected: selectedVarySubtleButtonIndices.contains(index)))
                                                                                                       }
                                                                                                       .padding(4)
                                                                                                       .cornerRadius(8)
                                                                                                   }
                                                                                               }
                                                                                               .padding(.top, -260)
                                                                                           }
                                                                                       } else {
                                                                                           GeometryReader { geometry in
                                                                                               let sideLength = geometry.size.width * 0.8
                                                                                               VStack(spacing: 0) {
                                                                                                   ForEach(0..<2, id: \.self) { row in
                                                                                                       HStack(spacing: 0) {
                                                                                                           ForEach(0..<2, id: \.self) { column in
                                                                                                               let imageIndex = row * 2 + column
                                                                                                               if gridImage.images.count > imageIndex {
                                                                                                                   Image(uiImage: gridImage.images[imageIndex])
                                                                                                                       .resizable()
                                                                                                                       .scaledToFill()
                                                                                                                       .frame(width: sideLength / 2, height: sideLength / 2)
                                                                                                                       .border(Color.black, width: 0.5)
                                                                                                                       .clipped()
                                                                                                                       .transition(.opacity) // Agrega el efecto de desvanecimiento
                                                                                                                       .animation(.easeInOut(duration: 0.6)) // Ajusta la duración de la animación
                                                                                                                       .onTapGesture {
                                                                                                                           if !self.selectedImages.contains(where: { $0.id == gridImage.id }) {
                                                                                                                               self.selectedImages.append(gridImage)
                                                                                                                           }
                                                                                                                           // Establecer la imagen seleccionada y el prompt seleccionado
                                                                                                                           self.selectedImage = gridImage.images[imageIndex]
                                                                                                                           self.selectedGridPrompt = gridImage.prompt
                                                                                                                           // Mostrar la vista de detalles
                                                                                                                           self.isShowingDetailView = true
                                                                                                                           // Actualizar la posición de desplazamiento
                                                                                                                           self.scrollPosition = index
                                                                                                                       }
                                                                                                               }
                                                                                                           }
                                                                                                       }
                                                                                                   }
                                                                                               }
                                                                                               .frame(width: sideLength, height: sideLength)
                                                                                               .padding(.horizontal, (geometry.size.width - sideLength) / 2)
                                                                                           }
                                                                                           .aspectRatio(1, contentMode: .fit)
                                                                                       }
                                                                                       if !gridImage.images.isEmpty && gridImage.source != "Button U" && !creatingImageIndices.contains(index) && gridImage.source != "Redo Upscale" && gridImage.showButtons {
                                                                                           VStack {
                                                                                               HStack(spacing: 16) {
                                                                                                   Button("V1", action: { self.v1ButtonTapped(index: index) })
                                                                                                       .buttonStyle(VariationButtonStyle(isSelected: allGridImages[index].isV1Selected))
                                                                                                       .disabled(isAnyImageGenerating)
                                                                                                   Button("V2", action: { self.v2ButtonTapped(index: index) })
                                                                                                       .buttonStyle(VariationButtonStyle(isSelected: allGridImages[index].isV2Selected))
                                                                                                       .disabled(isAnyImageGenerating)
                                                                                                   Button("V3", action: { self.v3ButtonTapped(index: index) })
                                                                                                       .buttonStyle(VariationButtonStyle(isSelected: allGridImages[index].isV3Selected))
                                                                                                       .disabled(isAnyImageGenerating)
                                                                                                   Button("V4", action: { self.v4ButtonTapped(index: index) })
                                                                                                       .buttonStyle(VariationButtonStyle(isSelected: allGridImages[index].isV4Selected))
                                                                                                       .disabled(isAnyImageGenerating)
                                                                                               }
                                                                                               .padding(8)
                                                                                               .cornerRadius(8)
                                                                                               .offset(y: -78)
                                                                                               
                                                                                               HStack(spacing: 16) {
                                                                                                   Button("U1", action: { self.u1ButtonTapped(index: index) })
                                                                                                       .buttonStyle(VariationButtonStyle(isSelected: gridImage.isU1Selected))
                                                                                                       .disabled(isAnyImageGenerating)
                                                                                                   Button("U2", action: { self.u2ButtonTapped(index: index) })
                                                                                                       .buttonStyle(VariationButtonStyle(isSelected: gridImage.isU2Selected))
                                                                                                       .disabled(isAnyImageGenerating)
                                                                                                   Button("U3", action: { self.u3ButtonTapped(index: index) })
                                                                                                       .buttonStyle(VariationButtonStyle(isSelected: gridImage.isU3Selected))
                                                                                                       .disabled(isAnyImageGenerating)
                                                                                                   Button("U4", action: { self.u4ButtonTapped(index: index) })
                                                                                                       .buttonStyle(VariationButtonStyle(isSelected: gridImage.isU4Selected))
                                                                                                       .disabled(isAnyImageGenerating)
                                                                                               }
                                                                                               .padding(8)
                                                                                               .cornerRadius(8)
                                                                                               .offset(y: -93)
                                                                                           }
                                                                                           
                                                                                           if gridImage.source != "Upscale (Subtle)" && gridImage.source != "Upscale (Creative)" {
                                                                                               if gridImage.isUpscaleSubtleSelected || gridImage.isUpscaleCreativeSelected {
                                                                                                   HStack(spacing: 8) {
                                                                                                       Button(action: { self.redoUpscaleSubtleButtonTapped(index: index) }) {
                                                                                                           VStack {
                                                                                                               Text("Redo Upscale")
                                                                                                               Text("(Subtle)")
                                                                                                           }
                                                                                                           .frame(maxWidth: .infinity, maxHeight: 50)
                                                                                                           .multilineTextAlignment(.center)
                                                                                                       }
                                                                                                       .buttonStyle(AppleStyleButton(isSelected: selectedRedoUpscaleSubtleButtonIndices.contains(index)))
                                                                                                       
                                                                                                       Button(action: { self.redoUpscaleCreativeButtonTapped(index: index) }) {
                                                                                                           VStack {
                                                                                                               Text("Redo Upscale")
                                                                                                               Text("(Creative)")
                                                                                                           }
                                                                                                           .frame(maxWidth: .infinity, maxHeight: 50)
                                                                                                           .multilineTextAlignment(.center)
                                                                                                       }
                                                                                                       .buttonStyle(AppleStyleButton(isSelected: selectedRedoUpscaleCreativeButtonIndices.contains(index)))
                                                                                                   }
                                                                                                   .padding(4)
                                                                                                   .cornerRadius(8)
                                                                                               }
                                                                                           }
                                                                                       }
                                                                                   }
                                                                                   .id(gridImage.id)
                                                                               }
                                                                               .padding(.bottom, 50)
                                                                               .padding(.horizontal, 20)
                                                                               .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                                               .onChange(of: allGridImages) { _ in
                                                                                   updateImageGenerationState3()
                                                                                   if shouldScroll {
                                                                                       withAnimation {
                                                                                           proxy.scrollTo(allGridImages.last?.id, anchor: .bottom)
                                                                                       }
                                                                                   }
                                                                               }
                                                                           }
                                                                           .onChange(of: isShowingDetailView) { showing in
                                                                               if !showing, let position = scrollPosition {
                                                                                   withAnimation {
                                                                                       proxy.scrollTo(position, anchor: .center)
                                                                                   }
                                                                               }
                                                                           }
                                                                           
                                                                           if allGridImages.isEmpty {
                                                                               GeometryReader { geometry in
                                                                                   VStack {
                                                                                       Spacer()
                                                                                       VStack {
                                                                                           Image("logox6")
                                                                                               .resizable()
                                                                                               .aspectRatio(contentMode: .fit)
                                                                                               .frame(width: 50, height: 50)
                                                                                               .background(
                                                                                                Circle()
                                                                                                    .fill(Color.white)
                                                                                                    .frame(width: 35, height: 35)
                                                                                                    .shadow(color: .gray.opacity(0.3), radius: 3, x: 1, y: 1)
                                                                                               )
                                                                                               .padding(.bottom, -20)
                                                                                           Text("Let me turn your imagination into imagery.")
                                                                                               .font(.system(size: 17))
                                                                                               .foregroundColor(.black)
                                                                                               .padding(.top, 10)
                                                                                           Text("by Visual Creator AI")
                                                                                               .font(.system(size: 17))
                                                                                               .foregroundColor(.gray)
                                                                                               .padding(.top, 5)
                                                                                       }
                                                                                       .position(x: geometry.size.width / 2, y: geometry.size.height / 2 + 220) // Ajusta el valor según sea necesario
                                                                                       Spacer()
                                                                                   }
                                                                               }
                                                                           }
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           VStack {
                                                                               ForEach(vButtonImages.indices, id: \.self) { index in
                                                                                   let gridImage = allGridImages[index] // Define gridImage en el contexto adecuado
                                                                                   if index < allPrompts.count {
                                                                                       VStack(alignment: .leading) {
                                                                                           // Agregar logo y "Image Creator Bot" justo arriba del prompt
                                                                                           HStack {
                                                                                               Image("logox")
                                                                                                   .resizable()
                                                                                                   .frame(width: 50, height: 50)
                                                                                                   .padding(.trailing, 3)
                                                                                               VStack(alignment: .leading, spacing: 4) {
                                                                                                   HStack {
                                                                                                       Text("Image Creator Bot")
                                                                                                           .font(.system(size: 14))
                                                                                                           .fontWeight(.bold)
                                                                                                           .foregroundColor(.black)
                                                                                                       Text(formatTimestamp(gridImage.timestamp))  // Usar el timestamp adecuado
                                                                                                           .font(.system(size: 12))
                                                                                                           .foregroundColor(.gray)
                                                                                                           .padding(.leading, 2)
                                                                                                   }
                                                                                               }
                                                                                               .padding(.vertical, 5)
                                                                                               .offset(x: -10)
                                                                                           }
                                                                                           // Mueve "Image Creator Bot" más hacia abajo
                                                                                           Text("\(self.selectedPrompt) - Variations")
                                                                                               .font(.system(size: 14))
                                                                                               .foregroundColor(.gray)
                                                                                               .padding(.top, 2)
                                                                                           
                                                                                           GeometryReader { geometry in
                                                                                               let sideLength = geometry.size.width * 0.8
                                                                                               VStack(spacing: 0) {
                                                                                                   ForEach(0..<2, id: \.self) { row in
                                                                                                       HStack(spacing: 0) {
                                                                                                           ForEach(0..<2, id: \.self) { column in
                                                                                                               let imageIndex = row * 2 + column
                                                                                                               if vButtonImages[index].count > imageIndex {
                                                                                                                   Image(uiImage: vButtonImages[index][imageIndex])
                                                                                                                       .resizable()
                                                                                                                       .scaledToFill()
                                                                                                                       .frame(width: sideLength / 2, height: sideLength / 2)
                                                                                                                       .border(Color.black, width: 0.5)
                                                                                                                       .clipped()
                                                                                                                       .onTapGesture {
                                                                                                                           self.selectedImage = vButtonImages[index][imageIndex]
                                                                                                                           self.isShowingDetailView = true
                                                                                                                       }
                                                                                                               }
                                                                                                           }
                                                                                                       }
                                                                                                   }
                                                                                               }
                                                                                               .frame(width: sideLength, height: sideLength)
                                                                                               .padding(.horizontal, (geometry.size.width - sideLength) / 2)
                                                                                           }
                                                                                           .aspectRatio(1, contentMode: .fit)
                                                                                           
                                                                                           HStack(spacing: 16) { // Añade espaciado entre los botones
                                                                                               HStack {
                                                                                                   // Añade espaciado entre los botones
                                                                                                   Button("V1", action: { self.v1ButtonTapped(index: index) })
                                                                                                       .buttonStyle(VariationButtonStyle(isSelected: allGridImages[index].isV1Selected))
                                                                                                   Button("V2", action: { self.v2ButtonTapped(index: index) })
                                                                                                       .buttonStyle(VariationButtonStyle(isSelected: allGridImages[index].isV2Selected))
                                                                                                   Button("V3", action: { self.v3ButtonTapped(index: index) })
                                                                                                       .buttonStyle(VariationButtonStyle(isSelected: allGridImages[index].isV3Selected))
                                                                                                   Button("V4", action: { self.v4ButtonTapped(index: index) })
                                                                                                       .buttonStyle(VariationButtonStyle(isSelected: allGridImages[index].isV4Selected))
                                                                                               }
                                                                                           }
                                                                                           .padding(-10)
                                                                                           .cornerRadius(0)
                                                                                           .offset(y: -65)
                                                                                       }
                                                                                   }
                                                                               }
                                                                               .padding(.horizontal, 20)
                                                                               .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                                               .onChange(of: allGridImages) { _ in
                                                                                   if shouldScroll {
                                                                                       withAnimation {
                                                                                           proxy.scrollTo(allGridImages.last?.id, anchor: .bottom)
                                                                                       }
                                                                                   }
                                                                               }
                                                                           }
                                                                           .onAppear {
                                                                               // if !initialLoadDone {
                                                                               //    if isImageLoaded.isEmpty {
                                                                               //       isImageLoaded = Array(repeating: false, count: allGridImages.count)
                                                                               //     }
                                                                               
                                                                               // Cargar imágenes desde Firestore
                                                                               loadImagesFromFirestore { images in
                                                                                   self.allGridImages.append(contentsOf: images)  // Cambiado para añadir nuevas imágenes en lugar de reemplazar
                                                                                   //    self.initialLoadDone = true
                                                                                   
                                                                                   // Desplazar al final de la lista si hay imágenes cargadas
                                                                                   if let lastImage = allGridImages.last {
                                                                                       proxy.scrollTo(lastImage.id, anchor: .bottom)
                                                                                   }
                                                                               }
                                                                               
                                                                               // Sincronizar con Firestore en tiempo real
                                                                               // loadDataAndListenFromFirestore()
                                                                               
                                                                               // Iniciar sesión o uso de la app
                                                                               // startUsingApp()
                                                                           }
                                                                       }

                            .overlay(
                                GeometryReader { geometry in
                                    if !allGridImages.isEmpty {
                                        Button(action: {
                                            proxy.scrollTo(allGridImages.last?.id, anchor: .bottom)
                                        }) {
                                            Image(systemName: "arrow.down.circle.fill")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(.white)
                                                .background(Color.black)
                                                .clipShape(Circle())
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.gray, lineWidth: 0.5)
                                                )
                                                .shadow(color: .gray.opacity(0.3), radius: 3, x: 1, y: 1)
                                        }
                                        .padding()
                                        .position(x: geometry.size.width - 35, y: geometry.size.height / 2 + 56.7)
                                    }
                                }
                            )
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        if !allButtonImages.isEmpty {
                            
                            Text("Button Generated Images")
                            
                                .font(.title)
                            
                                .padding()
                            
                            ForEach(allButtonImages, id: \.self) { imageSet in
                                
                                ForEach(imageSet, id: \.self) { image in
                                    
                                    Image(uiImage: image)
                                    
                                        .resizable()
                                    
                                        .scaledToFill()
                                    
                                        .frame(width: 100, height: 100)
                                    
                                        .clipped()
                                    
                                }
                                
                            }
                            
                        }
                        
                        
                        SearchBar(placeholder: "Message", text: $prompt, action: {
                            print("Botón 'Enviar' presionado")
                            blendImages(selectedImages: selectedBlendImages)
                            sendRequest()
                        }, isShowingImagePicker: $isShowingImagePicker, selectedBlendImages: $selectedBlendImages)
                        
                        
                        
                        
                        
                        .padding(.top, 0.01)
                        
                    }
                    
                }
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                .fullScreenCover(isPresented: $shouldShowSubscriptionView) {
                    
                    AI_GodView(dismissView: $shouldShowSubscriptionView)
                    
                }
                
                
                
                
                
                
                
                .background(
                    NavigationLink(
                        destination: DetailedImageView(image: selectedImage ?? UIImage(), gridPrompt: selectedGridPrompt, showAIGodView: $showAIGodView),
                        isActive: $isShowingDetailView
                    ) {
                        EmptyView()
                    }
                        .navigationBarBackButtonHidden(true)
                )
                
                
                
                .alert(isPresented: $showLimitReachedAlert) {
                    
                    Alert(
                        
                        title: Text("Limit Reached"),
                        
                        message: Text("You have generated many images today. Please wait a while to generate more.This measure is to guarantee a better experience for the entire community."),
                        
                        dismissButton: .default(Text("OK"))
                        
                    )
                    
                }
                
            }
            
            .fullScreenCover(isPresented: $showAIGodView) {
                
                AI_GodView(dismissView: $showAIGodView)
                
            }
            
            .alert(isPresented: $showLimitReachedAlert) {
                
                Alert(
                    
                    title: Text("Limit Reached"),
                    
                    message: Text("You've reached your image generation limit.Do you want to Upgrade to Plus for unlimited generations?"),
                    
                    primaryButton: .default(Text("Upgrade to Plus")) {
                        
                        self.showAIGodView = true  // Activa la vista AI God View
                        
                    },
                    
                    secondaryButton: .cancel()
                    
                )
                
            }
            
            .fullScreenCover(isPresented: $showAIGodView) {
                
                AI_GodView(dismissView: $showAIGodView)  // Muestra AI God View cuando showAIGodView es true
                
            }
            
            .fullScreenCover(isPresented: $showingPikaVideoView) {
                
                PikaVideoView()
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarBackButtonHidden(true)
        }
    }
    
    
    func containsProhibitedWords(text: String) -> Bool {
        
        
        
        prohibitedWords.contains(where: text.lowercased().contains)
        
    }
    
    
    private func resetConversation() {
        self.allGridImages.removeAll { $0.source == "Local" } // Eliminar solo las imágenes locales
    }
     
    func sendRequest() {
        guard canSendNewRequest && !isAnyImageGenerating else {
            print("No se puede enviar el prompt. Espere \(timeRemainingForNewRequest) segundos o termine de generarse la imagen actual.")
            return
        }
        
        if hasPlaceholder() {
            print("Ya hay un placeholder existente.")
            return
        }
        
        isGeneratingImages = true
        self.showImageCreatorText = true // Cambiar el estado aquí
        
        // Hacer vibrar el iPhone cuando se envía una nueva solicitud
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        let currentPrompt = self.prompt // Guardar el prompt actual
        self.prompt = "" // Reiniciar el prompt después de usarlo
        
        let jobID = UUID().uuidString // Generar un jobID único
        
        // Verificar si el prompt es aceptado
        checkIfPromptIsAccepted(currentPrompt) { isAccepted in
            if isAccepted {
                let newGridImage = GridImage(images: [], prompt: currentPrompt, source: "Local", timestamp: Date(), jobID: jobID)
                self.allGridImages.append(newGridImage) // Añadir nuevo bloque vacío
                
                // Solo añadir el prompt a allPrompts si no es una solicitud de variación
                if !isVariationRequest {
                    self.allPrompts.append(currentPrompt) // Añadir el prompt actual a la lista de prompts
                }
            }
            
            self.processAndSendRequest(currentPrompt, isAccepted: isAccepted)
            
            func startRequestTimer() {
                self.canSendNewRequest = false
                self.timeRemainingForNewRequest = 30
                
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    if self.timeRemainingForNewRequest > 0 {
                        self.timeRemainingForNewRequest -= 1
                    } else {
                        timer.invalidate()
                        self.canSendNewRequest = true
                    }
                }
            }
            
            startRequestTimer()
        }
    }

    private func checkIfPromptIsAccepted(_ prompt: String, completion: @escaping (Bool) -> Void) {
        // Implementar la lógica para verificar si el prompt es aceptado
        // Por ejemplo, podrías usar la función analyzeTextAndGenerateImages para esto
        analyzeTextAndGenerateImages(text: prompt) { isAppropriate in
            completion(isAppropriate)
        }
    }

    private func processAndSendRequest(_ text: String, isAccepted: Bool) {
        if !isAccepted {
            isLoading = false
            return
        }
        
        isLoading = true
        progressValue = 0.0
        compositeImage = nil
        
        // Hacer vibrar el iPhone cuando el proceso de generación empieza
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        detectLanguage(text) { isEnglish in
            if isEnglish {
                self.analyzeAndGenerateImages(text: text)
            } else {
                self.translateTextWithGoogleAPI(text) { translatedText in
                    self.analyzeAndGenerateImages(text: translatedText)
                }
            }
        }
    }
    
    // Funciones adicionales como detectLanguage, translateTextWithGoogleAPI, analyzeAndGenerateImages, etc., permanecen igual.
    
    
    
    
    
    private func analyzeAndGenerateImages(text: String) {
        
        
        
        if self.containsProhibitedWords(text: text) {
            
            
            
            // Manejar el caso en que el texto contiene palabras prohibidas
            
            
            
            DispatchQueue.main.async {
                
                
                
                self.isLoading = false
                
                
                
                // Mostrar algún mensaje de error al usuario
                
                
                
            }
            
            
            
        } else {
            
            
            
            // Si no hay palabras prohibidas, proceder con el análisis y la generación de imágenes
            
            
            
            self.analyzeTextAndGenerateImages(text: text) { isAppropriate in
                
                
                
                DispatchQueue.main.async {
                    
                    
                    
                    if isAppropriate {
                        
                        
                        
                        self.allPrompts.append(text)
                        
                        
                        
                        self.makeRequestForImageGeneration(text)
                        
                        
                        
                    } else {
                        
                        
                        
                        self.isLoading = false
                        
                        
                        
                        // Manejar el caso cuando el texto no es apropiado
                        
                        
                        
                    }
                    
                    
                    
                }
                
                
                
            }
            
            
            
        }
        
        
        
    }
  
    private func makeRequestForImageGeneration(_ prompt: String) {
        let initialRequestURL = "https://api.useapi.net/v2/jobs/imagine"
        makeRequest(urlString: initialRequestURL, isInitialRequest: true, prompt: prompt)
    }

    func makeRequest(urlString: String, isInitialRequest: Bool, prompt: String) {
        guard let url = URL(string: urlString) else {
            print("URL inválida: \(urlString)")
            self.isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isInitialRequest ? "POST" : "GET"
        request.addValue("Bearer user:807-hbo5l6k1Mv4rh7ApIcWFR", forHTTPHeaderField: "Authorization")
        
        if isInitialRequest {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let requestBody: [String: Any] = [
                "prompt": prompt,
                "discord": "MTE3ODgxNDkyMjM0MDE3NTkxNQ.GecmlV.3CjdjJBZLv7boAYim73QzDRRDtRR5qUCCxvUmw",
                "server": "1178973180602363974",
                "channel": "1178973181046952008",
                "replyUrl": "https://us-central1-image-creator-ai-a958f.cloudfunctions.net/receiveImageUrl",
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
            self.imageGenerationStarted = false
            startFakeProgress()  // Inicia el progreso falso cuando se envía la solicitud
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error en la solicitud: \(error.localizedDescription)")
                    self.isLoading = false
                    return
                }
                
                guard let data = data else {
                    print("No se recibieron datos en la respuesta")
                    self.isLoading = false
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    
                    if isInitialRequest {
                        if let jobID = jsonResponse?["jobid"] as? String {
                            self.jobID = jobID
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                                self.checkJobStatus(prompt: prompt)
                            }
                            self.imageGenerationStarted = true
                        } else {
                            self.isLoading = false
                        }
                    } else {
                        if let status = jsonResponse?["status"] as? String {
                            if status == "completed" {
                                self.loadingTimer?.invalidate()  // Detenemos el temporizador de progreso falso
                                self.progressValue = 1.0
                                if let attachments = jsonResponse?["attachments"] as? [[String: Any]],
                                   let firstAttachment = attachments.first,
                                   let imageUrlString = firstAttachment["url"] as? String {
                                    self.loadImage(from: imageUrlString) { loadedImage in
                                        if let image = loadedImage {
                                            self.processLoadedImage(image, imageUrl: imageUrlString, prompt: prompt)
                                        }
                                    }
                                }
                            } else if status == "progress", let content = jsonResponse?["content"] as? String {
                                if let progress = self.extractProgress(from: content) {
                                    DispatchQueue.main.async {
                                        self.progressValue = max(self.progressValue, Float(progress) / 100.0)
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                                    self.checkJobStatus(prompt: prompt)
                                }
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                                    self.checkJobStatus(prompt: prompt)
                                }
                            }
                        }
                    }
                } catch {
                    print("Error al deserializar JSON: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }
        }.resume()
    }

    @State private var loadingTimer: Timer?
    @State private var currentFakeProgress: Float = 0.0

    func startFakeProgress() {
        currentFakeProgress = 0.0
        progressValue = 0.0
        
        loadingTimer?.invalidate()  // Detener temporizador anterior si existe

        loadingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.currentFakeProgress < 100.0 {  // Aumentar hasta 100%
                self.currentFakeProgress += 1.0  // Incrementa en 1%
                DispatchQueue.main.async {
                    self.progressValue = self.currentFakeProgress / 100  // Actualizar el valor
                }
            } else {
                timer.invalidate()
            }
        }
    }


    func uploadImageDetails(imageUrl: String, prompt: String) {
        let db = Firestore.firestore()
        let imageData: [String: Any] = [
            "url": imageUrl,
            "prompt": prompt,  // Guarda el prompt correcto
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        db.collection("images").addDocument(data: imageData) { error in
            if let error = error {
                print("Error al guardar los detalles de la imagen: \(error.localizedDescription)")
            } else {
                print("Detalles de la imagen guardados exitosamente")
            }
        }
    }

    
    
    
    
    
    struct VariationButtonStyle: ButtonStyle {
        var isSelected: Bool
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(isSelected ? .white : .black) // Cambia el color del texto cuando está seleccionado
                .frame(width: 50, height: 50)
                .background(isSelected ? Color.customBlueColor : Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 0.5)
                )
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .shadow(color: .gray.opacity(0.3), radius: 3, x: 1, y: 1)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    struct AppleStyleButton: ButtonStyle {
        var isSelected: Bool
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.system(size: 12))
                .frame(width: 110, height: 25)
                .padding(.horizontal, 20)
                .padding(.vertical, 10) // Ajusta el padding vertical para mantener la altura correcta
                .background(isSelected ? Color.customBlueColor : Color.white)
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 0.5)
                )
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .shadow(color: .gray.opacity(0.3), radius: 3, x: 1, y: 1)
        }
    }
    func varyStrongButtonTapped(index: Int) {
        guard canSendNewVariationRequest && !isAnyImageGenerating else {
            print("No se puede enviar el prompt. Espere \(timeRemainingForNewVariationRequest) segundos o termine de generarse la imagen actual.")
            return
        }
        guard index < allGridImages.count else { return }
        let image = allGridImages[index]
        
        let newPrompt = image.prompt.components(separatedBy: " - Image #").first! + " - Variations (Strong)"
        
        let placeholderImage = GridImage(images: [], prompt: newPrompt, source: "Vary (Strong)", timestamp: Date(), jobID: image.jobID)
        self.allGridImages.append(placeholderImage)
        
        selectedVaryStrongButtonIndices.insert(index)
        creatingImageIndices.insert(allGridImages.count - 1)  // Añadir el índice al conjunto
        
        updateImageGeneratingState()
        print("Creating Image Indices (Vary Strong): \(creatingImageIndices)")
        
        makeRequestForImageGeneration(button: "Vary (Strong)", jobID: image.jobID, prompt: newPrompt, shouldUpdateUI: true, placeholderImage: placeholderImage) {
            self.creatingImageIndices.remove(allGridImages.count - 1)  // Eliminar el índice al completar
            self.updateImageGeneratingState()
            print("Creating Image Indices después de completar (Vary Strong): \(creatingImageIndices)")
        }
        
        startVariationRequestTimer()
    }

    func varySubtleButtonTapped(index: Int) {
        guard canSendNewVariationRequest && !isAnyImageGenerating else {
            print("No se puede enviar el prompt. Espere \(timeRemainingForNewVariationRequest) segundos o termine de generarse la imagen actual.")
            return
        }
        guard index < allGridImages.count else { return }
        let image = allGridImages[index]
        
        let newPrompt = image.prompt.components(separatedBy: " - Image #").first! + " - Variations (Subtle)"
        
        let placeholderImage = GridImage(images: [], prompt: newPrompt, source: "Vary (Subtle)", timestamp: Date(), jobID: image.jobID)
        self.allGridImages.append(placeholderImage)
        
        selectedVarySubtleButtonIndices.insert(index)
        creatingImageIndices.insert(allGridImages.count - 1)  // Añadir el índice al conjunto
        
        updateImageGeneratingState()
        print("Creating Image Indices (Vary Subtle): \(creatingImageIndices)")
        
        makeRequestForImageGeneration(button: "Vary (Subtle)", jobID: image.jobID, prompt: newPrompt, shouldUpdateUI: true, placeholderImage: placeholderImage) {
            self.creatingImageIndices.remove(allGridImages.count - 1)  // Eliminar el índice al completar
            self.updateImageGeneratingState()
            print("Creating Image Indices después de completar (Vary Subtle): \(creatingImageIndices)")
        }
        
        startVariationRequestTimer()
    }

    func upscaleSubtleButtonTapped(index: Int) {
        guard canSendNewVariationRequest && !isAnyImageGenerating else {
            print("No se puede enviar el prompt. Espere \(timeRemainingForNewVariationRequest) segundos o termine de generarse la imagen actual.")
            return
        }
        guard index < allGridImages.count else { return }
        var gridImage = allGridImages[index]
        
        let newPrompt = gridImage.prompt.components(separatedBy: " - Image #").first! + " - Upscaled (Subtle)"
        
        let placeholderImage = GridImage(images: [], prompt: newPrompt, source: "Upscale (Subtle)", timestamp: Date(), jobID: gridImage.jobID, isUpscaleSubtleSelected: true, isUpscaleCreativeSelected: gridImage.isUpscaleCreativeSelected, isUpscaleSubtleDone: true)
        self.allGridImages.append(placeholderImage)
        
        creatingImageIndices.insert(allGridImages.count - 1)  // Añadir el índice al conjunto
        
        updateImageGeneratingState()
        print("Creating Image Indices (Upscale Subtle): \(creatingImageIndices)")
        
        makeRequestForImageGeneration(button: "Upscale (Subtle)", jobID: gridImage.jobID, prompt: newPrompt, shouldUpdateUI: true, placeholderImage: placeholderImage) {
            if let placeholderIndex = self.allGridImages.firstIndex(of: placeholderImage) {
                self.creatingImageIndices.remove(placeholderIndex)  // Eliminar el índice al completar
            }
            self.isLoading = false
            self.updateImageGeneratingState()
            print("Creating Image Indices después de completar (Upscale Subtle): \(creatingImageIndices)")
        }
        isUpscaleSubtleSelected = true
        
        startVariationRequestTimer()
    }

    func upscaleCreativeButtonTapped(index: Int) {
        guard canSendNewVariationRequest && !isAnyImageGenerating else {
            print("No se puede enviar el prompt. Espere \(timeRemainingForNewVariationRequest) segundos o termine de generarse la imagen actual.")
            return
        }
        guard index < allGridImages.count else { return }
        var gridImage = allGridImages[index]
        
        let newPrompt = gridImage.prompt.components(separatedBy: " - Image #").first! + " - Upscaled (Creative)"
        
        let placeholderImage = GridImage(images: [], prompt: newPrompt, source: "Upscale (Creative)", timestamp: Date(), jobID: gridImage.jobID, isUpscaleSubtleSelected: gridImage.isUpscaleSubtleSelected, isUpscaleCreativeSelected: true, isUpscaleCreativeDone: true)
        self.allGridImages.append(placeholderImage)
        
        creatingImageIndices.insert(allGridImages.count - 1)  // Añadir el índice al conjunto
        
        updateImageGeneratingState()
        print("Creating Image Indices (Upscale Creative): \(creatingImageIndices)")
        
        makeRequestForImageGeneration(button: "Upscale (Creative)", jobID: gridImage.jobID, prompt: newPrompt, shouldUpdateUI: true, placeholderImage: placeholderImage) {
            if let placeholderIndex = self.allGridImages.firstIndex(of: placeholderImage) {
                self.creatingImageIndices.remove(placeholderIndex)  // Eliminar el índice al completar
            }
            self.isLoading = false
            self.updateImageGeneratingState()
            print("Creating Image Indices después de completar (Upscale Creative): \(creatingImageIndices)")
        }
        isUpscaleCreativeSelected = true
        
        startVariationRequestTimer()
    }

    func redoUpscaleSubtleButtonTapped(index: Int) {
               guard canSendNewVariationRequest && !isAnyImageGenerating else {
                   print("No se puede enviar el prompt. Espere \(timeRemainingForNewVariationRequest) segundos o termine de generarse la imagen actual.")
                   return
               }
               guard index < allGridImages.count else { return }
               let image = allGridImages[index]
               let newPrompt = image.prompt.components(separatedBy: " - Image #").first! + " - Redo Upscaled (Subtle)"
               let placeholderImage = GridImage(images: [], prompt: newPrompt, source: "Redo Upscale (Subtle)", timestamp: Date(), jobID: image.jobID, showScanningText: true, origin: "RedoUpscale", isImageLoaded: false)
               self.allGridImages.append(placeholderImage)
               
               creatingImageIndices.insert(allGridImages.count - 1)  // Añadir el índice al conjunto
               selectedRedoUpscaleSubtleButtonIndices.insert(index)
               
               updateImageGeneratingState()
               print("Creating Image Indices (Redo Upscale Subtle): \(creatingImageIndices)")
               
               makeRequestForRedo(urlString: "https://api.useapi.net/v2/jobs/button", isInitialRequest: true, button: "Redo Upscale (Subtle)", jobID: image.jobID, shouldUpdateUI: true, placeholderImage: placeholderImage) {
                   self.updateImageGeneratingState()  // Permitir de nuevo la interacción
                   print("Creating Image Indices después de completar (Redo Upscale Subtle): \(creatingImageIndices)")
               }
               
               startVariationRequestTimer()
           }
           
           func redoUpscaleCreativeButtonTapped(index: Int) {
               guard canSendNewVariationRequest && !isAnyImageGenerating else {
                   print("No se puede enviar el prompt. Espere \(timeRemainingForNewVariationRequest) segundos o termine de generarse la imagen actual.")
                   return
               }
               guard index < allGridImages.count else { return }
               let image = allGridImages[index]
               let newPrompt = image.prompt.components(separatedBy: " - Image #").first! + " - Redo Upscaled (Creative)"
               let placeholderImage = GridImage(images: [], prompt: newPrompt, source: "Redo Upscale (Creative)", timestamp: Date(), jobID: image.jobID, showScanningText: true, origin: "RedoUpscale", isImageLoaded: false)
               self.allGridImages.append(placeholderImage)
               
               creatingImageIndices.insert(allGridImages.count - 1)  // Añadir el índice al conjunto
               selectedRedoUpscaleCreativeButtonIndices.insert(index)
               
               updateImageGeneratingState()
               print("Creating Image Indices (Redo Upscale Creative): \(creatingImageIndices)")
               
               makeRequestForRedo(urlString: "https://api.useapi.net/v2/jobs/button", isInitialRequest: true, button: "Redo Upscale (Creative)", jobID: image.jobID, shouldUpdateUI: true, placeholderImage: placeholderImage) {
                   self.updateImageGeneratingState()  // Permitir de nuevo la interacción
                   print("Creating Image Indices después de completar (Redo Upscale Creative): \(creatingImageIndices)")
               }
               
               startVariationRequestTimer()
           }
           
           func startVariationRequestTimer() {
               self.canSendNewVariationRequest = false
               self.timeRemainingForNewVariationRequest = 10
               
               Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                   if self.timeRemainingForNewVariationRequest > 0 {
                       self.timeRemainingForNewVariationRequest -= 1
                   } else {
                       timer.invalidate()
                       self.canSendNewVariationRequest = true
                   }
               }
           }
           
           // Función para iniciar el temporizador para los botones U
           func startURequestTimer() {
               self.canSendNewURequest = false
               self.timeRemainingForNewURequest = 10
               
               Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                   if self.timeRemainingForNewURequest > 0 {
                       self.timeRemainingForNewURequest -= 1
                   } else {
                       timer.invalidate()
                       self.canSendNewURequest = true
                   }
               }
           }
           
           
    
    
    
    
    
    
    struct CircularButtonStyle: ButtonStyle {
        
        func makeBody(configuration: Configuration) -> some View {
            
            configuration.label
            
                .font(.system(size: 14)) // Tamaño del texto
            
                .foregroundColor(.white) // Color del texto
            
                .frame(width: 50, height: 50) // Tamaño del botón
            
                .background(Color.black) // Color de fondo del botón
            
                .clipShape(Circle()) // Hace que el botón sea circular
            
                .scaleEffect(configuration.isPressed ? 0.95 : 1.05)
            
            
            
        }
        
    }
    
    
    
    
    func v1ButtonTapped(index: Int) {
        guard canSendNewRequest && !isAnyImageGenerating else {
            print("No se puede enviar el prompt. Espere \(timeRemainingForNewRequest) segundos.")
            return
        }
        
        guard index < allGridImages.count else { return }
        allGridImages[index].isV1Selected = true
        self.selectedPrompt = allGridImages[index].prompt
        isGeneratingVariation = true
        isGeneratingImage = true
        let placeholderImage = addPreliminaryImageToUI(prompt: self.selectedPrompt, timestamp: Date(), isVariationPrompt: true, parentJobID: allGridImages[index].jobID)
        makeRequestForImageGeneration(button: "V1", jobID: allGridImages[index].jobID, prompt: self.selectedPrompt, shouldUpdateUI: true, placeholderImage: placeholderImage) {
            self.isGeneratingImage = false  // Permitir de nuevo la interacción
            self.updateImageGenerationState3() // Actualizar el estado de generación de imagen
            self.startURequestTimer() // Iniciar el temporizador para los botones U
            self.allGridImages[index].prompt += " -Variations (Strong)" // Añadir el texto "Variations (Strong)" al prompt
        }
        
        startRequestTimer1()
        startUTimerAfterV() // Iniciar el temporizador para los botones U después de presionar V
    }

    func v2ButtonTapped(index: Int) {
        guard canSendNewRequest && !isAnyImageGenerating else {
            print("No se puede enviar el prompt. Espere \(timeRemainingForNewRequest) segundos.")
            return
        }
        
        guard index < allGridImages.count else { return }
        allGridImages[index].isV2Selected = true
        self.selectedPrompt = allGridImages[index].prompt
        isGeneratingVariation = true
        isGeneratingImage = true
        let placeholderImage = addPreliminaryImageToUI(prompt: self.selectedPrompt, timestamp: Date(), isVariationPrompt: true, parentJobID: allGridImages[index].jobID)
        makeRequestForImageGeneration(button: "V2", jobID: allGridImages[index].jobID, prompt: self.selectedPrompt, shouldUpdateUI: true, placeholderImage: placeholderImage) {
            self.isGeneratingImage = false  // Permitir de nuevo la interacción
            self.updateImageGenerationState3() // Actualizar el estado de generación de imagen
            self.startURequestTimer() // Iniciar el temporizador para los botones U
            self.allGridImages[index].prompt += " -Variations (Strong)" // Añadir el texto "Variations (Strong)" al prompt
        }
        
        startRequestTimer1()
        startUTimerAfterV() // Iniciar el temporizador para los botones U después de presionar V
    }

    func v3ButtonTapped(index: Int) {
        guard canSendNewRequest && !isAnyImageGenerating else {
            print("No se puede enviar el prompt. Espere \(timeRemainingForNewRequest) segundos.")
            return
        }
        
        guard index < allGridImages.count else { return }
        allGridImages[index].isV3Selected = true
        self.selectedPrompt = allGridImages[index].prompt
        isGeneratingVariation = true
        isGeneratingImage = true
        let placeholderImage = addPreliminaryImageToUI(prompt: self.selectedPrompt, timestamp: Date(), isVariationPrompt: true, parentJobID: allGridImages[index].jobID)
        makeRequestForImageGeneration(button: "V3", jobID: allGridImages[index].jobID, prompt: self.selectedPrompt, shouldUpdateUI: true, placeholderImage: placeholderImage) {
            self.isGeneratingImage = false  // Permitir de nuevo la interacción
            self.updateImageGenerationState3() // Actualizar el estado de generación de imagen
            self.startURequestTimer() // Iniciar el temporizador para los botones U
            self.allGridImages[index].prompt += " -Variations (Strong)" // Añadir el texto "Variations (Strong)" al prompt
        }
        
        startRequestTimer1()
        startUTimerAfterV() // Iniciar el temporizador para los botones U después de presionar V
    }

    func v4ButtonTapped(index: Int) {
        guard canSendNewRequest && !isAnyImageGenerating else {
            print("No se puede enviar el prompt. Espere \(timeRemainingForNewRequest) segundos.")
            return
        }
        
        guard index < allGridImages.count else { return }
        allGridImages[index].isV4Selected = true
        self.selectedPrompt = allGridImages[index].prompt
        isGeneratingVariation = true
        isGeneratingImage = true
        let placeholderImage = addPreliminaryImageToUI(prompt: self.selectedPrompt, timestamp: Date(), isVariationPrompt: true, parentJobID: allGridImages[index].jobID)
        makeRequestForImageGeneration(button: "V4", jobID: allGridImages[index].jobID, prompt: self.selectedPrompt, shouldUpdateUI: true, placeholderImage: placeholderImage) {
            self.isGeneratingImage = false  // Permitir de nuevo la interacción
            self.updateImageGenerationState3() // Actualizar el estado de generación de imagen
            self.startURequestTimer() // Iniciar el temporizador para los botones U
            self.allGridImages[index].prompt += " -Variations (Strong)" // Añadir el texto "Variations (Strong)" al prompt
        }
        
        startRequestTimer1()
        startUTimerAfterV() // Iniciar el temporizador para los botones U después de presionar V
    }

    func startRequestTimer1() {
        self.canSendNewRequest = false
        self.timeRemainingForNewRequest = 22
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.timeRemainingForNewRequest > 0 {
                self.timeRemainingForNewRequest -= 1
            } else {
                timer.invalidate()
                self.canSendNewRequest = true
            }
        }
    }

    
    func addPreliminaryImageToUI(prompt: String, timestamp: Date, isVariationPrompt: Bool = false, parentJobID: String? = nil) -> GridImage {
        let jobID = UUID().uuidString
        let placeholderImage = GridImage(images: [], prompt: prompt, source: "Local", timestamp: timestamp, jobID: jobID, isVariationPrompt: isVariationPrompt, parentJobID: parentJobID)
        self.allGridImages.append(placeholderImage)
        return placeholderImage
    }
    
    func makeRequestForImageGeneration(button: String, jobID: String, prompt: String, shouldUpdateUI: Bool = true, placeholderImage: GridImage? = nil, completion: (() -> Void)? = nil) {
        let initialRequestURL = "https://api.useapi.net/v2/jobs/button"
        if button.starts(with: "U") {
            makeButtonRequestForU(urlString: initialRequestURL, isInitialRequest: true, button: button, jobID: jobID, shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage)
        } else if button.starts(with: "Redo") {
            makeRequestForRedo(urlString: initialRequestURL, isInitialRequest: true, button: button, jobID: jobID, shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage)
        } else {
            makeRequest(urlString: initialRequestURL, isInitialRequest: true, button: button, jobID: jobID, shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage, prompt: prompt, completion: completion)
        }
    }



    func makeRequest(urlString: String, isInitialRequest: Bool, button: String, jobID: String, shouldUpdateUI: Bool, placeholderImage: GridImage? = nil, prompt: String = "", completion: (() -> Void)? = nil) {
        guard let url = URL(string: urlString) else {
            isGeneratingVariation = false
            self.isLoading = false
            return
        }
        
        self.isGeneratingImage = true // Iniciar generación de imagen
        
        var request = URLRequest(url: url)
        request.httpMethod = isInitialRequest ? "POST" : "GET"
        request.addValue("Bearer user:807-hbo5l6k1Mv4rh7ApIcWFR", forHTTPHeaderField: "Authorization")
        
        if isInitialRequest {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let requestBody: [String: Any] = [
                "prompt": prompt,
                "jobid": jobID,
                "button": button,
                "discord": "MTE3ODgxNDkyMjM0MDE3NTkxNQ.GecmlV.3CjdjJBZLv7boAYim73QzDRRDtRR5qUCCxvUmw",
                "maxJobs": 3,
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.isLoading = false
                    self.isGeneratingImage = false // Finalizar generación de imagen
                    self.updateImageGeneratingState()
                    return
                }
                
                guard let data = data else {
                    self.isLoading = false
                    self.isGeneratingImage = false // Finalizar generación de imagen
                    self.updateImageGeneratingState()
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    if isInitialRequest, let jobID = jsonResponse?["jobid"] as? String {
                        self.jobID = jobID
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                            self.checkJobStatus1(shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage, prompt: prompt, completion: completion)
                        }
                    } else if let status = jsonResponse?["status"] as? String {
                        if status == "completed", let attachments = jsonResponse?["attachments"] as? [[String: Any]], let firstAttachment = attachments.first, let imageUrlString = firstAttachment["url"] as? String {
                            self.loadImage(from: imageUrlString) { loadedImage in
                                if let image = loadedImage {
                                    self.processLoadedImage1(image, shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage, imageUrl: imageUrlString, prompt: prompt, completion: completion)
                                    self.saveImageDetailsToFirestore(imageUrl: imageUrlString, prompt: prompt, jobID: jobID)
                                    self.uploadImageDetails(imageUrl: imageUrlString, prompt: prompt)
                                    
                                    self.isGeneratingImage = false // Finalizar generación de imagen
                                    self.updateImageGeneratingState()
                                }
                            }
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                                self.checkJobStatus1(shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage, prompt: prompt, completion: completion)
                            }
                        }
                    }
                    
                    // Procesar el array children
                    if let children = jsonResponse?["children"] as? [[String: Any]] {
                        for child in children {
                            if let button = child["button"] as? String, let childJobID = child["jobid"] as? String {
                                print("Button: \(button), JobID: \(childJobID)")
                                // Almacenar o utilizar el button y childJobID según sea necesario
                            }
                        }
                    }
                    
                } catch {
                    self.isLoading = false
                    self.isGeneratingImage = false // Finalizar generación de imagen
                    self.updateImageGeneratingState()
                }
            }
        }.resume()
    }
    func updateImageGeneratingState1() {
        DispatchQueue.main.async {
            self.isAnyImageGenerating = !self.creatingImageIndices.isEmpty
            print("Estado de generación de imágenes actualizado: \(self.isAnyImageGenerating)")
        }
    }

    
   
    
    func checkJobStatus1(shouldUpdateUI: Bool, placeholderImage: GridImage?, prompt: String, completion: (() -> Void)? = nil) {
        guard let jobID = self.jobID else { return }
        let statusCheckURL = "https://api.useapi.net/v2/jobs/?jobid=\(jobID)"
        makeRequest(urlString: statusCheckURL, isInitialRequest: false, button: "", jobID: jobID, shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage, prompt: prompt, completion: completion)
    }
    
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.isLoading = false
                completion(nil)
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let data = data, let uiImage = UIImage(data: data) {
                    completion(uiImage)
                } else {
                    self.isLoading = false
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func removeCreatingImageIndex(for jobID: String) {
        if let index = allGridImages.firstIndex(where: { $0.jobID == jobID }) {
            creatingImageIndices.remove(index)
        }
    }
    
    func processLoadedImage1(_ image: UIImage, shouldUpdateUI: Bool, placeholderImage: GridImage?, imageUrl: String, prompt: String, source: String = "Local", completion: (() -> Void)? = nil) {
        if let jobID = self.jobID {
            self.combineImagesIntoGrid1(image, prompt: prompt, source: source, jobID: jobID)
            DispatchQueue.global().async {
                self.saveImageDetailsToFirestore(imageUrl: imageUrl, prompt: prompt, jobID: jobID)
                DispatchQueue.main.async {
                    self.imageCounter.incrementCounter() // Incrementa el contador cuando la imagen se procesa y guarda exitosamente
                    self.uploadImageDetails(imageUrl: imageUrl, prompt: prompt)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.isLoading = false
            isGeneratingVariation = false // Resetear aquí al completar
            if shouldUpdateUI {
                self.replacePlaceholderImage(placeholderImage, with: image)
                self.sortImagesByDate()
                if let index = self.allGridImages.firstIndex(where: { $0.jobID == placeholderImage?.jobID }) {
                    self.creatingImageIndices.remove(index)  // Eliminar el índice del conjunto
                    self.removeCreatingImageIndex(for: placeholderImage?.jobID ?? "") // Llamada para eliminar el índice
                    self.allGridImages[index].isUpscaling = false // Actualizar estado de upscaling
                    self.allGridImages[index].prompt += " -Variations (Strong)" // Añadir el texto "Variations (Strong)" al prompt
                }
            }
            completion?()  // Llamar a la callback al finalizar
        }
    }


    
    
    
    func combineImagesIntoGrid1(_ image: UIImage, prompt: String, source: String, jobID: String, timestamp: Date = Date()) {
        let swiftImage = SwiftImage.Image<RGBA<UInt8>>(uiImage: image)
        let size = CGSize(width: swiftImage.width / 2, height: swiftImage.height / 2)
        var images: [UIImage] = []
        
        for y in 0..<2 {
            for x in 0..<2 {
                let startX = x * Int(size.width)
                let startY = y * Int(size.height)
                let slice = swiftImage[startX..<(startX + Int(size.width)), startY..<(startY + Int(size.height))].uiImage
                images.append(slice)
            }
        }
        
        DispatchQueue.main.async {
            // Verificar si ya existe una imagen con el mismo jobID
            if !self.allGridImages.contains(where: { $0.jobID == jobID }) {
                if let index = self.allGridImages.firstIndex(where: { $0.images.isEmpty }) {
                    self.allGridImages[index].images = images
                    self.allGridImages[index].jobID = jobID // Asigna el jobID a la imagen existente
                } else {
                    // let gridImage = GridImage(images: images, prompt: prompt, source: source, timestamp: timestamp, jobID: jobID)
                    // self.allGridImages.append(gridImage)
                    // self.allPrompts.append(prompt)
                }
                self.sortImagesByDate()
            }
        }
    }
    
    
    
    func replacePlaceholderImage(_ placeholderImage: GridImage?, with image: UIImage) {
        guard let placeholderImage = placeholderImage else { return }
        DispatchQueue.main.async {
            if self.allGridImages.contains(where: { $0.jobID == placeholderImage.jobID }) {
                return
            }
            if let index = self.allGridImages.firstIndex(of: placeholderImage) {
                let swiftImage = SwiftImage.Image<RGBA<UInt8>>(uiImage: image)
                let size = CGSize(width: swiftImage.width / 2, height: swiftImage.height / 2)
                var images: [UIImage] = []
                for y in 0..<2 {
                    for x in 0..<2 {
                        let startX = x * Int(size.width)
                        let startY = y * Int(size.height)
                        let slice = swiftImage[startX..<(startX + Int(size.width)), startY..<(startY + Int(size.height))].uiImage
                        images.append(slice)
                    }
                }
                self.allGridImages.remove(at: index)
                let newGridImage = GridImage(images: images, prompt: placeholderImage.prompt, source: placeholderImage.source, timestamp: placeholderImage.timestamp, jobID: placeholderImage.jobID)
                self.allGridImages.append(newGridImage)
                self.sortImagesByDate()
            }
        }
    }
    
    
    
    func makeButtonRequestForU(urlString: String, isInitialRequest: Bool, button: String, jobID: String, shouldUpdateUI: Bool, placeholderImage: GridImage?, completion: (() -> Void)? = nil) {
        guard let url = URL(string: urlString) else {
            print("URL inválida: \(urlString)")
            self.isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isInitialRequest ? "POST" : "GET"
        request.addValue("Bearer user:807-hbo5l6k1Mv4rh7ApIcWFR", forHTTPHeaderField: "Authorization")
        
        if isInitialRequest {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let requestBody: [String: Any] = [
                "prompt": prompt,
                "jobid": jobID,
                "button": button,
                "discord": "MTE3ODgxNDkyMjM0MDE3NTkxNQ.GecmlV.3CjdjJBZLv7boAYim73QzDRRDtRR5qUCCxvUmw",
                "maxJobs": 3,
                "replyUrl": "https://us-central1-image-creator-ai-a958f.cloudfunctions.net/receiveImageUrl",
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
            print("Enviando solicitud inicial para el botón: \(button) con body: \(requestBody)")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error en la solicitud: \(error.localizedDescription)")
                    self.isLoading = false
                    completion?()
                    return
                }
                
                guard let data = data else {
                    print("No se recibieron datos en la respuesta")
                    self.isLoading = false
                    completion?()
                    return
                }
                
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        print("Respuesta JSON recibida: \(String(describing: jsonResponse))")
                        
                        if isInitialRequest, let jobID = jsonResponse["jobid"] as? String {
                            self.jobID = jobID
                            print("Job ID obtenido: \(jobID)")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                                self.checkButtonJobStatusForU(shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage)
                            }
                        } else if let status = jsonResponse["status"] as? String, status == "completed", let attachments = jsonResponse["attachments"] as? [[String: Any]], let firstAttachment = attachments.first, let imageUrlString = firstAttachment["url"] as? String {
                            self.loadImage(from: imageUrlString) { loadedImage in
                                if let image = loadedImage {
                                    self.processButtonLoadedImageForU(image, shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage, imageUrl: imageUrlString, jobID: jobID, jsonResponse: jsonResponse)
                                }
                            }
                        } else if let error = jsonResponse["error"] as? String, error.contains("Button \(button) already executed by job") {
                            if let existingJobID = error.components(separatedBy: "job ").last {
                                self.jobID = existingJobID
                                print("Job ID existente recuperado: \(existingJobID)")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                                    self.checkButtonJobStatusForU(shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage)
                                }
                            }
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                                self.checkButtonJobStatusForU(shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage)
                            }
                        }
                    }
                } catch {
                    print("Error al deserializar JSON: \(error.localizedDescription)")
                    self.isLoading = false
                    completion?()
                }
            }
        }.resume()
    }
    
    
    
    func checkButtonJobStatusForU(shouldUpdateUI: Bool, placeholderImage: GridImage?) {
        guard let jobID = self.jobID else {
            print("No hay jobID disponible")
            return
        }
        let statusCheckURL = "https://api.useapi.net/v2/jobs/?jobid=\(jobID)"
        makeButtonRequestForU(urlString: statusCheckURL, isInitialRequest: false, button: "", jobID: jobID, shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage)
    }
    
    func processButtonLoadedImageForU(_ image: UIImage, shouldUpdateUI: Bool, placeholderImage: GridImage?, imageUrl: String, jobID: String, jsonResponse: [String: Any]) {
        DispatchQueue.main.async {
            self.isLoading = false
            if shouldUpdateUI {
                if let placeholderImage = placeholderImage, let index = self.allGridImages.firstIndex(of: placeholderImage) {
                    self.allGridImages[index].images = [image]
                    self.allGridImages[index].source = "Button U"
                    self.allGridImages[index].jobID = self.jobID ?? jobID
                    self.allGridImages[index].isImageLoaded = true
                    self.allGridImages[index].isUpscaling = false // Actualizar estado de upscaling
                    
                    // Procesar el array children
                    if let children = jsonResponse["children"] as? [[String: Any]] {
                        for child in children {
                            if let button = child["button"] as? String, let childJobID = child["jobid"] as? String {
                                print("Button: \(button), JobID: \(childJobID)")
                                // Almacenar o utilizar el button y childJobID según sea necesario
                            }
                        }
                    }
                    
                    // Remover el índice de creatingImageIndices
                    self.creatingImageIndices.remove(index)
                }
                self.sortImagesByDate()
            } else {
                print("Imagen procesada pero no añadida a la interfaz de usuario")
            }
            DispatchQueue.main.async {
                self.imageCounter.incrementCounter()
                //  self.saveImageDetailsToFirestore(imageUrl: imageUrl, promptText: placeholderImage?.prompt ?? "unknown", jobID: jobID)
            }
            self.updateImageGenerationState3() // Actualizar el estado de generación de imagen
        }
    }
    func u1ButtonTapped(index: Int) {
        guard canSendNewURequest && canSendURequestAfterV && !isAnyImageGenerating else {
            print("No se puede enviar el prompt. Espere \(timeRemainingForNewURequest) segundos o termine de generarse la imagen actual.")
            return
        }
        
        if index < allGridImages.count && allGridImages[index].images.count > 0 {
            var gridImage = allGridImages[index]
            let newSelectedImage = allGridImages[index]
            
            // Generar un nuevo prompt solo para el placeholder sin modificar el original
            let newPrompt = gridImage.prompt.components(separatedBy: " - Image #").first! + " - Image #1"
            
            gridImage.isU1Selected = true
            gridImage.uButtonStates["U1"] = true // Actualizar el estado del botón U1
            
            // Crear una nueva imagen placeholder con isUpscaling = true
            let placeholderImage = GridImage(images: [], prompt: newPrompt, source: "Button U", timestamp: Date(), jobID: newSelectedImage.jobID, isUpscaling: true, uButtonStates: [:])
            self.allGridImages.append(placeholderImage) // Añadir al final de la lista
            isGeneratingImage = true
            print("Botón U1 presionado, prompt generado: \(newPrompt)")
            makeRequestForImageGeneration(button: "U1", jobID: newSelectedImage.jobID, prompt: newPrompt, shouldUpdateUI: true, placeholderImage: placeholderImage) {
                self.isGeneratingImage = false // Permitir de nuevo la interacción
                self.updateImageGenerationState3() // Actualizar el estado de generación de imagen
            }
            allGridImages[index] = gridImage // Actualizar el estado de allGridImages
            print("Estado de allGridImages actualizado en index: \(index)")
        }
        
        startURequestTimer()
        print("Temporizador de solicitud U iniciado")
    }

    func u2ButtonTapped(index: Int) {
        guard canSendNewURequest && canSendURequestAfterV && !isAnyImageGenerating else {
            print("No se puede enviar el prompt. Espere \(timeRemainingForNewURequest) segundos o termine de generarse la imagen actual.")
            return
        }
        
        if index < allGridImages.count && allGridImages[index].images.count > 1 {
            var gridImage = allGridImages[index]
            let newSelectedImage = allGridImages[index]
            
            // Generar un nuevo prompt solo para el placeholder sin modificar el original
            let newPrompt = gridImage.prompt.components(separatedBy: " - Image #").first! + " - Image #2"
            
            gridImage.isU2Selected = true
            gridImage.uButtonStates["U2"] = true // Actualizar el estado del botón U2
            
            // Crear una nueva imagen placeholder con isUpscaling = true
            let placeholderImage = GridImage(images: [], prompt: newPrompt, source: "Button U", timestamp: Date(), jobID: newSelectedImage.jobID, isUpscaling: true, uButtonStates: [:])
            self.allGridImages.append(placeholderImage) // Añadir al final de la lista
            isGeneratingImage = true
            makeRequestForImageGeneration(button: "U2", jobID: newSelectedImage.jobID, prompt: newPrompt, shouldUpdateUI: true, placeholderImage: placeholderImage) {
                self.isGeneratingImage = false // Permitir de nuevo la interacción
                self.updateImageGenerationState3() // Actualizar el estado de generación de imagen
            }
            allGridImages[index] = gridImage // Actualizar el estado de allGridImages
        }
        
        startURequestTimer()
    }

    func u3ButtonTapped(index: Int) {
        guard canSendNewURequest && canSendURequestAfterV && !isAnyImageGenerating else {
            print("No se puede enviar el prompt. Espere \(timeRemainingForNewURequest) segundos o termine de generarse la imagen actual.")
            return
        }
        
        if index < allGridImages.count && allGridImages[index].images.count > 2 {
            var gridImage = allGridImages[index]
            let newSelectedImage = allGridImages[index]
            
            // Generar un nuevo prompt solo para el placeholder sin modificar el original
            let newPrompt = gridImage.prompt.components(separatedBy: " - Image #").first! + " - Image #3"
            
            gridImage.isU3Selected = true
            gridImage.uButtonStates["U3"] = true // Actualizar el estado del botón U3
            
            // Crear una nueva imagen placeholder con isUpscaling = true
            let placeholderImage = GridImage(images: [], prompt: newPrompt, source: "Button U", timestamp: Date(), jobID: newSelectedImage.jobID, isUpscaling: true, uButtonStates: [:])
            self.allGridImages.append(placeholderImage) // Añadir al final de la lista
            isGeneratingImage = true
            makeRequestForImageGeneration(button: "U3", jobID: newSelectedImage.jobID, prompt: newPrompt, shouldUpdateUI: true, placeholderImage: placeholderImage) {
                self.isGeneratingImage = false // Permitir de nuevo la interacción
                self.updateImageGenerationState3() // Actualizar el estado de generación de imagen
            }
            allGridImages[index] = gridImage // Actualizar el estado de allGridImages
        }
        
        startURequestTimer()
    }

    func u4ButtonTapped(index: Int) {
        guard canSendNewURequest && canSendURequestAfterV && !isAnyImageGenerating else {
            print("No se puede enviar el prompt. Espere \(timeRemainingForNewURequest) segundos o termine de generarse la imagen actual.")
            return
        }
        
        if index < allGridImages.count && allGridImages[index].images.count > 3 {
            var gridImage = allGridImages[index]
            let newSelectedImage = allGridImages[index]
            
            // Generar un nuevo prompt solo para el placeholder sin modificar el original
            let newPrompt = gridImage.prompt.components(separatedBy: " - Image #").first! + " - Image #4"
            
            gridImage.isU4Selected = true
            gridImage.uButtonStates["U4"] = true // Actualizar el estado del botón U4
            
            // Crear una nueva imagen placeholder con isUpscaling = true
            let placeholderImage = GridImage(images: [], prompt: newPrompt, source: "Button U", timestamp: Date(), jobID: newSelectedImage.jobID, isUpscaling: true, uButtonStates: [:])
            self.allGridImages.append(placeholderImage) // Añadir al final de la lista
            isGeneratingImage = true
            makeRequestForImageGeneration(button: "U4", jobID: newSelectedImage.jobID, prompt: newPrompt, shouldUpdateUI: true, placeholderImage: placeholderImage) {
                self.isGeneratingImage = false // Permitir de nuevo la interacción
                self.updateImageGenerationState3() // Actualizar el estado de generación de imagen
            }
            allGridImages[index] = gridImage // Actualizar el estado de allGridImages
        }
        
        startURequestTimer()
    }

    // Temporizador adicional para los botones U
    func startURequestTimer1() {
        canSendURequestAfterV = false
        Timer.scheduledTimer(withTimeInterval: 15.0, repeats: false) { timer in
            canSendURequestAfterV = true
        }
    }

    
    
  
    
    func replacePlaceholderImage1(_ placeholderImage: GridImage?, with image: UIImage) {
        guard let placeholderImage = placeholderImage else { return }
        if let index = self.allGridImages.firstIndex(of: placeholderImage) {
            // Elimina la imagen de placeholder
            self.allGridImages.remove(at: index)
            
            // Añade la nueva imagen al principio de la lista para que aparezca más arriba
            let newGridImage = GridImage(images: [image], prompt: placeholderImage.prompt, source: placeholderImage.source, timestamp: placeholderImage.timestamp, jobID: placeholderImage.jobID)
            
            // Inserta la nueva imagen al principio de la lista
            self.allGridImages.insert(newGridImage, at: 0)
            self.sortImagesByDate() // Ordenar las imágenes por fecha después de añadir una nueva imagen
        }
    }
    
    func startRequestTimer() {
        self.canSendNewRequest = false
        self.timeRemainingForNewRequest = 30
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.timeRemainingForNewRequest > 0 {
                self.timeRemainingForNewRequest -= 1
            } else {
                timer.invalidate()
                self.canSendNewRequest = true
            }
        }
    }
    
   

    

    func makeRequestForRedo(urlString: String, isInitialRequest: Bool, button: String, jobID: String, shouldUpdateUI: Bool, placeholderImage: GridImage?, completion: (() -> Void)? = nil) {
        guard let url = URL(string: urlString) else {
            print("URL inválida: \(urlString)")
            self.isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isInitialRequest ? "POST" : "GET"
        request.addValue("Bearer user:807-hbo5l6k1Mv4rh7ApIcWFR", forHTTPHeaderField: "Authorization")
        
        if isInitialRequest {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let requestBody: [String: Any] = [
                "jobid": jobID,
                "button": button,
                "discord": "MTE3ODgxNDkyMjM0MDE3NTkxNQ.GecmlV.3CjdjJBZLv7boAYim73QzDRRDtRR5qUCCxvUmw",
                "maxJobs": 3,
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
            print("Enviando solicitud inicial para el botón: \(button)")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error en la solicitud: \(error.localizedDescription)")
                    self.isLoading = false
                    completion?()
                    return
                }
                
                guard let data = data else {
                    print("No se recibieron datos en la respuesta")
                    self.isLoading = false
                    completion?()
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    
                    if isInitialRequest, let jobID = jsonResponse?["jobid"] as? String {
                        self.jobID = jobID
                        print("Job ID obtenido: \(jobID)")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.checkJobStatusForRedo(shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage)
                        }
                    } else if let status = jsonResponse?["status"] as? String, status == "completed", let attachments = jsonResponse?["attachments"] as? [[String: Any]], let firstAttachment = attachments.first, let imageUrlString = firstAttachment["url"] as? String {
                        self.loadImage(from: imageUrlString) { loadedImage in
                            if let image = loadedImage {
                                self.processLoadedImageForRedo(image, shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage)
                            }
                        }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.checkJobStatusForRedo(shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage)
                        }
                    }
                } catch {
                    print("Error al deserializar JSON: \(error.localizedDescription)")
                    self.isLoading = false
                    completion?()
                }
            }
        }.resume()
    }
    
    func checkJobStatusForRedo(shouldUpdateUI: Bool, placeholderImage: GridImage?) {
        guard let jobID = self.jobID else { return }
        let statusCheckURL = "https://api.useapi.net/v2/jobs/?jobid=\(jobID)"
        makeRequestForRedo(urlString: statusCheckURL, isInitialRequest: false, button: "", jobID: jobID, shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage)
    }
    
    func processLoadedImageForRedo(_ image: UIImage, shouldUpdateUI: Bool, placeholderImage: GridImage?) {
        DispatchQueue.main.async {
            self.isLoading = false
            if shouldUpdateUI {
                if let placeholderImage = placeholderImage, let index = self.allGridImages.firstIndex(of: placeholderImage) {
                    self.allGridImages[index].images = [image]
                    self.allGridImages[index].source = "Redo Upscale"
                    self.allGridImages[index].jobID = self.jobID ?? UUID().uuidString
                    self.allGridImages[index].isImageLoaded = true // Imagen cargada
                    self.allGridImages[index].isUpscaling = false // Actualizar estado de upscaling
                    self.creatingImageIndices.remove(index)
                }
                self.sortImagesByDate()
            } else {
                print("Imagen procesada pero no añadida a la interfaz de usuario")
            }
            DispatchQueue.main.async {
                self.imageCounter.incrementCounter()
            }
            self.updateImageGenerationState3() // Actualizar el estado de generación de imagen
        }
    }
    
    
    func replacePlaceholderImage2(_ placeholderImage: GridImage?, with image: UIImage) {
        guard let placeholderImage = placeholderImage else { return }
        if let index = self.allGridImages.firstIndex(of: placeholderImage) {
            // Elimina la imagen de placeholder
            self.allGridImages.remove(at: index)
            
            // Añade la nueva imagen al principio de la lista para que aparezca más arriba
            let newGridImage = GridImage(images: [image], prompt: placeholderImage.prompt, source: placeholderImage.source, timestamp: placeholderImage.timestamp, jobID: placeholderImage.jobID)
            
            // Inserta la nueva imagen al principio de la lista
            self.allGridImages.insert(newGridImage, at: 0)
            self.sortImagesByDate() // Ordenar las imágenes por fecha después de añadir una nueva imagen
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func blendImages(selectedImages: [UIImage]) {
        print("blendImages called with \(selectedImages.count) images")
        guard selectedImages.count > 0 else {
            print("No images selected")
            return
        }
        
        let placeholderImage = GridImage(images: [], prompt: "Creating image", source: "Blend", timestamp: Date(), jobID: UUID().uuidString, isCreatingImage: true)
        self.allGridImages.append(placeholderImage)
        
        
        let dispatchGroup = DispatchGroup()
        var uploadedImageUrls: [String] = []
        
        for image in selectedImages {
            dispatchGroup.enter()
            uploadImageToFirestore(image: image) { url in
                if let url = url {
                    print("Image uploaded to Firestore with URL: \(url)")
                    uploadedImageUrls.append(url)
                } else {
                    print("Failed to upload image to Firestore")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            guard uploadedImageUrls.count == selectedImages.count else {
                print("Not all images were uploaded successfully")
                self.isLoading = false
                return
            }
            print("All images uploaded successfully, URLs: \(uploadedImageUrls)")
            self.makeRequestForImageGeneration(blendUrls: uploadedImageUrls)
        }
    }
    
    
    
    
    
    
    func uploadImageToFirestore(image: UIImage, completion: @escaping (String?) -> Void) {
        print("uploadImageToFirestore called")
        let uniqueID = UUID().uuidString
        let storageRef = Storage.storage().reference().child("images/\(uniqueID).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert UIImage to JPEG data")
            completion(nil)
            return
        }
        
        print("Uploading image data to Firestore Storage at path: images/\(uniqueID).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image to Firestore: \(error.localizedDescription)")
                completion(nil)
                return
            }
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL from Firestore: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                guard let downloadURL = url else {
                    print("Download URL is nil")
                    completion(nil)
                    return
                }
                print("Download URL obtained: \(downloadURL.absoluteString)")
                completion(downloadURL.absoluteString)
            }
        }
    }
    
    func makeRequestForImageGeneration(blendUrls: [String]) {
        print("makeRequestForImageGeneration called with blendUrls: \(blendUrls)")
        let blendRequestURL = "https://api.useapi.net/v2/jobs/blend"
        guard let url = URL(string: blendRequestURL) else {
            print("Invalid URL: \(blendRequestURL)")
            self.isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer user:807-hbo5l6k1Mv4rh7ApIcWFR", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let requestBody: [String: Any] = [
            "blendUrls": blendUrls,
            "blendDimensions": "Square",
            "discord": "MTE3ODgxNDkyMjM0MDE3NTkxNQ.GecmlV.3CjdjJBZLv7boAYim73QzDRRDtRR5qUCCxvUmw",
            "server": "1178973180602363974",
            "channel": "1178973181046952008",
            "replyUrl": "https://us-central1-image-creator-ai-a958f.cloudfunctions.net/receiveImageUrl",
            "maxJobs": 3
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        print("Request body: \(requestBody)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error in request: \(error.localizedDescription)")
                    self.isLoading = false
                    return
                }
                
                guard let data = data else {
                    print("No data received in response")
                    self.isLoading = false
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let jobID = jsonResponse?["jobid"] as? String {
                        self.jobID = jobID
                        print("Job ID obtained: \(jobID)")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                            self.checkJobStatus3()
                        }
                    } else {
                        print("Job ID not found in response")
                        self.isLoading = false
                    }
                } catch {
                    print("Error deserializing JSON: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }
        }.resume()
    }
    
    func checkJobStatus3() {
        print("checkJobStatus3 called")
        guard let jobID = jobID else {
            print("No job ID available")
            return
        }
        
        let statusCheckURL = "https://api.useapi.net/v2/jobs/?jobid=\(jobID)"
        print("Checking job status at URL: \(statusCheckURL)")
        makeRequest(urlString: statusCheckURL, isInitialRequest: false, prompt: "")
    }
    
    func loadImage3(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        print("loadImage3 called with URL: \(urlString)")
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            DispatchQueue.main.async {
                self.isLoading = false
                completion(nil)
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                    self.isLoading = false
                    completion(nil)
                    return
                }
                
                guard let data = data, let uiImage = UIImage(data: data) else {
                    print("Failed to load image data")
                    self.isLoading = false
                    completion(nil)
                    return
                }
                
                print("Image loaded successfully from URL: \(urlString)")
                self.uploadImageDetails(imageUrl: urlString, prompt: "Imagen generada automáticamente")
                completion(uiImage)
            }
        }.resume()
    }
    
    func processLoadedImage3(_ image: UIImage, imageUrl: String, prompt: String, source: String = "Local") {
        print("processLoadedImage3 called with imageUrl: \(imageUrl), prompt: \(prompt), source: \(source)")
        self.locallyGeneratedImages.insert(imageUrl)
        
        if let jobID = self.jobID {
            self.combineImagesIntoGrid3(image, prompt: prompt, source: source, jobID: jobID)
            DispatchQueue.global().async {
                self.saveImageDetailsToFirestore(imageUrl: imageUrl, prompt: prompt, jobID: jobID)
            }
        }
        
        self.isLoading = false
        self.prompt = ""
        self.canSendNewRequest = true
        self.isGeneratingImages = false
    }
    
    func combineImagesIntoGrid3(_ image: UIImage, prompt: String, source: String, timestamp: Date = Date(), jobID: String) {
        print("combineImagesIntoGrid3 called with jobID: \(jobID), prompt: \(prompt), source: \(source), timestamp: \(timestamp)")
        let swiftImage = SwiftImage.Image<RGBA<UInt8>>(uiImage: image)
        let size = CGSize(width: swiftImage.width / 2, height: swiftImage.height / 2)
        var images: [UIImage] = []
        
        for y in 0..<2 {
            for x in 0..<2 {
                let startX = x * Int(size.width)
                let startY = y * Int(size.height)
                let slice = swiftImage[startX..<(startX + Int(size.width)), startY..<(startY + Int(size.height))].uiImage
                images.append(slice)
            }
        }
        
        DispatchQueue.main.async {
            if !self.allGridImages.contains(where: { $0.jobID == jobID && $0.prompt == prompt }) {
                if let index = self.allGridImages.firstIndex(where: { $0.images.isEmpty }) {
                    self.allGridImages[index].images = images
                    self.allGridImages[index].jobID = jobID
                    self.allGridImages[index].showButtons = false
                } else {
                    //   let gridImage = GridImage(images: images, prompt: prompt, source: source, timestamp: timestamp, jobID: jobID)
                    //   self.allGridImages.append(gridImage)
                    //   self.allPrompts.append(prompt)
                }
                self.sortImagesByDate()
                print("Images combined into grid successfully")
            } else {
                print("Grid image with jobID \(jobID) already exists")
            }
        }
    }
    
    func uploadImageDetails1(imageUrl: String, prompt: String) {
        print("uploadImageDetails called with imageUrl: \(imageUrl), prompt: \(prompt)")
        let db = Firestore.firestore()
        
        let imageData: [String: Any] = [
            "url": imageUrl,
            "prompt": prompt,  // Guarda el prompt correcto
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        db.collection("images").addDocument(data: imageData) { error in
            if let error = error {
                print("Error al guardar los detalles de la imagen: \(error.localizedDescription)")
            } else {
                print("Detalles de la imagen guardados exitosamente")
            }
        }
    }
    
    
    
    func translateTextWithGoogleAPI(_ text: String, completion: @escaping (String) -> Void) {
        let apiKey = "AIzaSyBAmp9Zum69ve0ciU6cOnvRt-JE6rBe3zg"  // Reemplaza con tu clave API real
        print("API Key utilizada para traducción: \(apiKey)")

        guard let url = URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(apiKey)") else {
            print("Error: URL inválida para la API de traducción.")
            return
        }
        print("URL de la API de traducción: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("Encabezados de la solicitud configurados.")

        let requestBody: [String: Any] = ["q": text, "target": "en"]
        print("Cuerpo de la solicitud para traducción: \(requestBody)")

        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error de traducción: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(text)  // En caso de error, retorna el texto original
                }
                return
            }
            
            print("Respuesta recibida de la API de traducción.")
            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP: \(httpResponse.statusCode)")
            }

            guard let data = data else {
                print("Error: No se recibió ningún dato.")
                DispatchQueue.main.async {
                    completion(text)
                }
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("Respuesta JSON de la API: \(jsonResponse)")
                    
                    if let responseData = jsonResponse["data"] as? [String: Any],
                       let translations = responseData["translations"] as? [[String: Any]],
                       let firstTranslation = translations.first,
                       let translatedText = firstTranslation["translatedText"] as? String {
                        print("Texto traducido: \(translatedText)")
                        DispatchQueue.main.async {
                            completion(translatedText)
                        }
                    } else {
                        print("Error: La respuesta JSON no contiene los datos esperados.")
                        DispatchQueue.main.async {
                            completion(text)
                        }
                    }
                }
            } catch {
                print("Error al procesar la respuesta de traducción: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(text)
                }
            }
        }.resume()
    }

    func detectLanguage(_ text: String, completion: @escaping (Bool) -> Void) {
        let apiKey = "AIzaSyBAmp9Zum69ve0ciU6cOnvRt-JE6rBe3zg"  // Reemplaza con tu clave API real
        print("API Key utilizada para detección de idioma: \(apiKey)")

        guard let url = URL(string: "https://translation.googleapis.com/language/translate/v2/detect?key=\(apiKey)") else {
            print("URL inválida para la API de Google Translate.")
            completion(false)
            return
        }
        print("URL de la API de detección de idioma: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("Encabezados de la solicitud configurados.")

        let requestBody: [String: Any] = ["q": text]
        print("Cuerpo de la solicitud para detección de idioma: \(requestBody)")

        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error en la detección del idioma: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }

            print("Respuesta recibida de la API de detección de idioma.")
            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP: \(httpResponse.statusCode)")
            }

            guard let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("Error: No se recibió ningún dato o la respuesta JSON no es válida.")
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }

            print("Respuesta JSON de la API: \(jsonResponse)")
            
            if let dataResponse = jsonResponse["data"] as? [String: Any],
               let detections = dataResponse["detections"] as? [[Any]],
               let firstDetection = detections.first as? [[String: Any]],
               let detection = firstDetection.first,
               let language = detection["language"] as? String {
                print("Idioma detectado: \(language)")
                DispatchQueue.main.async {
                    completion(language == "en")
                }
            } else {
                print("Error: La respuesta JSON no contiene los datos esperados.")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }.resume()
    }

    func analyzeTextAndGenerateImages(text: String, completion: @escaping (Bool) -> Void) {
        let apiKey = "AIzaSyBAmp9Zum69ve0ciU6cOnvRt-JE6rBe3zg"  // Reemplaza con tu clave API real
        print("API Key utilizada para análisis de texto: \(apiKey)")

        guard let url = URL(string: "https://commentanalyzer.googleapis.com/v1alpha1/comments:analyze?key=\(apiKey)") else {
            print("URL inválida.")
            completion(false)
            return
        }
        print("URL de la API de análisis de texto: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("Encabezados de la solicitud configurados.")

        let requestBody: [String: Any] = [
            "comment": ["text": text],
            "languages": ["en"],
            "requestedAttributes": [
                "SEVERE_TOXICITY": [:],
                "IDENTITY_ATTACK": [:],
                "INSULT": [:],
                "THREAT": [:],
                "SEXUALLY_EXPLICIT": [:]
            ]
        ]
        print("Cuerpo de la solicitud para análisis de texto: \(requestBody)")

        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error en la solicitud: \(error.localizedDescription)")
                completion(false)
                return
            }

            print("Respuesta recibida de la API de análisis de texto.")
            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP: \(httpResponse.statusCode)")
            }

            guard let data = data else {
                print("Error: No se recibió ningún dato.")
                completion(false)
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("Respuesta JSON de la API: \(jsonResponse)")

                    if let attributeScores = jsonResponse["attributeScores"] as? [String: Any] {
                        let isAppropriate = attributeScores.allSatisfy { attribute, _ in
                            if let score = attributeScores[attribute] as? [String: Any],
                               let summaryScore = score["summaryScore"] as? [String: Any],
                               let value = summaryScore["value"] as? Double {
                                print("Atributo \(attribute) con puntuación \(value)")
                                return value < 0.8  // Ejemplo: umbral de toxicidad < 0.8
                            }
                            return true
                        }
                        print("El contenido es apropiado: \(isAppropriate)")
                        completion(isAppropriate)
                    } else {
                        print("Error: La respuesta JSON no contiene los datos esperados.")
                        completion(false)
                    }
                }
            } catch {
                print("Error al procesar la respuesta: \(error.localizedDescription)")
                completion(false)
            }
        }.resume()
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func checkJobStatus(prompt: String) {
        guard let jobID = jobID else { return }
        let statusCheckURL = "https://api.useapi.net/v2/jobs/?jobid=\(jobID)"
        makeRequest(urlString: statusCheckURL, isInitialRequest: false, prompt: prompt)
    }

    func processLoadedImage(_ image: UIImage, imageUrl: String, prompt: String, source: String = "Local") {
        self.locallyGeneratedImages.insert(imageUrl)
        if let jobID = self.jobID {
            self.combineImagesIntoGrid(image, prompt: prompt, source: source, jobID: jobID)
            DispatchQueue.global().async {
                self.saveImageDetailsToFirestore(imageUrl: imageUrl, prompt: prompt, jobID: jobID)
                DispatchQueue.main.async {
                    self.imageCounter.incrementCounter()
                }
            }
        }
        self.isLoading = false
        self.prompt = ""
        self.canSendNewRequest = true
        self.isGeneratingImages = false
    }

    func combineImagesIntoGrid(_ image: UIImage, prompt: String, source: String, timestamp: Date = Date(), jobID: String) {
        let swiftImage = SwiftImage.Image<RGBA<UInt8>>(uiImage: image)
        let size = CGSize(width: swiftImage.width / 2, height: swiftImage.height / 2)
        var images: [UIImage] = []
        
        for y in 0..<2 {
            for x in 0..<2 {
                let startX = x * Int(size.width)
                let startY = y * Int(size.height)
                let slice = swiftImage[startX..<(startX + Int(size.width)), startY..<(startY + Int(size.height))].uiImage
                images.append(slice)
            }
        }
        
        DispatchQueue.main.async {
            if !self.allGridImages.contains(where: { $0.jobID == jobID }) {
                if let index = self.allGridImages.firstIndex(where: { $0.images.isEmpty }) {
                    self.allGridImages[index].images = images
                    self.allGridImages[index].jobID = jobID
                } else {
                    let gridImage = GridImage(images: images, prompt: prompt, source: source, timestamp: timestamp, jobID: jobID)
                    self.allGridImages.append(gridImage)
                    self.allPrompts.append(prompt)
                }
                self.sortImagesByDate()
            }
        }
    }
}

                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
        import SwiftUI



            import PencilKit





            struct DrawingCanvas: UIViewRepresentable {



                @Binding var canvasView: PKCanvasView



                var image: UIImage





                func makeUIView(context: Context) -> PKCanvasView {



                    canvasView.backgroundColor = .clear



                    canvasView.isOpaque = false



                    canvasView.drawingPolicy = .anyInput



                    canvasView.backgroundImage = image  // Establecer la imagen de fondo



                    return canvasView



                }





                func updateUIView(_ uiView: PKCanvasView, context: Context) {



                    // Actualizar la vista si es necesario



                }





                func makeCoordinator() -> Coordinator {



                    Coordinator(self)



                }





                class Coordinator: NSObject, PKCanvasViewDelegate {



                    var parent: DrawingCanvas





                    init(_ parent: DrawingCanvas) {



                        self.parent = parent



                        super.init()



                        parent.canvasView.delegate = self



                    }



                }



            }





            // Extensión para agregar una propiedad de imagen de fondo a PKCanvasView



            extension PKCanvasView {



                private struct AssociatedKeys {



                    static var backgroundImage = "backgroundImage"



                }





                var backgroundImage: UIImage? {



                    get {



                        return objc_getAssociatedObject(self, &AssociatedKeys.backgroundImage) as? UIImage



                    }



                    set {



                        objc_setAssociatedObject(self, &AssociatedKeys.backgroundImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)



                        if let image = newValue {



                            let imageView = UIImageView(image: image)



                            imageView.contentMode = .scaleAspectFit



                            addSubview(imageView)



                            sendSubviewToBack(imageView)



                            imageView.frame = bounds



                            imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]



                        }



                    }



                }



            }







import SwiftUI
import PencilKit
import CoreImage
import CoreImage.CIFilterBuiltins






import SwiftUI
import PencilKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            } else {
                // Manejar el caso en que el usuario no otorgue permiso
            }
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error al guardar la imagen: \(error.localizedDescription)")
        } else {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: nil, message: "Image saved successfully", preferredStyle: .alert)
                UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

struct DetailedImageView: View {
    var image: UIImage
    var gridPrompt: String
    
    @State private var isSharing = false
    @State private var isFullScreen = false
    @State private var isDrawingMode = false
    @State private var canvasView = PKCanvasView()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showActionSheet = false
    @State private var showPromptAlert = false
    @State private var hideButtons = false
    @State private var enhancedImage: UIImage?
    @State private var showDrawingView = false
    @State private var showImageSavedBanner = false
    @State private var showFeatureAlert = false
    
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Binding var showAIGodView: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                if !hideButtons {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 13, height: 13)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Button(action: {
                            self.showPromptAlert.toggle()
                        }) {
                            Image(systemName: "ellipsis")
                                .resizable()
                                .frame(width: 20, height: 5)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .background(Color.black.opacity(0.1))
                }
                
                if isFullScreen {
                    Image(uiImage: enhancedImage ?? image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.edgesIgnoringSafeArea(.all))
                        .onTapGesture {
                            self.isFullScreen.toggle()
                            self.hideButtons.toggle()
                        }
                } else {
                    Spacer()
                    
                    ZStack {
                        Image(uiImage: enhancedImage ?? image)
                            .resizable()
                            .scaledToFit()
                            .padding(.top, 20)
                            .onTapGesture {
                                self.isFullScreen.toggle()
                                self.hideButtons.toggle()
                            }
                        
                        if isDrawingMode {
                            CanvasView(canvasView: $canvasView, image: enhancedImage ?? image)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.clear)
                            
                            VStack {
                                Spacer()
                                HStack {
                                    Button(action: {
                                        //  saveDrawing()
                                        isDrawingMode = false
                                    }) {
                                        Text("Save")
                                            .padding()
                                            .background(Color.white)
                                            .foregroundColor(.black)
                                            .cornerRadius(8)
                                    }
                                    .padding(.leading)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        canvasView.drawing = PKDrawing()
                                    }) {
                                        Text("Delete")
                                            .padding()
                                            .background(Color.white)
                                            .foregroundColor(.black)
                                            .cornerRadius(8)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        isDrawingMode = false
                                    }) {
                                        Text("Back")
                                            .padding()
                                            .background(Color.white)
                                            .foregroundColor(.black)
                                            .cornerRadius(8)
                                    }
                                    .padding(.trailing)
                                }
                                .padding(.bottom)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    if !hideButtons {
                        HStack(spacing: 10) {
                            GeometryReader { geometry in
                                HStack(spacing: (geometry.size.width - 4 * 60) / 3) {
                                    VStack {
                                        Button(action: {
                                            if subscriptionManager.isSubscribed {
                                                isDrawingMode.toggle()
                                            } else {
                                                showFeatureAlert.toggle()
                                            }
                                        }) {
                                            Image("remix")
                                                .resizable()
                                                .frame(width: 22, height: 22)
                                                .foregroundColor(.white)
                                        }
                                        Text("Remix")
                                            .foregroundColor(.white)
                                            .font(.system(size: 14))
                                    }
                                    
                                    VStack {
                                        Button(action: {
                                            if subscriptionManager.isSubscribed {
                                                applyAutoEnhance()
                                            } else {
                                                showFeatureAlert.toggle()
                                            }
                                        }) {
                                            Image(systemName: "wand.and.stars")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.white)
                                        }
                                        Text("Magic Wand")
                                            .foregroundColor(.white)
                                            .font(.system(size: 14))
                                            .offset(y: -1.1)
                                    }
                                    
                                    VStack {
                                        Button(action: {
                                            saveImage()
                                        }) {
                                            Image("arrow1")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.white)
                                        }
                                        Text("Save")
                                            .foregroundColor(.white)
                                            .font(.system(size: 14))
                                            .offset(y: -1)
                                    }
                                    
                                    VStack {
                                        Button(action: {
                                            self.isSharing = true
                                        }) {
                                            Image("share")
                                                .resizable()
                                                .frame(width: 22, height: 22)
                                                .foregroundColor(.white)
                                        }
                                        Text("Share")
                                            .foregroundColor(.white)
                                            .font(.system(size: 14))
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                        .padding(.bottom, 18)
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .background(Color.black.opacity(1.0))
                        .sheet(isPresented: $isSharing) {
                            ActivityViewController(activityItems: [self.enhancedImage ?? self.image])
                        }
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Image Saved"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showFeatureAlert) {
                Alert(title: Text("This feature is only available for plus users"), message: Text(""), dismissButton: .default(Text("OK")))
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(isFullScreen ? .all : [])
            .overlay(
                showPromptAlert ? PromptAlert1(gridPrompt: gridPrompt, showPromptAlert: $showPromptAlert) : nil
            )
            
            if showImageSavedBanner {
                           GeometryReader { geometry in
                               VStack {
                                   Spacer()
                                   HStack {
                                       Text("Image saved")
                                           .font(.custom("SF Pro Text", size: 14))
                                           .foregroundColor(.white)
                                           .padding(.vertical, 8) // Aumentar el padding vertical para más altura
                                           .padding(.horizontal, 16)
                                           .background(Color(red: 38/255, green: 38/255, blue: 38/255))
                                           .cornerRadius(10)
                                           .frame(width: geometry.size.width * 4, alignment: .leading) // Set the banner width to 90% of the screen width
                                       Spacer()
                                   }
                                   .padding(.bottom, 70)
                               }
                               .transition(.move(edge: .bottom).combined(with: .opacity))
                               .animation(.easeInOut)
                               .onAppear {
                                   DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                       withAnimation {
                                           self.showImageSavedBanner = false
                                       }
                                   }
                               }
                           }
                       }
                   }
               }
    
    private func saveImage() {
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: enhancedImage ?? image)
    }

    private func applyAutoEnhance() {
        print("Iniciando proceso de mejora automática")
        
        guard let cgImage = image.cgImage else {
            print("No se pudo obtener cgImage de UIImage")
            return
        }
        print("cgImage obtenido exitosamente de UIImage")
        
        let ciImage = CIImage(cgImage: cgImage)
        print("Convertido cgImage a ciImage")
        
        let brightnessFilter = CIFilter.colorControls()
        brightnessFilter.inputImage = ciImage
        brightnessFilter.brightness = 0.1
        brightnessFilter.contrast = 1.2
        brightnessFilter.saturation = 1.3
        print("Filtro de control de color configurado con brillo: 0.1, contraste: 1.2, saturación: 1.3")
        
        let exposureFilter = CIFilter.exposureAdjust()
        exposureFilter.inputImage = brightnessFilter.outputImage
        exposureFilter.ev = 0.5
        print("Filtro de ajuste de exposición configurado con EV: 0.5")
        
        let sharpenFilter = CIFilter.sharpenLuminance()
        sharpenFilter.inputImage = exposureFilter.outputImage
        sharpenFilter.sharpness = 0.8
        print("Filtro de nitidez configurado con nitidez: 0.8")
        
        let vibranceFilter = CIFilter.vibrance()
        vibranceFilter.inputImage = sharpenFilter.outputImage
        vibranceFilter.amount = 0.7
        print("Filtro de vibrancia configurado con cantidad: 0.7")
        
        guard let outputImage = vibranceFilter.outputImage else {
            print("No se pudo obtener imagen de salida del filtro de vibrancia")
            return
        }
        print("Imagen de salida obtenida exitosamente del filtro de vibrancia")
        
        let context = CIContext()
        print("Contexto CIContext creado")
        
        if let cgOutputImage = context.createCGImage(outputImage, from: outputImage.extent) {
            enhancedImage = UIImage(cgImage: cgOutputImage)
            print("UIImage mejorada creada exitosamente")
        } else {
            print("No se pudo crear cgOutputImage desde CIContext")
        }
    }
}

struct PromptAlert1: View {
    var gridPrompt: String
    @Binding var showPromptAlert: Bool

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.showPromptAlert.toggle()
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                }
            }
            .padding()

            Text("Prompt")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .padding()

            ScrollView {
                Text(gridPrompt)
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .padding()
            }
            .padding()

            Spacer()

            Button(action: {
                UIPasteboard.general.string = gridPrompt
            }) {
                Text("Copy")
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 200, height: 50)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 2)
        .background(Color(UIColor.darkGray).opacity(0.9))
        .cornerRadius(15)
        .padding()
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    var image: UIImage

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .clear

        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}
struct SearchBar: View {
   var placeholder: String
   @Binding var text: String
   var action: () -> Void
   @Binding var isShowingImagePicker: Bool
   @Binding var selectedBlendImages: [UIImage]

   @State private var textFieldHeight: CGFloat = 20
   @State private var isFirstMessageSent: Bool = false  // Nuevo estado para controlar el cambio de placeholder

   var body: some View {
       GeometryReader { geometry in
           ZStack(alignment: .bottom) {
               VStack {
                   Spacer()
                       .frame(height: geometry.size.height * 1.08)
               }
               
               VStack(spacing: 0) {
                   if !selectedBlendImages.isEmpty {
                       VStack(spacing: 0) {
                           ScrollView(.horizontal, showsIndicators: false) {
                               HStack(spacing: 8) {
                                   ForEach(selectedBlendImages.indices, id: \.self) { index in
                                       ZStack(alignment: .topTrailing) {
                                           Image(uiImage: selectedBlendImages[index])
                                               .resizable()
                                               .frame(width: 80, height: 80)
                                               .cornerRadius(8)
                                               .overlay(
                                                   RoundedRectangle(cornerRadius: 8)
                                                       .stroke(Color.gray, lineWidth: 1)
                                               )
                                           
                                           Button(action: {
                                               selectedBlendImages.remove(at: index)
                                           }) {
                                               Image(systemName: "xmark.circle.fill")
                                                   .resizable()
                                                   .frame(width: 20, height: 20)
                                                   .background(Color.white)
                                                   .foregroundColor(Color.gray)
                                                   .clipShape(Circle())
                                           }
                                           .offset(x: -5, y: 5)
                                       }
                                   }
                               }
                               .padding(.horizontal, 8)
                           }
                           .padding(.bottom, 8)
                           .frame(height: 100)
                       }
                       .padding(.horizontal, 8)
                       .background(Color(white: 0.99))
                       .cornerRadius(8)
                       .overlay(
                           RoundedRectangle(cornerRadius: 8)
                               .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                       )
                       .padding(.bottom, 0)
                       .frame(width: geometry.size.width * 0.7)
                   }
                   
                   HStack(spacing: 12) {
                       Button(action: {
                           self.isShowingImagePicker = true
                           self.text = ""
                       }) {
                           Image("logoz")
                               .resizable()
                               .frame(width: 30, height: 30)
                               .foregroundColor(.blue)
                       }
                       .sheet(isPresented: $isShowingImagePicker) {
                           ImagePicker(selectedImages: self.$selectedBlendImages)
                               .onDisappear {
                                   if !selectedBlendImages.isEmpty {
                                       self.text = ""
                                   }
                               }
                       }
                       
                       VStack {
                           // Cambiar el placeholder dependiendo si es la primera vez o no
                           DynamicHeightTextField(
                               placeholder: isFirstMessageSent ? "message" : "describe your image",
                               text: $text,
                               minHeight: $textFieldHeight
                           )
                           .disabled(!selectedBlendImages.isEmpty)
                           .frame(minHeight: textFieldHeight)
                       }
                       .frame(height: textFieldHeight)
                       
                       Button(action: {
                           action()
                           selectedBlendImages.removeAll()
                           // Cambiar a 'message' después del primer mensaje
                           isFirstMessageSent = true
                       }) {
                           Image(systemName: "arrow.up.circle.fill")
                               .resizable()
                               .frame(width: 33, height: 33)
                               .foregroundColor(.black)
                               .background(Color.white)
                               .clipShape(Circle())
                       }
                   }
                   .padding(.horizontal, 8)
                   .padding(.vertical, 10)
                   .background(Color(white: 0.99))
                   .cornerRadius(20)
                   .frame(maxWidth: .infinity)
               }
               .padding(.horizontal, 8)
               .padding(.bottom, 20)
               .background(Color(white: 0.99))
           }
           .frame(width: geometry.size.width, height: geometry.size.height)
           .ignoresSafeArea(.keyboard, edges: .bottom)  // Evita que el teclado desplace la vista
           .gesture(DragGesture().onChanged { _ in
               UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
           })
       }
   }
}

extension View {
   func placeholder<Content: View>(
       when shouldShow: Bool,
       alignment: Alignment = .leading,
       @ViewBuilder placeholder: () -> Content
   ) -> some View {
       ZStack(alignment: alignment) {
           placeholder().opacity(shouldShow ? 1 : 0)
           self
       }
   }
}

struct DynamicHeightTextField: View {
   var placeholder: String
   @Binding var text: String
   @Binding var minHeight: CGFloat

   var body: some View {
       TextField("", text: $text, onEditingChanged: { _ in
           updateHeight()
       })
       .placeholder(when: text.isEmpty) {
           Text(placeholder)
               .foregroundColor(Color(white: 0.8))
               .font(.system(size: 16, weight: .medium))
       }
       .padding(.leading, 15)
       .padding(EdgeInsets(top: 5, leading: 8, bottom: 6, trailing: 8))
       .background(Color.white)
       .cornerRadius(20)
       .overlay(
           RoundedRectangle(cornerRadius: 20)
               .stroke(Color.black.opacity(0.3), lineWidth: 0.3)
       )
       .foregroundColor(.black)
       .background(
           GeometryReader { geo in
               Color.clear
                   .onAppear {
                       minHeight = geo.size.height
                   }
           }
       )
   }

   private func updateHeight() {
       DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
           minHeight = text.boundingRect(
               with: CGSize(width: UIScreen.main.bounds.width - 80, height: .greatestFiniteMagnitude),
               options: .usesLineFragmentOrigin,
               attributes: [.font: UIFont.systemFont(ofSize: 16)],
               context: nil
           ).height + 20 // Adjust for padding
       }
   }
}
struct SearchBar7: View {
        var placeholder: String
        @Binding var text: String
        var action: () -> Void
        @Binding var isShowingImagePicker: Bool
        @Binding var selectedBlendImages: [UIImage]

        var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    VStack {
                        Spacer()
                            .frame(height: geometry.size.height * 1.09)
                    }
                    
                    VStack(spacing: 0) {
                        if !selectedBlendImages.isEmpty {
                            VStack(spacing: 0) {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(selectedBlendImages.indices, id: \.self) { index in
                                            ZStack(alignment: .topTrailing) {
                                                Image(uiImage: selectedBlendImages[index])
                                                    .resizable()
                                                    .frame(width: 80, height: 80)
                                                    .cornerRadius(8)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(Color.gray, lineWidth: 1)
                                                    )
                                                
                                                Button(action: {
                                                    selectedBlendImages.remove(at: index)
                                                }) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .resizable()
                                                        .frame(width: 20, height: 20)
                                                        .background(Color.white)
                                                        .foregroundColor(Color.gray)
                                                        .clipShape(Circle())
                                                }
                                                .offset(x: -5, y: 5)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 8)
                                }
                                .padding(.bottom, 8)
                                .frame(height: 100)
                            }
                            .padding(.horizontal, 8)
                            .background(Color(white: 0.99))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .padding(.bottom, 0)
                            .frame(width: geometry.size.width * 0.7)
                        }
                        
                        HStack(spacing: 12) {
                            Button(action: {
                                self.isShowingImagePicker = true
                                self.text = ""
                            }) {
                                Image("logoz")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.blue)
                            }
                            .sheet(isPresented: $isShowingImagePicker) {
                                ImagePicker(selectedImages: self.$selectedBlendImages)
                            }
                            
                            VStack {
                                TextField("", text: $text)
                                    .placeholder(when: text.isEmpty) {
                                        Text(placeholder)
                                            .foregroundColor(Color(white: 0.8))
                                            .font(.system(size: 19, weight: .medium))
                                    }
                                    .padding(.leading, 15)
                                    .padding(EdgeInsets(top: 5, leading: 8, bottom: 7, trailing: 8)) // Disminuir estos valores reducirá el relleno interno del TextField
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.black.opacity(0.3), lineWidth: 0.3)
                                    )
                                    .foregroundColor(.black)
                                    .frame(height: 1) // Mantener una altura fija aquí para asegurar que todos los TextFields tengan la misma altura
                                    .disabled(!selectedBlendImages.isEmpty)
                            }
                            .frame(height: 1) // Ajustar la altura del VStack para asegurar consistencia
                            
                            Button(action: {
                                action()
                                selectedBlendImages.removeAll()
                            }) {
                                Image(systemName: "arrow.up.circle.fill")
                                    .resizable()
                                    .frame(width: 33, height: 33)
                                    .foregroundColor(.black)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 10)
                        .background(Color(white: 0.99))
                        .cornerRadius(20)
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 20)
                    .background(Color(white: 0.99))
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .gesture(DragGesture().onChanged { _ in
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                })

                
                
                
            }
        }
    }



    // Extensión para cambiar el color del placeholder
    extension View {
        func placeholder7<Content: View>(
            when shouldShow: Bool,
            alignment: Alignment = .leading,
            @ViewBuilder placeholder: () -> Content
        ) -> some View {
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    }

struct SessionListView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var subscriptionManager: SubscriptionManager

    @State private var showingEliminateAlert = false
    @State private var showImageAlert = false
    @State private var alertMessage = ""
    @State private var showingDeleteAlert = false
    @State private var navigateToPhoneAuth = false // Para navegar a PersonalChatView
    @State private var navigateToGeneralChat = false // Para navegar a SubscribedUserView
    @State private var isLoggedIn: Bool = false
    @State private var userName: String = ""
    @State private var navigateToPikaVideoView = false // Para navegar a PikaVideoView
    @State private var showAIGodView = false // Ya no es necesario para "Get Plus"
    @State private var showUpgradeView = false // Para mostrar la vista de Upgrade
    @Binding var showingPikaVideoView: Bool

    @State private var preloadedSubscribedUserView = SubscribedUserView()

    public init(showingPikaVideoView: Binding<Bool>) {
        self._showingPikaVideoView = showingPikaVideoView
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: sectionHeader(text: "APP")) {
                        // Eliminado Community Chat

                        // Ahora "Image Generation" está en la posición del botón de video
                        futuristButton(imageName: "person", text: "Image Generation") {
                            navigateToPhoneAuth = true
                        }
                        .background(
                            NavigationLink(destination: PersonalChatView().navigationBarBackButtonHidden(true), isActive: $navigateToPhoneAuth) {
                                EmptyView()
                            }
                            .hidden()
                        )

                        // Ahora "Video Generation" está en la posición del botón de imagen
                        futuristButton(imageName: "video", text: "Video Generation") {
                            navigateToPikaVideoView = true
                        }
                        .background(
                            NavigationLink(destination: PikaVideoView().navigationBarBackButtonHidden(true), isActive: $navigateToPikaVideoView) {
                                EmptyView()
                            }
                            .hidden()
                        )
                    }
                    .listRowBackground(Color.black)

                    Section(header: sectionHeader(text: "ACCOUNT")) {
                        // Botón "Upgrade to Plus" agregado
                        if !subscriptionManager.isSubscribed {
                            futuristButton(imageName: "arrow.up.square", text: "Upgrade to Plus") {
                                showUpgradeView = true
                            }
                            .fullScreenCover(isPresented: $showUpgradeView) {
                                AI_GodView(dismissView: $showUpgradeView)
                            }
                        }

                        futuristButton(imageName: "arrow.triangle.2.circlepath", text: "Restore Purchases") {
                            subscriptionManager.restorePurchases()
                        }
                        .alert(isPresented: $subscriptionManager.isRestorationSuccessful) {
                            Alert(title: Text("Restore Purchases"), message: Text("Your purchases have been restored."), dismissButton: .default(Text("OK")))
                        }
                    }
                    .listRowBackground(Color.black)

                    Section(header: sectionHeader(text: "ABOUT")) {
                        futuristButton(imageName: "book", text: "Image Creation Guide") {
                            openGoogleSite(urlString: "https://sites.google.com/d/1iVA-NsevO_pxA0aoXSqEVxnOQb4pYOE5/p/1EC-dM-zUsDYQoH4qH-98dGvabnLHfZXO/edit")
                        }

                        futuristButton(imageName: "book.closed", text: "Video Creation Guide") {
                            openGoogleSite(urlString: "https://sites.google.com/d/1ikUhdKfGKwJtVtqlFeEkpoixpRkj5P5V/p/1T_7Av95XE-QBz9C_qyHPvy-Fs0KYodkF/edit")
                        }

                        futuristButton(imageName: "video.bubble.left", text: "Video Prompting Guide") {
                            openGoogleSite(urlString: "https://sites.google.com/d/1E_p-tcc5vydSUH5svMhITRc4V9r2W9bj/p/1RzkPlaG4RiqiK_zhy4OU7qzDor8nSvVg/edit")
                        }

                        futuristButton(imageName: "newspaper", text: "Terms of Use") {
                            openGoogleSite(urlString: "https://sites.google.com/d/1lMEbJpxlqQYMBJxgAMuvPhtaMiU-ne_v/p/1gapFxjcP7kIWeZrM-foE-pr9dmJeq8yJ/edit")
                        }

                        futuristButton(imageName: "lock.shield", text: "Privacy Policy") {
                            openGoogleSite(urlString: "https://sites.google.com/d/1204_uvd7YG4Ltw-3WXPFrM6lJ6L4uOlN/p/1Rm4fBu-rPHZUxuV6Nu_GNpppImzICU21/edit")
                        }
                    }
                    .listRowBackground(Color.black)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Settings", displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    // Acción para el botón de logo
                }) {
                    ZStack {
                        Image("logox6") // Asegúrate de que el nombre del archivo de tu imagen de logo sea "logox"
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    }
                }, trailing: Button(action: {
                    dismiss() // Cerrar la vista actual de manera elegante
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 24, height: 24)
                        Text("X")
                            .foregroundColor(.black)
                            .font(.system(size: 16, weight: .bold))
                    }
                })
                .navigationBarBackButtonHidden(true) // Oculta el botón de retroceso
                .alert(isPresented: $showImageAlert) {
                    Alert(title: Text("Save Status"), message: Text(self.alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .background(LinearGradient(gradient: Gradient(colors: [.black, .blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
        }
        .navigationBarBackButtonHidden(true) // Oculta el botón de retroceso en la vista principal
        .environment(\.colorScheme, .dark) // Asegura que esté en modo oscuro solo para esta vista
        .onAppear {
            preloadedSubscribedUserView = SubscribedUserView() // Pre-cargar la vista
        }
    }

    private func openGoogleSite(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private func futuristButton(imageName: String, text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: imageName)
                    .foregroundColor(.white)
                Text(text)
                    .foregroundColor(.white)
                    .font(.custom("AvenirNext-Bold", size: 16))
                    .shadow(color: .blue, radius: 1, x: 1, y: 1) // Efecto de sombra
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(UIColor.systemGray3))
            }
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(10)
            .shadow(color: .blue, radius: 5, x: 0, y: 0) // Sombra alrededor del botón
        }
        .padding(.horizontal)
    }

    private func sectionHeader(text: String) -> some View {
        Text(text)
            .font(.footnote)
            .foregroundColor(.white)
            .padding(.vertical, 5) // Espaciado vertical
    }
}

struct PersonalChatView: View {

    
    
       @State private var isVariationRequest: Bool = false
       @State private var selectedButtonIndex: Int? = nil
       
       
       
       
       @State private var selectedPrompt: String = ""
       
       
       
       
       
       
       
       
       @State private var prompt: String = ""
       
       
       
       @State private var isLoading: Bool = false
       
       
       
       @State private var progressValue: Float = 0.0
       
       
       
       @State private var compositeImage: UIImage?
       
       
       
       @State private var gridImages: [UIImage] = []
       
       
       
       @State private var jobID: String?
       
       
       
       @State private var selectedImage: UIImage? = nil
       @State private var isShowingDetailView = false
       
       
       
       
       
       
       @State private var isSessionListOpen = false
       
       
       
       @State private var shouldShowSubscriptionView = false
       
       
       
    //   @StateObject private var sessionManager = SessionManager.shared
       
       
       
       @EnvironmentObject var subscriptionManager: SubscriptionManager
       
       
       
       
       
       
       
       @State private var showingPikaVideoView = false
       
       
       
       @State private var isShowingLoadingBar = false
       
       
       
       let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
       
       
       
       @State private var isLoggedIn = false
       
       
       
       @State private var imageGenerationStarted: Bool = false
       
       
       
       
       
       
       
       
       
       @State private var allPrompts: [String] = []
       
       
       
       @State private var showLimitReachedAlert = false
       
       
       @State private var selectedVButtonIndices: Set<Int> = []
       
       
       
       
       
       @State private var scrollViewKey = UUID()
       
       
       
       
       
       
       
       // Asegúrate de cambiar esto a false cuando la imagen esté cargada
       
       
       
       let iconSize: CGFloat = 35  // Tamaño del icono
       
       
       
       let lineWidth: CGFloat = 2   // Grosor de la línea del círculo
       
       
       
       let circlePadding: CGFloat = 5
       
       
       
       @State private var isAnimating: Bool = false
       
       
       
       @State var vButtonImages: [[UIImage]] = []
       
       @State private var showLoadingIndicator = true
       
       
       
       

    

    let prohibitedWords: Set<String> = ["sex", "Kill","blood", "bloodbath", "crucifixion", "bloody", "flesh", "bruises", "car crashes", "corpse", "crucified", "cutting", "decapitate", "infested", "gruesome", "kill", "infected", "sadist",

                                        

                                        "slaughter", "teratoma", "tryphophobia", "wound", "cronenberg", "khorne", "cannibal",

                                        

                                        "cannibalism", "visceral", "guts", "bloodshot", "gory", "killing", "surgery", "vivisection",

                                        

                                        "massacre", "hemoglobin", "suicide", "ahegao", "pinup", "ballgag", "playboy", "bimbo",

                                        

                                        "delight", "fluids in the body", "enjoyments", "boudoir", "rule34", "brothel", "concocting",

                                        

                                        "dominatrix", "seductive", "sexual seduction erotica", "a fuck", "sensual", "hardcore",

                                        

                                        "sexy", "hentai", "shag", "hot and sexy", "shibari", "incest", "smut", "jav", "succubus",

                                        

                                        "jerk off", "hot", "kinbaku", "transparent", "legs spread", "twerk", "in love", "voluptuous",

                                        

                                        "naughty", "wincest", "orgy", "sultry", "xxx", "bondage", "bdsm", "dog collar", "slavegirl",

                                        

                                        "transparent and translucent", "arse", "labia", "pussy", "ass", "gluteus maximus", "mammaries",

                                        

                                        "human centipede", "badonkers", "minge", "massive chests", "big ass", "mommy milker", "booba",

                                        

                                        "nipple", "booty", "oppai", "bosom", "organs", "breasts", "ovaries", "busty", "penis",

                                        

                                        "clunge", "phallus", "crotch", "sexy female", "dick", "skimpy", "girth", "thick", "honkers",

                                        

                                        "vagina", "hooters", "veiny", "knob", "no attire", "speedo", "au naturale", "no shirt",

                                        

                                        "bare chest", "naked", "just barely dressed", "bra", "risk", "transparent", "barely",

                                        

                                        "clad", "cleavage", "stripped", "fully frontal unclothed", "invisibility of clothing",

                                        

                                        "not wearing anything", "lingerie with no shirt", "unbehaved", "without clothes", "negligee",

                                        

                                        "zero clothes", "taboo", "fascist", "nazi", "prophet mohammed", "slave", "coon", "honkey",

                                        

                                        "arrested", "jail", "handcuffs", "drugs", "cocaine", "heroin", "meth", "crack", "torture",

                                        

                                        "disturbing", "farts", "fart", "poop", "warts", "xi jinping", "shit", "pleasure", "errect",

                                        

                                        "big black", "brown pudding", "bunghole", "vomit", "voluptuous", "seductive", "sperm", "hot",

                                        

                                        "sexy", "sensored", "censored", "silenced", "deepfake", "inappropriate", "pus", "waifu",

                                        

                                        "mp5", "succubus", "1488", "surgery",

                                        

                                        

                                        

                                        // Palabras adicionales PG-13

                                        

                                        "murder", "rape", "kidnapping", "abduction", "terrorism", "molestation", "nudity",

                                        

                                        "sexual assault", "pornography", "genocide", "hate speech", "racial slur", "explicit",

                                        

                                        "vulgar", "obscene", "drug abuse", "drug use", "excessive violence", "graphic violence",

                                        

                                        "intense violence", "harassment", "bullying", "extreme gore", "sadism", "masochism",

                                        

                                        "profanity", "foul language",         "strong language", "hateful language", "homophobia", "transphobia",

                                        

                                        "sexual content", "explicit content", "adult content", "mature content",

                                        

                                        "inflammatory", "extremist", "radical", "graphic sexual content",

                                        

                                        "blasphemy", "sacrilege", "profanation", "obscenity", "lewdness",

                                        

                                        "perversion", "depravity", "exploitation", "slander", "libel",

                                        

                                        "defamation", "cyberbullying", "trolling", "doxxing", "stalking",

                                        

                                        "intimidation", "threats", "violent extremism", "terrorism incitement",

                                        

                                        "radicalization", "hate crime", "discrimination", "xenophobia",

                                        

                                        "racial hatred", "ethnic hatred", "religious hatred", "gender hatred",

                                        

                                        "misogyny", "misandry", "ageism", "ableism", "body shaming",

                                        

                                        "slut shaming", "victim blaming", "gaslighting", "manipulation",

                                        

                                        "coercion", "abuse", "domestic violence", "child abuse", "elder abuse",

                                        

                                        "animal cruelty", "animal abuse", "self-harm", "self-mutilation",

                                        

                                        "eating disorders", "anorexia", "bulimia", "substance abuse",

                                        

                                        "alcoholism", "addiction", "overdose", "withdrawal", "rehabilitation",

                                        

                                        "recovery", "relapse", "mental illness", "depression", "anxiety",

                                        

                                        "bipolar disorder", "schizophrenia", "psychosis", "suicidal thoughts",

                                        

                                        "suicide attempt", "suicide prevention", "grief", "mourning",

                                        

                                        "bereavement", "loss", "trauma", "post-traumatic stress disorder",

                                        

                                        "complex trauma", "dissociation", "identity crisis", "existential crisis",

                                        

                                        "moral dilemma", "ethical dilemma", "controversy", "scandal",

                                        

                                        "corruption", "bribery", "embezzlement", "fraud", "deception",

                                        

                                        "conspiracy", "espionage", "sabotage", "treason", "sedition",

                                        

                                        "insurrection", "rebellion", "revolution", "coup d'état", "civil war",

                                        

                                        "genocide", "ethnic cleansing", "war crimes", "crimes against humanity",

                                        

                                        "human trafficking", "slavery", "forced labor", "sexual slavery",

                                        

                                        "child soldiers", "illegal arms trade", "drug trafficking", "smuggling",

                                        

                                        "black market", "organized crime", "gang violence", "mafia",

                                        

                                        "cartel", "syndicate", "extortion", "racketeering", "money laundering",

                                        

                                        "tax evasion", "cybercrime", "hacking", "phishing", "identity theft",

                                        

                                        "credit card fraud", "intellectual property theft", "piracy",

                                        

                                        "counterfeiting", "forgery", "tampering", "vandalism", "arson",

                                        

                                        "terrorism", "extremism", "radicalization", "hate speech",

                                        

                                        "propaganda", "disinformation", "fake news", "hoax", "conspiracy theory",

                                        

                                        "pseudoscience", "quackery", "charlatanism", "fraudulent claims",

                                        

                                        "snake oil", "miracle cure", "placebo effect", "nocebo effect",

                                        

                                        "psychosomatic illness", "hypochondria", "malingering", "factitious disorder",

                                        

                                        "Munchausen syndrome", "Munchausen by proxy", "self-diagnosis",

                                        

                                        "self-medication", "unproven treatment", "dangerous remedy",

                                        

                                        "toxic substance", "hazardous material", "environmental pollution",

                                        

                                        "climate change", "global warming", "ozone depletion", "deforestation",

                                        

                                        "habitat destruction", "species extinction", "biodiversity loss",

                                        

                                        "ecosystem collapse", "natural disaster", "earthquake", "volcano",

                                        

                                        "tsunami", "hurricane", "typhoon", "cyclone", "tornado",

                                        

                                        "flood", "drought", "wildfire", "avalanche", "landslide",

                                        

                                        "sinkhole", "radiation leak", "nuclear accident", "chemical spill",

                                        

                                        "oil spill", "industrial accident", "workplace hazard", "occupational disease",

                                        

                                        "repetitive strain injury", "carpal tunnel syndrome", "tendinitis",

                                        

                                        "bursitis", "back pain", "neck pain", "shoulder pain", "knee pain",

                                        

                                        "hip pain", "arthritis", "osteoporosis", "fracture", "sprain",

                                        

                                        "strain", "bruise", "contusion", "abrasion", "laceration",

                                        

                                        "puncture wound", "burn", "scald", "frostbite", "hypothermia",

                                        

                                        "heatstroke", "sunburn", "dehydration", "malnutrition",

                                        

                                        "starvation", "food poisoning", "allergic reaction", "anaphylaxis",

                                        

                                        "infection", "inflammation", "swelling", "redness", "pain",

                                        

                                        "fever", "chills", "nausea", "vomiting", "diarrhea", "constipation",

                                        

                                        "indigestion", "heartburn", "acid reflux", "ulcer", "gastroenteritis",

                                        

                                        "colitis", "irritable bowel syndrome", "Crohn's disease", "celiac disease",

                                        

                                        "food intolerance", "lactose intolerance", "gluten sensitivity",

                                        

                                        "peanut allergy", "shellfish allergy", "egg allergy", "dairy allergy",

                                        

                                        "soy allergy", "wheat allergy", "tree nut allergy", "fish allergy",

                                        

                                        "pollen allergy", "dust mite allergy", "mold allergy", "pet allergy",

                                        

                                        "latex allergy", "insect sting allergy", "drug allergy", "penicillin allergy",

                                        

                                        "aspirin allergy", "ibuprofen allergy", "acetaminophen allergy",

                                        

                                        "opioid allergy", "antibiotic allergy", "anesthetic allergy", "vaccine allergy",

                                        

                                        "contrast dye allergy", "cosmetic allergy", "fragrance allergy",

                                        

                                        "dye allergy", "preservative allergy", "additive allergy", "chemical sensitivity",

                                        

                                        "environmental illness", "multiple chemical sensitivity", "electromagnetic hypersensitivity",

                                        

                                        "radiation sickness", "sun sensitivity", "photosensitivity", "light sensitivity",

                                        

                                        "noise sensitivity", "sound sensitivity", "motion sickness", "altitude sickness",

                                        

                                        "sea sickness", "travel sickness", "jet lag", "circadian rhythm disorder",

                                        

                                        "sleep disorder", "insomnia", "sleep apnea", "narcolepsy", "restless leg syndrome",

                                        

                                        "periodic limb movement disorder", "nightmare", "night terror", "sleepwalking",

                                        

                                        "sleep talking", "bruxism", "snoring", "sleep paralysis", "hypersomnia",

                                        

                                        "excessive daytime sleepiness", "fatigue", "tiredness", "lethargy",

                                        

                                        "burnout", "stress", "anxiety", "panic attack", "phobia", "fear",

                                        

                                        "obsessive-compulsive disorder", "post-traumatic stress disorder",

                                        

                                        "acute stress disorder", "adjustment disorder", "reactive attachment disorder",

                                        

                                        "disinhibited social engagement disorder", "oppositional defiant disorder",

                                        

                                        "conduct disorder", "intermittent explosive disorder", "pyromania",

                                        

                                        "kleptomania", "pathological gambling", "trichotillomania", "skin picking disorder",

                                        

                                        "body dysmorphic disorder", "hoarding disorder", "tourette syndrome",

                                        

                                        "persistent motor or vocal tic disorder", "stereotypic movement disorder",

                                        

                                        "non-suicidal self-injury", "suicidal behavior", "suicidal ideation",

                                        

                                        "suicide attempt", "suicide pact", "suicide contagion", "copycat suicide",

                                        

                                        "suicide cluster", "suicide crisis", "suicide hotline", "suicide prevention",

                                        

                                        "suicide intervention", "suicide postvention", "bereavement support",

                                        

                                        "grief counseling", "loss support group", "trauma therapy", "trauma-focused therapy",

                                        

                                        "trauma-informed care", "crisis intervention", "emergency response",

                                        

                                        "first aid", "cardiopulmonary resuscitation", "automated external defibrillator",

                                        

                                        "basic life support", "advanced cardiac life support", "pediatric advanced life support",

                                        

                                        "neonatal resuscitation program", "wilderness first aid", "search and rescue",

                                        

                                        "disaster response", "emergency management", "emergency preparedness",

                                        

                                        "emergency shelter", "evacuation plan", "fire safety", "earthquake preparedness",

                                        

                                        "flood preparedness", "hurricane preparedness", "tornado preparedness",

                                        

                                        "volcano preparedness", "tsunami preparedness", "heatwave preparedness",

                                        

                                        "cold wave preparedness", "drought preparedness", "pandemic preparedness",

                                        

                                        "bioterrorism preparedness", "chemical terrorism preparedness",

                                        

                                        "radiological terrorism preparedness", "nuclear terrorism preparedness",

                                        

                                        "cyberterrorism preparedness", "counterterrorism measures", "anti-terrorism training",

                                        

                                        "terrorism awareness", "extremism prevention", "radicalization prevention",

                                        

                                        "violent extremism prevention", "hate crime prevention", "bias crime prevention",

                                        

                                        "discrimination prevention", "harassment prevention", "bullying prevention",

                                        

                                        "cyberbullying prevention", "internet safety", "online security",

                                        

                                        "data privacy", "identity protection", "fraud prevention", "scam prevention",

                                        

                                        "con artist prevention", "pyramid scheme prevention", "ponzi scheme prevention",

                                        

                                        "financial literacy", "consumer protection", "consumer rights",

                                        

                                        "patient rights", "healthcare access", "health equity", "health disparity reduction",

                                        

                                        "health literacy", "public health", "community health", "global health",

                                        

                                        "environmental health", "occupational health", "school health", "rural health",

                                        

                                        "urban health", "mental health", "behavioral health", "emotional health",

                                        

                                        "spiritual health", "holistic health", "integrative health", "complementary health",

                                        

                                        "alternative health", "preventive health", "proactive health", "wellness",

                                        

                                        "well-being", "self-care", "self-help", "self-improvement", "personal development",

                                        

                                        "life coaching", "motivational speaking", "inspirational speaking",

                                        

                                        "public speaking", "communication skills", "interpersonal skills",

                                        

                                        "social skills", "emotional intelligence", "cultural competence",

                                        

                                        "diversity training", "inclusion training", "equity training", "allyship training",

                                        

                                        "advocacy training", "activism training", "community organizing",

                                        

                                        "social justice", "civil rights", "human rights", "animal rights",

                                        

                                        "environmental activism", "climate activism", "sustainability",

                                        

                                        "conservation", "preservation", "restoration", "rehabilitation",

                                        

                                        "recycling", "upcycling", "reusing", "reducing", "rethinking",

                                        

                                        "reimagining", "reinventing", "reforming", "transforming", "revolutionizing",

                                        

                                        "innovating", "creating", "building", "designing", "engineering",

                                        

                                        "inventing", "discovering", "exploring", "adventuring", "traveling",

                                        

                                        "wandering", "roaming", "journeying", "questing", "seeking",

                                        

                                        "finding", "uncovering", "revealing", "exposing", "unmasking",

                                        

                                        "decrypting", "decoding", "interpreting", "translating", "converting",

                                        

                                        "adapting", "adjusting", "modifying", "customizing", "personalizing",

                                        

                                        "tailoring", "fitting", "suiting", "matching", "pairing", "complementing",

                                        

                                        "enhancing", "enriching", "embellishing", "beautifying", "decorating",

                                        

                                        "ornamenting", "adorning", "dressing", "styling", "fashioning",

                                        

                                        "crafting", "carving", "sculpting", "molding", "shaping", "forming",

                                        

                                        "forging", "fabricating", "manufacturing", "producing", "generating",

                                        

                                        "creating", "developing", "evolving", "growing", "maturing",

                                        

                                        "aging", "ripening", "blooming", "flourishing", "thriving",

                                        

                                        "succeeding", "prospering", "winning", "triumphing", "conquering",

                                        

                                        "dominating", "ruling", "governing", "leading", "guiding",

                                        

                                        "directing", "managing", "administering", "supervising", "overseeing",

                                        

                                        "coordinating", "organizing", "arranging", "planning", "preparing",

                                        

                                        "anticipating", "expecting", "predicting", "forecasting", "projecting",

                                        

                                        "envisioning", "imagining", "conceiving", "dreaming", "fantasizing",

                                        

                                        "daydreaming", "musing", "pondering", "contemplating", "reflecting",

                                        

                                        "meditating", "praying", "worshiping", "revering", "honoring",

                                        

                                        "respecting", "admiring", "appreciating", "valuing", "cherishing",

                                        

                                        "treasuring", "savoring", "enjoying", "delighting", "relishing",

                                        

                                        "indulging", "luxuriating", "basking", "soaking", "immersing", "engulfing", "embracing", "encircling", "enveloping", "wrapping",

                                        

                                        "poonany", "trim", "poon-tang", "quim", "coochie", "cooch", "cooter", "punani", "punany", "pussy", "vag", "vajayjay", "retard", "fag", "dyke", "tranny", "kike", "gook", "spic", "wetback", "chink", "raghead", "sand-n*gger", "zipperhead", "kraut", "mick", "paddy", "polack", "ruskie", "wop", "dago", "jap", "nip", "hun", "frog", "limey", "yank", "seppo", "bogan", "chav", "pikey", "gyppo", "abo", "coon", "redskin", "injun", "squaw", "nuts", "whacko", "jihad", "Zionist", "commie", "fascist", "libtard", "femnazi", "redneck", "hillbilly", "terrorist", "extremist", "radical", "heretic", "apostate", "infidel", "blasphemer", "heathen", "pagan", "idolater"]

    @State var allButtonImages = [[UIImage]]()
        
        
        @State private var isGeneratingImage: Bool = false
        
        @State private var isAnyImageGenerating: Bool = false

        @State private var canSendNewRequest = true
        
        
        
        @State private var timeRemainingForNewRequest = 22
        
        
        
        @State private var isSelectedV1 = false
        
        @State private var isSelectedV2 = false
        
        @State private var isSelectedV3 = false
        
        @State private var isSelectedV4 = false
        
        
        
        @State private var isUsingApp = true
        
        
        
        @State private var showAIGodView = false
        
        
        
        
        
        
        
        @State private var generatedImagesCount = 0
        
        
        
        @State private var showPhoneAuth = false
        
        
        
        @State private var remainingAttempts: Int = 3
        
        
        
        @State private var isSubscribed: Bool = false
        
        
        
        let userPhoneNumber: String = "userPhoneNumber" // Asumiendo que tienes el número de teléfono del usuario
        
        
        
        
        
        
        
        @State private var isVaryStrongSelected = false
        @State private var isVarySubtleSelected = false
        @State private var isUpscaleSubtleSelected = false
        @State private var isUpscaleCreativeSelected = false
        
        
        
        
        @State private var initialLoadDone = false
        
        
        
        
        
        
        
        @State private var locallyGeneratedImages = Set<String>()
        
        
        
        @State private var firestoreImageURLs = Set<String>()
        
        
        
       
        
        func addImagesToUI(_ images: [UIImage], prompt: String, timestamp: Date, jobID: String) {
            
            let gridImage = GridImage(images: images, prompt: prompt, source: "Firestore", timestamp: timestamp, jobID: jobID)
            
            self.allGridImages.append(gridImage)
            
            self.sortImagesByDate()
            
        }
        
        
        
        func extractJobID(from urlString: String) -> String {
            
            guard let url = URL(string: urlString),
                  
                    let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                  
                    let queryItems = components.queryItems else {
                
                return "defaultJobID"
                
            }
            
            
            
            return queryItems.first(where: { $0.name == "jobid" })?.value ?? "defaultJobID"
            
        }
        
        
        @State private var isV1Selected: Bool = false
        @State private var isV2Selected: Bool = false
        @State private var isV3Selected: Bool = false
        @State private var isV4Selected: Bool = false
        
        
        @State private var selectedRedoUpscaleSubtleButtonIndices: Set<Int> = []
        @State private var selectedRedoUpscaleCreativeButtonIndices: Set<Int> = []
        
        
        
        
        
    func saveImageDetailsToFirestore(imageUrl: String, prompt: String, jobID: String) {
        let db = Firestore.firestore()
        let imageData: [String: Any] = [
            "url": imageUrl,
            "prompt": prompt,
            "timestamp": FieldValue.serverTimestamp(),
            "jobID": jobID  // <-- Esta línea se agregó para almacenar el jobID
        ]
        
        db.collection("images").addDocument(data: imageData) { error in
            if let error = error {
                print("Error al guardar los detalles de la imagen: \(error.localizedDescription)")
            } else {
                print("Detalles de la imagen guardados exitosamente")
            }
        }
    }
    
        
        
        func sortImagesByDate() {
            
            self.allGridImages.sort { $0.timestamp < $1.timestamp }
            
        }
        
        
        
        @State private var selectedVaryStrongButtonIndex: Int? = nil
        @State private var selectedVarySubtleButtonIndex: Int? = nil
        
        
        
        
        
        
        
        
        
        
        
        
        
        @State private var allGridImages: [GridImage] = []
        
        
        
        
        
        struct GridImage: Identifiable, Equatable {
                          var id = UUID()
                          var images: [UIImage]
                          var prompt: String
                          var source: String
                          var timestamp: Date
                          var jobID: String
                          var isV1Selected: Bool = false
                          var isV2Selected: Bool = false
                          var isV3Selected: Bool = false
                          var isV4Selected: Bool = false
                          var isU1Selected: Bool = false
                          var isU2Selected: Bool = false
                          var isU3Selected: Bool = false
                          var isU4Selected: Bool = false
                          var isUpscaleSubtleSelected: Bool = false
                          var isUpscaleCreativeSelected: Bool = false
                          var isUpscaleSubtleDone: Bool = false
                          var isUpscaleCreativeDone: Bool = false
                          var showVariations: Bool = false // <-- Añadir esta propiedad
                          var selectedImage: UIImage? = nil
                          var isVariationPrompt: Bool = false
                          var parentJobID: String? = nil
                          var isUpscaling: Bool = false
                          var showScanningText: Bool = false
                          var isCreatingImage: Bool = false
                          var origin: String?
                          var isImageLoaded: Bool = false
                          var showButtons: Bool = true
                          
                          var uButtonStates: [String: Bool] = [:]
                          
                        
                          
                      }

        @State private var shouldScrollToEndOnAppear = true
        
        @State private var selectedGridPrompt: String = ""
        
        func checkAndShowAuthentication() {
            
            
            
            let isUserAuthenticated = UserDefaults.standard.bool(forKey: "isUserAuthenticated")
            
            
            
            print("Usuario autenticado: \(isUserAuthenticated)")
            
            
            
            
            
            
            
            if !isUserAuthenticated {
                
                
                
                self.showPhoneAuth = true
                
                
                
            }
            
            
            
        }
        
        @State private var selectedUpscaleSubtleIndex: Int? = nil
                      @State private var selectedUpscaleCreativeIndex: Int? = nil

       
        
        
        
        @State private var scrollViewProxy: ScrollViewProxy?
        
        
        
        @State private var isGeneratingImages = false
        
        @State private var areVariationButtonsEnabled = false
        
        
        func startUsingApp() {
            
            self.isUsingApp = true
            
        }
        
        
        
        func stopUsingApp() {
            
            self.isUsingApp = false
            
        }
        
        
        
      
        
        @State private var isPromptAccepted: Bool = true
        
        
        @State private var canSendNewVariationRequest = true
        @State private var timeRemainingForNewVariationRequest = 22
        
        // Estados para controlar los temporizadores de los botones U
        @State private var canSendNewURequest = true
        @State private var timeRemainingForNewURequest = 22
        
        
        
        func formatTimestamp(_ date: Date) -> String {
            
            let calendar = Calendar.current
            
            let timeFormatter = DateFormatter()
            
            timeFormatter.dateFormat = "hh:mm a"
            
            
            
            if calendar.isDateInToday(date) {
                
                return "Today at \(timeFormatter.string(from: date))"
                
            } else if calendar.isDateInYesterday(date) {
                
                return "Yesterday at \(timeFormatter.string(from: date))"
                
            } else {
                
                let dateFormatter = DateFormatter()
                
                dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a" // Formato MM/dd/yyyy hh:mm a
                
                return dateFormatter.string(from: date)
                
            }
            
        }
        
        
        func extractProgress(from content: String) -> Int? {
            
            let regex = try? NSRegularExpression(pattern: "(\\d+)%")
            
            if let match = regex?.firstMatch(in: content, range: NSRange(location: 0, length: content.utf16.count)) {
                
                let range = match.range(at: 1)
                
                if let progressRange = Range(range, in: content) {
                    
                    return Int(content[progressRange])
                    
                }
                
            }
            
            return nil
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        @State private var selectedButton: String? = nil
        
        
        struct ScanningTextView: View {
            var text: String
            @State private var scanPosition: CGFloat = -1.0
            
            var body: some View {
                Text(text)
                    .font(.system(size: 17))
                    .foregroundColor(Color.gray.opacity(0.6)) // Color del texto
                    .background(
                        GeometryReader { geometry in
                            Rectangle()
                                .fill(Color.black) // Color de la barra de escaneo
                                .frame(width: geometry.size.width / 3, height: geometry.size.height) // Tamaño de la barra de escaneo
                                .offset(x: geometry.size.width * scanPosition) // Posición de la barra de escaneo
                                .animation(Animation.linear(duration: 3.0).repeatForever(autoreverses: false)) // Animación de movimiento
                                .onAppear {
                                    self.scanPosition = 1.0 // Inicia la animación
                                }
                        }
                            .mask(
                                Text(text)
                                    .font(.system(size: 17)) // Hace que la barra de escaneo se enmascare dentro del texto
                            )
                    )
            }
        }
        
        @State private var creatingImageIndices: Set<Int> = []
        
        
        @State private var showScrollToBottomButton = false
        @State private var lastContentOffset: CGFloat = 0
        
        
        
        @State private var generatingVariationIndex: Int? = nil

        
        
        
        
        @State private var selectedImages: [GridImage] = []
        @State private var progressValues: [String: Float] = [:]
        @State private var selectedVaryStrongButtonIndices: Set<Int> = []
        @State private var selectedVarySubtleButtonIndices: Set<Int> = []
        
        
        func clearSelectedPrompt() {
            self.selectedPrompt = ""
        }
        
        @State private var isGeneratingVariation = false
        
        
        @State private var scrollOffset: CGFloat = 0
        @State private var isShowingImagePicker = false
        
        @State private var isImageLoaded: [Bool] = []
        
        @State private var isUpscalingImage: Bool = false
        
        
        
        @State private var selectedBlendImages: [UIImage] = []
       
        @State private var scrollViewOffset: CGFloat = 0
        
        
        class ImageGenerationViewModel: ObservableObject {
            @Published var allGridImages: [GridImage] = []
            @Published var isLoading = false
            @Published var jobID: String?
            @Published var progressValue: Float = 0.0
            @Published var canSendNewRequest = true
            @Published var timeRemainingForNewRequest = 30
            
            // Otras funciones y propiedades relacionadas con la generación de imágenes y manejo de estado
        }
        //  @State private var hasLoadedAllFirestoreImages = false
        
        
        @State private var shouldScroll = true
        
        @State private var isImageGenerationInProgress: Bool = false
        
        func canGenerateNewImage() -> Bool {
            return !isImageGenerationInProgress
        }
        
        

            @State private var lastDragPosition: CGFloat = 0
      
       

        func checkIfShouldShowScrollButton(currentIndex: Int) {
            let remainingImages = allGridImages.count - currentIndex - 1
            showScrollToBottomButton = remainingImages >= 10
        }
        
        @State private var showImageCreatorText: Bool = false
        
        
       
        
        @State private var messageBarVisible = true
        
        func updateImageGeneratingState() {
            DispatchQueue.main.async {
                self.isAnyImageGenerating = !self.creatingImageIndices.isEmpty
                print("Estado de generación de imágenes actualizado: \(self.isAnyImageGenerating)")
            }
        }
        
        
        
    //    @State private var isGeneratingImage = false

        func updateImageGenerationState3() {
            DispatchQueue.main.async {
                let isGenerating = allGridImages.contains { creatingImageIndices.contains(allGridImages.firstIndex(of: $0)!) }
                isAnyImageGenerating = isGenerating
            }
        }
       
        @State private var canSendURequestAfterV = true // Nueva variable de estado

        func startUTimerAfterV() {
            self.canSendURequestAfterV = false
            Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false) { _ in
                self.canSendURequestAfterV = true
            }
        }

        
     @State private var showIntroContent = true
        
        
        
         //     @State private var showImageCreatorText: Bool = false
              
              
       //   @State private var showIntroContent = true
          
          

    func scrollToEnd(proxy: ScrollViewProxy) {
        if let lastID = allGridImages.last?.id {
            withAnimation {
                proxy.scrollTo(lastID, anchor: .bottom)
            }
        }
    }

        
        
    
    var body: some View {
           NavigationView {
               ZStack {
                   Color.white.edgesIgnoringSafeArea(.all)
                   
                   VStack(spacing: 0) {
                       HStack {
                           Button(action: {
                               self.isSessionListOpen = true
                           }) {
                               Image("menu1")
                                   .resizable()
                                   .aspectRatio(contentMode: .fit)
                                   .frame(width: 24, height: 24)
                                   .foregroundColor(.black)
                           }
                           .padding(.leading, 20)
                           .padding(.top, 5)
                           
                           Spacer()
                           
                           if subscriptionManager.isSubscribed {
                               Text("Visual Creator AI")
                                   .font(.system(size: 19, weight: .bold, design: .default)) // Utiliza San Francisco por defecto
                                   .foregroundColor(.black)
                                   .offset(y: 2.1) // Mueve el texto ligeramente hacia abajo
                           } else {
                               if showImageCreatorText {
                                   Text("Visual Creator AI")
                                       .font(.system(size: 19, weight: .bold, design: .default)) // Utiliza San Francisco por defecto
                                       .foregroundColor(.black)
                                       .offset(y: 2.1) // Mueve el texto ligeramente hacia abajo
                               } else {
                                   Button(action: {
                                       self.showAIGodView = true
                                   }) {
                                       HStack(spacing: 4) {
                                           Text("Get Plus")
                                               .font(.system(size: 16, weight: .bold, design: .default)) // Utiliza San Francisco por defecto
                                               .foregroundColor(Color(red: 87/255, green: 86/255, blue: 206/255))
                                           Image(systemName: "sparkle")
                                               .foregroundColor(Color(red: 87/255, green: 86/255, blue: 206/255))
                                       }
                                       .padding(.horizontal, 14)
                                       .padding(.vertical, 10.4)
                                       .background(Color(red: 241 / 255, green: 241 / 255, blue: 251 / 255))
                                       .cornerRadius(13.5)
                                       .overlay(
                                           RoundedRectangle(cornerRadius: 15)
                                               .stroke(Color(red: 241 / 255, green: 241 / 255, blue: 251 / 255), lineWidth: 1)
                                       )
                                   }
                                   .font(.system(size: 16, weight: .bold, design: .default)) // Utiliza San Francisco por defecto
                               }
                           }
                           
                           Spacer()
                           
                           Button(action: {
                               self.resetConversation()
                           }) {
                               Image("edit1")
                                   .resizable()
                                   .aspectRatio(contentMode: .fit)
                                   .frame(width: 24, height: 24)
                                   .foregroundColor(allGridImages.isEmpty ? .gray : .black)
                           }
                           .disabled(allGridImages.isEmpty)
                           .padding(.trailing, 20)
                       }
                       .padding(.vertical, 7) // Reduce vertical padding to make the height smaller
                       
                     
                       
                       NavigationLink(destination: SessionListView(showingPikaVideoView: $showingPikaVideoView), isActive: $isSessionListOpen) {
                           EmptyView()
                       }
                       .navigationBarBackButtonHidden(true)
                       ZStack {
                           ScrollViewReader { proxy in
                               ScrollView {
                                   VStack(spacing: -120) {
                                       Spacer()
                                           .frame(height: UIScreen.main.bounds.height / 4) // Esto crea espacio para centrar el contenido

                                       Spacer()
                                           .frame(height: 30)

                                       ForEach(allGridImages.indices, id: \.self) { index in
                                           let gridImage = allGridImages[index]
                                           VStack {
                                               HStack {
                                                   VStack(alignment: .leading, spacing: 4) {
                                                       HStack {
                                                           Image("logox6")
                                                               .resizable()
                                                               .frame(width: 47, height: 47)
                                                               .offset(y: 1)
                                                               .offset(y: 10)
                                                           
                                                           Text("Visual Creator Bot")
                                                               .font(.system(size: 12.6))
                                                               .fontWeight(.bold)
                                                               .foregroundColor(.black)
                                                               .lineLimit(1)
                                                               .fixedSize(horizontal: true, vertical: false)
                                                               .padding(.leading, -11.2) // Ajusta este valor para mover el texto más hacia la izquierda
                                                               .offset(y: 10)
                                                           
                                                           Text(formatTimestamp(gridImage.timestamp))
                                                               .font(.system(size: 10))
                                                               .foregroundColor(.gray)
                                                               .padding(.leading, -5.7)
                                                               .lineLimit(1) // Limitar a una sola línea
                                                               .fixedSize(horizontal: true, vertical: false) // Ajustar tamaño para mostrar todo el contenido
                                                               .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading) // Ajustar el tamaño del contenedor
                                                               .offset(y: 10)
                                                       }
                                                       .frame(maxWidth: .infinity, alignment: .leading)
                                                       HStack {
                                                           if gridImage.source == "Blend" {
                                                               if !gridImage.images.isEmpty {
                                                                   ForEach(gridImage.images.indices, id: \.self) { imgIndex in
                                                                       Image(uiImage: gridImage.images[imgIndex])
                                                                           .resizable()
                                                                           .frame(width: 30, height: 30)
                                                                           .clipShape(Circle())
                                                                           .overlay(
                                                                            RoundedRectangle(cornerRadius: 15)
                                                                                .stroke(Color.gray, lineWidth: 1)
                                                                           )
                                                                           .padding(.leading, 5)
                                                                   }
                                                               } else if gridImage.isCreatingImage {
                                                                   ScanningTextView(text: "Creating\nimage")
                                                                       .font(.system(size: 14))
                                                                       .foregroundColor(.red)
                                                                       .padding(.leading, 5)
                                                                       .offset(x: -5, y: -5)
                                                               }
                                                           } else {
                                                               Text(gridImage.prompt)
                                                                   .font(.system(size: 14.4))
                                                                   .foregroundColor(.gray)
                                                                   .padding(.top, 2)
                                                                   .padding(.leading, 11.2)
                                                                   .lineLimit(nil) // Permitir múltiples líneas
                                                                   .multilineTextAlignment(.leading)
                                                                   .fixedSize(horizontal: false, vertical: true) // Ajustar tamaño para mostrar todo el contenido
                                                               
                                                               if gridImage.isUpscaling {
                                                                   ScanningTextView(text: "upscaling image")
                                                                       .font(.system(size: 14))
                                                                       .foregroundColor(.gray)
                                                                       .padding(.leading, 5)
                                                               }
                                                           }
                                                           
                                                           if isLoading && index == allGridImages.count - 1 {
                                                               Text(imageGenerationStarted ? "(\(Int(progressValue * 100))%) (relax mode)" : "Waiting to start")
                                                                   .foregroundColor(Color.gray.opacity(0.8))
                                                                   .font(.system(size: 15, weight: .thin, design: .default))
                                                                   .padding(.leading, 5)
                                                           }
                                                           
                                                           if selectedPrompt == "\(gridImage.prompt)" && gridImage.isVariationPrompt && isGeneratingVariation {
                                                               ScanningTextView(text: "Creating\nvariations")
                                                                   .font(.system(size: 14))
                                                                   .foregroundColor(.gray)
                                                                   .padding(.leading, 5)
                                                           }
                                                           
                                                           if creatingImageIndices.contains(index) {
                                                               ScanningTextView(text: "Creating\nimage")
                                                                   .font(.system(size: 14))
                                                                   .foregroundColor(.gray)
                                                                   .padding(.leading, 5)
                                                                   .offset(x: -5, y: -5)
                                                           }
                                                       }
                                                   }
                                               }
                                               .padding(.horizontal, 1)
                                               .padding(.vertical, 5)
                                               .offset(x: -10)
                                               .padding(.bottom, 0)
                                               .frame(maxWidth: .infinity, alignment: .leading)
                                               .padding(.horizontal, 39.4) // Ajusta este valor según sea necesario para mover el contenido a la derecha
                                               .padding(.bottom, 0)
                                               .offset(y: 10)
                                               if gridImage.source == "Button U" && gridImage.isImageLoaded {
                                                   VStack(spacing: 0) {
                                                       Image(uiImage: gridImage.images.first ?? UIImage())
                                                           .resizable()
                                                           .scaledToFit()
                                                           .frame(maxWidth: 310, maxHeight: 310)
                                                           .padding(.bottom, 260)
                                                       
                                                       VStack(spacing: 4) {
                                                           if gridImage.showButtons {
                                                               HStack(spacing: 8) {
                                                                   Button("Vary (Strong)") { self.varyStrongButtonTapped(index: index) }
                                                                       .buttonStyle(AppleStyleButton(isSelected: selectedVaryStrongButtonIndices.contains(index)))
                                                                   Button("Vary (Subtle)") { self.varySubtleButtonTapped(index: index) }
                                                                       .buttonStyle(AppleStyleButton(isSelected: selectedVarySubtleButtonIndices.contains(index)))
                                                               }
                                                               .padding(4)
                                                               .cornerRadius(8)
                                                               
                                                               if !(gridImage.isUpscaleSubtleDone || gridImage.isUpscaleCreativeDone) {
                                                                   HStack(spacing: 8) {
                                                                       Button("Upscale (Subtle)") {
                                                                           guard !isAnyImageGenerating else { return }
                                                                           self.selectedUpscaleSubtleIndex = index
                                                                           self.upscaleSubtleButtonTapped(index: index)
                                                                       }
                                                                       .buttonStyle(AppleStyleButton(isSelected: selectedUpscaleSubtleIndex == index))
                                                                       
                                                                       Button("Upscale (Creative)") {
                                                                           guard !isAnyImageGenerating else { return }
                                                                           self.selectedUpscaleCreativeIndex = index
                                                                           self.upscaleCreativeButtonTapped(index: index)
                                                                       }
                                                                       .buttonStyle(AppleStyleButton(isSelected: selectedUpscaleCreativeIndex == index))
                                                                   }
                                                                   .padding(4)
                                                                   .cornerRadius(8)
                                                               }
                                                               
                                                               if gridImage.isUpscaleSubtleSelected || gridImage.isUpscaleCreativeSelected {
                                                                   HStack(spacing: 8) {
                                                                       Button(action: { self.redoUpscaleSubtleButtonTapped(index: index) }) {
                                                                           VStack {
                                                                               Text("Redo Upscale")
                                                                               Text("(Subtle)")
                                                                           }
                                                                           .frame(maxWidth: .infinity, maxHeight: 50)
                                                                           .multilineTextAlignment(.center)
                                                                       }
                                                                       .buttonStyle(AppleStyleButton(isSelected: selectedRedoUpscaleSubtleButtonIndices.contains(index)))
                                                                       
                                                                       Button(action: { self.redoUpscaleCreativeButtonTapped(index: index) }) {
                                                                           VStack {
                                                                               Text("Redo Upscale")
                                                                               Text("(Creative)")
                                                                           }
                                                                           .frame(maxWidth: .infinity, maxHeight: 50)
                                                                           .multilineTextAlignment(.center)
                                                                       }
                                                                       .buttonStyle(AppleStyleButton(isSelected: selectedRedoUpscaleCreativeButtonIndices.contains(index)))
                                                                   }
                                                                   .padding(4)
                                                                   .cornerRadius(8)
                                                               }
                                                           }
                                                       }
                                                       .padding(.top, -260)
                                                   }
                                                   
                                                   
                                                   
                                                   
                                                   
                                               } else if (gridImage.source == "Redo Upscale" || gridImage.source == "Redo Upscale") && gridImage.isImageLoaded {
                                                   VStack(spacing: 0) {
                                                       Image(uiImage: gridImage.images.first ?? UIImage())
                                                           .resizable()
                                                           .scaledToFit()
                                                           .frame(maxWidth: 310, maxHeight: 310)
                                                           .padding(.bottom, 260)
                                                       
                                                       VStack(spacing: 4) {
                                                           if gridImage.showButtons {
                                                               HStack(spacing: 8) {
                                                                   Button("Vary (Strong)") { self.varyStrongButtonTapped(index: index) }
                                                                       .buttonStyle(AppleStyleButton(isSelected: selectedVaryStrongButtonIndices.contains(index)))
                                                                   Button("Vary (Subtle)") { self.varySubtleButtonTapped(index: index) }
                                                                       .buttonStyle(AppleStyleButton(isSelected: selectedVarySubtleButtonIndices.contains(index)))
                                                               }
                                                               .padding(4)
                                                               .cornerRadius(8)
                                                           }
                                                       }
                                                       .padding(.top, -260)
                                                   }
                                               } else {
                                                   GeometryReader { geometry in
                                                       let sideLength = geometry.size.width * 0.8
                                                       VStack(spacing: 0) {
                                                           ForEach(0..<2, id: \.self) { row in
                                                               HStack(spacing: 0) {
                                                                   ForEach(0..<2, id: \.self) { column in
                                                                       let imageIndex = row * 2 + column
                                                                       if gridImage.images.count > imageIndex {
                                                                           Image(uiImage: gridImage.images[imageIndex])
                                                                               .resizable()
                                                                               .scaledToFill()
                                                                               .frame(width: sideLength / 2, height: sideLength / 2)
                                                                               .border(Color.black, width: 0.5)
                                                                               .clipped()
                                                                               .onTapGesture {
                                                                                   if !self.selectedImages.contains(where: { $0.images == gridImage.images }) {
                                                                                       self.selectedImages.append(gridImage)
                                                                                   }
                                                                                   self.selectedImage = gridImage.images[imageIndex]
                                                                                   self.selectedGridPrompt = gridImage.prompt
                                                                                   self.isShowingDetailView = true
                                                                                   
                                                                                   
                                                                                   
                                                                               }
                                                                       }
                                                                   }
                                                               }
                                                           }
                                                       }
                                                       .frame(width: sideLength, height: sideLength)
                                                       .padding(.horizontal, (geometry.size.width - sideLength) / 2)
                                                   }
                                                   .aspectRatio(1, contentMode: .fit)
                                               }
                                               
                                               if !gridImage.images.isEmpty && gridImage.source != "Button U" && !creatingImageIndices.contains(index) && gridImage.source != "Redo Upscale" && gridImage.showButtons {
                                                   VStack {
                                                       HStack(spacing: 16) {
                                                           Button("V1", action: { self.v1ButtonTapped(index: index) })
                                                               .buttonStyle(VariationButtonStyle(isSelected: allGridImages[index].isV1Selected))
                                                               .disabled(isAnyImageGenerating)
                                                           Button("V2", action: { self.v2ButtonTapped(index: index) })
                                                               .buttonStyle(VariationButtonStyle(isSelected: allGridImages[index].isV2Selected))
                                                               .disabled(isAnyImageGenerating)
                                                           Button("V3", action: { self.v3ButtonTapped(index: index) })
                                                               .buttonStyle(VariationButtonStyle(isSelected: allGridImages[index].isV3Selected))
                                                               .disabled(isAnyImageGenerating)
                                                           Button("V4", action: { self.v4ButtonTapped(index: index) })
                                                               .buttonStyle(VariationButtonStyle(isSelected: allGridImages[index].isV4Selected))
                                                               .disabled(isAnyImageGenerating)
                                                       }
                                                       .padding(8)
                                                       .cornerRadius(8)
                                                       .offset(y: -78)
                                                       
                                                       HStack(spacing: 16) {
                                                           Button("U1", action: { self.u1ButtonTapped(index: index) })
                                                               .buttonStyle(VariationButtonStyle(isSelected: gridImage.isU1Selected))
                                                               .disabled(isAnyImageGenerating)
                                                           Button("U2", action: { self.u2ButtonTapped(index: index) })
                                                               .buttonStyle(VariationButtonStyle(isSelected: gridImage.isU2Selected))
                                                               .disabled(isAnyImageGenerating)
                                                           Button("U3", action: { self.u3ButtonTapped(index: index) })
                                                               .buttonStyle(VariationButtonStyle(isSelected: gridImage.isU3Selected))
                                                               .disabled(isAnyImageGenerating)
                                                           Button("U4", action: { self.u4ButtonTapped(index: index) })
                                                               .buttonStyle(VariationButtonStyle(isSelected: gridImage.isU4Selected))
                                                               .disabled(isAnyImageGenerating)
                                                       }
                                                       .padding(8)
                                                       .cornerRadius(8)
                                                       .offset(y: -93)
                                                   }
                                                   
                                                   if gridImage.source != "Upscale (Subtle)" && gridImage.source != "Upscale (Creative)" {
                                                       if gridImage.isUpscaleSubtleSelected || gridImage.isUpscaleCreativeSelected {
                                                           HStack(spacing: 8) {
                                                               Button(action: { self.redoUpscaleSubtleButtonTapped(index: index) }) {
                                                                   VStack {
                                                                       Text("Redo Upscale")
                                                                       Text("(Subtle)")
                                                                   }
                                                                   .frame(maxWidth: .infinity, maxHeight: 50)
                                                                   .multilineTextAlignment(.center)
                                                               }
                                                               .buttonStyle(AppleStyleButton(isSelected: selectedRedoUpscaleSubtleButtonIndices.contains(index)))
                                                               
                                                               Button(action: { self.redoUpscaleCreativeButtonTapped(index: index) }) {
                                                                   VStack {
                                                                       Text("Redo Upscale")
                                                                       Text("(Creative)")
                                                                   }
                                                                   .frame(maxWidth: .infinity, maxHeight: 50)
                                                                   .multilineTextAlignment(.center)
                                                               }
                                                               .buttonStyle(AppleStyleButton(isSelected: selectedRedoUpscaleCreativeButtonIndices.contains(index)))
                                                           }
                                                           .padding(4)
                                                           .cornerRadius(8)
                                                       }
                                                   }
                                               }
                                           }
                                           .id(gridImage.id)
                                       }
                                       .padding(.bottom, 50)
                                       .padding(.horizontal, 20)
                                       .frame(maxWidth: .infinity, maxHeight: .infinity)
                                       .onChange(of: allGridImages) { _ in
                                           updateImageGenerationState3()
                                           if shouldScroll {
                                               withAnimation {
                                                   proxy.scrollTo(allGridImages.last?.id, anchor: .bottom)
                                               }
                                           }
                                       }
                                   }
                                   
                                   
                                   if allGridImages.isEmpty {
                                       GeometryReader { geometry in
                                           VStack {
                                               Spacer()
                                               VStack {
                                                   Image("logox6")
                                                       .resizable()
                                                       .aspectRatio(contentMode: .fit)
                                                       .frame(width: 50, height: 50)
                                                       .background(
                                                        Circle()
                                                            .fill(Color.white)
                                                            .frame(width: 35, height: 35)
                                                            .shadow(color: .gray.opacity(0.3), radius: 3, x: 1, y: 1)
                                                       )
                                                       .padding(.bottom, -20)
                                                   Text("Let me turn your imagination into imagery.")
                                                       .font(.system(size: 17))
                                                       .foregroundColor(.black)
                                                       .padding(.top, 10)
                                                   Text("by Visual Creator AI")
                                                       .font(.system(size: 17))
                                                       .foregroundColor(.gray)
                                                       .padding(.top, 5)
                                               }
                                               .position(x: geometry.size.width / 2, y: geometry.size.height / 2 + 140) // Reduce el valor de 220 a 150


                                               Spacer()
                                           }
                                       }
                                   }
                                   
                                   
                                   
                                   
                                   VStack {
                                       ForEach(vButtonImages.indices, id: \.self) { index in
                                           let gridImage = allGridImages[index] // Define gridImage en el contexto adecuado
                                           if index < allPrompts.count {
                                               VStack(alignment: .leading) {
                                                   // Agregar logo y "Image Creator Bot" justo arriba del prompt
                                                   HStack {
                                                       Image("logox")
                                                           .resizable()
                                                           .frame(width: 50, height: 50)
                                                           .padding(.trailing, 3)
                                                       VStack(alignment: .leading, spacing: 4) {
                                                           HStack {
                                                               Text("Visual Creator Bot")
                                                                   .font(.system(size: 14))
                                                                   .fontWeight(.bold)
                                                                   .foregroundColor(.black)
                                                               Text(formatTimestamp(gridImage.timestamp))  // Usar el timestamp adecuado
                                                                   .font(.system(size: 12))
                                                                   .foregroundColor(.gray)
                                                                   .padding(.leading, 2)
                                                           }
                                                       }
                                                       .padding(.vertical, 5)
                                                       .offset(x: -10)
                                                   }
                                                   // Mueve "Image Creator Bot" más hacia abajo
                                                   Text("\(self.selectedPrompt) - Variations")
                                                       .font(.system(size: 14))
                                                       .foregroundColor(.gray)
                                                       .padding(.top, 2)
                                                   
                                                   GeometryReader { geometry in
                                                       let sideLength = geometry.size.width * 0.8
                                                       VStack(spacing: 0) {
                                                           ForEach(0..<2, id: \.self) { row in
                                                               HStack(spacing: 0) {
                                                                   ForEach(0..<2, id: \.self) { column in
                                                                       let imageIndex = row * 2 + column
                                                                       if vButtonImages[index].count > imageIndex {
                                                                           Image(uiImage: vButtonImages[index][imageIndex])
                                                                               .resizable()
                                                                               .scaledToFill()
                                                                               .frame(width: sideLength / 2, height: sideLength / 2)
                                                                               .border(Color.black, width: 0.5)
                                                                               .clipped()
                                                                               .onTapGesture {
                                                                                   self.selectedImage = vButtonImages[index][imageIndex]
                                                                                   self.isShowingDetailView = true
                                                                               }
                                                                       }
                                                                   }
                                                               }
                                                           }
                                                       }
                                                       .frame(width: sideLength, height: sideLength)
                                                       .padding(.horizontal, (geometry.size.width - sideLength) / 2)
                                                   }
                                                   .aspectRatio(1, contentMode: .fit)
                                                   
                                                   HStack(spacing: 16) { // Añade espaciado entre los botones
                                                       HStack {
                                                           // Añade espaciado entre los botones
                                                           Button("V1", action: { self.v1ButtonTapped(index: index) })
                                                               .buttonStyle(VariationButtonStyle(isSelected: allGridImages[index].isV1Selected))
                                                           Button("V2", action: { self.v2ButtonTapped(index: index) })
                                                               .buttonStyle(VariationButtonStyle(isSelected: allGridImages[index].isV2Selected))
                                                           Button("V3", action: { self.v3ButtonTapped(index: index) })
                                                               .buttonStyle(VariationButtonStyle(isSelected: allGridImages[index].isV3Selected))
                                                           Button("V4", action: { self.v4ButtonTapped(index: index) })
                                                               .buttonStyle(VariationButtonStyle(isSelected: allGridImages[index].isV4Selected))
                                                       }
                                                   }
                                                   .padding(-10)
                                                   .cornerRadius(0)
                                                   .offset(y: -65)
                                               }
                                           }
                                       }
                                       .padding(.horizontal, 20)
                                       .frame(maxWidth: .infinity, maxHeight: .infinity)
                                       .onChange(of: allGridImages) { _ in
                                           if shouldScroll {
                                               withAnimation {
                                                   proxy.scrollTo(allGridImages.last?.id, anchor: .bottom)
                                               }
                                           }
                                       }
                                   }
                                   .onAppear {
                                       if isImageLoaded.isEmpty {
                                           isImageLoaded = Array(repeating: false, count: allGridImages.count)
                                       }
                                       
                                       // Cargar datos y escuchar cambios desde Firestore
                                       //       self.loadDataAndListenFromFirestore()
                                       
                                       // Asignar el proxy del ScrollView
                                       self.scrollViewProxy = proxy
                                       
                                       // Desplazar automáticamente al último elemento
                                       if let lastImage = allGridImages.last {
                                           proxy.scrollTo(lastImage.id, anchor: .bottom)
                                       }
                                       
                                       // Cargar sesiones y empezar a usar la aplicación
                                       //   sessionManager.loadSessions()
                                       self.startUsingApp()
                                       
                                       // Eliminar el temporizador para desactivar el intervalo de tiempo
                                       /*
                                        Timer.scheduledTimer(withTimeInterval: 160, repeats: false) { _ in
                                        shouldScroll = false // Desactivar el desplazamiento automático después de 1 minuto
                                        }
                                        */
                                   }
                                   .onChange(of: allGridImages) { _ in
                                       if let scrollViewProxy = self.scrollViewProxy {
                                           scrollToEnd(proxy: scrollViewProxy)
                                       }
                                   }
                                   .onDisappear {
                                       self.stopUsingApp()
                                   }
                               }
                               
                           }
                       
                       
                       
                       
                       
                       
                       
                       
                       
                       
                       
                       
                       
                       
                       if !allButtonImages.isEmpty {
                           
                           Text("Button Generated Images")
                           
                               .font(.title)
                           
                               .padding()
                           
                           ForEach(allButtonImages, id: \.self) { imageSet in
                               
                               ForEach(imageSet, id: \.self) { image in
                                   
                                   Image(uiImage: image)
                                   
                                       .resizable()
                                   
                                       .scaledToFill()
                                   
                                       .frame(width: 100, height: 100)
                                   
                                       .clipped()
                                   
                               }
                               
                           }
                           
                       }
                       
                       
                       SearchBar(placeholder: "Message", text: $prompt, action: {
                           print("Botón 'Enviar' presionado")
                           blendImages(selectedImages: selectedBlendImages)
                           sendRequest()
                       }, isShowingImagePicker: $isShowingImagePicker, selectedBlendImages: $selectedBlendImages)
                       
                       
                       
                       
                       
                       .padding(.top, 0.01)
                       
                   }
                   
               }
               
               
               
               
               
               
               
               
               
               
               
               
               
               
               
               
               .fullScreenCover(isPresented: $shouldShowSubscriptionView) {
                   
                   AI_GodView(dismissView: $shouldShowSubscriptionView)
                   
               }
               
               
               
               
               
               
               
               .background(
                   NavigationLink(
                       destination: DetailedImageView(image: selectedImage ?? UIImage(), gridPrompt: selectedGridPrompt, showAIGodView: $showAIGodView),
                       isActive: $isShowingDetailView
                   ) {
                       EmptyView()
                   }
                       .navigationBarBackButtonHidden(true)
               )
               
               
               
               .alert(isPresented: $showLimitReachedAlert) {
                   
                   Alert(
                       
                       title: Text("Limit Reached"),
                       
                       message: Text("You have generated many images today. Please wait a while to generate more.This measure is to guarantee a better experience for the entire community."),
                       
                       dismissButton: .default(Text("OK"))
                       
                   )
                   
               }
               
           }
           
           .fullScreenCover(isPresented: $showAIGodView) {
               
               AI_GodView(dismissView: $showAIGodView)
               
           }
           
           .alert(isPresented: $showLimitReachedAlert) {
               
               Alert(
                   
                   title: Text("Limit Reached"),
                   
                   message: Text("You've reached your image generation limit.Do you want to Upgrade to Plus for unlimited generations?"),
                   
                   primaryButton: .default(Text("Upgrade to Plus")) {
                       
                       self.showAIGodView = true  // Activa la vista AI God View
                       
                   },
                   
                   secondaryButton: .cancel()
                   
               )
               
           }
           
           .fullScreenCover(isPresented: $showAIGodView) {
               
               AI_GodView(dismissView: $showAIGodView)  // Muestra AI God View cuando showAIGodView es true
               
           }
           
           .fullScreenCover(isPresented: $showingPikaVideoView) {
               
               PikaVideoView()
               
               
               
               
               
               
               
               
               
               
               
               
               
               
               
               
               
               
           }
           .navigationViewStyle(StackNavigationViewStyle())
           .navigationBarBackButtonHidden(true)
       }
   }
   
   
   func containsProhibitedWords(text: String) -> Bool {
       
       
       
       prohibitedWords.contains(where: text.lowercased().contains)
       
   }
   
   
   private func resetConversation() {
       self.allGridImages.removeAll { $0.source == "Local" } // Eliminar solo las imágenes locales
   }
    
   func sendRequest() {
       guard canSendNewRequest && !isAnyImageGenerating else {
           print("No se puede enviar el prompt. Espere \(timeRemainingForNewRequest) segundos o termine de generarse la imagen actual.")
           return
       }
       
     
       
       isGeneratingImages = true
       self.showImageCreatorText = true // Cambiar el estado aquí
       
       let currentPrompt = self.prompt // Guardar el prompt actual
       self.prompt = "" // Reiniciar el prompt después de usarlo
       
       let jobID = UUID().uuidString // Generar un jobID único
       
       // Verificar si el prompt es aceptado
       checkIfPromptIsAccepted(currentPrompt) { isAccepted in
           if isAccepted {
               let newGridImage = GridImage(images: [], prompt: currentPrompt, source: "Local", timestamp: Date(), jobID: jobID)
               self.allGridImages.append(newGridImage) // Añadir nuevo bloque vacío
               
               // Solo añadir el prompt a allPrompts si no es una solicitud de variación
               if !isVariationRequest {
                   self.allPrompts.append(currentPrompt) // Añadir el prompt actual a la lista de prompts
               }
           }
           
           self.processAndSendRequest(currentPrompt, isAccepted: isAccepted)
           
           func startRequestTimer() {
               self.canSendNewRequest = false
               self.timeRemainingForNewRequest = 30
               
               Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                   if self.timeRemainingForNewRequest > 0 {
                       self.timeRemainingForNewRequest -= 1
                   } else {
                       timer.invalidate()
                       self.canSendNewRequest = true
                   }
               }
           }
           
           startRequestTimer()
       }
   }
   
   private func checkIfPromptIsAccepted(_ prompt: String, completion: @escaping (Bool) -> Void) {
       // Implementar la lógica para verificar si el prompt es aceptado
       // Por ejemplo, podrías usar la función analyzeTextAndGenerateImages para esto
       analyzeTextAndGenerateImages(text: prompt) { isAppropriate in
           completion(isAppropriate)
       }
   }
   
   private func processAndSendRequest(_ text: String, isAccepted: Bool) {
       if !isAccepted {
           isLoading = false
           return
       }
       
       isLoading = true
       progressValue = 0.0
       compositeImage = nil
       
       detectLanguage(text) { isEnglish in
           if isEnglish {
               self.analyzeAndGenerateImages(text: text)
           } else {
               self.translateTextWithGoogleAPI(text) { translatedText in
                   self.analyzeAndGenerateImages(text: translatedText)
               }
           }
       }
   }
   
   // Funciones adicionales como detectLanguage, translateTextWithGoogleAPI, analyzeAndGenerateImages, etc., permanecen igual.
   
   
   
   
   
   private func analyzeAndGenerateImages(text: String) {
       
       
       
       if self.containsProhibitedWords(text: text) {
           
           
           
           // Manejar el caso en que el texto contiene palabras prohibidas
           
           
           
           DispatchQueue.main.async {
               
               
               
               self.isLoading = false
               
               
               
               // Mostrar algún mensaje de error al usuario
               
               
               
           }
           
           
           
       } else {
           
           
           
           // Si no hay palabras prohibidas, proceder con el análisis y la generación de imágenes
           
           
           
           self.analyzeTextAndGenerateImages(text: text) { isAppropriate in
               
               
               
               DispatchQueue.main.async {
                   
                   
                   
                   if isAppropriate {
                       
                       
                       
                       self.allPrompts.append(text)
                       
                       
                       
                       self.makeRequestForImageGeneration(text)
                       
                       
                       
                   } else {
                       
                       
                       
                       self.isLoading = false
                       
                       
                       
                       // Manejar el caso cuando el texto no es apropiado
                       
                       
                       
                   }
                   
                   
                   
               }
               
               
               
           }
           
           
           
       }
       
       
       
   }
   
   
   
    private func makeRequestForImageGeneration(_ prompt: String) {
        let initialRequestURL = "https://api.useapi.net/v2/jobs/imagine"
        makeRequest(urlString: initialRequestURL, isInitialRequest: true, prompt: prompt)
    }

    func makeRequest(urlString: String, isInitialRequest: Bool, prompt: String) {
        guard let url = URL(string: urlString) else {
            print("URL inválida: \(urlString)")
            self.isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isInitialRequest ? "POST" : "GET"
        request.addValue("Bearer user:807-hbo5l6k1Mv4rh7ApIcWFR", forHTTPHeaderField: "Authorization")
        
        if isInitialRequest {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let requestBody: [String: Any] = [
                "prompt": prompt,
                "discord": "MTE3ODgxNDkyMjM0MDE3NTkxNQ.GecmlV.3CjdjJBZLv7boAYim73QzDRRDtRR5qUCCxvUmw",
                "server": "1178973180602363974",
                "channel": "1178973181046952008",
                "replyUrl": "https://us-central1-image-creator-ai-a958f.cloudfunctions.net/receiveImageUrl",
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
            self.imageGenerationStarted = false
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error en la solicitud: \(error.localizedDescription)")
                    self.isLoading = false
                    return
                }
                
                guard let data = data else {
                    print("No se recibieron datos en la respuesta")
                    self.isLoading = false
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    
                    if isInitialRequest {
                        if let jobID = jsonResponse?["jobid"] as? String {
                            self.jobID = jobID
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                                self.checkJobStatus(prompt: prompt)
                            }
                            self.imageGenerationStarted = true
                        } else {
                            self.isLoading = false
                        }
                    } else {
                        if let status = jsonResponse?["status"] as? String {
                            if status == "completed" {
                                self.progressValue = 1.0
                                if let attachments = jsonResponse?["attachments"] as? [[String: Any]],
                                   let firstAttachment = attachments.first,
                                   let imageUrlString = firstAttachment["url"] as? String {
                                    self.loadImage(from: imageUrlString) { loadedImage in
                                        if let image = loadedImage {
                                            self.processLoadedImage(image, imageUrl: imageUrlString, prompt: prompt)
                                        }
                                    }
                                }
                            } else if status == "progress", let content = jsonResponse?["content"] as? String {
                                if let progress = self.extractProgress(from: content) {
                                    DispatchQueue.main.async {
                                        self.progressValue = Float(progress) / 100.0
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                                    self.checkJobStatus(prompt: prompt)
                                }
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                                    self.checkJobStatus(prompt: prompt)
                                }
                            }
                        }
                    }
                } catch {
                    print("Error al deserializar JSON: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }
        }.resume()
    }

    
    func uploadImageDetails(imageUrl: String, prompt: String) {
        let db = Firestore.firestore()
        let imageData: [String: Any] = [
            "url": imageUrl,
            "prompt": prompt,  // Guarda el prompt correcto
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        db.collection("images").addDocument(data: imageData) { error in
            if let error = error {
                print("Error al guardar los detalles de la imagen: \(error.localizedDescription)")
            } else {
                print("Detalles de la imagen guardados exitosamente")
            }
        }
    }
    
                          
                          struct VariationButtonStyle: ButtonStyle {
                              var isSelected: Bool
                              
                              func makeBody(configuration: Configuration) -> some View {
                                  configuration.label
                                      .font(.system(size: 16, weight: .bold))
                                      .foregroundColor(isSelected ? .white : .black) // Cambia el color del texto cuando está seleccionado
                                      .frame(width: 50, height: 50)
                                      .background(isSelected ? Color.customBlueColor : Color.white)
                                      .cornerRadius(8)
                                      .overlay(
                                          RoundedRectangle(cornerRadius: 8)
                                              .stroke(Color.gray, lineWidth: 0.5)
                                      )
                                      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                                      .shadow(color: .gray.opacity(0.3), radius: 3, x: 1, y: 1)
                              }
                          }
                          
                          
                          
                          
                          
                          
                          
                          
                          
                          
                          
                          
                          struct AppleStyleButton: ButtonStyle {
                              var isSelected: Bool
                              
                              func makeBody(configuration: Configuration) -> some View {
                                  configuration.label
                                      .font(.system(size: 12))
                                      .frame(width: 110, height: 25)
                                      .padding(.horizontal, 20)
                                      .padding(.vertical, 10) // Ajusta el padding vertical para mantener la altura correcta
                                      .background(isSelected ? Color.customBlueColor : Color.white)
                                      .foregroundColor(isSelected ? .white : .black)
                                      .cornerRadius(8)
                                      .overlay(
                                          RoundedRectangle(cornerRadius: 8)
                                              .stroke(Color.gray, lineWidth: 0.5)
                                      )
                                      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                                      .shadow(color: .gray.opacity(0.3), radius: 3, x: 1, y: 1)
                              }
                          }
                          
    func varyStrongButtonTapped(index: Int) {
                  guard canSendNewVariationRequest && !isAnyImageGenerating else {
                      print("No se puede enviar el prompt. Espere \(timeRemainingForNewVariationRequest) segundos o termine de generarse la imagen actual.")
                      return
                  }
                  guard index < allGridImages.count else { return }
                  let image = allGridImages[index]
                  
                  let newPrompt = image.prompt.components(separatedBy: " - Image #").first! + " - Variations (Strong)"
                  
                  let placeholderImage = GridImage(images: [], prompt: newPrompt, source: "Vary (Strong)", timestamp: Date(), jobID: image.jobID)
                  self.allGridImages.append(placeholderImage)
                  
                  selectedVaryStrongButtonIndices.insert(index)
                  creatingImageIndices.insert(allGridImages.count - 1)  // Añadir el índice al conjunto
                  
                  updateImageGeneratingState()
                  print("Creating Image Indices (Vary Strong): \(creatingImageIndices)")
                  
                  makeRequestForImageGeneration(button: "Vary (Strong)", jobID: image.jobID, shouldUpdateUI: true, placeholderImage: placeholderImage) {
                      self.creatingImageIndices.remove(allGridImages.count - 1)  // Eliminar el índice al completar
                      self.updateImageGeneratingState()
                      print("Creating Image Indices después de completar (Vary Strong): \(creatingImageIndices)")
                  }
                  
                  startVariationRequestTimer()
              }
              
              func varySubtleButtonTapped(index: Int) {
                  guard canSendNewVariationRequest && !isAnyImageGenerating else {
                      print("No se puede enviar el prompt. Espere \(timeRemainingForNewVariationRequest) segundos o termine de generarse la imagen actual.")
                      return
                  }
                  guard index < allGridImages.count else { return }
                  let image = allGridImages[index]
                  
                  let newPrompt = image.prompt.components(separatedBy: " - Image #").first! + " - Variations (Subtle)"
                  
                  let placeholderImage = GridImage(images: [], prompt: newPrompt, source: "Vary (Subtle)", timestamp: Date(), jobID: image.jobID)
                  self.allGridImages.append(placeholderImage)
                  
                  selectedVarySubtleButtonIndices.insert(index)
                  creatingImageIndices.insert(allGridImages.count - 1)  // Añadir el índice al conjunto
                  
                  updateImageGeneratingState()
                  print("Creating Image Indices (Vary Subtle): \(creatingImageIndices)")
                  
                  makeRequestForImageGeneration(button: "Vary (Subtle)", jobID: image.jobID, shouldUpdateUI: true, placeholderImage: placeholderImage) {
                      self.creatingImageIndices.remove(allGridImages.count - 1)  // Eliminar el índice al completar
                      self.updateImageGeneratingState()
                      print("Creating Image Indices después de completar (Vary Subtle): \(creatingImageIndices)")
                  }
                  
                  startVariationRequestTimer()
              }
              
              func upscaleSubtleButtonTapped(index: Int) {
                  guard canSendNewVariationRequest && !isAnyImageGenerating else {
                      print("No se puede enviar el prompt. Espere \(timeRemainingForNewVariationRequest) segundos o termine de generarse la imagen actual.")
                      return
                  }
                  guard index < allGridImages.count else { return }
                  var gridImage = allGridImages[index]
                  
                  let newPrompt = gridImage.prompt.components(separatedBy: " - Image #").first! + " - Upscaled (Subtle)"
                  
                  let placeholderImage = GridImage(images: [], prompt: newPrompt, source: "Upscale (Subtle)", timestamp: Date(), jobID: gridImage.jobID, isUpscaleSubtleSelected: true, isUpscaleCreativeSelected: gridImage.isUpscaleCreativeSelected, isUpscaleSubtleDone: true)
                  self.allGridImages.append(placeholderImage)
                  
                  creatingImageIndices.insert(allGridImages.count - 1)  // Añadir el índice al conjunto
                  
                  updateImageGeneratingState()
                  print("Creating Image Indices (Upscale Subtle): \(creatingImageIndices)")
                  
                  makeRequestForImageGeneration(button: "Upscale (Subtle)", jobID: gridImage.jobID, shouldUpdateUI: true, placeholderImage: placeholderImage) {
                      if let placeholderIndex = self.allGridImages.firstIndex(of: placeholderImage) {
                          self.creatingImageIndices.remove(placeholderIndex)  // Eliminar el índice al completar
                      }
                      self.isLoading = false
                      self.updateImageGeneratingState()
                      print("Creating Image Indices después de completar (Upscale Subtle): \(creatingImageIndices)")
                  }
                  isUpscaleSubtleSelected = true
                  
                  startVariationRequestTimer()
              }
              
              func upscaleCreativeButtonTapped(index: Int) {
                  guard canSendNewVariationRequest && !isAnyImageGenerating else {
                      print("No se puede enviar el prompt. Espere \(timeRemainingForNewVariationRequest) segundos o termine de generarse la imagen actual.")
                      return
                  }
                  guard index < allGridImages.count else { return }
                  var gridImage = allGridImages[index]
                  
                  let newPrompt = gridImage.prompt.components(separatedBy: " - Image #").first! + " - Upscaled (Creative)"
                  
                  let placeholderImage = GridImage(images: [], prompt: newPrompt, source: "Upscale (Creative)", timestamp: Date(), jobID: gridImage.jobID, isUpscaleSubtleSelected: gridImage.isUpscaleSubtleSelected, isUpscaleCreativeSelected: true, isUpscaleCreativeDone: true)
                  self.allGridImages.append(placeholderImage)
                  
                  creatingImageIndices.insert(allGridImages.count - 1)  // Añadir el índice al conjunto
                  
                  updateImageGeneratingState()
                  print("Creating Image Indices (Upscale Creative): \(creatingImageIndices)")
                  
                  makeRequestForImageGeneration(button: "Upscale (Creative)", jobID: gridImage.jobID, shouldUpdateUI: true, placeholderImage: placeholderImage) {
                      if let placeholderIndex = self.allGridImages.firstIndex(of: placeholderImage) {
                          self.creatingImageIndices.remove(placeholderIndex)  // Eliminar el índice al completar
                      }
                      self.isLoading = false
                      self.updateImageGeneratingState()
                      print("Creating Image Indices después de completar (Upscale Creative): \(creatingImageIndices)")
                  }
                  isUpscaleCreativeSelected = true
                  
                  startVariationRequestTimer()
              }
              
              func redoUpscaleSubtleButtonTapped(index: Int) {
                  guard canSendNewVariationRequest && !isAnyImageGenerating else {
                      print("No se puede enviar el prompt. Espere \(timeRemainingForNewVariationRequest) segundos o termine de generarse la imagen actual.")
                      return
                  }
                  guard index < allGridImages.count else { return }
                  let image = allGridImages[index]
                  let newPrompt = image.prompt.components(separatedBy: " - Image #").first! + " - Redo Upscaled (Subtle)"
                  let placeholderImage = GridImage(images: [], prompt: newPrompt, source: "Redo Upscale (Subtle)", timestamp: Date(), jobID: image.jobID, showScanningText: true, origin: "RedoUpscale", isImageLoaded: false)
                  self.allGridImages.append(placeholderImage)
                  
                  creatingImageIndices.insert(allGridImages.count - 1)  // Añadir el índice al conjunto
                  selectedRedoUpscaleSubtleButtonIndices.insert(index)
                  
                  updateImageGeneratingState()
                  print("Creating Image Indices (Redo Upscale Subtle): \(creatingImageIndices)")
                  
                  makeRequestForRedo(urlString: "https://api.useapi.net/v2/jobs/button", isInitialRequest: true, button: "Redo Upscale (Subtle)", jobID: image.jobID, shouldUpdateUI: true, placeholderImage: placeholderImage) {
                      self.updateImageGeneratingState()  // Permitir de nuevo la interacción
                      print("Creating Image Indices después de completar (Redo Upscale Subtle): \(creatingImageIndices)")
                  }
                  
                  startVariationRequestTimer()
              }
              
              func redoUpscaleCreativeButtonTapped(index: Int) {
                  guard canSendNewVariationRequest && !isAnyImageGenerating else {
                      print("No se puede enviar el prompt. Espere \(timeRemainingForNewVariationRequest) segundos o termine de generarse la imagen actual.")
                      return
                  }
                  guard index < allGridImages.count else { return }
                  let image = allGridImages[index]
                  let newPrompt = image.prompt.components(separatedBy: " - Image #").first! + " - Redo Upscaled (Creative)"
                  let placeholderImage = GridImage(images: [], prompt: newPrompt, source: "Redo Upscale (Creative)", timestamp: Date(), jobID: image.jobID, showScanningText: true, origin: "RedoUpscale", isImageLoaded: false)
                  self.allGridImages.append(placeholderImage)
                  
                  creatingImageIndices.insert(allGridImages.count - 1)  // Añadir el índice al conjunto
                  selectedRedoUpscaleCreativeButtonIndices.insert(index)
                  
                  updateImageGeneratingState()
                  print("Creating Image Indices (Redo Upscale Creative): \(creatingImageIndices)")
                  
                  makeRequestForRedo(urlString: "https://api.useapi.net/v2/jobs/button", isInitialRequest: true, button: "Redo Upscale (Creative)", jobID: image.jobID, shouldUpdateUI: true, placeholderImage: placeholderImage) {
                      self.updateImageGeneratingState()  // Permitir de nuevo la interacción
                      print("Creating Image Indices después de completar (Redo Upscale Creative): \(creatingImageIndices)")
                  }
                  
                  startVariationRequestTimer()
              }
              

                            func startVariationRequestTimer() {
                                self.canSendNewVariationRequest = false
                                self.timeRemainingForNewVariationRequest = 10

                                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                                    if self.timeRemainingForNewVariationRequest > 0 {
                                        self.timeRemainingForNewVariationRequest -= 1
                                    } else {
                                        timer.invalidate()
                                        self.canSendNewVariationRequest = true
                                    }
                                }
                            }

                            // Función para iniciar el temporizador para los botones U
                            func startURequestTimer() {
                                self.canSendNewURequest = false
                                self.timeRemainingForNewURequest = 10

                                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                                    if self.timeRemainingForNewURequest > 0 {
                                        self.timeRemainingForNewURequest -= 1
                                    } else {
                                        timer.invalidate()
                                        self.canSendNewURequest = true
                                    }
                                }
                            }

                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            struct CircularButtonStyle: ButtonStyle {
                                
                                func makeBody(configuration: Configuration) -> some View {
                                    
                                    configuration.label
                                    
                                        .font(.system(size: 14)) // Tamaño del texto
                                    
                                        .foregroundColor(.white) // Color del texto
                                    
                                        .frame(width: 50, height: 50) // Tamaño del botón
                                    
                                        .background(Color.black) // Color de fondo del botón
                                    
                                        .clipShape(Circle()) // Hace que el botón sea circular
                                    
                                        .scaleEffect(configuration.isPressed ? 0.95 : 1.05)
                                    
                                    
                                    
                                }
                                
                            }
                            
                            
                            
                            
                            
       func v1ButtonTapped(index: Int) {
           guard canSendNewRequest && !isAnyImageGenerating else {
               print("No se puede enviar el prompt. Espere \(timeRemainingForNewRequest) segundos.")
               return
           }

           guard index < allGridImages.count else { return }
           allGridImages[index].isV1Selected = true
           self.selectedPrompt = allGridImages[index].prompt
           isGeneratingVariation = true
           isGeneratingImage = true
           let placeholderImage = addPreliminaryImageToUI(prompt: self.selectedPrompt, timestamp: Date(), isVariationPrompt: true, parentJobID: allGridImages[index].jobID)
           makeRequestForImageGeneration(button: "V1", jobID: allGridImages[index].jobID, shouldUpdateUI: true, placeholderImage: placeholderImage) {
               self.isGeneratingImage = false  // Permitir de nuevo la interacción
               self.updateImageGenerationState3() // Actualizar el estado de generación de imagen
               self.startURequestTimer() // Iniciar el temporizador para los botones U
           }

           startRequestTimer1()
           startUTimerAfterV() // Iniciar el temporizador para los botones U después de presionar V
       }

       func v2ButtonTapped(index: Int) {
           guard canSendNewRequest && !isAnyImageGenerating else {
               print("No se puede enviar el prompt. Espere \(timeRemainingForNewRequest) segundos.")
               return
           }

           guard index < allGridImages.count else { return }
           allGridImages[index].isV2Selected = true
           self.selectedPrompt = allGridImages[index].prompt
           isGeneratingVariation = true
           isGeneratingImage = true
           let placeholderImage = addPreliminaryImageToUI(prompt: self.selectedPrompt, timestamp: Date(), isVariationPrompt: true, parentJobID: allGridImages[index].jobID)
           makeRequestForImageGeneration(button: "V2", jobID: allGridImages[index].jobID, shouldUpdateUI: true, placeholderImage: placeholderImage) {
               self.isGeneratingImage = false  // Permitir de nuevo la interacción
               self.updateImageGenerationState3() // Actualizar el estado de generación de imagen
               self.startURequestTimer() // Iniciar el temporizador para los botones U
           }

           startRequestTimer1()
           startUTimerAfterV() // Iniciar el temporizador para los botones U después de presionar V
       }

       func v3ButtonTapped(index: Int) {
           guard canSendNewRequest && !isAnyImageGenerating else {
               print("No se puede enviar el prompt. Espere \(timeRemainingForNewRequest) segundos.")
               return
           }

           guard index < allGridImages.count else { return }
           allGridImages[index].isV3Selected = true
           self.selectedPrompt = allGridImages[index].prompt
           isGeneratingVariation = true
           isGeneratingImage = true
           let placeholderImage = addPreliminaryImageToUI(prompt: self.selectedPrompt, timestamp: Date(), isVariationPrompt: true, parentJobID: allGridImages[index].jobID)
           makeRequestForImageGeneration(button: "V3", jobID: allGridImages[index].jobID, shouldUpdateUI: true, placeholderImage: placeholderImage) {
               self.isGeneratingImage = false  // Permitir de nuevo la interacción
               self.updateImageGenerationState3() // Actualizar el estado de generación de imagen
               self.startURequestTimer() // Iniciar el temporizador para los botones U
           }

           startRequestTimer1()
           startUTimerAfterV() // Iniciar el temporizador para los botones U después de presionar V
       }

       func v4ButtonTapped(index: Int) {
           guard canSendNewRequest && !isAnyImageGenerating else {
               print("No se puede enviar el prompt. Espere \(timeRemainingForNewRequest) segundos.")
               return
           }

           guard index < allGridImages.count else { return }
           allGridImages[index].isV4Selected = true
           self.selectedPrompt = allGridImages[index].prompt
           isGeneratingVariation = true
           isGeneratingImage = true
           let placeholderImage = addPreliminaryImageToUI(prompt: self.selectedPrompt, timestamp: Date(), isVariationPrompt: true, parentJobID: allGridImages[index].jobID)
           makeRequestForImageGeneration(button: "V4", jobID: allGridImages[index].jobID, shouldUpdateUI: true, placeholderImage: placeholderImage) {
               self.isGeneratingImage = false  // Permitir de nuevo la interacción
               self.updateImageGenerationState3() // Actualizar el estado de generación de imagen
               self.startURequestTimer() // Iniciar el temporizador para los botones U
           }

           startRequestTimer1()
           startUTimerAfterV() // Iniciar el temporizador para los botones U después de presionar V
       }
       func startRequestTimer1() {
           self.canSendNewRequest = false
           self.timeRemainingForNewRequest = 22
           
           Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
               if self.timeRemainingForNewRequest > 0 {
                   self.timeRemainingForNewRequest -= 1
               } else {
                   timer.invalidate()
                   self.canSendNewRequest = true
               }
           }
       }

       func addPreliminaryImageToUI(prompt: String, timestamp: Date, isVariationPrompt: Bool = false, parentJobID: String? = nil) -> GridImage {
           let jobID = UUID().uuidString
           let placeholderImage = GridImage(images: [], prompt: prompt, source: "Local", timestamp: timestamp, jobID: jobID, isVariationPrompt: isVariationPrompt, parentJobID: parentJobID)
           self.allGridImages.append(placeholderImage)
           return placeholderImage
       }

       func makeRequestForImageGeneration(button: String, jobID: String, shouldUpdateUI: Bool = true, placeholderImage: GridImage? = nil, completion: (() -> Void)? = nil) {
                   let initialRequestURL = "https://api.useapi.net/v2/jobs/button"
                   if button.starts(with: "U") {
                       makeButtonRequestForU(urlString: initialRequestURL, isInitialRequest: true, button: button, jobID: jobID, shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage)
                   } else if button.starts(with: "Redo") {
                       makeRequestForRedo(urlString: initialRequestURL, isInitialRequest: true, button: button, jobID: jobID, shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage)
                   } else {
                       makeRequest(urlString: initialRequestURL, isInitialRequest: true, button: button, jobID: jobID, shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage, completion: completion)
                   }
               }

               func makeRequest(urlString: String, isInitialRequest: Bool, button: String, jobID: String, shouldUpdateUI: Bool, placeholderImage: GridImage? = nil, prompt: String = "", completion: (() -> Void)? = nil) {
                   guard let url = URL(string: urlString) else {
                       isGeneratingVariation = false
                       self.isLoading = false
                       return
                   }
                   
                   self.isGeneratingImage = true // Iniciar generación de imagen
                   
                   var request = URLRequest(url: url)
                   request.httpMethod = isInitialRequest ? "POST" : "GET"
                   request.addValue("Bearer user:807-hbo5l6k1Mv4rh7ApIcWFR", forHTTPHeaderField: "Authorization")
                   
                   if isInitialRequest {
                       request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                       let requestBody: [String: Any] = [
                           "jobid": jobID,
                           "button": button,
                           "discord": "MTE3ODgxNDkyMjM0MDE3NTkxNQ.GecmlV.3CjdjJBZLv7boAYim73QzDRRDtRR5qUCCxvUmw",
                           "maxJobs": 3,
                       ]
                       request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
                   }
                   
                   URLSession.shared.dataTask(with: request) { data, response, error in
                       DispatchQueue.main.async {
                           if let error = error {
                               self.isLoading = false
                               self.isGeneratingImage = false // Finalizar generación de imagen
                               self.updateImageGeneratingState()
                               return
                           }
                           
                           guard let data = data else {
                               self.isLoading = false
                               self.isGeneratingImage = false // Finalizar generación de imagen
                               self.updateImageGeneratingState()
                               return
                           }
                           
                           do {
                               let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                               if isInitialRequest, let jobID = jsonResponse?["jobid"] as? String {
                                   self.jobID = jobID
                                   DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                                       self.checkJobStatus1(shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage, prompt: prompt, completion: completion)
                                   }
                               } else if let status = jsonResponse?["status"] as? String {
                                   if status == "completed", let attachments = jsonResponse?["attachments"] as? [[String: Any]], let firstAttachment = attachments.first, let imageUrlString = firstAttachment["url"] as? String {
                                       self.loadImage(from: imageUrlString) { loadedImage in
                                           if let image = loadedImage {
                                               self.processLoadedImage1(image, shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage, imageUrl: imageUrlString, prompt: prompt, completion: completion)
                                               self.uploadImageDetails(imageUrl: imageUrlString, prompt: prompt) // Subir detalles de la imagen a Firestore
                                               self.isGeneratingImage = false // Finalizar generación de imagen
                                               self.updateImageGeneratingState()
                                           }
                                       }
                                   } else {
                                       DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                                           self.checkJobStatus1(shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage, prompt: prompt, completion: completion)
                                       }
                                   }
                               }

                               // Procesar el array children
                               if let children = jsonResponse?["children"] as? [[String: Any]] {
                                   for child in children {
                                       if let button = child["button"] as? String, let childJobID = child["jobid"] as? String {
                                           print("Button: \(button), JobID: \(childJobID)")
                                           // Almacenar o utilizar el button y childJobID según sea necesario
                                       }
                                   }
                               }

                           } catch {
                               self.isLoading = false
                               self.isGeneratingImage = false // Finalizar generación de imagen
                               self.updateImageGeneratingState()
                           }
                       }
                   }.resume()
               }

           
              
       func updateImageGeneratingState1() {
              DispatchQueue.main.async {
                  self.isAnyImageGenerating = !self.creatingImageIndices.isEmpty
                  print("Estado de generación de imágenes actualizado: \(self.isAnyImageGenerating)")
              }
          }
          
          func checkJobStatus1(shouldUpdateUI: Bool, placeholderImage: GridImage?, prompt: String, completion: (() -> Void)? = nil) {
              guard let jobID = self.jobID else { return }
              let statusCheckURL = "https://api.useapi.net/v2/jobs/?jobid=\(jobID)"
              makeRequest(urlString: statusCheckURL, isInitialRequest: false, button: "", jobID: jobID, shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage, prompt: prompt, completion: completion)
          }
          
          
          func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
              guard let url = URL(string: urlString) else {
                  DispatchQueue.main.async {
                      self.isLoading = false
                      completion(nil)
                  }
                  return
              }
              
              URLSession.shared.dataTask(with: url) { data, _, error in
                  DispatchQueue.main.async {
                      if let data = data, let uiImage = UIImage(data: data) {
                          completion(uiImage)
                      } else {
                          self.isLoading = false
                          completion(nil)
                      }
                  }
              }.resume()
          }
          
          func removeCreatingImageIndex(for jobID: String) {
              if let index = allGridImages.firstIndex(where: { $0.jobID == jobID }) {
                  creatingImageIndices.remove(index)
              }
          }
          
          func processLoadedImage1(_ image: UIImage, shouldUpdateUI: Bool, placeholderImage: GridImage?, imageUrl: String, prompt: String, source: String = "Local", completion: (() -> Void)? = nil) {
              if let jobID = self.jobID {
                  self.combineImagesIntoGrid1(image, prompt: prompt, source: source, jobID: jobID)
                  DispatchQueue.global().async {
                      self.saveImageDetailsToFirestore(imageUrl: imageUrl, prompt: prompt, jobID: jobID)
                      DispatchQueue.main.async {
                      //    self.imageCounter.incrementCounter() // Incrementa el contador cuando la imagen se procesa y guarda exitosamente
                      }
                  }
              }
              
              DispatchQueue.main.async {
                  self.isLoading = false
                  isGeneratingVariation = false // Resetear aquí al completar
                  if shouldUpdateUI {
                      self.replacePlaceholderImage(placeholderImage, with: image)
                      self.sortImagesByDate()
                      if let index = self.allGridImages.firstIndex(where: { $0.jobID == placeholderImage?.jobID }) {
                          self.creatingImageIndices.remove(index)  // Eliminar el índice del conjunto
                          self.removeCreatingImageIndex(for: placeholderImage?.jobID ?? "") // Llamada para eliminar el índice
                          self.allGridImages[index].isUpscaling = false // Actualizar estado de upscaling
                      }
                  }
                  completion?()  // Llamar a la callback al finalizar
              }
          }
          
          
          
          func combineImagesIntoGrid1(_ image: UIImage, prompt: String, source: String, jobID: String, timestamp: Date = Date()) {
                 let swiftImage = SwiftImage.Image<RGBA<UInt8>>(uiImage: image)
                 let size = CGSize(width: swiftImage.width / 2, height: swiftImage.height / 2)
                 var images: [UIImage] = []

                 for y in 0..<2 {
                     for x in 0..<2 {
                         let startX = x * Int(size.width)
                         let startY = y * Int(size.height)
                         let slice = swiftImage[startX..<(startX + Int(size.width)), startY..<(startY + Int(size.height))].uiImage
                         images.append(slice)
                     }
                 }

                 DispatchQueue.main.async {
                     // Verificar si ya existe una imagen con el mismo jobID
                     if !self.allGridImages.contains(where: { $0.jobID == jobID }) {
                         if let index = self.allGridImages.firstIndex(where: { $0.images.isEmpty }) {
                             self.allGridImages[index].images = images
                             self.allGridImages[index].jobID = jobID // Asigna el jobID a la imagen existente
                         } else {
                             // let gridImage = GridImage(images: images, prompt: prompt, source: source, timestamp: timestamp, jobID: jobID)
                             // self.allGridImages.append(gridImage)
                             // self.allPrompts.append(prompt)
                         }
                         self.sortImagesByDate()
                     }
                 }
             }



          func replacePlaceholderImage(_ placeholderImage: GridImage?, with image: UIImage) {
              guard let placeholderImage = placeholderImage else { return }
              DispatchQueue.main.async {
                  if self.allGridImages.contains(where: { $0.jobID == placeholderImage.jobID }) {
                      return
                  }
                  if let index = self.allGridImages.firstIndex(of: placeholderImage) {
                      let swiftImage = SwiftImage.Image<RGBA<UInt8>>(uiImage: image)
                      let size = CGSize(width: swiftImage.width / 2, height: swiftImage.height / 2)
                      var images: [UIImage] = []
                      for y in 0..<2 {
                          for x in 0..<2 {
                              let startX = x * Int(size.width)
                              let startY = y * Int(size.height)
                              let slice = swiftImage[startX..<(startX + Int(size.width)), startY..<(startY + Int(size.height))].uiImage
                              images.append(slice)
                          }
                      }
                      self.allGridImages.remove(at: index)
                      let newGridImage = GridImage(images: images, prompt: placeholderImage.prompt, source: placeholderImage.source, timestamp: placeholderImage.timestamp, jobID: placeholderImage.jobID)
                      self.allGridImages.append(newGridImage)
                      self.sortImagesByDate()
                  }
              }
          }
          
          func uploadImageDetails2(imageUrl: String, prompt: String) {
              let db = Firestore.firestore()
              let imageData: [String: Any] = [
                  "url": imageUrl,
                  "prompt": prompt,  // Guarda el prompt correcto
                  "timestamp": FieldValue.serverTimestamp()
              ]
              
              db.collection("images").addDocument(data: imageData) { error in
                  if let error = error {
                      print("Error al guardar los detalles de la imagen: \(error.localizedDescription)")
                  } else {
                      print("Detalles de la imagen guardados exitosamente")
                  }
              }
          }



                            
       func makeButtonRequestForU(urlString: String, isInitialRequest: Bool, button: String, jobID: String, shouldUpdateUI: Bool, placeholderImage: GridImage?, completion: (() -> Void)? = nil) {
           guard let url = URL(string: urlString) else {
               print("URL inválida: \(urlString)")
               self.isLoading = false
               return
           }
           
           var request = URLRequest(url: url)
           request.httpMethod = isInitialRequest ? "POST" : "GET"
           request.addValue("Bearer user:807-hbo5l6k1Mv4rh7ApIcWFR", forHTTPHeaderField: "Authorization")
           
           if isInitialRequest {
               request.addValue("application/json", forHTTPHeaderField: "Content-Type")
               let requestBody: [String: Any] = [
                   "jobid": jobID,
                   "button": button,
                   "discord": "MTE3ODgxNDkyMjM0MDE3NTkxNQ.GecmlV.3CjdjJBZLv7boAYim73QzDRRDtRR5qUCCxvUmw",
                   "maxJobs": 3,
               ]
               request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
               print("Enviando solicitud inicial para el botón: \(button) con body: \(requestBody)")
           }
           
           URLSession.shared.dataTask(with: request) { data, response, error in
               DispatchQueue.main.async {
                   if let error = error {
                       print("Error en la solicitud: \(error.localizedDescription)")
                       self.isLoading = false
                       completion?()
                       return
                   }
                   
                   guard let data = data else {
                       print("No se recibieron datos en la respuesta")
                       self.isLoading = false
                       completion?()
                       return
                   }
                   
                   do {
                       let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                       print("Respuesta JSON recibida: \(String(describing: jsonResponse))")
                       
                       if isInitialRequest, let jobID = jsonResponse?["jobid"] as? String {
                           self.jobID = jobID
                           print("Job ID obtenido: \(jobID)")
                           DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                               self.checkButtonJobStatusForU(shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage)
                           }
                       } else if let status = jsonResponse?["status"] as? String, status == "completed", let attachments = jsonResponse?["attachments"] as? [[String: Any]], let firstAttachment = attachments.first, let imageUrlString = firstAttachment["url"] as? String {
                           self.loadImage(from: imageUrlString) { loadedImage in
                               if let image = loadedImage {
                                   self.processButtonLoadedImageForU(image, shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage, imageUrl: imageUrlString, jobID: jobID)
                               }
                           }
                       } else {
                           DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                               self.checkButtonJobStatusForU(shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage)
                           }
                       }
                   } catch {
                       print("Error al deserializar JSON: \(error.localizedDescription)")
                       self.isLoading = false
                       completion?()
                   }
               }
           }.resume()
       }

       func checkButtonJobStatusForU(shouldUpdateUI: Bool, placeholderImage: GridImage?) {
           guard let jobID = self.jobID else {
               print("No hay jobID disponible")
               return
           }
           let statusCheckURL = "https://api.useapi.net/v2/jobs/?jobid=\(jobID)"
           makeButtonRequestForU(urlString: statusCheckURL, isInitialRequest: false, button: "", jobID: jobID, shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage)
       }

       func processButtonLoadedImageForU(_ image: UIImage, shouldUpdateUI: Bool, placeholderImage: GridImage?, imageUrl: String, jobID: String) {
           DispatchQueue.main.async {
               self.isLoading = false
               if shouldUpdateUI {
                   if let placeholderImage = placeholderImage, let index = self.allGridImages.firstIndex(of: placeholderImage) {
                       self.allGridImages[index].images = [image]
                       self.allGridImages[index].source = "Button U"
                       self.allGridImages[index].jobID = self.jobID ?? jobID
                       self.allGridImages[index].isImageLoaded = true
                       self.allGridImages[index].isUpscaling = false // Actualizar estado de upscaling
                       self.creatingImageIndices.remove(index)
                   }
                   self.sortImagesByDate()
               } else {
                   print("Imagen procesada pero no añadida a la interfaz de usuario")
               }
               DispatchQueue.main.async {
                  // self.imageCounter.incrementCounter()
              //     self.saveImageDetailsToFirestore(imageUrl: imageUrl, promptText: placeholderImage?.prompt ?? "unknown", jobID: jobID)
               }
               self.updateImageGenerationState3() // Actualizar el estado de generación de imagen
           }
       }

       func u1ButtonTapped(index: Int) {
           guard canSendNewURequest && canSendURequestAfterV && !isAnyImageGenerating else {
               print("No se puede enviar el prompt. Espere \(timeRemainingForNewURequest) segundos o termine de generarse la imagen actual.")
               return
           }

           if index < allGridImages.count && allGridImages[index].images.count > 0 {
               var gridImage = allGridImages[index]
               let newSelectedImage = allGridImages[index]

               // Generar un nuevo prompt solo para el placeholder sin modificar el original
               let newPrompt = gridImage.prompt.components(separatedBy: " - Image #").first! + " - Image #1"

               gridImage.isU1Selected = true
               gridImage.uButtonStates["U1"] = true // Actualizar el estado del botón U1

               // Crear una nueva imagen placeholder con isUpscaling = true
               let placeholderImage = GridImage(images: [], prompt: newPrompt, source: "Button U", timestamp: Date(), jobID: newSelectedImage.jobID, isUpscaling: true, uButtonStates: [:])
               self.allGridImages.append(placeholderImage) // Añadir al final de la lista
               isGeneratingImage = true
               print("Botón U1 presionado, prompt generado: \(newPrompt)")
               makeRequestForImageGeneration(button: "U1", jobID: newSelectedImage.jobID, shouldUpdateUI: true, placeholderImage: placeholderImage) {
                   self.isGeneratingImage = false // Permitir de nuevo la interacción
                   self.updateImageGenerationState3() // Actualizar el estado de generación de imagen
               }
               allGridImages[index] = gridImage // Actualizar el estado de allGridImages
               print("Estado de allGridImages actualizado en index: \(index)")
           }

           startURequestTimer()
           print("Temporizador de solicitud U iniciado")
       }


       func u2ButtonTapped(index: Int) {
           guard canSendNewURequest && canSendURequestAfterV && !isAnyImageGenerating else {
               print("No se puede enviar el prompt. Espere \(timeRemainingForNewURequest) segundos o termine de generarse la imagen actual.")
               return
           }

           if index < allGridImages.count && allGridImages[index].images.count > 1 {
               var gridImage = allGridImages[index]
               let newSelectedImage = allGridImages[index]

               // Generar un nuevo prompt solo para el placeholder sin modificar el original
               let newPrompt = gridImage.prompt.components(separatedBy: " - Image #").first! + " - Image #2"

               gridImage.isU2Selected = true
               gridImage.uButtonStates["U2"] = true // Actualizar el estado del botón U2

               // Crear una nueva imagen placeholder con isUpscaling = true
               let placeholderImage = GridImage(images: [], prompt: newPrompt, source: "Button U", timestamp: Date(), jobID: newSelectedImage.jobID, isUpscaling: true, uButtonStates: [:])
               self.allGridImages.append(placeholderImage) // Añadir al final de la lista
               isGeneratingImage = true
               makeRequestForImageGeneration(button: "U2", jobID: newSelectedImage.jobID, shouldUpdateUI: true, placeholderImage: placeholderImage) {
                   self.isGeneratingImage = false // Permitir de nuevo la interacción
                   self.updateImageGenerationState3() // Actualizar el estado de generación de imagen
               }
               allGridImages[index] = gridImage // Actualizar el estado de allGridImages
           }

           startURequestTimer()
       }

       func u3ButtonTapped(index: Int) {
           guard canSendNewURequest && canSendURequestAfterV && !isAnyImageGenerating else {
               print("No se puede enviar el prompt. Espere \(timeRemainingForNewURequest) segundos o termine de generarse la imagen actual.")
               return
           }

           if index < allGridImages.count && allGridImages[index].images.count > 2 {
               var gridImage = allGridImages[index]
               let newSelectedImage = allGridImages[index]

               // Generar un nuevo prompt solo para el placeholder sin modificar el original
               let newPrompt = gridImage.prompt.components(separatedBy: " - Image #").first! + " - Image #3"

               gridImage.isU3Selected = true
               gridImage.uButtonStates["U3"] = true // Actualizar el estado del botón U3

               // Crear una nueva imagen placeholder con isUpscaling = true
               let placeholderImage = GridImage(images: [], prompt: newPrompt, source: "Button U", timestamp: Date(), jobID: newSelectedImage.jobID, isUpscaling: true, uButtonStates: [:])
               self.allGridImages.append(placeholderImage) // Añadir al final de la lista
               isGeneratingImage = true
               makeRequestForImageGeneration(button: "U3", jobID: newSelectedImage.jobID, shouldUpdateUI: true, placeholderImage: placeholderImage) {
                   self.isGeneratingImage = false // Permitir de nuevo la interacción
                   self.updateImageGenerationState3() // Actualizar el estado de generación de imagen
               }
               allGridImages[index] = gridImage // Actualizar el estado de allGridImages
           }

           startURequestTimer()
       }

       func u4ButtonTapped(index: Int) {
           guard canSendNewURequest && canSendURequestAfterV && !isAnyImageGenerating else {
               print("No se puede enviar el prompt. Espere \(timeRemainingForNewURequest) segundos o termine de generarse la imagen actual.")
               return
           }

           if index < allGridImages.count && allGridImages[index].images.count > 3 {
               var gridImage = allGridImages[index]
               let newSelectedImage = allGridImages[index]

               // Generar un nuevo prompt solo para el placeholder sin modificar el original
               let newPrompt = gridImage.prompt.components(separatedBy: " - Image #").first! + " - Image #4"

               gridImage.isU4Selected = true
               gridImage.uButtonStates["U4"] = true // Actualizar el estado del botón U4

               // Crear una nueva imagen placeholder con isUpscaling = true
               let placeholderImage = GridImage(images: [], prompt: newPrompt, source: "Button U", timestamp: Date(), jobID: newSelectedImage.jobID, isUpscaling: true, uButtonStates: [:])
               self.allGridImages.append(placeholderImage) // Añadir al final de la lista
               isGeneratingImage = true
               makeRequestForImageGeneration(button: "U4", jobID: newSelectedImage.jobID, shouldUpdateUI: true, placeholderImage: placeholderImage) {
                   self.isGeneratingImage = false // Permitir de nuevo la interacción
                   self.updateImageGenerationState3() // Actualizar el estado de generación de imagen
               }
               allGridImages[index] = gridImage // Actualizar el estado de allGridImages
           }

           startURequestTimer()
       }

       // Temporizador adicional para los botones U
       func startURequestTimer1() {
           canSendURequestAfterV = false
           Timer.scheduledTimer(withTimeInterval: 22.0, repeats: false) { timer in
               canSendURequestAfterV = true
           }
       }

       func replacePlaceholderImage1(_ placeholderImage: GridImage?, with image: UIImage) {
           guard let placeholderImage = placeholderImage else { return }
           if let index = self.allGridImages.firstIndex(of: placeholderImage) {
               // Elimina la imagen de placeholder
               self.allGridImages.remove(at: index)
               
               // Añade la nueva imagen al principio de la lista para que aparezca más arriba
               let newGridImage = GridImage(images: [image], prompt: placeholderImage.prompt, source: placeholderImage.source, timestamp: placeholderImage.timestamp, jobID: placeholderImage.jobID)
               
               // Inserta la nueva imagen al principio de la lista
               self.allGridImages.insert(newGridImage, at: 0)
               self.sortImagesByDate() // Ordenar las imágenes por fecha después de añadir una nueva imagen
           }
       }

       func startRequestTimer() {
           self.canSendNewRequest = false
           self.timeRemainingForNewRequest = 30
           
           Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
               if self.timeRemainingForNewRequest > 0 {
                   self.timeRemainingForNewRequest -= 1
               } else {
                   timer.invalidate()
                   self.canSendNewRequest = true
               }
           }
       }

       func makeRequestForRedo(urlString: String, isInitialRequest: Bool, button: String, jobID: String, shouldUpdateUI: Bool, placeholderImage: GridImage?, completion: (() -> Void)? = nil) {
           guard let url = URL(string: urlString) else {
               print("URL inválida: \(urlString)")
               self.isLoading = false
               return
           }

           var request = URLRequest(url: url)
           request.httpMethod = isInitialRequest ? "POST" : "GET"
           request.addValue("Bearer user:807-hbo5l6k1Mv4rh7ApIcWFR", forHTTPHeaderField: "Authorization")

           if isInitialRequest {
               request.addValue("application/json", forHTTPHeaderField: "Content-Type")
               let requestBody: [String: Any] = [
                   "jobid": jobID,
                   "button": button,
                   "discord": "MTE3ODgxNDkyMjM0MDE3NTkxNQ.GecmlV.3CjdjJBZLv7boAYim73QzDRRDtRR5qUCCxvUmw",
                   "maxJobs": 3,
               ]
               request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
               print("Enviando solicitud inicial para el botón: \(button)")
           }

           URLSession.shared.dataTask(with: request) { data, response, error in
               DispatchQueue.main.async {
                   if let error = error {
                       print("Error en la solicitud: \(error.localizedDescription)")
                       self.isLoading = false
                       completion?()
                       return
                   }

                   guard let data = data else {
                       print("No se recibieron datos en la respuesta")
                       self.isLoading = false
                       completion?()
                       return
                   }

                   do {
                       let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                       
                       if isInitialRequest, let jobID = jsonResponse?["jobid"] as? String {
                           self.jobID = jobID
                           print("Job ID obtenido: \(jobID)")
                           DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                               self.checkJobStatusForRedo(shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage)
                           }
                       } else if let status = jsonResponse?["status"] as? String, status == "completed", let attachments = jsonResponse?["attachments"] as? [[String: Any]], let firstAttachment = attachments.first, let imageUrlString = firstAttachment["url"] as? String {
                           self.loadImage(from: imageUrlString) { loadedImage in
                               if let image = loadedImage {
                                   self.processLoadedImageForRedo(image, shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage)
                               }
                           }
                       } else {
                           DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                               self.checkJobStatusForRedo(shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage)
                           }
                       }
                   } catch {
                       print("Error al deserializar JSON: \(error.localizedDescription)")
                       self.isLoading = false
                       completion?()
                   }
               }
           }.resume()
       }

       func checkJobStatusForRedo(shouldUpdateUI: Bool, placeholderImage: GridImage?) {
           guard let jobID = self.jobID else { return }
           let statusCheckURL = "https://api.useapi.net/v2/jobs/?jobid=\(jobID)"
           makeRequestForRedo(urlString: statusCheckURL, isInitialRequest: false, button: "", jobID: jobID, shouldUpdateUI: shouldUpdateUI, placeholderImage: placeholderImage)
       }

       func processLoadedImageForRedo(_ image: UIImage, shouldUpdateUI: Bool, placeholderImage: GridImage?) {
           DispatchQueue.main.async {
               self.isLoading = false
               if shouldUpdateUI {
                   if let placeholderImage = placeholderImage, let index = self.allGridImages.firstIndex(of: placeholderImage) {
                       self.allGridImages[index].images = [image]
                       self.allGridImages[index].source = "Redo Upscale"
                       self.allGridImages[index].jobID = self.jobID ?? UUID().uuidString
                       self.allGridImages[index].isImageLoaded = true // Imagen cargada
                       self.allGridImages[index].isUpscaling = false // Actualizar estado de upscaling
                       self.creatingImageIndices.remove(index)
                   }
                   self.sortImagesByDate()
               } else {
                   print("Imagen procesada pero no añadida a la interfaz de usuario")
               }
               DispatchQueue.main.async {
                   //self.imageCounter.incrementCounter()
               }
               self.updateImageGenerationState3() // Actualizar el estado de generación de imagen
           }
       }


       func replacePlaceholderImage2(_ placeholderImage: GridImage?, with image: UIImage) {
           guard let placeholderImage = placeholderImage else { return }
           if let index = self.allGridImages.firstIndex(of: placeholderImage) {
               // Elimina la imagen de placeholder
               self.allGridImages.remove(at: index)
               
               // Añade la nueva imagen al principio de la lista para que aparezca más arriba
               let newGridImage = GridImage(images: [image], prompt: placeholderImage.prompt, source: placeholderImage.source, timestamp: placeholderImage.timestamp, jobID: placeholderImage.jobID)
               
               // Inserta la nueva imagen al principio de la lista
               self.allGridImages.insert(newGridImage, at: 0)
               self.sortImagesByDate() // Ordenar las imágenes por fecha después de añadir una nueva imagen
           }
       }
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       func blendImages(selectedImages: [UIImage]) {
           print("blendImages called with \(selectedImages.count) images")
           guard selectedImages.count > 0 else {
               print("No images selected")
               return
           }

           let placeholderImage = GridImage(images: [], prompt: "Creating image", source: "Blend", timestamp: Date(), jobID: UUID().uuidString, isCreatingImage: true)
           self.allGridImages.append(placeholderImage)


           let dispatchGroup = DispatchGroup()
           var uploadedImageUrls: [String] = []

           for image in selectedImages {
               dispatchGroup.enter()
               uploadImageToFirestore(image: image) { url in
                   if let url = url {
                       print("Image uploaded to Firestore with URL: \(url)")
                       uploadedImageUrls.append(url)
                   } else {
                       print("Failed to upload image to Firestore")
                   }
                   dispatchGroup.leave()
               }
           }

           dispatchGroup.notify(queue: .main) {
               guard uploadedImageUrls.count == selectedImages.count else {
                   print("Not all images were uploaded successfully")
                   self.isLoading = false
                   return
               }
               print("All images uploaded successfully, URLs: \(uploadedImageUrls)")
               self.makeRequestForImageGeneration(blendUrls: uploadedImageUrls)
           }
       }




           

           func uploadImageToFirestore(image: UIImage, completion: @escaping (String?) -> Void) {
               print("uploadImageToFirestore called")
               let uniqueID = UUID().uuidString
               let storageRef = Storage.storage().reference().child("images/\(uniqueID).jpg")
               guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                   print("Failed to convert UIImage to JPEG data")
                   completion(nil)
                   return
               }

               print("Uploading image data to Firestore Storage at path: images/\(uniqueID).jpg")
               storageRef.putData(imageData, metadata: nil) { metadata, error in
                   if let error = error {
                       print("Error uploading image to Firestore: \(error.localizedDescription)")
                       completion(nil)
                       return
                   }
                   storageRef.downloadURL { url, error in
                       if let error = error {
                           print("Error getting download URL from Firestore: \(error.localizedDescription)")
                           completion(nil)
                           return
                       }
                       guard let downloadURL = url else {
                           print("Download URL is nil")
                           completion(nil)
                           return
                       }
                       print("Download URL obtained: \(downloadURL.absoluteString)")
                       completion(downloadURL.absoluteString)
                   }
               }
           }

       func makeRequestForImageGeneration(blendUrls: [String]) {
               print("makeRequestForImageGeneration called with blendUrls: \(blendUrls)")
               let blendRequestURL = "https://api.useapi.net/v2/jobs/blend"
               guard let url = URL(string: blendRequestURL) else {
                   print("Invalid URL: \(blendRequestURL)")
                   self.isLoading = false
                   return
               }

               var request = URLRequest(url: url)
               request.httpMethod = "POST"
               request.addValue("Bearer user:807-hbo5l6k1Mv4rh7ApIcWFR", forHTTPHeaderField: "Authorization")
               request.addValue("application/json", forHTTPHeaderField: "Content-Type")
               let requestBody: [String: Any] = [
                   "blendUrls": blendUrls,
                   "blendDimensions": "Square",
                   "discord": "MTE3ODgxNDkyMjM0MDE3NTkxNQ.GecmlV.3CjdjJBZLv7boAYim73QzDRRDtRR5qUCCxvUmw",
                   "server": "1178973180602363974",
                   "channel": "1178973181046952008",
                   "replyUrl": "https://us-central1-image-creator-ai-a958f.cloudfunctions.net/receiveImageUrl",
                   "maxJobs": 3
               ]
               request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
               print("Request body: \(requestBody)")

               URLSession.shared.dataTask(with: request) { data, response, error in
                   DispatchQueue.main.async {
                       if let error = error {
                           print("Error in request: \(error.localizedDescription)")
                           self.isLoading = false
                           return
                       }

                       guard let data = data else {
                           print("No data received in response")
                           self.isLoading = false
                           return
                       }

                       do {
                           let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                           if let jobID = jsonResponse?["jobid"] as? String {
                               self.jobID = jobID
                               print("Job ID obtained: \(jobID)")
                               DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                                   self.checkJobStatus3()
                               }
                           } else {
                               print("Job ID not found in response")
                               self.isLoading = false
                           }
                       } catch {
                           print("Error deserializing JSON: \(error.localizedDescription)")
                           self.isLoading = false
                       }
                   }
               }.resume()
           }

           func checkJobStatus3() {
               print("checkJobStatus3 called")
               guard let jobID = jobID else {
                   print("No job ID available")
                   return
               }

               let statusCheckURL = "https://api.useapi.net/v2/jobs/?jobid=\(jobID)"
               print("Checking job status at URL: \(statusCheckURL)")
               makeRequest(urlString: statusCheckURL, isInitialRequest: false, prompt: "")
           }

           func loadImage3(from urlString: String, completion: @escaping (UIImage?) -> Void) {
               print("loadImage3 called with URL: \(urlString)")
               guard let url = URL(string: urlString) else {
                   print("Invalid URL: \(urlString)")
                   DispatchQueue.main.async {
                       self.isLoading = false
                       completion(nil)
                   }
                   return
               }

               URLSession.shared.dataTask(with: url) { data, _, error in
                   DispatchQueue.main.async {
                       if let error = error {
                           print("Error loading image: \(error.localizedDescription)")
                           self.isLoading = false
                           completion(nil)
                           return
                       }

                       guard let data = data, let uiImage = UIImage(data: data) else {
                           print("Failed to load image data")
                           self.isLoading = false
                           completion(nil)
                           return
                       }

                       print("Image loaded successfully from URL: \(urlString)")
                       self.uploadImageDetails(imageUrl: urlString, prompt: "Imagen generada automáticamente")
                       completion(uiImage)
                   }
               }.resume()
           }

           func processLoadedImage3(_ image: UIImage, imageUrl: String, prompt: String, source: String = "Local") {
               print("processLoadedImage3 called with imageUrl: \(imageUrl), prompt: \(prompt), source: \(source)")
               self.locallyGeneratedImages.insert(imageUrl)

               if let jobID = self.jobID {
                   self.combineImagesIntoGrid3(image, prompt: prompt, source: source, jobID: jobID)
                   DispatchQueue.global().async {
                       self.saveImageDetailsToFirestore(imageUrl: imageUrl, prompt: prompt, jobID: jobID)
                   }
               }

               self.isLoading = false
               self.prompt = ""
               self.canSendNewRequest = true
               self.isGeneratingImages = false
           }

           func combineImagesIntoGrid3(_ image: UIImage, prompt: String, source: String, timestamp: Date = Date(), jobID: String) {
               print("combineImagesIntoGrid3 called with jobID: \(jobID), prompt: \(prompt), source: \(source), timestamp: \(timestamp)")
               let swiftImage = SwiftImage.Image<RGBA<UInt8>>(uiImage: image)
               let size = CGSize(width: swiftImage.width / 2, height: swiftImage.height / 2)
               var images: [UIImage] = []

               for y in 0..<2 {
                   for x in 0..<2 {
                       let startX = x * Int(size.width)
                       let startY = y * Int(size.height)
                       let slice = swiftImage[startX..<(startX + Int(size.width)), startY..<(startY + Int(size.height))].uiImage
                       images.append(slice)
                   }
               }

               DispatchQueue.main.async {
                   if !self.allGridImages.contains(where: { $0.jobID == jobID && $0.prompt == prompt }) {
                       if let index = self.allGridImages.firstIndex(where: { $0.images.isEmpty }) {
                           self.allGridImages[index].images = images
                           self.allGridImages[index].jobID = jobID
                           self.allGridImages[index].showButtons = false
                       } else {
                        //   let gridImage = GridImage(images: images, prompt: prompt, source: source, timestamp: timestamp, jobID: jobID)
                        //   self.allGridImages.append(gridImage)
                        //   self.allPrompts.append(prompt)
                       }
                       self.sortImagesByDate()
                       print("Images combined into grid successfully")
                   } else {
                       print("Grid image with jobID \(jobID) already exists")
                   }
               }
           }

           func uploadImageDetails1(imageUrl: String, prompt: String) {
               print("uploadImageDetails called with imageUrl: \(imageUrl), prompt: \(prompt)")
               let db = Firestore.firestore()
               
               let imageData: [String: Any] = [
                   "url": imageUrl,
                   "prompt": prompt,  // Guarda el prompt correcto
                   "timestamp": FieldValue.serverTimestamp()
               ]
               
               db.collection("images").addDocument(data: imageData) { error in
                   if let error = error {
                       print("Error al guardar los detalles de la imagen: \(error.localizedDescription)")
                   } else {
                       print("Detalles de la imagen guardados exitosamente")
                   }
               }
           }

          
          
           
    

    func translateTextWithGoogleAPI(_ text: String, completion: @escaping (String) -> Void) {

        

        let apiKey = "AIzaSyBAmp9Zum69ve0ciU6cOnvRt-JE6rBe3zg"  // Reemplaza con tu clave API real

        

        guard let url = URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(apiKey)") else { return }

        

        

        

        var request = URLRequest(url: url)

        

        request.httpMethod = "POST"

        

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        

        

        

        let requestBody: [String: Any] = ["q": text, "target": "en"]

        

        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        

        

        

        URLSession.shared.dataTask(with: request) { data, response, error in

            

            if let error = error {

                

                print("Error de traducción: \(error.localizedDescription)")

                

                DispatchQueue.main.async {

                    

                    completion(text)  // En caso de error, retorna el texto original

                    

                }

                

                return

                

            }

            

            

            

            guard let data = data else {

                

                DispatchQueue.main.async {

                    

                    completion(text)

                    

                }

                

                return

                

            }

            

            

            

            do {

                

                if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],

                   

                    let responseData = jsonResponse["data"] as? [String: Any],

                   

                    let translations = responseData["translations"] as? [[String: Any]],

                   

                    let firstTranslation = translations.first,

                   

                    let translatedText = firstTranslation["translatedText"] as? String {

                    

                    DispatchQueue.main.async {

                        

                        completion(translatedText)

                        

                    }

                    

                } else {

                    

                    DispatchQueue.main.async {

                        

                        completion(text)

                        

                    }

                    

                }

                

            } catch {

                

                print("Error al procesar la respuesta de traducción: \(error.localizedDescription)")

                

                DispatchQueue.main.async {

                    

                    completion(text)

                    

                }

                

            }

            

        }.resume()

        

    }

    

    

    

    func detectLanguage(_ text: String, completion: @escaping (Bool) -> Void) {

        

        let apiKey = "AIzaSyBAmp9Zum69ve0ciU6cOnvRt-JE6rBe3zg"  // Reemplaza con tu clave API real

        

        guard let url = URL(string: "https://translation.googleapis.com/language/translate/v2/detect?key=\(apiKey)") else {

            

            print("URL inválida para la API de Google Translate.")

            

            completion(false)

            

            return

            

        }

        

        

        

        var request = URLRequest(url: url)

        

        request.httpMethod = "POST"

        

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        

        

        

        let requestBody: [String: Any] = ["q": text]

        

        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        

        

        

        URLSession.shared.dataTask(with: request) { data, response, error in

            

            if let error = error {

                

                print("Error en la detección del idioma: \(error.localizedDescription)")

                

                DispatchQueue.main.async {

                    

                    completion(false)

                    

                }

                

                return

                

            }

            

            

            

            guard let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],

                  

                    let dataResponse = jsonResponse["data"] as? [String: Any],

                  

                    let detections = dataResponse["detections"] as? [[Any]],

                  

                    let firstDetection = detections.first as? [[String: Any]],

                  

                    let detection = firstDetection.first,

                  

                    let language = detection["language"] as? String else {

                

                print("Respuesta de la API de Google Translate no válida o incompleta.")

                

                DispatchQueue.main.async {

                    

                    completion(false)

                    

                }

                

                return

                

            }

            

            

            

            DispatchQueue.main.async {

                

                completion(language == "en")

                

            }

            

        }.resume()

        

    }

    

    

    

    func analyzeTextAndGenerateImages(text: String, completion: @escaping (Bool) -> Void) {

        

        let apiKey = "AIzaSyBAmp9Zum69ve0ciU6cOnvRt-JE6rBe3zg"  // Reemplaza con tu clave API real

        

        guard let url = URL(string: "https://commentanalyzer.googleapis.com/v1alpha1/comments:analyze?key=\(apiKey)") else {

            

            print("URL inválida.")

            

            completion(false)

            

            return

            

        }

        

        
        
        
        
        var request = URLRequest(url: url)

        

        request.httpMethod = "POST"

        

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        

        

        

        let requestBody: [String: Any] = [

            

            "comment": ["text": text],

            

            "languages": ["en"],

            

            "requestedAttributes": [

                

                

                

                "SEVERE_TOXICITY": [:],

                

                "IDENTITY_ATTACK": [:],

                

                "INSULT": [:],

                

                

                

                "THREAT": [:],

                

                "SEXUALLY_EXPLICIT": [:],

                

                

            ]

            

        ]

        

        

        

        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        

        

        

        URLSession.shared.dataTask(with: request) { data, response, error in

            

            if let error = error {

                

                print("Error en la solicitud: \(error.localizedDescription)")

                

                completion(false)

                

                return

                

            }

            

            

            

            guard let data = data else {

                

                completion(false)

                

                return

                

            }

            

            

            

            do {

                

                if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],

                   

                    let attributeScores = jsonResponse["attributeScores"] as? [String: Any] {

                    

                    let isAppropriate = attributeScores.allSatisfy { attribute, _ in

                        

                        if let score = attributeScores[attribute] as? [String: Any],

                           

                            let summaryScore = score["summaryScore"] as? [String: Any],

                           

                            let value = summaryScore["value"] as? Double {

                            

                            return value < 0.5  // Ejemplo: umbral de toxicidad < 0.5

                            

                        }

                        

                        return true

                        

                    }

                    

                    

                    

                    completion(isAppropriate)

                    

                } else {

                    

                    completion(false)

                    

                }

                

            } catch {

                

                print("Error al procesar la respuesta: \(error.localizedDescription)")

                

                completion(false)

                

            }

            

        }.resume()

        

    }

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    
    
    
    
    func checkJobStatus(prompt: String) {
        guard let jobID = jobID else { return }
        let statusCheckURL = "https://api.useapi.net/v2/jobs/?jobid=\(jobID)"
        makeRequest(urlString: statusCheckURL, isInitialRequest: false, prompt: prompt)
    }

    func processLoadedImage(_ image: UIImage, imageUrl: String, prompt: String, source: String = "Local") {
        self.locallyGeneratedImages.insert(imageUrl)
        if let jobID = self.jobID {
            self.combineImagesIntoGrid(image, prompt: prompt, source: source, jobID: jobID)
            DispatchQueue.global().async {
                self.saveImageDetailsToFirestore(imageUrl: imageUrl, prompt: prompt, jobID: jobID)
                DispatchQueue.main.async {
                   // self.imageCounter.incrementCounter()
                }
            }
        }
        self.isLoading = false
        self.prompt = ""
        self.canSendNewRequest = true
        self.isGeneratingImages = false
    }

    func combineImagesIntoGrid(_ image: UIImage, prompt: String, source: String, timestamp: Date = Date(), jobID: String) {
        let swiftImage = SwiftImage.Image<RGBA<UInt8>>(uiImage: image)
        let size = CGSize(width: swiftImage.width / 2, height: swiftImage.height / 2)
        var images: [UIImage] = []
        
        for y in 0..<2 {
            for x in 0..<2 {
                let startX = x * Int(size.width)
                let startY = y * Int(size.height)
                let slice = swiftImage[startX..<(startX + Int(size.width)), startY..<(startY + Int(size.height))].uiImage
                images.append(slice)
            }
        }
        
        DispatchQueue.main.async {
            if !self.allGridImages.contains(where: { $0.jobID == jobID }) {
                if let index = self.allGridImages.firstIndex(where: { $0.images.isEmpty }) {
                    self.allGridImages[index].images = images
                    self.allGridImages[index].jobID = jobID
                } else {
                    let gridImage = GridImage(images: images, prompt: prompt, source: source, timestamp: timestamp, jobID: jobID)
                    self.allGridImages.append(gridImage)
                    self.allPrompts.append(prompt)
                }
                self.sortImagesByDate()
            }
        }
    }
}

                               
                               
                               
                               
                               
                  


import SwiftUI
import UIKit
import PencilKit

struct DetailedImageView1: View {
    var image: UIImage
    var gridPrompt: String

    @State private var isFullScreen = false
    @State private var isDrawingMode = false
    @State private var canvasView = PKCanvasView()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showActionSheet = false
    @State private var showPromptAlert = false
    @State private var hideButtons = false

    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Binding var showAIGodView: Bool
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                if !hideButtons {
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image("equis")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Button(action: {
                            self.showPromptAlert.toggle()
                        }) {
                            Image(systemName: "ellipsis")
                                .resizable()
                                .frame(width: 25, height: 5)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .background(Color.black.opacity(0.1))

                    Divider()
                }

                if isFullScreen {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.edgesIgnoringSafeArea(.all))
                        .onTapGesture {
                            self.isFullScreen.toggle()
                            self.hideButtons.toggle()
                        }
                } else {
                    Spacer()

                    if isDrawingMode {
                        DrawingCanvas(canvasView: $canvasView, image: image)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .padding(.top, 20)
                            .onTapGesture {
                                self.isFullScreen.toggle()
                                self.hideButtons.toggle()
                            }
                    }

                    Spacer()

                    if !hideButtons {
                        HStack {
                            VStack {
                                Button(action: {
                                    self.showShareSheet()
                                }) {
                                    Image("share")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.white)
                                }
                                Text("Share")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                            }
                            .padding(.leading, 20)

                            Spacer()

                            VStack {
                                Button(action: {
                                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                }) {
                                    Image("arrow1")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.white)
                                }
                                Text("Save")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                            }
                            .padding(.trailing, 20)
                        }
                        .padding(.bottom, 18)
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.7))
                        .overlay(
                            Divider(), alignment: .top
                        )
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Image Saved"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(isFullScreen ? .all : [])
            .overlay(
                showPromptAlert ? PromptAlert(gridPrompt: gridPrompt, showPromptAlert: $showPromptAlert) : nil
            )
        }
    }

    private func showShareSheet() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }

        let activityViewController = UIActivityViewController(activityItems: [self.image], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            if completed {
                print("Share completed")
            } else {
                print("Share canceled")
            }
        }

        // Present the share sheet
        DispatchQueue.main.async {
            rootViewController.present(activityViewController, animated: true, completion: nil)
        }
    }

    private func saveDrawing() {
        UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.main.scale)
        image.draw(at: CGPoint.zero)

        if let context = UIGraphicsGetCurrentContext() {
            canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale).draw(in: canvasView.bounds)
            context.setBlendMode(.normal)
        }

        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let finalImage = combinedImage {
            let imageSaver = ImageSaver1()
            imageSaver.saveImageToPhotoAlbum(image: finalImage)
            alertMessage = "Image saved successfully."
            showAlert = true
        } else {
            alertMessage = "Failed to save image."
            showAlert = true
        }
    }

    private func exitDrawingMode() {
        isDrawingMode = false
        canvasView.drawing = PKDrawing() // Limpia el dibujo
    }
}

class ImageSaver1: NSObject {
    func saveImageToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Save error: \(error.localizedDescription)")
        } else {
            print("Save successful!")
        }
    }
}

struct PromptAlert: View {
    var gridPrompt: String
    @Binding var showPromptAlert: Bool

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.showPromptAlert.toggle()
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                }
            }
            .padding()

            Text("Prompt")
                .font(.system(size: 24, weight: .bold)) // Aumentar el tamaño del texto
                .foregroundColor(.white)
                .padding()

            ScrollView {
                Text(gridPrompt)
                    .foregroundColor(.white)
                    .font(.system(size: 20)) // Aumentar el tamaño del texto
                    .padding()
            }
            .padding()

            Spacer()

            Button(action: {
                UIPasteboard.general.string = gridPrompt
            }) {
                Text("Copy")
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 200, height: 50)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 2)
        .background(Color(UIColor.darkGray).opacity(0.9))
        .cornerRadius(15)
        .padding()
    }
}



import SwiftUI
import Combine

struct SearchBar6: View {
    var placeholder: String
    @Binding var text: String
    var action: () -> Void
    @Binding var isShowingImagePicker: Bool
    @Binding var selectedBlendImages: [UIImage]
    @State private var keyboardHeight: CGFloat = 0
    private var keyboardPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                .map { (notification) -> CGFloat in
                    (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
                },
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
        ).eraseToAnyPublisher()
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    if !selectedBlendImages.isEmpty {
                        VStack(spacing: 0) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(selectedBlendImages.indices, id: \.self) { index in
                                        ZStack(alignment: .topTrailing) {
                                            Image(uiImage: selectedBlendImages[index])
                                                .resizable()
                                                .frame(width: 80, height: 80)
                                                .cornerRadius(8)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(Color.gray, lineWidth: 1)
                                                )
                                            
                                            Button(action: {
                                                selectedBlendImages.remove(at: index)
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .background(Color.white)
                                                    .foregroundColor(Color.gray)
                                                    .clipShape(Circle())
                                            }
                                            .offset(x: -5, y: 5)
                                        }
                                    }
                                }
                                .padding(.horizontal, 8)
                            }
                            .padding(.bottom, 8)
                            .frame(height: 100)
                        }
                        .padding(.horizontal, 8)
                        .background(Color(white: 0.99))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.bottom, 0)
                        .frame(width: geometry.size.width * 0.7)
                    }
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            self.isShowingImagePicker = true
                            self.text = ""
                        }) {
                            Image("logoz")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                        }
                        .sheet(isPresented: $isShowingImagePicker) {
                            ImagePicker(selectedImages: self.$selectedBlendImages)
                        }
                        
                        VStack {
                            TextField("", text: $text)
                                .placeholder1(when: text.isEmpty) {
                                    Text(placeholder)
                                        .foregroundColor(Color(white: 0.8))
                                        .font(.system(size: 19, weight: .medium))
                                }
                                .padding(.leading, 15)
                                .padding(EdgeInsets(top: 6, leading: 8, bottom: 8, trailing: 8))
                                .background(Color.white)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black.opacity(0.3), lineWidth: 0.3)
                                )
                                .foregroundColor(.black)
                                .disabled(!selectedBlendImages.isEmpty)
                        }
                        
                        Button(action: {
                            action()
                            selectedBlendImages.removeAll()
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .resizable()
                                .frame(width: 33, height: 33)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 10)
                    .background(Color(white: 0.99))
                    .cornerRadius(20)
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 20)
                .background(Color(white: 0.99))
            }
            .onReceive(keyboardPublisher) { height in
                withAnimation {
                    self.keyboardHeight = height
                }
            }
            .padding(.bottom, keyboardHeight)
            .gesture(DragGesture().onChanged { _ in
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            })
        }
    }
}

// Extensión para cambiar el color del placeholder
extension View {
    func placeholder1<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

class ImageCache1 {
    static let shared = NSCache<NSString, UIImage>()
}

func cacheImage(_ image: UIImage, forKey key: String) {
    ImageCache1.shared.setObject(image, forKey: key as NSString)
}

func getCachedImag(forKey key: String) -> UIImage? {
    return ImageCache1.shared.object(forKey: key as NSString)
}

struct GridImage: Identifiable, Equatable {
    var id = UUID()
    var images: [UIImage]
    var prompt: String
    var source: String
    var timestamp: Date
    var jobID: String
}
struct SessionListView1: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    
    @State private var showingEliminateAlert = false
    @State private var showImageAlert = false
    @State private var alertMessage = ""
    @State private var showingDeleteAlert = false
    @State private var navigateToPhoneAuth = false
    @State private var navigateToGeneralChat = false
    @State private var isLoggedIn: Bool = false
    @State private var showUpgradeView = false
    @State private var userName: String = ""
    @State private var showUpgradeAlert = false
    @State private var showAIGodView = false
    @State private var navigateToPikaVideoView = false
    @State private var showAlertForPlusFeature = false
    @Binding var showingPikaVideoView: Bool
    @State private var allGridImages: [GridImage] = []
    @State private var preloadSubscribedUserView = false

    public init(showingPikaVideoView: Binding<Bool>) {
        self._showingPikaVideoView = showingPikaVideoView
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    // Sección eliminada: Community Chat

                    futuristButton(imageName: "video", text: "Video Generation") {
                        if subscriptionManager.isSubscribed {
                            navigateToPikaVideoView = true
                        } else {
                            showAlertForPlusFeature = true
                        }
                    }
                    .alert(isPresented: $showAlertForPlusFeature) {
                        Alert(
                            title: Text("Only Plus users have access to this feature. Do you want to get Plus?"),
                            primaryButton: .default(Text("Get Plus"), action: {
                                showAIGodView = true
                            }),
                            secondaryButton: .cancel()
                        )
                    }

                    futuristButton(imageName: "person", text: "Image Generation") {
                        navigateToPhoneAuth = true
                    }
                    .listRowBackground(Color.black)

                    Section(header: sectionHeader(text: "ACCOUNT")) {
                        if !subscriptionManager.isSubscribed {
                            futuristButton(imageName: "arrow.up.square", text: "Upgrade to Plus") {
                                showUpgradeView = true
                            }
                            .fullScreenCover(isPresented: $showUpgradeView) {
                                AI_GodView(dismissView: $showUpgradeView)
                            }
                        }

                        futuristButton(imageName: "arrow.triangle.2.circlepath", text: "Restore Purchases") {
                            subscriptionManager.restorePurchases()
                        }
                        .alert(isPresented: $subscriptionManager.isRestorationSuccessful) {
                            Alert(title: Text("Restore Purchases"), message: Text("Your purchases have been restored."), dismissButton: .default(Text("OK")))
                        }
                    }
                    .listRowBackground(Color.black)

                    Section(header: sectionHeader(text: "ABOUT")) {
                        futuristButton(imageName: "book", text: "Guide") {
                            openGoogleSite(urlString: "https://sites.google.com/d/1iVA-NsevO_pxA0aoXSqEVxnOQb4pYOE5/p/1EC-dM-zUsDYQoH4qH-98dGvabnLHfZXO/edit")
                        }

                        futuristButton(imageName: "globe", text: "Languages") {
                            openGoogleSite(urlString: "https://sites.google.com/d/1V10urBegoi4g-aM5x1l8l3ngvPUMzP4y/p/1Vo_Wm3QdY9JZDHG9SSi7sQ1V3BPHqwQk/edit")
                        }

                        futuristButton(imageName: "newspaper", text: "Terms of Use") {
                            openGoogleSite(urlString: "https://sites.google.com/d/1lMEbJpxlqQYMBJxgAMuvPhtaMiU-ne_v/p/1gapFxjcP7kIWeZrM-foE-pr9dmJeq8yJ/edit")
                        }

                        futuristButton(imageName: "lock.shield", text: "Privacy Policy") {
                            openGoogleSite(urlString: "https://sites.google.com/d/1204_uvd7YG4Ltw-3WXPFrM6lJ6L4uOlN/p/1Rm4fBu-rPHZUxuV6Nu_GNpppImzICU21/edit")
                        }
                    }
                    .listRowBackground(Color.black)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Settings", displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    // Acción para el botón de logo
                }) {
                    ZStack {
                        Image("logox6")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    }
                }, trailing: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 24, height: 24)
                        Text("X")
                            .foregroundColor(.black)
                            .font(.system(size: 16, weight: .bold))
                    }
                })
                .navigationBarBackButtonHidden(true)
                .alert(isPresented: $showImageAlert) {
                    Alert(title: Text("Save Status"), message: Text(self.alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .background(LinearGradient(gradient: Gradient(colors: [.black, .blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .background(
                NavigationLink(destination: PersonalChatView().navigationBarBackButtonHidden(true), isActive: $navigateToPhoneAuth) {
                    EmptyView()
                }
                .navigationBarBackButtonHidden(true)
            )
            .background(
                NavigationLink(destination: PikaVideoView().navigationBarBackButtonHidden(true), isActive: $navigateToPikaVideoView) {
                    EmptyView()
                }
                .navigationBarBackButtonHidden(true)
            )
        }
        .alert(isPresented: $showUpgradeAlert) {
            Alert(
                title: Text("This function is only available for Plus users"),
                message: Text("Do you want to get Plus?"),
                primaryButton: .default(Text("Upgrade to Plus").foregroundColor(.blue)) {
                    showAIGodView = true
                },
                secondaryButton: .cancel()
            )
        }
        .fullScreenCover(isPresented: $showAIGodView) {
            AI_GodView(dismissView: $showAIGodView)
        }
        .navigationBarBackButtonHidden(true)
        .environment(\.colorScheme, .dark)
        .onAppear {
            // Precargar SubscribedUserView
            self.preloadSubscribedUserView = true
        }
    }

    private func openGoogleSite(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private func futuristButton(imageName: String, text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: imageName)
                    .foregroundColor(.white)
                Text(text)
                    .foregroundColor(.white)
                    .font(.custom("AvenirNext-Bold", size: 16))
                    .shadow(color: .blue, radius: 1, x: 1, y: 1)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(UIColor.systemGray3))
            }
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(10)
            .shadow(color: .blue, radius: 5, x: 0, y: 0)
        }
        .padding(.horizontal)
    }
    
    private func sectionHeader(text: String) -> some View {
        Text(text)
            .font(.footnote)
            .foregroundColor(.white)
            .padding(.vertical, 5)
    }

    private func preloadImagesToCache() {
        for gridImage in allGridImages {
            for image in gridImage.images {
                cacheImage(image, forKey: gridImage.jobID)
            }
        }
    }

    private func cacheImage(_ image: UIImage, forKey key: String) {
        // Implementar la lógica de caché aquí
    }

    private func loadImagesInBackground() {
        DispatchQueue.global(qos: .background).async {
            let context = CoreDataStack.shared.context
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CachedImage")

            do {
                let cachedImages = try context.fetch(fetchRequest)
                var gridImages = [GridImage]()
                for cachedImage in cachedImages {
                    if let imageData = cachedImage.value(forKey: "data") as? Data,
                       let image = UIImage(data: imageData),
                       let id = cachedImage.value(forKey: "id") as? String,
                       let timestamp = cachedImage.value(forKey: "timestamp") as? Date,
                       let jobID = cachedImage.value(forKey: "jobID") as? String,
                       let prompt = cachedImage.value(forKey: "prompt") as? String {

                        let size = CGSize(width: image.size.width / 2, height: image.size.height / 2)
                        var images: [UIImage] = []

                        for y in 0..<2 {
                            for x in 0..<2 {
                                let startX = CGFloat(x) * size.width
                                let startY = CGFloat(y) * size.height
                                if let slice = cropImage(image: image, rect: CGRect(x: startX, y: startY, width: size.width, height: size.height)) {
                                    images.append(slice)
                                }
                            }
                        }

                        let gridImage = GridImage(images: images, prompt: prompt, source: "CoreData", timestamp: timestamp, jobID: jobID)
                        gridImages.append(gridImage)
                    }
                }

                DispatchQueue.main.async {
                    self.allGridImages.append(contentsOf: gridImages)
                    self.sortImagesByDate()
                }

            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }

    private func cropImage(image: UIImage, rect: CGRect) -> UIImage? {
        guard let cgImage = image.cgImage?.cropping(to: rect) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }

    private func sortImagesByDate() {
        self.allGridImages.sort { $0.timestamp < $1.timestamp }
    }
}

extension URL: Identifiable {
    public var id: String { absoluteString }
}




import SwiftUI
import AVKit
import Photos
import Combine
import Foundation
import Firebase
import FirebaseFirestore

enum VideoStatusError: Error, Equatable {
   case rateLimitExceeded
   case other(Error)
   static func ==(lhs: VideoStatusError, rhs: VideoStatusError) -> Bool {
       switch (lhs, rhs) {
       case (.rateLimitExceeded, .rateLimitExceeded):
           return true
       case (.other(let lhsError), .other(let rhsError)):
           return lhsError.localizedDescription == rhsError.localizedDescription
       default:
           return false
       }
   }
}



// Formato de fecha
let dateFormatter: DateFormatter = {
   let formatter = DateFormatter()
   formatter.dateStyle = .short
   formatter.timeStyle = .short
   return formatter
}()




struct PikaVideoView: View {
   @State private var messageText: String = ""
   @State private var videoId: String?
   @State private var isLoading: Bool = false
   @State private var videoURL: String? // Para mostrar la URL del video
   @State private var errorMessage: String?
   @State private var accountConfigured: Bool = false
   @State private var timer: Timer?
   @State private var player: AVPlayer? // Para reproducir el video
   @State private var videoData: [(url: URL, prompt: String, timestamp: Date)] = [] // Estructura para almacenar URL, prompt y timestamp
   @State private var selectedVideo: URL?
   @State private var showingFullScreenVideo = false
   @State private var isPlaying: Bool = false // Estado para controlar la reproducción y visibilidad del ícono de play
   @State private var outOfCredits = [String]() // Lista para manejar cuentas sin créditos
  
   @State private var searchText: String = ""
  
   @State private var textFieldHeight: CGFloat = 20
   @State private var isFirstMessageSent: Bool = false // Para cambiar el placeholder dinámico
  
  
  
  
   var body: some View {
       VStack {
           HStack {
               Image("menu1")
                   .resizable()
                   .renderingMode(.template)
                   .foregroundColor(.black)
                   .frame(width: 24, height: 24)
                   .padding(.leading, 10)
              
               Spacer()
              
               Text("Visual Creator AI")
                   .font(.system(size: 18, weight: .semibold))
                   .foregroundColor(.black)
              
               Spacer()
              
               Image("edit1")
                   .resizable()
                   .renderingMode(.template)
                   .foregroundColor(.black)
                   .frame(width: 24, height: 24)
                   .padding(.trailing, 10)
           }
           .padding(.top, 50)
           .padding(.bottom, 10)
          
           Spacer()
          
           if !videoData.isEmpty {
               ScrollView {
                   ForEach($videoData, id: \.url) { $video in
                       VStack {
                           HStack(alignment: .top) {
                               Image("logox 1")
                                   .resizable()
                                   .frame(width: 40, height: 40)
                                   .padding(.leading, 13)
                                   .padding(.top, -11)
                                   .padding(.trailing, 3)
                              
                               VStack(alignment: .leading, spacing: 4) {
                                   HStack {
                                       Text("Visual Creator Bot")
                                           .font(.system(size: 14))
                                           .fontWeight(.medium)
                                           .foregroundColor(.black)
                                           .lineLimit(1)
                                           .fixedSize(horizontal: true, vertical: false)
                                           .padding(.leading, -15.3)
                                      
                                       Text(video.timestamp, formatter: dateFormatter)
                                           .font(.system(size: 12.4))
                                           .foregroundColor(.gray)
                                           .padding(.leading, 5)
                                           .lineLimit(1)
                                           .fixedSize(horizontal: false, vertical: true)
                                   }
                                   .frame(maxWidth: .infinity, alignment: .leading)
                                  
                                   HStack {
                                       Text(video.prompt)
                                           .font(.system(size: 13.5)) // Aumenté el tamaño a 16
                                                                                         .foregroundColor(Color.gray) // Remplacé la opacidad por gris sólido
                                                                                         .lineLimit(nil)
                                                                                         .padding(.leading, -41)
                                   }
                               }
                           }
                           .padding(.bottom, -6)
                          
                           GeometryReader { geo in
                               let player = AVPlayer(url: video.url)
                              
                               Button(action: {
                                   print("Seleccionando video para pantalla completa: \(video.url)")
                                   selectedVideo = video.url
                                   showingFullScreenVideo = true
                               }) {
                                   ZStack(alignment: .topLeading) {
                                       CustomVideoPlayerView(player: player)
                                           .onAppear {
                                               print("Reproduciendo video en la vista principal: \(video.url)")
                                               playVideoWhenVisible(player: player, geo: geo)
                                               addPlayerObserver(player: player)
                                           }
                                           .onDisappear {
                                               NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                                               print("El video desapareció de la vista")
                                           }
                                           .aspectRatio(contentMode: .fill)
                                                                                       .frame(width: geo.size.width * 0.98, height: 180)  // Ajustado para más ancho (95%)
                                                                                       .cornerRadius(12)
                                                                                       .clipped()
                                                                                       .position(x: geo.size.width / 2, y: geo.size.height / 2) // Centrar el video
                                      
                                       // Mostrar ícono de play si el video no está reproduciendo
                                       if !isPlaying {
                                           Image(systemName: "play.fill")
                                               .resizable()
                                               .frame(width: 15, height: 15)
                                               .foregroundColor(.white)
                                               .padding(12)
                                               .background(Circle().fill(Color.black.opacity(0.5)))
                                               .position(x: geo.size.width / 2, y: geo.size.height / 2)
                                       }
                                      
                                       Button(action: {
                                           print("Intentando guardar el video desde la URL: \(video.url)")
                                          
                                           // Verificar si la URL es remota (comienza con "http")
                                           if video.url.isFileURL {
                                               // Si el video ya es un archivo local, simplemente guardarlo en el carrete de fotos
                                               let videoSaver = VideoSaver()
                                               videoSaver.saveVideoToPhotoAlbum(videoURL: video.url)
                                               print("El video ya es local, guardado directamente en el carrete de fotos.")
                                           } else {
                                               // Si es una URL remota, descargar el video primero
                                               print("El video es una URL remota, descargando antes de guardar.")
                                               downloadAndSaveVideo1(video.url) { localURL in
                                                   if let localURL = localURL {
                                                       let videoSaver = VideoSaver()
                                                       videoSaver.saveVideoToPhotoAlbum(videoURL: localURL)
                                                       print("Video descargado y guardado en el carrete de fotos.")
                                                   } else {
                                                       print("Error al descargar el video antes de guardarlo en el carrete de fotos.")
                                                   }
                                               }
                                           }
                                       }) {
                                           Image("arrow1")
                                               .resizable()
                                               .frame(width: 15, height: 15)
                                               .foregroundColor(.white)
                                               .padding(6)
                                               .background(Circle().fill(Color.black.opacity(0.5)))
                                               .padding(.top, 8)
                                               .padding(.leading, 8)
                                       }
                                   }
                               }
                               .fullScreenCover(item: $selectedVideo) { videoURL in
                                                                   FullscreenVideoView(videoURL: videoURL, prompt: video.prompt, timestamp: video.timestamp, downloadVideo: downloadVideo, downloadAndSaveVideo1: downloadAndSaveVideo1)
                                  
                               }
                           }
                           .frame(height: 180)
                       }
                       .padding(.vertical, 10)
                   }
               }
               .padding(.horizontal, 16)
           } else {
               Image("logox 1")
                   .resizable()
                   .scaledToFit()
                   .frame(width: 200, height: 200)
                   .foregroundColor(.gray)
               //  print("No hay videos para mostrar")
           }
          
           Spacer()
          
           if isLoading {
               ProgressView("Generando video...")
                   .padding()
                   .foregroundColor(.black)  // Cambia el color del texto a negro
               //    print("Generando video...")
           }
          
          
           HStack(spacing: 12) {
                           VStack {
                               DynamicHeightTextField(
                                   placeholder: isFirstMessageSent ? "message" : "describe your video",
                                   text: $messageText,
                                   minHeight: $textFieldHeight
                               )
                               .frame(minHeight: textFieldHeight + 5) // Aumenta un poquito el minHeight para que sea más alta
                               .font(.system(size: 17, weight: .regular)) // Fuente San Francisco con tamaño y peso regular
                               .foregroundColor(Color(white: 0.3)) // Color gris similar al placeholder de iOS
                           }
                           .frame(height: textFieldHeight + 10)
                          
                          
                           Button(action: {
                               if !messageText.isEmpty {
                                   isLoading = true
                                   errorMessage = nil
                                   videoURL = nil
                                   player = nil
                                   print("Texto ingresado: \(messageText)")
                                  
                                   if !accountConfigured {
                                       configureAccount { result in
                                           switch result {
                                           case .success:
                                               print("Cuenta configurada correctamente")
                                               accountConfigured = true
                                               submitPrompt(prompt: messageText)
                                           case .failure(let error):
                                               isLoading = false
                                               errorMessage = error.localizedDescription
                                               print("Error configurando cuenta: \(error.localizedDescription)")
                                           }
                                       }
                                   } else {
                                       print("Cuenta ya configurada. Generando video...")
                                       submitPrompt(prompt: messageText)
                                   }
                               }
                           }) {
                               ZStack {
                                   Image(systemName: "arrow.up.circle.fill")
                                       .resizable()
                                       .frame(width: 33, height: 33)
                                       .foregroundColor(.black)
                                       .background(Color.white)
                                       .clipShape(Circle())
                               }
                           }
                           .padding(.trailing, 8)
                       }
                       .padding(.leading, 20)
                       .padding()
                       .frame(maxWidth: .infinity)
                       .background(Color(white: 0.97))
                       .padding(.bottom, 10)
                   }
                      
                       .onAppear {
                       fetchVideosFromFirestore()
                       print("Vista principal apareció, cargando videos desde Firestore")
                   }
                   .background(Color.white)
                   .edgesIgnoringSafeArea(.all)
               }
  
   func addPlayerObserver(player: AVPlayer) {
       player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 600), queue: .main) { time in
           if player.timeControlStatus == .playing {
               isPlaying = true
               //   print("El video está en reproducción")
           }
       }
   }
  
   func playVideoWhenVisible(player: AVPlayer, geo: GeometryProxy) {
       if geo.frame(in: .global).minY < UIScreen.main.bounds.height && geo.frame(in: .global).maxY > 0 {
           player.play()
           //   print("Reproducción automática cuando el video está visible")
           NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
               player.seek(to: .zero)
               player.play()
               //  print("El video ha terminado y se está reproduciendo de nuevo")
           }
       }
   }
  
   struct CustomVideoPlayerView: UIViewControllerRepresentable {
       var player: AVPlayer
      
       func makeUIViewController(context: Context) -> AVPlayerViewController {
           let controller = AVPlayerViewController()
           controller.player = player
           controller.showsPlaybackControls = false
           return controller
       }
      
       func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
           // Actualizar si es necesario
       }
   }
  
   func downloadVideo(_ url: URL, completion: @escaping (URL?) -> Void) {
       print("Iniciando la descarga del video desde URL: \(url)")
       let task = URLSession.shared.downloadTask(with: url) { localURL, response, error in
           if let error = error {
               print("Error durante la descarga del video: \(error.localizedDescription)")
               completion(nil)
               return
           }
           if let localURL = localURL {
               print("Descarga del video completa, archivo local: \(localURL)")
               completion(localURL)
           } else {
               print("No se pudo obtener el archivo local del video")
               completion(nil)
           }
       }
       task.resume()
   }
  
  
    struct FullscreenVideoView: View {
        var videoURL: URL
        var prompt: String
        var timestamp: Date
        @State private var player = AVPlayer()
        @State private var showPlayIcon = true
        @State private var isSharing = false
        @Environment(\.presentationMode) var presentationMode

        @State private var showImageSavedBanner = false
        @State private var show4KAppliedBanner = false // Para mostrar el banner de 4K
        @State private var extendedVideoURL: URL? = nil  // URL para el video extendido

        var downloadVideo: (URL, @escaping (URL?) -> Void) -> Void
        var downloadAndSaveVideo1: (URL, @escaping (URL?) -> Void) -> Void

        var body: some View {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        // Agregamos el icono logox 1 en la esquina superior izquierda
                        Image("logox 1")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                            .padding(.top, 13)
                            .padding(.leading, 20) // Espaciado para que esté alineado con equis

                        Spacer()

                        // Icono de cerrar (equis)
                        Button(action: {
                            print("Cerrando la vista de video en pantalla completa")
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image("equis")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                                .padding(.top, 20)
                                .padding(.trailing, 20)
                        }
                    }
                    Spacer()

                    GeometryReader { geometry in
                        VStack {
                            Spacer()

                            ZStack {
                                VideoPlayer(player: player)
                                    .onAppear {
                                        player.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
                                        player.play()
                                        showPlayIcon = false
                                        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
                                            player.seek(to: .zero)
                                            player.play()
                                        }
                                    }
                                    .frame(width: geometry.size.width) // Ancho de la pantalla
                                 //   .frame(height: geometry.size.height * 0.6) // Altura relativa al tamaño de la pantalla
                                    .background(Color.black)
                                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2.2) // Centrado vertical y horizontalmente

                                if showPlayIcon {
                                    Image(systemName: "play.circle")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.white)
                                }
                            }

                            Spacer()
                        }
                    }
                    .frame(maxHeight: .infinity) // Asegura que ocupe todo el espacio vertical disponible

                    Spacer()

                    HStack(spacing: 60) {
                        VStack {
                            Button(action: {
                                print("Extendiendo duración del video.")
                                extendVideoDuration()
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 5)
                            }
                            Text("Duration")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.top, -5)
                        }
                        VStack {
                            Button(action: {
                                applyAutoEnhance() // Aplicar la mejora de 4K
                            }) {
                                Image(systemName: "4k.tv")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 5)
                            }
                            Text("4K")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.top, -5)
                        }
                        VStack {
                            Button(action: {
                                print("Intentando guardar el video desde la URL: \(videoURL)")

                                if videoURL.isFileURL {
                                    let videoSaver = VideoSaver()
                                    videoSaver.saveVideoToPhotoAlbum(videoURL: videoURL)
                                    print("El video ya es local, guardado directamente en el carrete de fotos.")
                                } else {
                                    print("El video es una URL remota, descargando antes de guardarlo.")
                                    downloadAndSaveVideo1(videoURL) { localURL in
                                        if let localURL = localURL {
                                            let videoSaver = VideoSaver()
                                            videoSaver.saveVideoToPhotoAlbum(videoURL: localURL)
                                            print("Video descargado y guardado en el carrete de fotos.")
                                        } else {
                                            print("Error al descargar el video antes de guardarlo en el carrete de fotos.")
                                        }
                                    }
                                }
                                showImageSavedBanner = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    showImageSavedBanner = false
                                }
                            }) {
                                Image("arrow1")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.white)
                                    .padding(.bottom, 5)
                            }
                            Text("Save")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.top, -5)
                        }
                        VStack {
                            Button(action: {
                                isSharing.toggle()
                            }) {
                                Image("share")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.white)
                                    .padding(.bottom, 5)
                            }
                            Text("Share")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.top, -5)
                        }
                    }
                    .padding(.top, -100)
                    .padding(.bottom, 10)
                    .sheet(isPresented: $isSharing) {
                        ActivityViewController(activityItems: [videoURL])
                    }
                }

                // Banner de "4K applied successfully"
                if show4KAppliedBanner {
                    VStack {
                        Spacer()
                        Text("4K applied successfully")
                            .font(.system(size: 12)) // Tamaño de letra más pequeño
                            .foregroundColor(.white)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.8, alignment: .leading) // Alineado a la izquierda
                            .padding()
                            .background(Color(red: 0.12, green: 0.12, blue: 0.12)) // Color ajustado
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1) // Borde gris fino
                            )
                            .padding(.bottom, 150) // Mueve el banner hacia arriba
                    }
                    .transition(.move(edge: .top))
                }

                // Banner de "Image saved"
                if showImageSavedBanner {
                    VStack {
                        Spacer()
                        Text("Image saved")
                            .font(.system(size: 12)) // Tamaño de letra más pequeño
                            .foregroundColor(.white)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.8, alignment: .leading) // Alineado a la izquierda
                            .padding()
                            .background(Color(red: 0.12, green: 0.12, blue: 0.12)) // Color ajustado
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1) // Borde gris fino
                            )
                            .padding(.bottom, 150) // Mueve el banner hacia arriba
                    }
                    .transition(.move(edge: .top))
                }
            }
        }

      
       // Estructura para presentar el ActivityViewController y compartir el archivo
       struct ActivityViewController: UIViewControllerRepresentable {
           var activityItems: [Any]
           var applicationActivities: [UIActivity]? = nil
          
           func makeUIViewController(context: Context) -> UIActivityViewController {
               let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
               return controller
           }
          
           func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
       }
      
       private func extendVideoDuration() {
           guard let asset = AVAsset(url: videoURL) as? AVAsset else { return }
          
           let composition = AVMutableComposition()
           guard let track = asset.tracks(withMediaType: .video).first else { return }
          
           do {
               let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
               try videoTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: track, at: .zero)
               try videoTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: track, at: asset.duration)
              
               let outputURL = URL(fileURLWithPath: NSTemporaryDirectory() + UUID().uuidString + ".mov")
               guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else { return }
              
               exportSession.outputURL = outputURL
               exportSession.outputFileType = .mov
              
               exportSession.exportAsynchronously {
                   DispatchQueue.main.async {
                       if exportSession.status == .completed {
                           self.extendedVideoURL = outputURL
                           print("Video extendido guardado en: \(outputURL)")
                           // Reemplazar el video actual por el nuevo video extendido
                           player.replaceCurrentItem(with: AVPlayerItem(url: outputURL))
                           player.play()
                       } else if let error = exportSession.error {
                           print("Error al exportar el video: \(error.localizedDescription)")
                       }
                   }
               }
           } catch {
               print("Error al duplicar la duración del video: \(error.localizedDescription)")
           }
       }
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
       private func applyAutoEnhance() {
           let asset = AVAsset(url: videoURL)
           let composition = AVVideoComposition(asset: asset) { request in
               let source = request.sourceImage.clampedToExtent()
              
               let brightnessFilter = CIFilter.colorControls()
               brightnessFilter.inputImage = source
               brightnessFilter.brightness = 0.1
               brightnessFilter.contrast = 1.2
               brightnessFilter.saturation = 1.3
              
               let exposureFilter = CIFilter.exposureAdjust()
               exposureFilter.inputImage = brightnessFilter.outputImage
               exposureFilter.ev = 0.5
              
               let sharpenFilter = CIFilter.sharpenLuminance()
               sharpenFilter.inputImage = exposureFilter.outputImage
               sharpenFilter.sharpness = 0.8
              
               let vibranceFilter = CIFilter.vibrance()
               vibranceFilter.inputImage = sharpenFilter.outputImage
               vibranceFilter.amount = 0.7
              
               if let output = vibranceFilter.outputImage {
                   let context = CIContext()
                   let outputImage = output.cropped(to: request.sourceImage.extent)
                   request.finish(with: outputImage, context: context)
               } else {
                   request.finish(with: request.sourceImage, context: nil)
               }
           }
          
           let outputURL = URL(fileURLWithPath: NSTemporaryDirectory() + UUID().uuidString + ".mov")
           guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else { return }
          
           exportSession.videoComposition = composition
           exportSession.outputURL = outputURL
           exportSession.outputFileType = .mov
          
           exportSession.exportAsynchronously {
               DispatchQueue.main.async {
                   if exportSession.status == .completed {
                       // Mostrar el banner de "4K applied successfully"
                       show4KAppliedBanner = true
                       DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                           show4KAppliedBanner = false
                       }
                   } else if let error = exportSession.error {
                       print("Error al exportar el video: \(error.localizedDescription)")
                   }
               }
           }
       }
   }
  
  
   func configureAccount(completion: @escaping (Result<Void, Error>) -> Void) {
       print("Configurando cuenta de MiniMax...")
       let url = URL(string: "https://api.useapi.net/v1/minimax/accounts/298735194041511941")!
       var request = URLRequest(url: url)
       request.httpMethod = "POST"
       request.addValue("Bearer user:807-hbo5l6k1Mv4rh7ApIcWFR", forHTTPHeaderField: "Authorization")
       request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      
       let requestBody: [String: Any] = [
           "account": "298735194041511941",
           "url": "https://hailuoai.video/v1/api/user/device/register?device_platform=web&app_id=3001&version_code=22201&uuid=785c9336-7260-450d-ac9d-69c945427b5b&device_id=301883552830660614&os_name=Windows&browser_name=chrome&device_memory=4&cpu_core_num=2&browser_language=en-US&browser_platform=Win32&screen_width=1366&screen_height=768&unix=1729064635000",
           "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzI1MTk0NjMsInVzZXIiOnsiaWQiOiIyOTg3MzUxOTQwNDE1MTE5NDEiLCJuYW1lIjoiS2FyaW0gQmVuemVtYSIsImF2YXRhciI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FDZzhvY0s1d3d0LWJYQUxJQlJ3cmczQUpoTlVMOWhOWmY3UnZhOUtGVkNzQkFqSGo4d2ZKUT1zOTYtYyIsImRldmljZUlEIjoiIn19.z3fres8bWVYach5052KQ3OsxlYPdoQU4ByDWNKX-c_o",
           "maxJobs": 5
       ]
      
       request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
       URLSession.shared.dataTask(with: request) { data, response, error in
           if let error = error {
               completion(.failure(error))
               return
           }
           completion(.success(()))
       }.resume()
   }
  
   func submitPrompt(prompt: String) {
       let availableAccountsUrl = URL(string: "https://api.useapi.net/v1/minimax/scheduler/available")!
       var request = URLRequest(url: availableAccountsUrl)
       request.addValue("Bearer user:807-hbo5l6k1Mv4rh7ApIcWFR", forHTTPHeaderField: "Authorization")
      
       URLSession.shared.dataTask(with: request) { data, response, error in
           if let error = error {
               return
           }
           guard let data = data,
                 let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                 let availableAccounts = json["available"] as? [[String: Any]] else {
               return
           }
           let validAccounts = availableAccounts.compactMap { account -> String? in
               return account["account"] as? String
           }
           guard let selectedAccount = validAccounts.first else { return }
           createVideo(prompt: prompt, account: selectedAccount)
       }.resume()
   }
  
   func createVideo(prompt: String, account: String) {
       let createVideoUrl = URL(string: "https://api.useapi.net/v1/minimax/videos/create")!
       var request = URLRequest(url: createVideoUrl)
       request.httpMethod = "POST"
       request.addValue("Bearer user:807-hbo5l6k1Mv4rh7ApIcWFR", forHTTPHeaderField: "Authorization")
       request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      
       let requestBody: [String: Any] = [
           "account": account,
           "prompt": prompt,
           "promptOptimization": true,
           "replyUrl": "https://us-central1-image-creator-ai-a958f.cloudfunctions.net/receiveImageUrl"
       ]
      
       request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
       URLSession.shared.dataTask(with: request) { data, response, error in
           if let error = error {
               return
           }
           guard let data = data,
                 let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                 let videoId = json["videoId"] as? String else {
               return
           }
           startPollingVideoStatus(videoId: videoId)
       }.resume()
   }
  
   func startPollingVideoStatus(videoId: String) {
       let retryInterval = 30.0
       func checkStatus() {
           fetchVideoStatus(videoId: videoId) { result in
               switch result {
               case .success(let status):
                   if status == 2 {
                       getVideoURL(for: videoId)
                       return
                   }
               case .failure:
                   break
               }
               DispatchQueue.main.asyncAfter(deadline: .now() + retryInterval) {
                   checkStatus()
               }
           }
       }
       checkStatus()
   }
  
   func fetchVideoStatus(videoId: String, completion: @escaping (Result<Int, VideoStatusError>) -> Void) {
       let url = URL(string: "https://api.useapi.net/v1/minimax/videos/\(videoId)")!
       var request = URLRequest(url: url)
       request.httpMethod = "GET"
       request.addValue("Bearer user:807-hbo5l6k1Mv4rh7ApIcWFR", forHTTPHeaderField: "Authorization")
      
       URLSession.shared.dataTask(with: request) { data, response, error in
           if let error = error {
               completion(.failure(.other(error)))
               return
           }
          
           guard let data = data else {
               completion(.failure(.other(NSError(domain: "Invalid Data", code: 0, userInfo: nil))))
               return
           }
          
           if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let status = json["status"] as? Int {
               completion(.success(status))
           } else {
               completion(.failure(.other(NSError(domain: "Invalid JSON", code: 0, userInfo: nil))))
           }
       }.resume()
   }
  
   func getVideoURL(for videoId: String) {
       let url = URL(string: "https://api.useapi.net/v1/minimax/videos/\(videoId)")!
       var request = URLRequest(url: url)
       request.httpMethod = "GET"
       request.addValue("Bearer user:807-hbo5l6k1Mv4rh7ApIcWFR", forHTTPHeaderField: "Authorization")
      
       URLSession.shared.dataTask(with: request) { data, response, error in
           if let data = data,
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let downloadURL = json["downloadURL"] as? String {
               DispatchQueue.main.async {
                   // Asegúrate de que la URL es válida y que el video está listo para ser reproducido
                   if let url = URL(string: downloadURL) {
                       // Guarda el video en Firestore
                       self.saveVideoURLToFirestore(url: downloadURL)
                      
                       // Añade el video generado a la lista para que aparezca en la UI
                       self.videoData.insert((url, self.messageText, Date()), at: 0)
                      
                       // Asegúrate de detener la animación de carga
                       self.isLoading = false
                      
                       // Llamada a la nueva función para descargar y guardar el video en segundo plano
                       self.downloadAndSaveVideo1(url)
                   }
               }
           }
       }.resume()
   }
  
   func downloadAndSaveVideo1(_ remoteURL: URL, completion: @escaping (URL?) -> Void = { _ in }) {
       print("Iniciando la descarga del video desde URL: \(remoteURL)")
      
       let task = URLSession.shared.downloadTask(with: remoteURL) { tempLocalURL, response, error in
           if let error = error {
               print("Error durante la descarga del video: \(error.localizedDescription)")
               completion(nil)
               return
           }
          
           guard let tempLocalURL = tempLocalURL else {
               print("Error: No se obtuvo una URL temporal válida.")
               completion(nil)
               return
           }
          
           let fileManager = FileManager.default
           do {
               let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
               let uniqueFileName = UUID().uuidString + "-" + remoteURL.lastPathComponent
               let destinationURL = documentsURL.appendingPathComponent(uniqueFileName)
              
               try fileManager.moveItem(at: tempLocalURL, to: destinationURL)
               print("Video movido al directorio de documentos: \(destinationURL)")
               completion(destinationURL)
           } catch {
               print("Error al mover el video al directorio de documentos: \(error.localizedDescription)")
               completion(nil)
           }
       }
       task.resume()
   }
  
  
  
   // Función para guardar la URL del video en Firestore
   func saveVideoURLToFirestore(url: String) {
       let db = Firestore.firestore()
       let videoData: [String: Any] = [
           "url": url,
           "prompt": messageText, // Guardar el prompt
           "timestamp": Timestamp(date: Date())
       ]
      
       db.collection("videos").addDocument(data: videoData) { error in
           if let error = error {
               print("Error al guardar la URL del video en Firestore: \(error.localizedDescription)")
           } else {
               print("URL del video guardada correctamente en Firestore.")
           }
       }
   }
  
   func fetchVideosFromFirestore() {
       let db = Firestore.firestore()
       print("Iniciando la recuperación de videos desde Firestore...")
      
       db.collection("videos").order(by: "timestamp", descending: true).getDocuments { snapshot, error in
           if let error = error {
               print("Error al recuperar videos de Firestore: \(error.localizedDescription)")
               return
           }
          
           if let documents = snapshot?.documents {
               print("Se recuperaron \(documents.count) documentos de Firestore.")
              
               // Crear una lista temporal para almacenar los videos descargados
               var downloadedVideos: [(url: URL, prompt: String, timestamp: Date)] = []
              
               // Iterar sobre los documentos para procesar cada video
               for document in documents {
                   print("Procesando documento Firestore: \(document.documentID)")
                  
                   if let urlString = document.data()["url"] as? String {
                       print("URL del video recuperada: \(urlString)")
                      
                       if let remoteURL = URL(string: urlString) {
                           // Usamos valores opcionales para prompt y timestamp
                           let prompt = document.data()["prompt"] as? String ?? "Sin descripción"
                           let timestamp = (document.data()["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                          
                           print("Iniciando descarga del video desde la URL remota: \(remoteURL)")
                          
                           // Descargar y guardar el video en el directorio de documentos en lugar de la carpeta temporal
                           downloadAndSaveVideo(remoteURL) { localURL in
                               if let localURL = localURL {
                                   print("Video descargado y guardado localmente en: \(localURL)")
                                  
                                   // Guardar el video en el carrete de fotos
                                   //   let videoSaver = VideoSaver()
                                   //   videoSaver.saveVideoToPhotoAlbum(videoURL: localURL)
                                  
                                   // Agregar el video a la lista temporal
                                   downloadedVideos.append((localURL, prompt, timestamp))
                                   print("Video agregado a la lista temporal. Lista actual: \(downloadedVideos.count) videos.")
                                  
                                   // Actualizar el videoData con los videos descargados
                                   DispatchQueue.main.async {
                                       self.videoData = downloadedVideos
                                       print("videoData actualizado en el hilo principal. Total de videos: \(self.videoData.count)")
                                   }
                               } else {
                                   print("Error al descargar el video desde la URL remota: \(remoteURL)")
                               }
                           }
                       } else {
                           print("Error: URL remota no válida: \(urlString)")
                       }
                   } else {
                       print("Error al recuperar la URL del video en el documento Firestore.")
                   }
               }
           } else {
               print("No se recuperaron documentos de Firestore.")
           }
       }
   }
  
   // Función para descargar el video y guardarlo en el directorio de documentos con nombres únicos
   func downloadAndSaveVideo(_ remoteURL: URL, completion: @escaping (URL?) -> Void) {
       print("Iniciando la descarga del video desde URL: \(remoteURL)")
      
       let task = URLSession.shared.downloadTask(with: remoteURL) { tempLocalURL, response, error in
           if let error = error {
               print("Error durante la descarga del video: \(error.localizedDescription)")
               completion(nil)
               return
           }
          
           guard let tempLocalURL = tempLocalURL else {
               print("Error: No se obtuvo una URL temporal válida.")
               completion(nil)
               return
           }
          
           // Obtener la URL del directorio de documentos
           let fileManager = FileManager.default
           do {
               let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
              
               // Generar un nombre único para el archivo descargado
               let uniqueFileName = UUID().uuidString + "-" + remoteURL.lastPathComponent
               let destinationURL = documentsURL.appendingPathComponent(uniqueFileName)
              
               // Mover el archivo desde la carpeta temporal al directorio de documentos
               try fileManager.moveItem(at: tempLocalURL, to: destinationURL)
               print("Video movido al directorio de documentos: \(destinationURL)")
               completion(destinationURL)
           } catch {
               print("Error al mover el video al directorio de documentos: \(error.localizedDescription)")
               completion(nil)
           }
       }
       task.resume()
   }
  
  
  
   // Clase para guardar el video en el carrete de fotos
   class VideoSaver: NSObject {
       func saveVideoToPhotoAlbum(videoURL: URL) {
           print("Guardando video en el carrete de fotos desde URL: \(videoURL)")
           // Usamos el método UISaveVideoAtPathToSavedPhotosAlbum con un callback para manejar el resultado
           UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
       }
      
       // Método de callback para manejar el resultado del guardado
       @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
           if let error = error {
               // Manejar error si falla al guardar el video
               print("Error al guardar el video en el carrete de fotos: \(error.localizedDescription)")
           } else {
               // Confirmar éxito al guardar el video
               print("Video guardado correctamente en el carrete de fotos")
           }
       }
   }
  
  
  
  
   // Main app structure
   struct MyApp: App {
       var body: some Scene {
           WindowGroup {
               NavigationView {
                   PikaVideoView()
                       .navigationBarBackButtonHidden(true)
               }
           }
       }
   }
}
