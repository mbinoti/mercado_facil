# Contexto do Projeto: Mercado Fácil

## Sobre o App
O **Mercado Fácil** é um aplicativo de e-commerce focado em supermercado/delivery. O objetivo é permitir que usuários naveguem por categorias, adicionem produtos ao carrinho e finalizem a compra.

## Regras de Negócio Principais
1.  **Carrinho**: Deve persistir os itens enquanto o usuário navega.
2.  **Checkout**: Exige endereço selecionado e usuário logado.
3.  **Produtos**: Possuem variações (peso, unidade) e promoções.

## Identidade Visual & UX
- Cores principais: Verdes definidos em `AppTheme`.
- Feedback: Sempre usar Snackbars para sucesso/erro.
- Estado vazio: Telas de lista devem ter empty states amigáveis.

## Integrações (Simuladas ou Reais)
- API Rest para produtos.
- Hive para persistência local (carrinho/settings).
