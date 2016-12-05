//
//  IQKeyboardReturnKeyHandler.swift
// https://github.com/hackiftekhar/IQKeyboardManager
// Copyright (c) 2013-16 Iftekhar Qurashi.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import UIKit

/**
Manages the return key to work like next/done in a view hierarchy.
*/
open class IQKeyboardReturnKeyHandler: NSObject , UITextFieldDelegate, UITextViewDelegate {
    
    
    ///---------------
    /// MARK: Settings
    ///---------------
    
    /**
    Delegate of textField/textView.
    */
    open var delegate: UITextFieldDelegate & UITextViewDelegate?
    
    /**
    Set the last textfield return key type. Default is UIReturnKeyDefault.
    */
    open var lastTextFieldReturnKeyType : UIReturnKeyType = UIReturnKeyType.default {
        
        didSet {
            
            for infoDict in textFieldInfoCache {
                
                if let view = (infoDict as AnyObject).object(forKey: kIQTextField) as? UIView {
                    updateReturnKeyTypeOnTextField(view)
                }
            }
        }
    }
    
    ///--------------------------------------
    /// MARK: Initialization/Deinitialization
    ///--------------------------------------

    public override init() {
        super.init()
    }
    
    /**
    Add all the textFields available in UIViewController's view.
    */
    public init(controller : UIViewController) {
        super.init()
        
        addResponderFromView(controller.view)
    }

    deinit {
        
        for infoDict in textFieldInfoCache {
            
            let view = (infoDict as AnyObject).object(forKey: kIQTextField) as? UIView
            
            if let textField = view as? UITextField {
                
                let returnKeyTypeValue = (infoDict as AnyObject).object(forKey: kIQTextFieldReturnKeyType) as! NSNumber
                textField.returnKeyType = UIReturnKeyType(rawValue: returnKeyTypeValue.intValue)!
                
                textField.delegate = (infoDict as AnyObject).object(forKey: kIQTextFieldDelegate) as! UITextFieldDelegate?
            } else if let textView = view as? UITextView {
                
                textView.returnKeyType = UIReturnKeyType(rawValue: ((infoDict as AnyObject).object(forKey: kIQTextFieldReturnKeyType) as! NSNumber).intValue)!
                
                let returnKeyTypeValue = (infoDict as AnyObject).object(forKey: kIQTextFieldReturnKeyType) as! NSNumber
                textView.returnKeyType = UIReturnKeyType(rawValue: returnKeyTypeValue.intValue)!
                
                textView.delegate = (infoDict as AnyObject).object(forKey: kIQTextFieldDelegate) as! UITextViewDelegate?
            }
        }
        
        textFieldInfoCache.removeAllObjects()
    }
    

    ///------------------------
    /// MARK: Private variables
    ///------------------------
    fileprivate var textFieldInfoCache          =   NSMutableSet()
    fileprivate let kIQTextField                =   "kIQTextField"
    fileprivate let kIQTextFieldDelegate        =   "kIQTextFieldDelegate"
    fileprivate let kIQTextFieldReturnKeyType   =   "kIQTextFieldReturnKeyType"

    
    ///------------------------
    /// MARK: Private Functions
    ///------------------------
    fileprivate func textFieldCachedInfo(_ textField : UIView) -> [String : AnyObject]? {
        
        for infoDict in textFieldInfoCache {
            
            if (infoDict as AnyObject).object(forKey: kIQTextField) as! NSObject == textField {
                return infoDict as? [String : AnyObject]
            }
        }
        
        return nil
    }

    fileprivate func updateReturnKeyTypeOnTextField(_ view : UIView)
    {
        var superConsideredView : UIView?
        
        //If find any consider responderView in it's upper hierarchy then will get deepResponderView. (Bug ID: #347)
        for disabledClass in IQKeyboardManager.sharedManager().toolbarPreviousNextAllowedClasses {
            
            superConsideredView = view.superviewOfClassType(disabledClass)
            
            if superConsideredView != nil {
                break
            }
        }

        var textFields : [UIView]?
        
        //If there is a tableView in view's hierarchy, then fetching all it's subview that responds.
        if let unwrappedTableView = superConsideredView {     //   (Enhancement ID: #22)
            textFields = unwrappedTableView.deepResponderViews()
        } else {  //Otherwise fetching all the siblings
            
            textFields = view.responderSiblings()
            
            //Sorting textFields according to behaviour
            switch IQKeyboardManager.sharedManager().toolbarManageBehaviour {
                //If needs to sort it by tag
            case .byTag:        textFields = textFields?.sortedArrayByTag()
                //If needs to sort it by Position
            case .byPosition:   textFields = textFields?.sortedArrayByPosition()
            default:    break
            }
        }
        
        if let lastView = textFields?.last {
            
            if let textField = view as? UITextField {
                
                //If it's the last textField in responder view, else next
                textField.returnKeyType = (view == lastView)    ?   lastTextFieldReturnKeyType : UIReturnKeyType.next
            } else if let textView = view as? UITextView {
                
                //If it's the last textField in responder view, else next
                textView.returnKeyType = (view == lastView)    ?   lastTextFieldReturnKeyType : UIReturnKeyType.next
            }
        }
    }
    

