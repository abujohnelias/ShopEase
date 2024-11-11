import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopease/constants/color_const.dart';
import 'package:shopease/constants/text_style_const.dart';
import 'package:shopease/provider/products_provider.dart';
import 'package:shopease/utils/extensions/sizedbox_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopease/views/product_details_screen.dart';
import 'package:shopease/widgets/reusable_appbar.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  get baseColor => null;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: Scaffold(
        backgroundColor: scaffoldColor,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(050),
          child: ReusableAppBar(
            isHome: true,
            leadingIcon: Icons.menu,
            actionIcons: Icons.shopping_cart_outlined,
          ),
        ),
        body: Consumer<ProductProvider>(
          builder: (context, provider, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Discover our exclusive\nproducts",
                      style: TextStyleConst.poppinsBold20.copyWith(
                        color: primaryTextColor,
                      ),
                    ),
                    SizedBoxExtension.height(8),
                    SizedBox(
                      width: 280,
                      child: Text(
                        "In this market place, you'll find various products in the cheapest price",
                        style: TextStyleConst.poppinsMedium13.copyWith(
                          color: nonHighlighterColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: provider.products.length +
                            (provider.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < provider.products.length) {
                            final product = provider.products[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailScreen(
                                          productId: product.id),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      height: 120,
                                      width: 120,
                                      decoration: const BoxDecoration(
                                        borderRadius: SmoothBorderRadius.all(
                                          SmoothRadius(
                                            cornerRadius: 8,
                                            cornerSmoothing: 1,
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        color: white,
                                        height: 84,
                                        width: 90,
                                        child: CachedNetworkImage(
                                          imageUrl: product.thumbnail,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const Center(
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
                                    ),
                                    SizedBoxExtension.width(8),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            product.title.toUpperCase(),
                                            style: TextStyleConst.poppinsBold14
                                                .copyWith(
                                              color: primaryTextColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            product.description ?? "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyleConst
                                                .poppinsMedium12
                                                .copyWith(
                                              color: primaryTextColor,
                                            ),
                                          ),
                                        ),
                                        SizedBoxExtension.height(8),
                                        Text(
                                          '₹ ${product.price}',
                                          style: TextStyleConst.poppinsMedium15
                                              .copyWith(
                                            color: secondryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            provider.fetchNextPage();
                            return Shimmer.fromColors(
                              baseColor: white,
                              highlightColor: black,
                              child: const SizedBox(
                                height: 120,
                                width: 500,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
