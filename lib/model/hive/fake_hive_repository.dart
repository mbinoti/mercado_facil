import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'carrinho_hive.dart';
import 'categoria_hive.dart';
import 'endereco_hive.dart';
import 'hive_boxes.dart';
import 'hive_enums.dart';
import 'info_nutricional_hive.dart';
import 'item_carrinho_hive.dart';
import 'mercado_seed_data.dart';
import 'oferta_hive.dart';
import 'produto_hive.dart';
import 'sessao_app_hive.dart';
import 'usuario_hive.dart';

abstract final class FakeHiveRepository {
  static const _settingsBox = 'settings';
  static const _seedVersionKey = 'fake_seed_version';
  static const _seedVersion = 1;

  static const _currentSessionKey = 'current';
  static const _activeCartKey = 'active';

  static Future<void> initialize() async {
    await _openRequiredBoxes();
    await _seedFakeDataIfNeeded();
  }

  static ValueListenable<Box<dynamic>> cartListenable() {
    return Hive.box<dynamic>(HiveBoxes.cart).listenable(keys: [_activeCartKey]);
  }

  static CarrinhoHive getCart() {
    final cartBox = Hive.box<dynamic>(HiveBoxes.cart);
    final raw = cartBox.get(_activeCartKey);
    if (raw is Map) {
      return _cartFromMap(Map<String, dynamic>.from(raw));
    }
    return MercadoSeedData.carrinho;
  }

  static int cartItemsCount() {
    return getCart().itens.length;
  }

  static ProdutoHive? getProductById(String productId) {
    final productsBox = Hive.box<dynamic>(HiveBoxes.products);
    final raw = productsBox.get(productId);
    if (raw is Map) {
      return _productFromMap(Map<String, dynamic>.from(raw));
    }
    for (final product in MercadoSeedData.produtos) {
      if (product.id == productId) {
        return product;
      }
    }
    return null;
  }

  static Future<bool> addProductToCartById(
    String productId, {
    double quantity = 1,
  }) async {
    final product = getProductById(productId);
    if (product == null) {
      return false;
    }
    return addProductToCart(product, quantity: quantity);
  }

  static Future<bool> addProductToCart(
    ProdutoHive product, {
    double quantity = 1,
  }) async {
    if (product.esgotado || quantity <= 0) {
      return false;
    }

    final cartBox = Hive.box<dynamic>(HiveBoxes.cart);
    final raw = cartBox.get(_activeCartKey);
    final cartMap = raw is Map
        ? Map<String, dynamic>.from(raw)
        : _cartToMap(MercadoSeedData.carrinho);

    final items = _itemMapList(cartMap['itens']);
    final nowIso = DateTime.now().toIso8601String();
    final index = items.indexWhere((item) => item['produtoId'] == product.id);

    if (index >= 0) {
      final current = items[index];
      current['quantidade'] = _readDouble(current['quantidade'], 1) + quantity;
      current['nomeSnapshot'] = product.nome;
      current['subtituloSnapshot'] = _productSubtitleSnapshot(product);
      current['unidade'] = product.unidade.name;
      current['precoUnitarioCents'] = product.precoCents;
      current['precoAntigoUnitarioCents'] = product.precoAntigoCents;
      current['aceitaSubstituicao'] = product.aceitaSubstituicaoPadrao;
      current['adicionadoEm'] = nowIso;
    } else {
      items.add({
        'id': 'cart_item_${DateTime.now().microsecondsSinceEpoch}',
        'produtoId': product.id,
        'nomeSnapshot': product.nome,
        'subtituloSnapshot': _productSubtitleSnapshot(product),
        'unidade': product.unidade.name,
        'quantidade': quantity,
        'precoUnitarioCents': product.precoCents,
        'precoAntigoUnitarioCents': product.precoAntigoCents,
        'aceitaSubstituicao': product.aceitaSubstituicaoPadrao,
        'observacao': null,
        'adicionadoEm': nowIso,
      });
    }

    var subtotalCents = 0;
    for (final item in items) {
      final unitPrice = _readInt(item['precoUnitarioCents']);
      final itemQuantity = _readDouble(item['quantidade'], 1);
      subtotalCents += (unitPrice * itemQuantity).round();
    }

    final descontoCupomCents = _readInt(cartMap['descontoCupomCents']);
    final limiteFreteGratisCents = _readInt(
      cartMap['limiteFreteGratisCents'],
      MercadoSeedData.carrinho.limiteFreteGratisCents,
    );
    final taxaEntregaBaseCents = _readInt(
      cartMap['taxaEntregaBaseCents'],
      _readInt(
        cartMap['taxaEntregaCents'],
        MercadoSeedData.carrinho.taxaEntregaCents,
      ),
    );
    final taxaEntregaCents = subtotalCents >= limiteFreteGratisCents
        ? 0
        : taxaEntregaBaseCents;
    final totalCents = subtotalCents + taxaEntregaCents - descontoCupomCents;

    cartMap['itens'] = items;
    cartMap['subtotalCents'] = subtotalCents;
    cartMap['taxaEntregaBaseCents'] = taxaEntregaBaseCents;
    cartMap['taxaEntregaCents'] = taxaEntregaCents;
    cartMap['totalCents'] = totalCents < 0 ? 0 : totalCents;
    cartMap['atualizadoEm'] = nowIso;

    await cartBox.put(_activeCartKey, cartMap);
    return true;
  }

