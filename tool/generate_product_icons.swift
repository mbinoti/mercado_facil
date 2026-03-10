#!/usr/bin/env swift

import AppKit
import Foundation

struct ProductSeed {
  let id: String
  let name: String
  let visualKey: String
  let imageLabel: String
  let colorHexes: [UInt32]
}

let sourcePath = "lib/repository/hive_fake_products_repository.dart"
let outputDirPath = "assets/images/products"
let readmePath = "\(outputDirPath)/README.md"
let iconSize: CGFloat = 512

func regexCaptures(pattern: String, text: String) -> [String]? {
  guard let regex = try? NSRegularExpression(pattern: pattern) else {
    return nil
  }
  let range = NSRange(text.startIndex..<text.endIndex, in: text)
  guard let match = regex.firstMatch(in: text, options: [], range: range) else {
    return nil
  }
  guard match.numberOfRanges > 1 else {
    return []
  }

  var captures: [String] = []
  for captureIndex in 1..<match.numberOfRanges {
    let captureRange = match.range(at: captureIndex)
    guard
      captureRange.location != NSNotFound,
      let swiftRange = Range(captureRange, in: text)
    else {
      captures.append("")
      continue
    }
    captures.append(String(text[swiftRange]))
  }

  return captures
}

func extractField(_ key: String, from block: String) -> String? {
  let escaped = NSRegularExpression.escapedPattern(for: key)
  let pattern = "'\(escaped)'\\s*:\\s*'([^']+)'"
  return regexCaptures(pattern: pattern, text: block)?.first
}

func extractColorHexes(from block: String) -> [UInt32]? {
  let captures = regexCaptures(
    pattern: "'imageColorHexes'\\s*:\\s*\\[(0x[0-9A-Fa-f]+),\\s*(0x[0-9A-Fa-f]+)\\]",
    text: block
  )

  guard let captures, captures.count == 2 else {
    return nil
  }

  let values = captures.compactMap { capture -> UInt32? in
    let cleaned = capture.replacingOccurrences(of: "0x", with: "")
    return UInt32(cleaned, radix: 16)
  }

  return values.count == 2 ? values : nil
}

func extractMapBlocks(from section: String) -> [String] {
  var blocks: [String] = []
  var depth = 0
  var startIndex: String.Index?
  var idx = section.startIndex

  while idx < section.endIndex {
    let char = section[idx]
    if char == "{" {
      if depth == 0 {
        startIndex = idx
      }
      depth += 1
    } else if char == "}" {
      depth -= 1
      if depth == 0, let startIndex {
        blocks.append(String(section[startIndex...idx]))
      }
    }
    idx = section.index(after: idx)
  }

  return blocks
}

func parseSeedProducts(from source: String) -> [ProductSeed] {
  guard
    let startRange = source.range(
      of: "static const List<Map<String, Object>> _seedProducts = ["
    ),
    let endRange = source.range(
      of: "static const List<Map<String, Object>> _seedPromotionalBanners =",
      range: startRange.upperBound..<source.endIndex
    )
  else {
    return []
  }

  let section = String(source[startRange.upperBound..<endRange.lowerBound])
  let blocks = extractMapBlocks(from: section)

  return blocks.compactMap { block -> ProductSeed? in
    guard extractField("type", from: block) == "product" else {
      return nil
    }

    guard
      let id = extractField("id", from: block),
      let name = extractField("name", from: block),
      let visualKey = extractField("visualKey", from: block),
      let imageLabel = extractField("imageLabel", from: block),
      let colorHexes = extractColorHexes(from: block)
    else {
      return nil
    }

    return ProductSeed(
      id: id,
      name: name,
      visualKey: visualKey,
      imageLabel: imageLabel,
      colorHexes: colorHexes
    )
  }
}

func color(fromARGB value: UInt32) -> NSColor {
  let alpha = CGFloat((value >> 24) & 0xFF) / 255.0
  let red = CGFloat((value >> 16) & 0xFF) / 255.0
  let green = CGFloat((value >> 8) & 0xFF) / 255.0
  let blue = CGFloat(value & 0xFF) / 255.0
  return NSColor(calibratedRed: red, green: green, blue: blue, alpha: alpha)
}

