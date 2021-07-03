//
//  TestTextureViewController.swift
//  VK
//
//  Created by Karahanyan Levon on 01.06.2021.
//

import UIKit
import AsyncDisplayKit

class TestTextureViewController: UIViewController {
    
    @IBOutlet weak var testImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        let vc = VC()
        vc.modalPresentationStyle = .fullScreen
        vc.text = "hello from vc"
        present(vc, animated: true, completion: nil)
    }
}

class VC: UIViewController {
    
    var label = UILabel()
    
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        label.tintColor = .white
        label.text = text
        
        view.backgroundColor = .red
    }
}


class AsyncImageView: UIImageView {
    private var _image: UIImage?
    
    override var image: UIImage? {
        get {
            return _image
        }
        set {
            // Сохраняем изображение в _image
            _image = newValue
            // Сбрасываем содержимое слоя
            layer.contents = nil
            // Проверяем, не пустое ли новое значение
            guard let image = newValue else { return }
            
            DispatchQueue.global(qos: .userInitiated).async {
                // Выносим операцию декодирования в глобальную очередь
                let decodedCGImage = self.decode(image)
                
                DispatchQueue.main.async {
                    // Обновляем интерфейс в главном потоке в соответствии с правилами UIKit
                    self.layer.contents = decodedCGImage
                }
            }
        }
    }
    
    private func decode(_ image: UIImage) -> CGImage? {
        // Конвертируем входящий UIImage в СoreGraphics Image
        guard let newImage = image.cgImage else { return nil }
        // Создаем цветовое пространство для рендеринга
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        // Создаем «чистый» графический контекст
        let context = CGContext(data: nil, width: newImage.width, height: newImage.height, bitsPerComponent: 8, bytesPerRow: newImage.width * 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        // Рассчитываем cornerRadius для закругления
        let imgRect = CGRect(x: 0, y: 0, width: newImage.width, height: newImage.height)
        let maxDimension = CGFloat(max(newImage.width, newImage.height))
        let cornerRadiusPath = UIBezierPath(roundedRect: imgRect, cornerRadius: maxDimension / 2 ).cgPath
        context?.addPath(cornerRadiusPath)
        context?.clip()
        // Рисуем наше изображение в контекст
        context?.draw(newImage, in: CGRect(x: 0, y: 0, width: newImage.width, height: newImage.height))
        // Создаем и возвращаем изображение
        return context?.makeImage()
    }
}

class TextureNewsController: ASDKViewController<ASDisplayNode>, ASTableDelegate, ASTableDataSource {
    
    var tableNode: ASTableNode {
        return node as! ASTableNode
    }
    
    override init() {
        // Инициализируемся с таблицей в качестве корневого View / Node
        super.init(node: ASTableNode())
        // Привязываем к себе методы делегата и дата-сорса
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
        // По желанию кастомизируем корневую таблицу
        self.tableNode.allowsSelection = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
