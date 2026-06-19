import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;

// A widget that loads a PNG asset, replaces blue-dominant pixels with a
// target color while preserving red-dominant pixels (the red star), and
// displays the resulting image. Results are cached in memory by
// assetPath+targetColor.

class TintedAssetImage extends StatefulWidget {
  final String assetPath; // e.g. 'assets/images/search_ai_select.png'
  final Color targetColor;
  final int? dominanceThreshold;
  final double? width;
  final double? height;
  final BoxFit fit;

  const TintedAssetImage({
    Key? key,
    required this.assetPath,
    required this.targetColor,
    this.dominanceThreshold,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  @override
  State<TintedAssetImage> createState() => _TintedAssetImageState();
}

class _TintedAssetImageState extends State<TintedAssetImage> {
  static final Map<String, Uint8List> _cache = {};

  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  @override
  void didUpdateWidget(covariant TintedAssetImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath ||
        oldWidget.targetColor != widget.targetColor) {
      _prepare();
    }
  }

  Future<void> _prepare() async {
    final int tA = (widget.targetColor.a * 255.0).round() & 0xFF;
    final int tR = (widget.targetColor.r * 255.0).round() & 0xFF;
    final int tG = (widget.targetColor.g * 255.0).round() & 0xFF;
    final int tB = (widget.targetColor.b * 255.0).round() & 0xFF;
    final cacheKey = '${widget.assetPath}#${tA}-${tR}-${tG}-${tB}-${widget._dominanceThreshold ?? "def"}';
    if (_cache.containsKey(cacheKey)) {
      setState(() {
        _bytes = _cache[cacheKey];
      });
      return;
    }

    try {
      final data = await rootBundle.load(widget.assetPath);
      final bytes = data.buffer.asUint8List();

      final int targetValue = (tA << 24) | (tR << 16) | (tG << 8) | tB;

      final processed = await compute<_ProcessParams, Uint8List>(
        _processImage,
        _ProcessParams(
          bytes: bytes,
          targetColorValue: targetValue,
          dominanceThreshold: widget._dominanceThreshold,
        ),
      );

      _cache[cacheKey] = processed;

      if (mounted) {
        setState(() {
          _bytes = processed;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('TintedAssetImage: failed to process ${widget.assetPath}: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bytes != null) {
      return Image.memory(
        _bytes!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
    }

    // While loading, show the original asset
    return Image.asset(
      widget.assetPath,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
    );
  }
}

class _ProcessParams {
  final Uint8List bytes;
  final int targetColorValue;
  final int? dominanceThreshold;

  _ProcessParams({required this.bytes, required this.targetColorValue, this.dominanceThreshold});
}

// Top-level function so it can be used with compute().
Uint8List _processImage(_ProcessParams params) {
  final bytes = params.bytes;
  final target = params.targetColorValue;

  final img.Image? image = img.decodeImage(bytes);
  if (image == null) return bytes; // fallback

  // extract target RGB components
  final int targetR = (target >> 16) & 0xFF;
  final int targetG = (target >> 8) & 0xFF;
  final int targetB = target & 0xFF;

  const int dominanceThreshold = 40;
  final int effectiveThreshold = params.dominanceThreshold ?? dominanceThreshold;

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final img.Pixel p = image.getPixel(x, y);
      final int a = (p.a).round();
      if (a == 0) continue; // transparent

      final int r = (p.r).round();
      final int g = (p.g).round();
      final int b = (p.b).round();

      final bool isRedDominant = (r > g + effectiveThreshold) && (r > b + effectiveThreshold);
      final bool isBlueDominant = (b > r + effectiveThreshold) && (b > g + effectiveThreshold);

      if (isRedDominant) {
        // leave red star as-is
        continue;
      }

      if (isBlueDominant) {
        final hslOrig = _rgbToHsl(r, g, b);
        final hslTarget = _rgbToHsl(targetR, targetG, targetB);

        const double satBlend = 0.25;
        final double newS = (hslOrig[1] * (1 - satBlend) + hslTarget[1] * satBlend).clamp(0.0, 1.0);
        final double newL = hslOrig[2];
        final double newH = hslTarget[0];

        final rgb = _hslToRgb(newH, newS, newL);
        final int newR = (rgb[0]).clamp(0, 255).toInt();
        final int newG = (rgb[1]).clamp(0, 255).toInt();
        final int newB = (rgb[2]).clamp(0, 255).toInt();

        final int outA = a;

        image.setPixelRgba(x, y, newR, newG, newB, outA);
      }
    }
  }

  final out = img.encodePng(image);
  return Uint8List.fromList(out);
}

// Helpers
List<double> _rgbToHsl(int r, int g, int b) {
  final double rf = r / 255.0;
  final double gf = g / 255.0;
  final double bf = b / 255.0;

  final double max = [rf, gf, bf].reduce((a, b) => a > b ? a : b);
  final double min = [rf, gf, bf].reduce((a, b) => a < b ? a : b);
  double h = 0.0, s = 0.0;
  final double l = (max + min) / 2.0;

  if (max == min) {
    h = 0.0;
    s = 0.0;
  } else {
    final double d = max - min;
    s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
    if (max == rf) {
      h = (gf - bf) / d + (gf < bf ? 6 : 0);
    } else if (max == gf) {
      h = (bf - rf) / d + 2;
    } else {
      h = (rf - gf) / d + 4;
    }
    h *= 60.0;
  }

  return [h, s, l];
}

List<double> _hslToRgb(double h, double s, double l) {
  final double c = (1 - (2 * l - 1).abs()) * s;
  final double hh = h / 60.0;
  final double x = c * (1 - (hh % 2 - 1).abs());
  double r1 = 0, g1 = 0, b1 = 0;

  if (hh >= 0 && hh < 1) {
    r1 = c;
    g1 = x;
    b1 = 0;
  } else if (hh >= 1 && hh < 2) {
    r1 = x;
    g1 = c;
    b1 = 0;
  } else if (hh >= 2 && hh < 3) {
    r1 = 0;
    g1 = c;
    b1 = x;
  } else if (hh >= 3 && hh < 4) {
    r1 = 0;
    g1 = x;
    b1 = c;
  } else if (hh >= 4 && hh < 5) {
    r1 = x;
    g1 = 0;
    b1 = c;
  } else if (hh >= 5 && hh < 6) {
    r1 = c;
    g1 = 0;
    b1 = x;
  }

  final double m = l - c / 2.0;
  final int r = ((r1 + m) * 255.0).round();
  final int g = ((g1 + m) * 255.0).round();
  final int b = ((b1 + m) * 255.0).round();
  return [r.toDouble(), g.toDouble(), b.toDouble()];
}

extension on TintedAssetImage {
  int? get _dominanceThreshold => dominanceThreshold;
}