func emoji(for visualKey: String) -> String {
  switch visualKey {
  case "tomato":
    return "🍅"
  case "yogurt", "milk", "oat_milk":
    return "🥛"
  case "banana":
    return "🍌"
  case "apple":
    return "🍎"
  case "kiwi":
    return "🥝"
  case "avocado":
    return "🥑"
  case "cheese":
    return "🧀"
  case "coffee":
    return "☕"
  case "rice", "quinoa":
    return "🍚"
  case "beans", "lentils":
    return "🫘"
  case "orange_juice":
    return "🍊"
  case "grape_juice":
    return "🍇"
  case "bread":
    return "🍞"
  case "chicken":
    return "🍗"
  case "fish", "salmon":
    return "🐟"
  case "cleaner", "shampoo":
    return "🧴"
  case "paper_towel", "napkins":
    return "🧻"
  case "soap":
    return "🧼"
  case "chocolate":
    return "🍫"
  case "cookie":
    return "🍪"
  case "granola":
    return "🥣"
  case "nuts":
    return "🥜"
  case "sparkling_water":
    return "💧"
  case "coconut_water":
    return "🥥"
  case "eggs":
    return "🥚"
  default:
    return "🛒"
  }
}

func emojiAssetToken(for emoji: String) -> String {
  let runes = emoji.unicodeScalars.map { scalar in
    "u" + String(scalar.value, radix: 16, uppercase: false)
  }
  return runes.joined(separator: "_")
}

func chipAttributes() -> [NSAttributedString.Key: Any] {
  [
    .font: NSFont.systemFont(ofSize: 28, weight: .heavy),
    .foregroundColor: NSColor(calibratedWhite: 0.19, alpha: 0.95),
    .kern: 0.4,
  ]
}

func emojiAttributes(fontSize: CGFloat) -> [NSAttributedString.Key: Any] {
  let font = NSFont(name: "Apple Color Emoji", size: fontSize)
    ?? NSFont.systemFont(ofSize: fontSize, weight: .regular)
  return [
    .font: font,
    .foregroundColor: NSColor.white,
  ]
}

func drawRoundedGradient(
  rect: NSRect,
  cornerRadius: CGFloat,
  colors: [NSColor]
) {
  let roundedPath = NSBezierPath(
    roundedRect: rect,
    xRadius: cornerRadius,
    yRadius: cornerRadius
  )
  roundedPath.addClip()
  let gradient = NSGradient(colors: colors) ?? NSGradient(
    colors: [
      NSColor(calibratedWhite: 0.68, alpha: 1.0),
      NSColor(calibratedWhite: 0.52, alpha: 1.0),
    ]
  )!
  gradient.draw(in: rect, angle: -38)
}

func drawDecorations(in rect: NSRect) {
  NSColor.white.withAlphaComponent(0.20).setFill()
  NSBezierPath(
    ovalIn: NSRect(
      x: rect.maxX - 170,
      y: rect.maxY - 154,
      width: 170,
      height: 170
    )
  ).fill()

  NSColor.white.withAlphaComponent(0.12).setFill()
  NSBezierPath(
    ovalIn: NSRect(
      x: rect.minX - 34,
      y: rect.minY - 54,
      width: 205,
      height: 205
    )
  ).fill()

  let shineRect = NSRect(
    x: rect.minX + 18,
    y: rect.midY + 58,
    width: rect.width - 36,
    height: 170
  )
  NSGraphicsContext.saveGraphicsState()
  let shinePath = NSBezierPath(roundedRect: shineRect, xRadius: 64, yRadius: 64)
  shinePath.addClip()
  let shineGradient = NSGradient(
    colors: [
      NSColor.white.withAlphaComponent(0.34),
      NSColor.white.withAlphaComponent(0.0),
    ]
  )
  shineGradient?.draw(in: shineRect, angle: 90)
  NSGraphicsContext.restoreGraphicsState()
}

func drawChip(text: String, in rect: NSRect) {
  let attributes = chipAttributes()
  let chipText = text.uppercased()
  let textSize = chipText.size(withAttributes: attributes)
  let chipPaddingX: CGFloat = 20
  let chipPaddingY: CGFloat = 10
  let chipRect = NSRect(
    x: rect.minX + 30,
    y: rect.maxY - textSize.height - 28 - (chipPaddingY * 2),
    width: textSize.width + (chipPaddingX * 2),
    height: textSize.height + (chipPaddingY * 2)
  )

  NSColor.white.withAlphaComponent(0.88).setFill()
  NSBezierPath(
    roundedRect: chipRect,
    xRadius: chipRect.height / 2,
    yRadius: chipRect.height / 2
  ).fill()

  chipText.draw(
    in: NSRect(
      x: chipRect.minX + chipPaddingX,
      y: chipRect.minY + chipPaddingY - 1,
      width: textSize.width,
      height: textSize.height + 4
    ),
    withAttributes: attributes
  )
}