  static Future<void> _openRequiredBoxes() async {
    await Future.wait([
      Hive.openBox<dynamic>(_settingsBox),
      Hive.openBox<dynamic>(HiveBoxes.session),
      Hive.openBox<dynamic>(HiveBoxes.users),
      Hive.openBox<dynamic>(HiveBoxes.addresses),
      Hive.openBox<dynamic>(HiveBoxes.categories),
      Hive.openBox<dynamic>(HiveBoxes.offers),
      Hive.openBox<dynamic>(HiveBoxes.products),
      Hive.openBox<dynamic>(HiveBoxes.cart),
    ]);
  }

  static Future<void> _seedFakeDataIfNeeded() async {
    final settingsBox = Hive.box<dynamic>(_settingsBox);
    final currentVersion = settingsBox.get(_seedVersionKey);
    if (currentVersion == _seedVersion) {
      return;
    }

    final sessionBox = Hive.box<dynamic>(HiveBoxes.session);
    final usersBox = Hive.box<dynamic>(HiveBoxes.users);
    final addressesBox = Hive.box<dynamic>(HiveBoxes.addresses);
    final categoriesBox = Hive.box<dynamic>(HiveBoxes.categories);
    final offersBox = Hive.box<dynamic>(HiveBoxes.offers);
    final productsBox = Hive.box<dynamic>(HiveBoxes.products);
    final cartBox = Hive.box<dynamic>(HiveBoxes.cart);

    await Future.wait([
      sessionBox.clear(),
      usersBox.clear(),
      addressesBox.clear(),
      categoriesBox.clear(),
      offersBox.clear(),
      productsBox.clear(),
      cartBox.clear(),
    ]);

    await usersBox.put(
      MercadoSeedData.usuario.id,
      _userToMap(MercadoSeedData.usuario),
    );
    await sessionBox.put(
      _currentSessionKey,
      _sessionToMap(MercadoSeedData.sessao),
    );

    for (final address in MercadoSeedData.enderecos) {
      await addressesBox.put(address.id, _addressToMap(address));
    }

    for (final category in MercadoSeedData.categorias) {
      await categoriesBox.put(category.id, _categoryToMap(category));
    }

    for (final offer in MercadoSeedData.ofertas) {
      await offersBox.put(offer.id, _offerToMap(offer));
    }

    for (final product in MercadoSeedData.produtos) {
      await productsBox.put(product.id, _productToMap(product));
    }

    final cartMap = _cartToMap(MercadoSeedData.carrinho)
      ..['taxaEntregaBaseCents'] = MercadoSeedData.carrinho.taxaEntregaCents;
    await cartBox.put(_activeCartKey, cartMap);

    await settingsBox.put(_seedVersionKey, _seedVersion);
  }

  static Map<String, dynamic> _userToMap(UsuarioHive user) {
    return {
      'id': user.id,
      'nome': user.nome,
      'email': user.email,
      'telefone': user.telefone,
      'criadoEm': user.criadoEm.toIso8601String(),
      'atualizadoEm': user.atualizadoEm.toIso8601String(),
    };
  }

  static Map<String, dynamic> _sessionToMap(SessaoAppHive session) {
    return {
      'onboardingConcluido': session.onboardingConcluido,
      'usuarioLogadoId': session.usuarioLogadoId,
      'enderecoSelecionadoId': session.enderecoSelecionadoId,
      'ultimoAcessoEm': session.ultimoAcessoEm.toIso8601String(),
    };
  }

