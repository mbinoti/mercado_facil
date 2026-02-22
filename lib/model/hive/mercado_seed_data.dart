import 'carrinho_hive.dart';
import 'categoria_hive.dart';
import 'checkout_rascunho_hive.dart';
import 'endereco_hive.dart';
import 'hive_enums.dart';
import 'info_nutricional_hive.dart';
import 'item_carrinho_hive.dart';
import 'item_pedido_hive.dart';
import 'oferta_hive.dart';
import 'pedido_hive.dart';
import 'produto_hive.dart';
import 'resumo_pedido_hive.dart';
import 'sessao_app_hive.dart';
import 'usuario_hive.dart';

abstract final class MercadoSeedData {
  static final usuario = UsuarioHive(
    id: 'usr_001',
    nome: 'Marcos Silva',
    email: 'marcos@email.com',
    telefone: '(11) 98888-0000',
    criadoEm: DateTime.utc(2026, 1, 15, 10),
    atualizadoEm: DateTime.utc(2026, 2, 20, 9, 30),
  );

  static final sessao = SessaoAppHive(
    onboardingConcluido: true,
    usuarioLogadoId: usuario.id,
    enderecoSelecionadoId: 'addr_casa',
    ultimoAcessoEm: DateTime.utc(2026, 2, 20, 10, 15),
  );

  static final enderecos = <EnderecoHive>[
    const EnderecoHive(
      id: 'addr_casa',
      usuarioId: 'usr_001',
      apelido: 'Casa',
      logradouro: 'Rua das Flores',
      numero: '123',
      bairro: 'Centro',
      cidade: 'Sao Paulo',
      estado: 'SP',
      cep: '01000-000',
      complemento: 'Apt 402',
      referencia: 'Proximo a farmacia',
      latitude: -23.5505,
      longitude: -46.6333,
      padrao: true,
    ),
    const EnderecoHive(
      id: 'addr_trabalho',
      usuarioId: 'usr_001',
      apelido: 'Trabalho',
      logradouro: 'Av. Paulista',
      numero: '1000',
      bairro: 'Bela Vista',
      cidade: 'Sao Paulo',
      estado: 'SP',
      cep: '01310-100',
      complemento: null,
      referencia: 'Edificio Torre Sul',
      latitude: -23.5631,
      longitude: -46.6544,
      padrao: false,
    ),
  ];

  static EnderecoHive get enderecoSelecionado {
    final id = sessao.enderecoSelecionadoId;
    return enderecos.firstWhere(
      (e) => e.id == id,
      orElse: () => enderecos.first,
    );
  }

  static final categorias = <CategoriaHive>[
    const CategoriaHive(
      id: 'cat_hortifruti',
      nome: 'Hortifruti',
      iconeCodePoint: 0,
      ordem: 1,
      ativa: true,
    ),
    const CategoriaHive(
      id: 'cat_carnes',
      nome: 'Carnes',
      iconeCodePoint: 0,
      ordem: 2,
      ativa: true,
    ),
    const CategoriaHive(
      id: 'cat_padaria',
      nome: 'Padaria',
      iconeCodePoint: 0,
      ordem: 3,
      ativa: true,
    ),
    const CategoriaHive(
      id: 'cat_bebidas',
      nome: 'Bebidas',
      iconeCodePoint: 0,
      ordem: 4,
      ativa: true,
    ),
    const CategoriaHive(
      id: 'cat_laticinios',
      nome: 'Laticinios',
      iconeCodePoint: 0,
      ordem: 5,
      ativa: true,
    ),
    const CategoriaHive(
      id: 'cat_mercearia',
      nome: 'Mercearia',
      iconeCodePoint: 0,
      ordem: 6,
      ativa: true,
    ),
  ];

  static final ofertas = <OfertaHive>[
    OfertaHive(
      id: 'offer_001',
      tag: 'PROMOCAO',
      titulo: 'Feira Fresca\nToda Quarta',
      subtitulo: 'Descontos de ate 40%',
      corInicioHex: 0xFF0F4930,
      corFimHex: 0xFF174E25,
      larguraCard: 248,
      inicioEm: DateTime.utc(2026, 2, 18, 0),
      fimEm: DateTime.utc(2026, 2, 25, 23, 59),
      categoriaId: 'cat_hortifruti',
    ),
    OfertaHive(
      id: 'offer_002',
      tag: 'CHURRASCO',
      titulo: 'Churrasco\nde Domingo',
      subtitulo: 'Carnes selecionadas',
      corInicioHex: 0xFF5A260D,
      corFimHex: 0xFF8D3B12,
      larguraCard: 184,
      inicioEm: DateTime.utc(2026, 2, 19, 0),
      fimEm: DateTime.utc(2026, 2, 22, 23, 59),
      categoriaId: 'cat_carnes',
    ),
  ];