    ///----------------------------------------------
    /// MARK: Registering/Unregistering textFieldView
    ///----------------------------------------------

    /**
    Should pass UITextField/UITextView intance. Assign textFieldView delegate to self, change it's returnKeyType.
    
    @param textFieldView UITextField/UITextView object to register.
    */
    open func addTextFieldView(_ view : UIView) {
        
        var dictInfo : [String : AnyObject] = [String : AnyObject]()
        
        dictInfo[kIQTextField] = view
        
        if let textField = view as? UITextField {
            
            dictInfo[kIQTextFieldReturnKeyType] = textField.returnKeyType.rawValue as AnyObject?
            
            if let textFieldDelegate = textField.delegate {
                dictInfo[kIQTextFieldDelegate] = textFieldDelegate
            }
            textField.delegate = self
            
        } else if let textView = view as? UITextView {
            
            dictInfo[kIQTextFieldReturnKeyType] = textView.returnKeyType.rawValue as AnyObject?
            
            if let textViewDelegate = textView.delegate {
                dictInfo[kIQTextFieldDelegate] = textViewDelegate
            }
            
            textView.delegate = self
        }
        
        textFieldInfoCache.add(dictInfo)
    }
    
    /**
    Should pass UITextField/UITextView intance. Restore it's textFieldView delegate and it's returnKeyType.
    
    @param textFieldView UITextField/UITextView object to unregister.
    */
    open func removeTextFieldView(_ view : UIView) {
        
        if let dict : [String : AnyObject] = textFieldCachedInfo(view) {
            
            if let textField = view as? UITextField {
                
                let returnKeyTypeValue = dict[kIQTextFieldReturnKeyType] as! NSNumber
                textField.returnKeyType = UIReturnKeyType(rawValue: returnKeyTypeValue.intValue)!
                
                textField.delegate = dict[kIQTextFieldDelegate] as! UITextFieldDelegate?
            } else if let textView = view as? UITextView {
                
                let returnKeyTypeValue = dict[kIQTextFieldReturnKeyType] as! NSNumber
                textView.returnKeyType = UIReturnKeyType(rawValue: returnKeyTypeValue.intValue)!
                
                textView.delegate = dict[kIQTextFieldDelegate] as! UITextViewDelegate?
            }
            
            textFieldInfoCache.remove(dict)
        }
    }
    
    /**
    Add all the UITextField/UITextView responderView's.
    
    @param UIView object to register all it's responder subviews.
    */
    open func addResponderFromView(_ view : UIView) {
        
        let textFields = view.deepResponderViews()
        
        for textField in textFields {
            
            addTextFieldView(textField)
        }
    }
    
    /**
    Remove all the UITextField/UITextView responderView's.
    
    @param UIView object to unregister all it's responder subviews.
    */
    open func removeResponderFromView(_ view : UIView) {
        
        let textFields = view.deepResponderViews()
        
        for textField in textFields {
            
            removeTextFieldView(textField)
        }
    }
    
    fileprivate func goToNextResponderOrResign(_ view : UIView) -> Bool {
        
        var superConsideredView : UIView?
        
        //If find any consider responderView in it's upper hierarchy then will get deepResponderView. (Bug ID: #347)
        for disabledClass in IQKeyboardManager.sharedManager().toolbarPreviousNextAllowedClasses {
            
            superConsideredView = view.superviewOfClassType(disabledClass)
            
            if superConsideredView != nil {
                break
            }
        }
        
        var textFields : [UIView]?
        
        //If there is a tableView in view's hierarchy, then fetching all it's subview that responds.
        if let unwrappedTableView = superConsideredView {     //   (Enhancement ID: #22)
            textFields = unwrappedTableView.deepResponderViews()
        } else {  //Otherwise fetching all the siblings
            
            textFields = view.responderSiblings()
            
            //Sorting textFields according to behaviour
            switch IQKeyboardManager.sharedManager().toolbarManageBehaviour {
                //If needs to sort it by tag
            case .byTag:        textFields = textFields?.sortedArrayByTag()
                //If needs to sort it by Position
            case .byPosition:   textFields = textFields?.sortedArrayByPosition()
            default:
                break
            }
        }

        if let unwrappedTextFields = textFields {
            
            //Getting index of current textField.
            if let index = unwrappedTextFields.index(of: view) {
                //If it is not last textField. then it's next object becomeFirstResponder.
                if index < (unwrappedTextFields.count - 1) {
                    
                    let nextTextField = unwrappedTextFields[index+1]
                    nextTextField.becomeFirstResponder()
                    return false;
                } else {
                    
                    view.resignFirstResponder()
                    return true;
                }
            } else {
                return true;
            }
        } else {
            return true;
        }
    }
    

