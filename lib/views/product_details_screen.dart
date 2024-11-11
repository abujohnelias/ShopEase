// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:shopease/constants/color_const.dart';
// import 'package:shopease/constants/text_style_const.dart';
// import 'package:shopease/provider/product_details_provider.dart';
// import 'package:shopease/utils/extensions/sizedbox_extension.dart';
// import 'package:shopease/views/product_edit_screen.dart';
// import 'package:shopease/widgets/reusable_appbar.dart';

// class ProductDetailScreen extends StatelessWidget {
//   final int productId;

//   const ProductDetailScreen({super.key, required this.productId});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => ProductDetailProvider()..fetchProductDetail(productId),
//       child: Scaffold(
//         backgroundColor: scaffoldColor,
// appBar: PreferredSize(
//   preferredSize: const Size.fromHeight(50),
//   child: ReusableAppBar(
//     backgroundColor: white,
//     isHome: false,
//     leadingIcon: Icons.arrow_back,
//     actionIcons: Icons.edit,
//     onActionTap: () {
//       if (provider.product != null) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ProductEditScreen(product: provider.product!),
//                 ),
//               );
//             }
//     },
//   ),
// ),
//         body: Consumer<ProductDetailProvider>(
//           builder: (context, provider, _) {
//             if (provider.isLoading) {
//               return Center(child: CircularProgressIndicator());
//             }

//             if (provider.product == null) {
//               return Center(child: Text('Failed to load product details'));
//             }

//             final product = provider.product!;
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: double.infinity,
//                   height: 200,
//                   color: white,
//                   child: CachedNetworkImage(
//                     imageUrl: product.thumbnail,
//                     fit: BoxFit.fitHeight,
//                     placeholder: (context, url) => const Center(
//                       child: Shimmer(
//                         gradient: SweepGradient(
//                           colors: [
//                             primaryTextColor,
//                             nonHighlighterColor,
//                           ],
//                         ),
//                         child: SizedBox(
//                           height: 120,
//                           width: 120,
//                         ),
//                       ),
//                     ),
//                     errorWidget: (context, url, error) =>
//                         const Icon(Icons.error),
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           SizedBox(
//                             width: 250,
//                             child: Text(
//                               product.title,
//                               style: TextStyleConst.poppinsBold20.copyWith(
//                                 color: black,
//                               ),
//                             ),
//                           ),
//                           Text(
//                             '₹${product.price}',
//                             style: TextStyleConst.poppinsBold20.copyWith(
//                               color: primaryTextColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBoxExtension.height(16),
//                       Text('Category: ${product.category ?? 'N/A'}'),
//                       Text(
//                           'Rating: ${product.rating?.toStringAsFixed(1) ?? 'N/A'}'),
//                       Text('Stock: ${product.stock ?? 'N/A'}'),
//                       const Text('Description:',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       Text(product.description ?? 'No description available'),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

/// screens/product_detail_screen.dart

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

  ProductDetailScreen({required this.productId});

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
              return Center(child: CircularProgressIndicator());
            }

            if (provider.product == null) {
              return Center(child: Text('Failed to load product details'));
            }

            final product = provider.product!;
            return Column(
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
                              style: TextStyleConst.poppinsBold20.copyWith(
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
                      SizedBoxExtension.height(16),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          _detailItems(product,Icons.category_outlined),
                          Text('Return Policy: ${product.returnPolicy}'),
                          Text(
                              'Shipping Information: ${product.shippingInformation}'),
                          Text(
                              'Rating: ${product.rating?.toStringAsFixed(1) ?? 'N/A'}'),
                          Text('Stock: ${product.stock ?? 'N/A'}'),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Container _detailItems(Product product,IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const ShapeDecoration(
        color: highlightBlueColor,
        shape: SmoothRectangleBorder(
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
            product.category?.toUpperCase() ?? "".toUpperCase(),
            style: TextStyleConst.poppinsMedium14,
          ),
        ],
      ),
    );
  }
}