  static final produtos = <ProdutoHive>[
    const ProdutoHive(
      id: 'prd_banana_prata',
      categoriaId: 'cat_hortifruti',
      nome: 'Banana Prata',
      marca: 'Fazenda Sol',
      subtitulo: 'aprox. 1kg / penca',
      descricao: 'Bananas prata frescas, selecionadas e de origem controlada.',
      unidade: UnidadeMedidaHive.kg,
      precoCents: 799,
      precoAntigoCents: 990,
      badge: '-19%',
      esgotado: false,
      favorito: true,
      aceitaSubstituicaoPadrao: true,
      imagemUrl: null,
      infoNutricional: InfoNutricionalHive(
        caloriasKcal: 89,
        carboidratosG: 23,
        proteinasG: 1.1,
        gordurasG: 0.3,
        fibrasG: 2.6,
        potassioMg: 358,
        sodioMg: 1,
      ),
      tags: <String>['OFERTA', 'HORTIFRUTI'],
    ),
    const ProdutoHive(
      id: 'prd_arroz_tio_joao_5kg',
      categoriaId: 'cat_mercearia',
      nome: 'Arroz Tio Joao Branco',
      marca: 'Tio Joao',
      subtitulo: 'Pacote 5kg',
      descricao: 'Arroz branco tipo 1, graos selecionados.',
      unidade: UnidadeMedidaHive.pacote,
      precoCents: 2490,
      precoAntigoCents: 2990,
      badge: 'MAIS VENDIDO',
      esgotado: false,
      favorito: false,
      aceitaSubstituicaoPadrao: true,
      imagemUrl: null,
      infoNutricional: null,
      tags: <String>['ARROZ', 'MAIS VENDIDO'],
    ),
    const ProdutoHive(
      id: 'prd_arroz_camil_1kg',
      categoriaId: 'cat_mercearia',
      nome: 'Arroz Camil Parboilizado',
      marca: 'Camil',
      subtitulo: 'Pacote 1kg',
      descricao: 'Arroz parboilizado para o dia a dia.',
      unidade: UnidadeMedidaHive.pacote,
      precoCents: 650,
      precoAntigoCents: null,
      badge: null,
      esgotado: false,
      favorito: false,
      aceitaSubstituicaoPadrao: true,
      imagemUrl: null,
      infoNutricional: null,
      tags: <String>['ARROZ'],
    ),
    const ProdutoHive(
      id: 'prd_arroz_integral_1kg',
      categoriaId: 'cat_mercearia',
      nome: 'Arroz Integral Prato Fino',
      marca: 'Prato Fino',
      subtitulo: 'Pacote 1kg',
      descricao: 'Arroz integral rico em fibras.',
      unidade: UnidadeMedidaHive.pacote,
      precoCents: 590,
      precoAntigoCents: 720,
      badge: '15% OFF',
      esgotado: false,
      favorito: false,
      aceitaSubstituicaoPadrao: true,
      imagemUrl: null,
      infoNutricional: null,
      tags: <String>['ARROZ'],
    ),
    const ProdutoHive(
      id: 'prd_arroz_arboreo_1kg',
      categoriaId: 'cat_mercearia',
      nome: 'Arroz Arboreo Paganini',
      marca: 'Paganini',
      subtitulo: 'Caixa 1kg',
      descricao: 'Ideal para risotos cremosos.',
      unidade: UnidadeMedidaHive.pacote,
      precoCents: 2290,
      precoAntigoCents: null,
      badge: null,
      esgotado: true,
      favorito: false,
      aceitaSubstituicaoPadrao: false,
      imagemUrl: null,
      infoNutricional: null,
      tags: <String>['ARROZ'],
    ),
    const ProdutoHive(
      id: 'prd_leite_integral_1l',
      categoriaId: 'cat_laticinios',
      nome: 'Leite Integral Piracanjuba',
      marca: 'Piracanjuba',
      subtitulo: '1 litro',
      descricao: 'Leite UHT integral.',
      unidade: UnidadeMedidaHive.l,
      precoCents: 459,
      precoAntigoCents: 510,
      badge: null,
      esgotado: false,
      favorito: false,
      aceitaSubstituicaoPadrao: true,
      imagemUrl: null,
      infoNutricional: null,
      tags: <String>['LEITE'],
    ),
    const ProdutoHive(
      id: 'prd_coca_zero_2l',
      categoriaId: 'cat_bebidas',
      nome: 'Refrigerante Coca-Cola Sem Acucar',
      marca: 'Coca-Cola',
      subtitulo: '2 litros',
      descricao: 'Refrigerante sem acucar.',
      unidade: UnidadeMedidaHive.l,
      precoCents: 990,
      precoAntigoCents: null,
      badge: null,
      esgotado: false,
      favorito: false,
      aceitaSubstituicaoPadrao: true,
      imagemUrl: null,
      infoNutricional: null,
      tags: <String>['BEBIDA'],
    ),
    const ProdutoHive(
      id: 'prd_maca_fuji',
      categoriaId: 'cat_hortifruti',
      nome: 'Maca Fuji',
      marca: null,
      subtitulo: 'aprox. 180g / un',
      descricao: null,
      unidade: UnidadeMedidaHive.unidade,
      precoCents: 1290,
      precoAntigoCents: null,
      badge: null,
      esgotado: false,
      favorito: true,
      aceitaSubstituicaoPadrao: true,
      imagemUrl: null,
      infoNutricional: null,
      tags: <String>['FRUTA'],
    ),
    const ProdutoHive(
      id: 'prd_alface_americana',
      categoriaId: 'cat_hortifruti',
      nome: 'Alface Americana',
      marca: null,
      subtitulo: '1 unidade',
      descricao: null,
      unidade: UnidadeMedidaHive.unidade,
      precoCents: 450,
      precoAntigoCents: null,
      badge: null,
      esgotado: false,
      favorito: true,
      aceitaSubstituicaoPadrao: true,
      imagemUrl: null,
      infoNutricional: null,
      tags: <String>['VERDURA'],
    ),
    const ProdutoHive(
      id: 'prd_tomate_italiano',
      categoriaId: 'cat_hortifruti',
      nome: 'Tomate Italiano',
      marca: null,
      subtitulo: 'aprox. 150g / un',
      descricao: null,
      unidade: UnidadeMedidaHive.unidade,
      precoCents: 990,
      precoAntigoCents: null,
      badge: null,
      esgotado: false,
      favorito: true,
      aceitaSubstituicaoPadrao: true,
      imagemUrl: null,
      infoNutricional: null,
      tags: <String>['LEGUME'],
    ),
    const ProdutoHive(
      id: 'prd_cenoura_500g',
      categoriaId: 'cat_hortifruti',
      nome: 'Cenoura',
      marca: null,
      subtitulo: 'aprox. 500g',
      descricao: null,
      unidade: UnidadeMedidaHive.g,
      precoCents: 549,
      precoAntigoCents: null,
      badge: null,
      esgotado: false,
      favorito: true,
      aceitaSubstituicaoPadrao: true,
      imagemUrl: null,
      infoNutricional: null,
      tags: <String>['LEGUME'],
    ),
    const ProdutoHive(
      id: 'prd_morango_250g',
      categoriaId: 'cat_hortifruti',
      nome: 'Morango',
      marca: null,
      subtitulo: 'Bandeja 250g',
      descricao: null,
      unidade: UnidadeMedidaHive.g,
      precoCents: 1490,
      precoAntigoCents: null,
      badge: null,
      esgotado: false,
      favorito: true,
      aceitaSubstituicaoPadrao: true,
      imagemUrl: null,
      infoNutricional: null,
      tags: <String>['FRUTA'],
    ),
  ];

