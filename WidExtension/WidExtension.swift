//
//  WidExtension.swift
//  WidExtension
//
//  Created by Junaid Mukadam on 26/04/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(),font: "Charter-Bold", textColor: "#000000ff", BGcolor: "#F4F4F4F4", bgImage: Data(), opacity: 0, text: "One day on Venus is almost 8 months on Earth.")
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration,font: "Charter-Bold", textColor: "#000000ff", BGcolor: "#F4F4F4F4", bgImage: Data(), opacity: 0, text: "One day on Venus is almost 8 months on Earth.")
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let font = UserDefaults(suiteName: "group.Widinfo")!.object(forKey: "font") as? String ?? "Charter-Bold"
        
        let bgColor = UserDefaults(suiteName: "group.Widinfo")!.object(forKey: "bgColor") as? String ?? "#F4F4F4F4"
        
        let textColor = UserDefaults(suiteName: "group.Widinfo")!.object(forKey: "textColor") as? String ?? "#000000ff"
        
        let bgImage = UserDefaults(suiteName: "group.Widinfo")!.object(forKey: "bgImage") as? Data ?? Data()
        //let dataAd = #imageLiteral(resourceName: "ad").pngData()
        
        
        let opacity = UserDefaults(suiteName: "group.Widinfo")!.object(forKey: "opacity") as? Double ?? 1

        
        let type = UserDefaults(suiteName: "group.Widinfo")!.object(forKey: "type") as? Array ?? ["random"]

        let isPro = UserDefaults(suiteName: "group.Widinfo")!.object(forKey: "pro") as? Bool ?? false
        
        var arrayofQuotes = [String]()
        
        postWithParameter(Url: "factsforwidget.php", parameters: ["type":type]) { (JSON, Err) in
            
            if Err == nil {
                
                for (_,Subjson) in JSON["quotes"]{
                    arrayofQuotes.append(Subjson.string ?? "")
                }
            
                if !isPro {
                    
                 arrayofQuotes.insert("Upgrade to Pro\n\n 80% Off: One-time Payment", at: 3)
                    
                arrayofQuotes.insert("Upgrade to Pro\n\n 80% Off: One-time Payment", at: 8)
                    
                arrayofQuotes.insert("Upgrade to Pro\n\n 80% Off: One-time Payment", at: 18)
                    
                arrayofQuotes.insert("Upgrade to Pro\n\n 80% Off: One-time Payment", at: 26)
                    
                arrayofQuotes.insert("Upgrade to Pro\n\n 80% Off: One-time Payment", at: 33)
                    
                arrayofQuotes.insert("Upgrade to Pro\n\n 80% Off: One-time Payment", at: 42)
                    
                }
                
                let currentDate = Date()
                for hourOffset in 0 ..< arrayofQuotes.count-2 {
                    
                    
                    let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
                
                        
                        let entry = SimpleEntry(date: entryDate, configuration: configuration,font: font, textColor: textColor, BGcolor: bgColor, bgImage: bgImage, opacity: opacity, text: arrayofQuotes[hourOffset])
                        entries.append(entry)
   
                }
                
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
                
                
            }else{
                
                // error
                
            }
            
        }
        
        
    }
    
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    
    let font:String
    let textColor:String
    let BGcolor:String
    let bgImage:Data
    let opacity:Double
    let text:String
    
}

struct WidExtensionEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            
            Color(UIColor(hexString: entry.BGcolor)!).edgesIgnoringSafeArea(.all)
            
            if entry.bgImage.isEmpty {
                
                Image(uiImage: #imageLiteral(resourceName: "null"))
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
            }else{
                
                let bgImage = UserDefaults(suiteName: "group.Widinfo")!.object(forKey: "bgImage") as? Data ?? Data()
                
                Image(uiImage: UIImage(data: bgImage)!)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .background(Color.black)
                    .opacity(entry.opacity)
                
            }
            
            
            Text(entry.text).foregroundColor(Color(UIColor(hexString: entry.textColor)!)).multilineTextAlignment(.center).font(.custom(entry.font, size: 25)).minimumScaleFactor(0.6).lineLimit(5).padding(10)
            
            
            
            //Testing
            
            //                        Color.white.edgesIgnoringSafeArea(.all)
            //
            //                        Image(uiImage: #imageLiteral(resourceName: "null"))
            //                                    .resizable()
            //                                    .scaledToFill()
            //                                    .edgesIgnoringSafeArea(.all)
            //
            //
            //
            //                        Text("Think, Belive, Dream, and Dare Think, Belive, Dream, and DareThink, Belive, Dream, and DareThink, Belive, Dream, and DareThink, Belive, Dream, and DareThink, Belive, Dream, and DareThink, Belive, Dream, and Dare").foregroundColor(Color.black).multilineTextAlignment(.center).font(.custom("Charter-Bold", size: 30)).padding(20).minimumScaleFactor(0.5).clipped()
        }
    }
}

@main
struct WidExtension: Widget {
    let kind: String = "WidExtension"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidExtensionEntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("Motivational Widget")
        .description("Add this to your homescreen to get motivated daily")
    }
}

struct WidExtension_Previews: PreviewProvider {
    static var previews: some View {
        WidExtensionEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(),font: "Charter-Bold", textColor: "#000000ff", BGcolor: "F4F4F4", bgImage: Data(), opacity: 0, text: "One day on Venus is almost 8 months on Earth.")).previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

