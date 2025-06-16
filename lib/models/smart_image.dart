import 'dart:io'; // Required for File object
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cf_game.dart';

class SmartImage extends StatelessWidget {
  /// The path to the asset if the image is from assets.
  /// e.g., "assets/images/placeholder.png"
  final String? assetPath;

  /// A [File] object if the image is from local storage.
  final File? imageFile;

  /// An alternative to [imageFile]: a string path to a local file.
  final String? localFilePath;

  /// An alternative to [imageFile]: a string path to a local file.
  final int? userID;


  // Standard Image widget parameters
  final double? width;
  final double? height;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;
  final Widget Function(BuildContext, Widget, int?, bool)? frameBuilder;
  final String? semanticLabel;
  final bool excludeFromSemantics;

  const SmartImage({
    super.key,
    this.assetPath,
    this.imageFile,
    this.localFilePath,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.errorBuilder,
    this.frameBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.userID,
  })  : assert(
  (assetPath != null && imageFile == null && localFilePath == null) ||
      (assetPath == null && imageFile != null && localFilePath == null) ||
      (assetPath == null && imageFile == null && localFilePath != null) ||
      (assetPath == null && imageFile == null && localFilePath == null),
  'Provide exactly one image source (assetPath, imageFile, or localFilePath), or none to show a placeholder.');

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    final appState = Provider.of<AppState>(context, listen: true);

    if (appState.hasChoiceImage(userID!)) {
      // --- Display image from choice ---
      imageWidget = Image.asset(
        appState.getPlayerChoiceImage(userID!)!,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        frameBuilder: frameBuilder,
        errorBuilder: errorBuilder ?? _defaultAssetErrorBuilder,
      );
      if (kDebugMode) {
        print('has choice image: $userID');
      }
    } else

     if (imageFile != null) {

      // --- Display image from File object ---
      imageWidget = Image.file(
        imageFile!,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        frameBuilder: frameBuilder,
        errorBuilder: errorBuilder ?? _defaultErrorBuilder,
      );
      if (kDebugMode) {
        print('has image file: $userID');
      }
    } else if (localFilePath != null && localFilePath!.isNotEmpty) {
      // --- Display image from local file path string ---
      imageWidget = Image.file(
        File(localFilePath!), // Create File object from path
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        frameBuilder: frameBuilder,
        errorBuilder: errorBuilder ?? _defaultErrorBuilder,
      );
      if (kDebugMode) {
        print('has image path: $userID');
      }
    } else if (assetPath != null && assetPath!.isNotEmpty) {
      // --- Display image from asset ---
      imageWidget = Image.asset(
        assetPath!,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        frameBuilder: frameBuilder,
        errorBuilder: errorBuilder ?? _defaultAssetErrorBuilder,
      );
      if (kDebugMode) {
        print('has asset image: $userID');
      }
    } else {
      // --- Fallback: No image source provided ---
      // You can return a placeholder, an empty container, or throw an error
      imageWidget = errorBuilder != null
          ? errorBuilder!(context, 'No image source provided', null)
          : _defaultPlaceholder(context);
      if (kDebugMode) {
        print('has no image: $userID');
      }
    }
    return imageWidget;
  }

  /// Default error builder for file-based images
  Widget _defaultErrorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
    // You might want to log the error for debugging
    // print('Error loading file image: $error');
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Icon(Icons.broken_image, color: Colors.grey[600], size: width != null ? width! / 2 : null),
    );
  }

  /// Default error builder specific to asset images (e.g., if asset not found)
  Widget _defaultAssetErrorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
    // print('Error loading asset image: $error');
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Icon(Icons.image_not_supported, color: Colors.grey[500], size: width != null ? width! / 2 : null),
    );
  }

  /// Default placeholder when no image source is given
  Widget _defaultPlaceholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[100],
      child: Icon(Icons.image, color: Colors.grey[400], size: width != null ? width! / 2 : null),
    );
  }
}