func drawEmoji(_ emojiText: String, in rect: NSRect) {
  NSColor.white.withAlphaComponent(0.16).setFill()
  let plateRect = NSRect(
    x: rect.midX - 118,
    y: rect.midY - 120,
    width: 236,
    height: 236
  )
  NSBezierPath(
    roundedRect: plateRect,
    xRadius: 72,
    yRadius: 72
  ).fill()

  let fontSize: CGFloat = 174
  let attributes = emojiAttributes(fontSize: fontSize)
  let textSize = emojiText.size(withAttributes: attributes)
  let textRect = NSRect(
    x: rect.midX - (textSize.width / 2),
    y: rect.midY - (textSize.height / 2) - 4,
    width: textSize.width,
    height: textSize.height
  )
  emojiText.draw(in: textRect, withAttributes: attributes)
}

func drawBorder(rect: NSRect, cornerRadius: CGFloat) {
  NSColor.white.withAlphaComponent(0.24).setStroke()
  let strokePath = NSBezierPath(
    roundedRect: rect.insetBy(dx: 1.5, dy: 1.5),
    xRadius: cornerRadius - 1.5,
    yRadius: cornerRadius - 1.5
  )
  strokePath.lineWidth = 3
  strokePath.stroke()
}

func iconImage(for product: ProductSeed, size: CGFloat) -> NSImage {
  let image = NSImage(size: NSSize(width: size, height: size))
  image.lockFocus()
  defer { image.unlockFocus() }

  NSColor.clear.setFill()
  NSBezierPath(rect: NSRect(x: 0, y: 0, width: size, height: size)).fill()

  let cardRect = NSRect(x: 0, y: 0, width: size, height: size)
  let cornerRadius: CGFloat = 104

  NSGraphicsContext.saveGraphicsState()
  drawRoundedGradient(
    rect: cardRect,
    cornerRadius: cornerRadius,
    colors: product.colorHexes.map(color(fromARGB:))
  )
  drawDecorations(in: cardRect)
  drawChip(text: product.imageLabel, in: cardRect)
  drawEmoji(emoji(for: product.visualKey), in: cardRect)
  drawBorder(rect: cardRect, cornerRadius: cornerRadius)
  NSGraphicsContext.restoreGraphicsState()

  return image
}

func writePNG(_ image: NSImage, to url: URL) throws {
  guard
    let tiffData = image.tiffRepresentation,
    let rep = NSBitmapImageRep(data: tiffData),
    let pngData = rep.representation(using: .png, properties: [:])
  else {
    throw NSError(
      domain: "icon_generation",
      code: 1,
      userInfo: [NSLocalizedDescriptionKey: "Falha ao converter imagem para PNG"]
    )
  }

  try pngData.write(to: url, options: .atomic)
}

func ensureDirectory(_ path: String) throws {
  try FileManager.default.createDirectory(
    atPath: path,
    withIntermediateDirectories: true
  )
}

func writeReadme(products: [ProductSeed], to path: String) throws {
  var lines: [String] = [
    "# Product Icons",
    "",
    "PNG set gerado automaticamente por `tool/generate_product_icons.swift`.",
    "",
    "- Tamanho: 512x512",
    "- Estilo: gradiente do seed + selo + elemento central",
    "",
    "## Arquivos",
    "",
  ]

  for product in products {
    lines.append("- `\(product.id).png` - \(product.name)")
  }

  lines.append("")
  try lines.joined(separator: "\n").write(
    toFile: path,
    atomically: true,
    encoding: .utf8
  )
}

do {
  let source = try String(contentsOfFile: sourcePath, encoding: .utf8)
  let products = parseSeedProducts(from: source)

  guard !products.isEmpty else {
    fputs(
      "Nenhum produto encontrado no seed em \(sourcePath)\n",
      stderr
    )
    exit(1)
  }

  try ensureDirectory(outputDirPath)
  var generatedEmojiAliases = Set<String>()

  for product in products {
    let image = iconImage(for: product, size: iconSize)
    let fileURL = URL(fileURLWithPath: outputDirPath)
      .appendingPathComponent("\(product.id).png")
    try writePNG(image, to: fileURL)
    print("Gerado: \(fileURL.path)")

    let emojiToken = emojiAssetToken(for: emoji(for: product.visualKey))
    if !generatedEmojiAliases.contains(emojiToken) {
      let emojiFileURL = URL(fileURLWithPath: outputDirPath)
        .appendingPathComponent("emoji_\(emojiToken).png")
      try writePNG(image, to: emojiFileURL)
      generatedEmojiAliases.insert(emojiToken)
      print("Alias: \(emojiFileURL.path)")
    }
  }

  try writeReadme(products: products, to: readmePath)
  print("README: \(readmePath)")
  print("Total: \(products.count) ícones")
} catch {
  fputs("Erro: \(error.localizedDescription)\n", stderr)
  exit(1)
}