  static Map<String, dynamic> _addressToMap(EnderecoHive address) {
    return {
      'id': address.id,
      'usuarioId': address.usuarioId,
      'apelido': address.apelido,
      'logradouro': address.logradouro,
      'numero': address.numero,
      'bairro': address.bairro,
      'cidade': address.cidade,
      'estado': address.estado,
      'cep': address.cep,
      'complemento': address.complemento,
      'referencia': address.referencia,
      'latitude': address.latitude,
      'longitude': address.longitude,
      'padrao': address.padrao,
    };
  }

  static Map<String, dynamic> _categoryToMap(CategoriaHive category) {
    return {
      'id': category.id,
      'nome': category.nome,
      'iconeCodePoint': category.iconeCodePoint,
      'ordem': category.ordem,
      'ativa': category.ativa,
    };
  }

  static Map<String, dynamic> _offerToMap(OfertaHive offer) {
    return {
      'id': offer.id,
      'tag': offer.tag,
      'titulo': offer.titulo,
      'subtitulo': offer.subtitulo,
      'corInicioHex': offer.corInicioHex,
      'corFimHex': offer.corFimHex,
      'larguraCard': offer.larguraCard,
      'inicioEm': offer.inicioEm.toIso8601String(),
      'fimEm': offer.fimEm.toIso8601String(),
      'categoriaId': offer.categoriaId,
    };
  }

  static Map<String, dynamic> _productToMap(ProdutoHive product) {
    return {
      'id': product.id,
      'categoriaId': product.categoriaId,
      'nome': product.nome,
      'marca': product.marca,
      'subtitulo': product.subtitulo,
      'descricao': product.descricao,
      'unidade': product.unidade.name,
      'precoCents': product.precoCents,
      'precoAntigoCents': product.precoAntigoCents,
      'badge': product.badge,
      'esgotado': product.esgotado,
      'favorito': product.favorito,
      'aceitaSubstituicaoPadrao': product.aceitaSubstituicaoPadrao,
      'imagemUrl': product.imagemUrl,
      'infoNutricional': product.infoNutricional == null
          ? null
          : _nutritionToMap(product.infoNutricional!),
      'tags': product.tags,
    };
  }

  static Map<String, dynamic> _nutritionToMap(InfoNutricionalHive nutrition) {
    return {
      'caloriasKcal': nutrition.caloriasKcal,
      'carboidratosG': nutrition.carboidratosG,
      'proteinasG': nutrition.proteinasG,
      'gordurasG': nutrition.gordurasG,
      'fibrasG': nutrition.fibrasG,
      'potassioMg': nutrition.potassioMg,
      'sodioMg': nutrition.sodioMg,
    };
  }

  static Map<String, dynamic> _cartToMap(CarrinhoHive cart) {
    return {
      'id': cart.id,
      'usuarioId': cart.usuarioId,
      'itens': cart.itens.map(_cartItemToMap).toList(growable: false),
      'cupomCodigo': cart.cupomCodigo,
      'descontoCupomCents': cart.descontoCupomCents,
      'taxaEntregaCents': cart.taxaEntregaCents,
      'limiteFreteGratisCents': cart.limiteFreteGratisCents,
      'subtotalCents': cart.subtotalCents,
      'totalCents': cart.totalCents,
      'atualizadoEm': cart.atualizadoEm.toIso8601String(),
    };
  }

  static Map<String, dynamic> _cartItemToMap(ItemCarrinhoHive item) {
    return {
      'id': item.id,
      'produtoId': item.produtoId,
      'nomeSnapshot': item.nomeSnapshot,
      'subtituloSnapshot': item.subtituloSnapshot,
      'unidade': item.unidade.name,
      'quantidade': item.quantidade,
      'precoUnitarioCents': item.precoUnitarioCents,
      'precoAntigoUnitarioCents': item.precoAntigoUnitarioCents,
      'aceitaSubstituicao': item.aceitaSubstituicao,
      'observacao': item.observacao,
      'adicionadoEm': item.adicionadoEm.toIso8601String(),
    };
  }

  static CarrinhoHive _cartFromMap(Map<String, dynamic> map) {
    final items = _itemMapList(
      map['itens'],
    ).map(_cartItemFromMap).toList(growable: false);
    return CarrinhoHive(
      id: (map['id'] ?? 'cart_001').toString(),
      usuarioId: (map['usuarioId'] ?? 'usr_001').toString(),
      itens: items,
      cupomCodigo: map['cupomCodigo'] as String?,
      descontoCupomCents: _readInt(map['descontoCupomCents']),
      taxaEntregaCents: _readInt(map['taxaEntregaCents']),
      limiteFreteGratisCents: _readInt(map['limiteFreteGratisCents']),
      subtotalCents: _readInt(map['subtotalCents']),
      totalCents: _readInt(map['totalCents']),
      atualizadoEm: _readDate(map['atualizadoEm']),
    );
  }