  static ProdutoHive get produtoPrincipal =>
      produtos.firstWhere((p) => p.id == 'prd_banana_prata');

  static List<ProdutoHive> get produtosHome => <String>[
        'prd_banana_prata',
        'prd_arroz_tio_joao_5kg',
        'prd_leite_integral_1l',
        'prd_coca_zero_2l',
      ]
          .map(
            (id) => produtos.firstWhere((p) => p.id == id),
          )
          .toList(growable: false);

  static List<ProdutoHive> get produtosHortifruti => produtos
      .where((p) => p.categoriaId == 'cat_hortifruti')
      .toList(growable: false);

  static List<ProdutoHive> buscarProdutos(String termo) {
    final query = termo.toLowerCase();
    return produtos
        .where((p) => p.nome.toLowerCase().contains(query))
        .toList(growable: false);
  }

  static final carrinho = CarrinhoHive(
    id: 'cart_001',
    usuarioId: usuario.id,
    itens: <ItemCarrinhoHive>[
      ItemCarrinhoHive(
        id: 'cart_item_001',
        produtoId: 'prd_arroz_tio_joao_5kg',
        nomeSnapshot: 'Arroz Branco Tipo 1 (5kg)',
        subtituloSnapshot: 'Marca: Tio Joao',
        unidade: UnidadeMedidaHive.pacote,
        quantidade: 1,
        precoUnitarioCents: 2490,
        precoAntigoUnitarioCents: null,
        aceitaSubstituicao: true,
        observacao: null,
        adicionadoEm: DateTime.utc(2026, 2, 20, 9, 15),
      ),
      ItemCarrinhoHive(
        id: 'cart_item_002',
        produtoId: 'prd_leite_integral_1l',
        nomeSnapshot: 'Leite Integral (1L)',
        subtituloSnapshot: 'Marca: Piracanjuba',
        unidade: UnidadeMedidaHive.l,
        quantidade: 4,
        precoUnitarioCents: 459,
        precoAntigoUnitarioCents: null,
        aceitaSubstituicao: true,
        observacao: null,
        adicionadoEm: DateTime.utc(2026, 2, 20, 9, 18),
      ),
      ItemCarrinhoHive(
        id: 'cart_item_003',
        produtoId: 'prd_banana_prata',
        nomeSnapshot: 'Banana Prata (Kg)',
        subtituloSnapshot: 'Aprox. 800g',
        unidade: UnidadeMedidaHive.kg,
        quantidade: 1,
        precoUnitarioCents: 690,
        precoAntigoUnitarioCents: null,
        aceitaSubstituicao: true,
        observacao: null,
        adicionadoEm: DateTime.utc(2026, 2, 20, 9, 20),
      ),
    ],
    cupomCodigo: null,
    descontoCupomCents: 0,
    taxaEntregaCents: 790,
    limiteFreteGratisCents: 9000,
    subtotalCents: 5016,
    totalCents: 5806,
    atualizadoEm: DateTime.utc(2026, 2, 20, 9, 30),
  );

