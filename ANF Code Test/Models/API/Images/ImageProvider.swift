//
//  ImageProvider.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/24/25.
//

import Foundation
import UIKit

/**
 This class is for animation properties, when an animation should
 be performed when the image is loaded
 
 This animation class allows us to prefill the animation properties when the
 image is loaded onto the imageview, for ease of use within the application
 */
final class ImageAnimationOptions: NSObject {
    
    /// The duration of the default animation,
    /// defaults to 1
    var duration: TimeInterval = 1.0
    
    /// The options provided to the animation
    /// defaults to .curveEaseInOut
    var options: UIView.AnimationOptions = .curveEaseInOut
    
    /// Create the animation class with the provided properties.
    /// Uses the defaults as default params
    ///
    /// - Parameters:
    ///   - duration:   The duration of the animation
    ///   - options:    The options passed into the animation transition
    init(
        duration: TimeInterval = 1.0,
        options: UIView.AnimationOptions = .curveEaseInOut
    ) {
        self.duration = duration
        self.options = options
    }
}

/**
 This class is used to abstract all image loading within the application.
 
 The abstraction layer allows us to not only have a centralzed place for all image
 downloads into image views, howwever, it also allows us to control the animations,
 the cache and even the CDN (if one is added) with ease. Since every image will be
 passed through this ßingle class (through a variety of methods and helpers), This
 centralizes our ability to scale the image managment framework to beyond what is already
 defined in these functions.
 */
final class ImageProvider: NSObject {
    
    /// Image erros possible when fetching images
    enum ImageProviderError: LocalizedError {
        
        /// The URL is not a valid format
        case invalidURL
        
        /// The data returned is not a supported image
        case invalidImageData
        
        /// There was an unknown issue when downloading the image
        /// The dev should review the error message to troubleshoot
        case unknownServerError(String)
        
        /// Map the error message to a legible message for troubleshooting
        var errorDescription: String? {
            switch self {
                case .invalidURL:
                return "Invalid URL"
            case .invalidImageData:
                return "Invalid Image Data"
            case .unknownServerError(let error):
                return error
            }
        }
    }
    
    /// Private singleton so that only a single cahce is created and shared
    private static var instance: ImageProvider = ImageProvider()
    
