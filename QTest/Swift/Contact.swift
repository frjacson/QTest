//
//  File.swift
//  QTest
//
//  Created by 齐维凯 on 2026/4/26.
//

import UIKit
import Contacts
import ContactsUI

@objc(Contact)
@objcMembers
public final class Contact: NSObject, CNContactViewControllerDelegate, CNContactPickerDelegate {
    private static let shared = Contact()
    private let store = CNContactStore()

    private weak var addToExistingHost: UIViewController?
    private var addToExistingPhoneNumber: String?

    @objc(presentContactEditorFrom:phoneNumber:)
    public static func presentContactEditor(from viewController: UIViewController, phoneNumber: String) {
        shared.showContactEditor(from: viewController, rawPhoneNumber: phoneNumber)
    }

    private func showContactEditor(from viewController: UIViewController, rawPhoneNumber: String) {
        let phoneNumber = rawPhoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !phoneNumber.isEmpty else {
            showAlert(on: viewController, title: "提示", message: "请先输入电话号码")
            return
        }

        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .authorized, .limited:
            presentActionSheet(from: viewController, phoneNumber: phoneNumber)
        case .notDetermined:
            store.requestAccess(for: .contacts) { [weak self] granted, _ in
                guard let self else { return }
                DispatchQueue.main.async {
                    if granted {
                        self.presentActionSheet(from: viewController, phoneNumber: phoneNumber)
                    } else {
                        self.showPermissionAlert(on: viewController)
                    }
                }
            }
        case .denied, .restricted:
            showPermissionAlert(on: viewController)
        @unknown default:
            showPermissionAlert(on: viewController)
        }
    }

    private func presentActionSheet(from viewController: UIViewController, phoneNumber: String) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "新建联系人", style: .default) { [weak self] _ in
            self?.presentNewContactEditor(from: viewController, phoneNumber: phoneNumber)
        })
        sheet.addAction(UIAlertAction(title: "添加到现有联系人", style: .default) { [weak self] _ in
            self?.presentContactPicker(from: viewController, phoneNumber: phoneNumber)
        })
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel))

        if let popover = sheet.popoverPresentationController {
            popover.sourceView = viewController.view
            popover.sourceRect = CGRect(
                x: viewController.view.bounds.midX,
                y: viewController.view.bounds.midY,
                width: 0,
                height: 0
            )
            popover.permittedArrowDirections = []
        }

        viewController.present(sheet, animated: true)
    }

    private func presentNewContactEditor(from viewController: UIViewController, phoneNumber: String) {
        let newContact = CNMutableContact()
        newContact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: phoneNumber))]
        let contactVC = CNContactViewController(forNewContact: newContact)
        contactVC.title = "新建联系人"
        presentContactEditorNav(contactVC, from: viewController)
    }

    private func presentContactPicker(from viewController: UIViewController, phoneNumber: String) {
        addToExistingHost = viewController
        addToExistingPhoneNumber = phoneNumber
        let picker = CNContactPickerViewController()
        picker.delegate = self
        viewController.present(picker, animated: true)
    }

    private func keysForContactEditor() -> [CNKeyDescriptor] {
        [
            CNContactViewController.descriptorForRequiredKeys(),
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]
    }

    private func openExistingContactEditor(hosting: UIViewController, picked: CNContact, phoneNumber: String) {
        let keys = keysForContactEditor()
        guard let full = try? store.unifiedContact(withIdentifier: picked.identifier, keysToFetch: keys),
              let mutable = full.mutableCopy() as? CNMutableContact
        else {
            showAlert(on: hosting, title: "提示", message: "无法读取所选联系人")
            return
        }

        let digits = normalize(phoneNumber)
        let alreadyHas = mutable.phoneNumbers.contains { normalize($0.value.stringValue) == digits }
        if !alreadyHas {
            mutable.phoneNumbers.append(CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: phoneNumber)))
        }

        let contactVC = CNContactViewController(for: mutable)
        contactVC.title = "编辑联系人"
        presentContactEditorNav(contactVC, from: hosting)
    }

    private func presentContactEditorNav(_ contactVC: CNContactViewController, from host: UIViewController) {
        contactVC.contactStore = store
        contactVC.delegate = self
        contactVC.allowsEditing = true
        contactVC.allowsActions = true
        let nav = UINavigationController(rootViewController: contactVC)
        host.present(nav, animated: true)
    }

    private func normalize(_ phone: String) -> String {
        phone.unicodeScalars.filter { CharacterSet.decimalDigits.contains($0) }.map(String.init).joined()
    }

    private func showPermissionAlert(on viewController: UIViewController) {
        let alert = UIAlertController(
            title: "无法访问通讯录",
            message: "请在系统设置中允许此应用访问通讯录。",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "去设置", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        })
        viewController.present(alert, animated: true)
    }

    private func showAlert(on viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "知道了", style: .default))
        viewController.present(alert, animated: true)
    }

    // MARK: - CNContactPickerDelegate

    public func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        guard let phoneNumber = addToExistingPhoneNumber, let host = addToExistingHost else {
            addToExistingPhoneNumber = nil
            addToExistingHost = nil
            picker.dismiss(animated: true)
            return
        }
        addToExistingPhoneNumber = nil
        addToExistingHost = nil

        picker.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.openExistingContactEditor(hosting: host, picked: contact, phoneNumber: phoneNumber)
        }
    }

    public func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        addToExistingPhoneNumber = nil
        addToExistingHost = nil
        picker.dismiss(animated: true)
    }

    // MARK: - CNContactViewControllerDelegate

    public func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        viewController.navigationController?.dismiss(animated: true)
    }
}