  static final checkout = CheckoutRascunhoHive(
    usuarioId: usuario.id,
    enderecoId: enderecoSelecionado.id,
    metodoPagamento: MetodoPagamentoHive.pix,
    subtotalCents: carrinho.subtotalCents,
    freteCents: 500,
    descontoCents: 251,
    totalCents: 5265,
    janelaEntregaInicio: DateTime.utc(2026, 2, 20, 14, 45),
    janelaEntregaFim: DateTime.utc(2026, 2, 20, 15, 10),
    atualizadoEm: DateTime.utc(2026, 2, 20, 9, 35),
  );

  static int get totalItensCarrinho {
    return carrinho.itens.fold<int>(
      0,
      (soma, item) => soma + item.quantidade.round(),
    );
  }

  static final pedidoConfirmado = PedidoHive(
    id: 'ord_1234',
    numeroExibicao: '#1234',
    usuarioId: usuario.id,
    status: StatusPedidoHive.confirmado,
    metodoPagamento: checkout.metodoPagamento,
    enderecoEntregaTexto: 'Av. Paulista, 1000 - Bela Vista\nApt 42 - Sao Paulo, SP',
    itens: <ItemPedidoHive>[
      const ItemPedidoHive(
        produtoId: 'prd_arroz_tio_joao_5kg',
        nome: 'Arroz Branco Tipo 1 (5kg)',
        quantidade: 1,
        unidade: UnidadeMedidaHive.pacote,
        precoUnitarioCents: 2490,
        totalItemCents: 2490,
      ),
      const ItemPedidoHive(
        produtoId: 'prd_leite_integral_1l',
        nome: 'Leite Integral (1L)',
        quantidade: 4,
        unidade: UnidadeMedidaHive.l,
        precoUnitarioCents: 459,
        totalItemCents: 1836,
      ),
      const ItemPedidoHive(
        produtoId: 'prd_banana_prata',
        nome: 'Banana Prata (Kg)',
        quantidade: 1,
        unidade: UnidadeMedidaHive.kg,
        precoUnitarioCents: 690,
        totalItemCents: 690,
      ),
    ],
    resumo: const ResumoPedidoHive(
      itensQuantidade: 6,
      subtotalCents: 5016,
      freteCents: 500,
      descontoCents: 251,
      totalCents: 5265,
    ),
    criadoEm: DateTime.utc(2026, 2, 20, 9, 45),
    confirmadoEm: DateTime.utc(2026, 2, 20, 9, 46),
    entregueEm: null,
    estimativaInicio: DateTime.utc(2026, 2, 20, 14, 45),
    estimativaFim: DateTime.utc(2026, 2, 20, 15, 10),
  );
}