    /// The primary image cache, supports up to 1_000 images to start
    /// but can be configured later. Currently uses FIFO methods to manage
    /// what assets are stroed. Images in cached are not resized so they can
    /// later be resized according to use case. They are indexed by imageURL
    private lazy var imageCache: NSCache = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 1_000
        cache.name = "ImageCache"
        return cache
    }()
    
    /// Returns the cached image, if it exists
    /// - Parameter imageUrl: The image URL, which is used for fetching anc caching
    /// - Returns: The image, if it exists in the current cache
    class func getCachedImage(for imageUrl: String) -> UIImage? {
        instance.imageCache.object(forKey: imageUrl as NSString)
    }
    
    /// Sets the image in the image view by wrapping it to a Task based implementation.
    /// The provided paramters are unique to this function as a URL is already meant to
    /// be provided, instead of a raw string., helpful to prevent unneeded casting within
    /// the application
    ///
    /// - Parameters:
    ///   - placeholder:        The placeholder image to set on the image view
    ///   - url:                The image URL (remote) to download the image from
    ///   - imageView:          The image view which will have the placeholder and
    ///                         primary image set
    ///   - animationOptions:   The animation options, if any, to use when the image
    ///                         is done downloading
    ///   - completion:         The completion block, if requested, that returns the
    ///                         image asset for use in analytics
    class func setImage(
        with placeholder: UIImage?
        , url: URL?
        , in imageView: UIImageView
        , animationOptions: ImageAnimationOptions? = nil
        , completion: ((Result<UIImage, Error>) -> Void)? = nil
    ) {
        Task {
            do {
                let newImage = try await setImage(
                    with: placeholder,
                    url: url,
                    in: imageView,
                    animationOptions: animationOptions
                )
                completion?(.success(newImage))
            } catch {
                completion?(.failure(error))
            }
        }
    }
    
    /// Helper function to just download an image and return it, given the image url
    ///
    /// - Parameter imageUrl:   The image url (String) to fetch the image from
    /// - Returns:              The image, when found, from `getImage(_)`
    class func downloadImage(
        fromUrl imageUrl: String
    ) async throws -> UIImage {
        try await setImage(
            with: nil,
            url: URL(string: imageUrl),
            in: nil
        )
    }
    
    /// Primary function to download the image and set it in the image view
    /// once it is downloaded. This will apply any animation options and will
    /// automatically store the image in the cahce when complete.
    ///
    /// - Note:         Before the image is even fetched from the remote, the lcoal capy
    ///                 is checked from the cache. If the image already exists from the url, the
    ///                 cache item is used and the animation is not performed, to speed up the
    ///                 process
    ///
    /// - Parameters:
    ///   - placeholder:        The image to use as a placeholder in the image view
    ///   - url:                The Remote URL to fetch the image from
    ///   - imageView:          The UIImageview in which the image will be placed on completion
    ///   - animationOptions:   The animation options, when applicable, to use when the image was
    ///                          successfully downloaded
    /// - Returns:              The image fetched, if needed. Can discard the result if not
    @discardableResult
    class func setImage(
        with placeholder: UIImage?
        , url: URL?
        , in imageView: UIImageView?
        , animationOptions: ImageAnimationOptions? = nil
    ) async throws -> UIImage {
        
        //  Set the placeholder before the image is fetched
        //  to ensure the placeholder is default if image fails
        await set(
            image: placeholder,
            on: imageView,
            animationOptions: nil
        )
        
        guard let url
        else { throw ImageProviderError.invalidURL }
        
        //  if the image exists in the cache, just
        //  display it as it already exists
        if let image = instance
                .imageCache
                .object(forKey: url.absoluteString as NSString) {
            await set(
                image: image,
                on: imageView,
                animationOptions: nil
            )
            return image
        }
        
        //  Perform the network request
        let (data, _) = try await URLSession.shared.data(
            from: configureForCDN(url: url)
        )
        
        //  Map the image from the data gathered
        guard let image = UIImage(data: data)
            else { throw ImageProviderError.invalidImageData }
        
        //  Now that the image is mapped from the data, set in the image view
        //  provided so that it can update from the original placeholder
        await set(
            image: image,
            on: imageView,
            animationOptions: animationOptions
        )
        
        //  Now that the image was downloaded, store it in our cache
        instance.imageCache.setObject(
            image,
            forKey: url.absoluteString as NSString
        )
        
        //  Return the image so the client can use it, optionally
        return image
    }
    
    /// Helper function for setting the image and/or placeholder on the image view,
    /// animations are included, when provided
    ///
    ///- Note:      While this is currenttly private, this can be made public if the
    ///             purpose is to just set the image with/without an animation.
    ///             Could be a helpful herlper method
    ///
    /// - Parameters:
    ///   - image:                  The image to set on the image view
    ///   - imageView:              The image view to update the image on
    ///   - animationOptions:       The animation options, if provided
    private class func set(
        image: UIImage?,
        on imageView: UIImageView?,
        animationOptions: ImageAnimationOptions? = nil
    ) async {
        await MainActor.run {
            if let animationOptions
                , let imageView {
                UIView.transition(
                    with: imageView,
                    duration: animationOptions.duration,
                    options: animationOptions.options
                ) { imageView.image = image }
            } else {
                imageView?.image = image
            }
        }
    }
    
}

//  MARK: - CDN Management
private extension ImageProvider {
    
    /// (Optionally) Configures the image URL to fetch from a CDN,
    /// instead of just raw reploading the image
    ///
    /// - Note: Not yet built, just returns the original url
    ///
    /// - Parameter url: The image URL to fetch before the CDN config is used
    /// - Returns: The String after it has been updated to include use from the CDN
    class func configureForCDN(url: URL) -> URL { url }
    
}
