//
//  ImageProvider+UIImageView.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/24/25.
//

import UIKit
/**
 UIImageView extensions, specifically for the image provider.
 
 This is kept separate from the EXT+UIIMAgeView classes as this is just meant
 to sypport the image downloading functiona and make the development easier as the image
 support continues. These functions are solely for the downloading of images
 */
extension UIImageView {
    
    /// Helper function to supply the ImageProvider access directly on the
    /// provided UIIMageView, so that images can be downloaded seamlessly.
    ///
    /// This function is likely the most commonly used as the imagePath is a URL,
    /// which lines up from the mapping from the ImageAsset objects coded `link`
    /// property
    ///
    /// - Usage:
    /// ```swift
    ///     imageView.downloadImage(
    ///         with: UIImage(named: "Placeholder_Image"),
    ///         imagePath: "https://www.catimage.com",
    ///         animationOptions: ImageAnimationOptions(
    ///             duration: 1.0,
    ///             options: .curveEaseInOut
    ///         ) { [weak self] result in
    ///             switch result {
    ///                 case .success(let img):
    ///                     //  Do something with image
    ///                 case .failure(let err):
    ///                     //  Do something with error
    ///             }
    ///         }
    ///     )
    ///
    ///     //  With only a image path string
    ///     imageView.downloadImage(
    ///         imagePath: "https://www.catimage.com"
    ///     )
    /// ```
    ///
    /// - Parameters:
    ///   - placeholder:        The placeholder image to set on the image view while the image
    ///                         is loading
    ///   - imagePath:          The path of the image to fetch fromteh server. only `https`
    ///                         requests are supported, per App Transport Sercurity policy
    ///   - animationOptions:   The animation options to use when the image loads successfully
    ///   - completion:         The completion, if needed, for image fetching and analytics reporting
    func downloadImage(
        with placeholder: UIImage? = nil
        , imagePath: String
        , animationOptions: ImageAnimationOptions? = nil
        , completion: ((Result<UIImage, Error>) -> Void)? = nil
    ) {
        ImageProvider.setImage(
            with: placeholder,
            url: URL(string: imagePath),
            in: self,
            animationOptions: animationOptions,
            completion: completion
        )
    }
    
    /// Similar to the function above, `downloadImage(with: ...)`, this function
    /// updates the functionality to already take in a URL, if one is found.
    ///
    /// - Parameters:
    ///   - placeholder:        The placeholder image to set on the image view while the image
    ///                         is loading
    ///   - imageUrl:           The path of the image to fetch fromteh server. only `https`
    ///                         requests are supported, per App Transport Sercurity policy
    ///   - animationOptions:   The animation options to use when the image loads successfully
    ///   - completion:         The completion, if needed, for image fetching and analytics reporting
    func downloadImage(
        with placeholder: UIImage? = nil
        , imageUrl: URL?
        , animationOptions: ImageAnimationOptions? = nil
        , completion: ((Result<UIImage, Error>) -> Void)? = nil
    ) {
        ImageProvider.setImage(
            with: placeholder,
            url: imageUrl,
            in: self,
            animationOptions: animationOptions,
            completion: completion
        )
    }
    
    /// Similar to the functions above, however, there is not a completion block
    /// to be perfoemedd when the result come sin. Instead, this one is a wrapper
    /// for the async/await paradigm that allows for Task based processes.
    ///
    /// - Parameters:
    ///   - placeholder:        The placeholder image to set on the image view while the image
    ///                         is loading
    ///   - animationOptions:   The animation options to use when the image loads successfully
    ///   - imageUrl:           The path of the image to fetch fromteh server. only `https`
    ///                         requests are supported, per App Transport Sercurity policy
    /// - Returns:              The image, when found, throws error otherwise
    @discardableResult
    func downloadImage(
        with placeholder: UIImage? = nil
        , animationOptions: ImageAnimationOptions? = nil
        , imageUrl: URL?
    ) async throws -> UIImage? {
        try await ImageProvider.setImage(
            with: placeholder,
            url: imageUrl,
            in: self,
            animationOptions: animationOptions
        )
    }
    
}