  static ItemCarrinhoHive _cartItemFromMap(Map<String, dynamic> map) {
    return ItemCarrinhoHive(
      id: (map['id'] ?? '').toString(),
      produtoId: (map['produtoId'] ?? '').toString(),
      nomeSnapshot: (map['nomeSnapshot'] ?? '').toString(),
      subtituloSnapshot: (map['subtituloSnapshot'] ?? '').toString(),
      unidade: _unitFromName(map['unidade']?.toString()),
      quantidade: _readDouble(map['quantidade'], 1),
      precoUnitarioCents: _readInt(map['precoUnitarioCents']),
      precoAntigoUnitarioCents: map['precoAntigoUnitarioCents'] == null
          ? null
          : _readInt(map['precoAntigoUnitarioCents']),
      aceitaSubstituicao: map['aceitaSubstituicao'] == true,
      observacao: map['observacao'] as String?,
      adicionadoEm: _readDate(map['adicionadoEm']),
    );
  }

  static ProdutoHive _productFromMap(Map<String, dynamic> map) {
    return ProdutoHive(
      id: (map['id'] ?? '').toString(),
      categoriaId: (map['categoriaId'] ?? '').toString(),
      nome: (map['nome'] ?? '').toString(),
      marca: map['marca'] as String?,
      subtitulo: (map['subtitulo'] ?? '').toString(),
      descricao: map['descricao'] as String?,
      unidade: _unitFromName(map['unidade']?.toString()),
      precoCents: _readInt(map['precoCents']),
      precoAntigoCents: map['precoAntigoCents'] == null
          ? null
          : _readInt(map['precoAntigoCents']),
      badge: map['badge'] as String?,
      esgotado: map['esgotado'] == true,
      favorito: map['favorito'] == true,
      aceitaSubstituicaoPadrao: map['aceitaSubstituicaoPadrao'] == true,
      imagemUrl: map['imagemUrl'] as String?,
      infoNutricional: _nutritionFromRaw(map['infoNutricional']),
      tags: _stringList(map['tags']),
    );
  }

  static InfoNutricionalHive? _nutritionFromRaw(dynamic raw) {
    if (raw is! Map) {
      return null;
    }
    final map = Map<String, dynamic>.from(raw);
    return InfoNutricionalHive(
      caloriasKcal: _readNullableDouble(map['caloriasKcal']),
      carboidratosG: _readNullableDouble(map['carboidratosG']),
      proteinasG: _readNullableDouble(map['proteinasG']),
      gordurasG: _readNullableDouble(map['gordurasG']),
      fibrasG: _readNullableDouble(map['fibrasG']),
      potassioMg: _readNullableDouble(map['potassioMg']),
      sodioMg: _readNullableDouble(map['sodioMg']),
    );
  }

  static List<Map<String, dynamic>> _itemMapList(dynamic rawList) {
    if (rawList is! List) {
      return <Map<String, dynamic>>[];
    }
    return rawList
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList(growable: true);
  }

  static String _productSubtitleSnapshot(ProdutoHive product) {
    if (product.marca == null || product.marca!.isEmpty) {
      return product.subtitulo;
    }
    return 'Marca: ${product.marca}';
  }

  static UnidadeMedidaHive _unitFromName(String? name) {
    if (name == null || name.isEmpty) {
      return UnidadeMedidaHive.unidade;
    }
    for (final unit in UnidadeMedidaHive.values) {
      if (unit.name == name) {
        return unit;
      }
    }
    return UnidadeMedidaHive.unidade;
  }

  static DateTime _readDate(dynamic value) {
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }
    if (value is DateTime) {
      return value;
    }
    return DateTime.now();
  }

  static int _readInt(dynamic value, [int fallback = 0]) {
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.round();
    }
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }
    return fallback;
  }

  static double _readDouble(dynamic value, [double fallback = 0]) {
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }
    return fallback;
  }

  static double? _readNullableDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    return _readDouble(value);
  }

  static List<String> _stringList(dynamic rawList) {
    if (rawList is! List) {
      return const <String>[];
    }
    return rawList.map((value) => value.toString()).toList(growable: false);
  }
}