    ///----------------------------------------------
    /// MARK: UITextField/UITextView delegates
    ///----------------------------------------------
    
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if delegate?.responds(to: #selector(UITextFieldDelegate.textFieldShouldBeginEditing(_:))) != nil {
            return (delegate?.textFieldShouldBeginEditing?(textField) == true)
        } else {
            return true
        }
    }
    
    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if delegate?.responds(to: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:))) != nil {
            return (delegate?.textFieldShouldEndEditing?(textField) == true)
        } else {
            return true
        }
    }
    
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        updateReturnKeyTypeOnTextField(textField)
        
        delegate?.textFieldDidBeginEditing?(textField)
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        
        delegate?.textFieldDidEndEditing?(textField)
    }
    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if delegate?.responds(to: #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:))) != nil {
            return (delegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) == true)
        } else {
            return true
        }
    }
    
    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        if delegate?.responds(to: #selector(UITextFieldDelegate.textFieldShouldClear(_:))) != nil {
            return (delegate?.textFieldShouldClear?(textField) == true)
        } else {
            return true
        }
    }
    
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if delegate?.responds(to: #selector(UITextFieldDelegate.textFieldShouldReturn(_:))) != nil {
            let shouldReturn = (delegate?.textFieldShouldReturn?(textField) == true)
            
            if shouldReturn == true {
                _ = goToNextResponderOrResign(textField)
            }

            return shouldReturn

        } else {
            return goToNextResponderOrResign(textField)
        }
    }
    
    
    open func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if delegate?.responds(to: #selector(UITextViewDelegate.textViewShouldBeginEditing(_:))) != nil {
            return (delegate?.textViewShouldBeginEditing?(textView) == true)
        } else {
            return true
        }
    }
    
    open func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        if delegate?.responds(to: #selector(UITextViewDelegate.textViewShouldEndEditing(_:))) != nil {
            return (delegate?.textViewShouldEndEditing?(textView) == true)
        } else {
            return true
        }
    }
    
    open func textViewDidBeginEditing(_ textView: UITextView) {
        updateReturnKeyTypeOnTextField(textView)
        
        delegate?.textViewDidBeginEditing?(textView)
    }
    
    open func textViewDidEndEditing(_ textView: UITextView) {
        
        delegate?.textViewDidEndEditing?(textView)
    }
    
    open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        var shouldReturn = true
        
        if delegate?.responds(to: #selector(UITextViewDelegate.textView(_:shouldChangeTextIn:replacementText:))) != nil {
            shouldReturn = ((delegate?.textView?(textView, shouldChangeTextIn: range, replacementText: text)) == true)
        }
        
        if shouldReturn == true && text == "\n" {
            shouldReturn = goToNextResponderOrResign(textView)
        }
        
        
        return shouldReturn
    }
    
    open func textViewDidChange(_ textView: UITextView) {
        
        delegate?.textViewDidChange?(textView)
    }
    
    open func textViewDidChangeSelection(_ textView: UITextView) {
        
        delegate?.textViewDidChangeSelection?(textView)
    }
    
    @available(iOS 10.0, *)
    open func textView(_ aTextView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        
        if delegate?.responds(to: #selector(textView as (UITextView, URL, NSRange, UITextItemInteraction) -> Bool)) != nil {
            return delegate?.textView?(aTextView, shouldInteractWith: URL, in: characterRange, interaction: interaction) == true
        } else {
            return true
        }
    }
    
    @available(iOS 10.0, *)
    open func textView(_ aTextView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if delegate?.responds(to: #selector(textView as (UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool)) != nil {
            return delegate?.textView?(aTextView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) == true
        } else {
            return true
        }
    }
    
    open func textView(_ aTextView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        if delegate?.responds(to: #selector(textView as (UITextView, URL, NSRange) -> Bool)) != nil {
            return (delegate?.textView?(aTextView, shouldInteractWith: URL, in: characterRange) == true)
        } else {
            return true
        }
        
    }
    
    open func textView(_ aTextView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        
        if delegate?.responds(to: #selector(textView as (UITextView, NSTextAttachment, NSRange) -> Bool)) != nil {
            return (delegate?.textView?(aTextView, shouldInteractWith: textAttachment, in: characterRange) == true)
        } else {
            return true
        }
    }
}
