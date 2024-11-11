import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopease/constants/color_const.dart';
import 'package:shopease/constants/text_style_const.dart';
import 'package:shopease/models/products_model.dart';
import 'package:shopease/provider/product_details_provider.dart';
import 'package:shopease/utils/extensions/sizedbox_extension.dart';
import 'package:shopease/widgets/reusable_appbar.dart';

import 'product_edit_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;

  ProductDetailScreen({super.key, required this.productId});
  final List<Color> highlightColors = [
    highlightPinkColor, 
    highlightBlueColor, 
    highlightOrangeColor, 
    highlightYellowColor, 
    highlightRedColor, 
  ];
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductDetailProvider()..fetchProductDetail(productId),
      child: Scaffold(
        backgroundColor: scaffoldColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Consumer<ProductDetailProvider>(
            builder: (context, provider, _) {
              return ReusableAppBar(
                backgroundColor: white,
                isHome: false,
                leadingIcon: Icons.arrow_back,
                actionIcons: Icons.edit,
                onActionTap: () async {
                  if (provider.product != null) {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductEditScreen(product: provider.product!),
                      ),
                    );

                    // Re-fetch the product data after editing
                    if (result == true) {
                      await provider.fetchProductDetail(productId,
                          forceRefresh: true);
                    }
                  }
                },
              );
            },
          ),
        ),
        body: Consumer<ProductDetailProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.product == null) {
              return const Center(
                  child: Text('Failed to load product details'));
            }

            final product = provider.product!;
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        color: white,
                        child: CachedNetworkImage(
                          imageUrl: product.thumbnail,
                          fit: BoxFit.fitHeight,
                          placeholder: (context, url) => const Center(
                            child: Shimmer(
                              gradient: SweepGradient(
                                colors: [
                                  primaryTextColor,
                                  nonHighlighterColor,
                                ],
                              ),
                              child: SizedBox(
                                height: 120,
                                width: 120,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 250,
                                  child: Text(
                                    product.title.toUpperCase(),
                                    style:
                                        TextStyleConst.poppinsBold20.copyWith(
                                      color: black,
                                    ),
                                  ),
                                ),
                                Text(
                                  '₹${product.price}',
                                  style: TextStyleConst.poppinsBold20.copyWith(
                                    color: black,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              product.brand,
                              style: TextStyleConst.poppinsSemiBold15.copyWith(
                                color: primaryTextColor,
                              ),
                            ),
                            SizedBoxExtension.height(8),
                            Text(
                              product.description ?? 'No description available',
                              style: TextStyleConst.poppinsMedium14.copyWith(
                                color: secondryTextColor,
                              ),
                            ),
                            SizedBoxExtension.height(32),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: [
                                _detailItems(
                                  product.category ?? "",
                                  Icons.category_outlined,
                                ),
                                _detailItems(
                                  product.rating.toString(),
                                  Icons.star_outline,
                                ),
                                _detailItems(
                                  product.returnPolicy.toString(),
                                  Icons.undo,
                                ),
                                _detailItems(
                                  "${product.stock}In stock",
                                  Icons.bar_chart,
                                ),
                                _detailItems(
                                  "${product.dimensions.height.toStringAsFixed(0)}L, ${product.dimensions.width.toStringAsFixed(0)}W, ${product.dimensions.depth.toStringAsFixed(0)}B in cms",
                                  Icons.crop_square_outlined,
                                ),
                                _detailItems(
                                  product.warrantyInformation,
                                  Icons.shield_outlined,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: ReusableButton(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Container _detailItems(String product, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration:  ShapeDecoration(
        color: getRandomColor(),
        shape: const SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 15, cornerSmoothing: 1),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
          ),
          SizedBoxExtension.width(4),
          Text(
            product.toUpperCase(),
            style: TextStyleConst.poppinsMedium14,
          ),
        ],
      ),
    );
  }

  Color getRandomColor() {
    Random random = Random();
    return highlightColors[random.nextInt(highlightColors.length)];
  }
}

class ReusableButton extends StatelessWidget {
  const ReusableButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 66,
        margin: const EdgeInsets.all(16),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 24),
        width: double.infinity,
        decoration: const ShapeDecoration(
          color: onButtonColor,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius.all(
              SmoothRadius(cornerRadius: 20, cornerSmoothing: 1),
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "ADD TO CART",
              style: TextStyleConst.poppinsSemiBold14.copyWith(color: white),
            ),
            SizedBoxExtension.width(8),
            const Icon(
              Icons.arrow_forward_rounded,
              color: white,
              size: 20,
            )
          ],
        ),
      ),
    );
  }
}
