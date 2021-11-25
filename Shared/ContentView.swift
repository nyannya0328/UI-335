//
//  ContentView.swift
//  Shared
//
//  Created by nyannyan0328 on 2021/10/19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Home : View{
    
    @State var text : String = ""
    @State var containerHegight : CGFloat = 0
    var body: some View{
        
        NavigationView{
            
            VStack{
                
                AutoSizingTF(hint: "Enter Message", txt: $text, containerHegight: $containerHegight, onEnd: {
                    
                    
                    
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                })
                 
                    .padding(.horizontal)
                    .frame(height: containerHegight <= 120 ? containerHegight : 120)//120以上広がらない
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding()
                   
                
                
            }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primary.opacity(0.04).ignoresSafeArea())//nvのtopbarの色
           
            .navigationTitle("Input Accessory View")
        }
    }
}

struct AutoSizingTF : UIViewRepresentable{
    func makeCoordinator() -> Coordinator {
        
        return AutoSizingTF.Coordinator(parent:self)
    }
    
    
    var hint : String
    @Binding var txt : String
    @Binding var containerHegight : CGFloat
    var onEnd : ()->()
    
    func makeUIView(context: Context) -> UITextView {
        
        let textView = UITextView()
        textView.text = hint
        textView.font = .systemFont(ofSize: 20, weight: .bold)
        textView.backgroundColor = .clear//clearにすると上で指定した色が反映される
        textView.delegate = context.coordinator
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        
       // toolBar.barStyle = .default default
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
      
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: context.coordinator, action: #selector(context.coordinator.closeKeyBoard))
       
       
        
        toolBar.items = [spacer, doneButton]
        toolBar.sizeToFit()
        
        textView.inputAccessoryView = toolBar
        
        return textView
        
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        
        DispatchQueue.main.async {
            if containerHegight == 0{
                
                containerHegight = uiView.contentSize.height
            }
            
        }
       
        
    }
    
    class Coordinator : NSObject,UITextViewDelegate{
        
        
        var parent : AutoSizingTF
        
        init(parent : AutoSizingTF) {
            self.parent = parent
        }
        
        @objc func closeKeyBoard(){
            
            parent.onEnd()
            
            
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            
            //編集が始まったとき
            if textView.text == parent.hint{
                
                textView.text = ""//最初に入っているメッセージをからにする
                textView.textColor = UIColor(.gray)//入力した時の文字の色
            }
            
            
        }
        
        func textViewDidChange(_ textView: UITextView) {
            
            parent.txt = textView.text
            parent.containerHegight = textView.contentSize.height
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            
            if textView.text == ""{
                
                textView.text = parent.txt
                textView.textColor = .red
            }
            
        }
        
    }
}
