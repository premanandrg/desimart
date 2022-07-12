import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desimart/FIREBASE/firebase_config.dart';
import 'package:desimart/app_config.dart';
import 'package:desimart/components/skeleton.dart';
import 'package:desimart/customerCare/customer_support_page.dart';
import 'package:desimart/notification/notification_page.dart';
import 'package:desimart/product/product_details_page.dart';
import 'package:desimart/profile/profile_page.dart';
import 'package:desimart/search/search_product_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../login/login_page.dart';
import '../main_page.dart';
import '../short_codes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: [
          AppBar(
            backgroundColor: Colors.white,
            foregroundColor: appColor,
            // title: Text(
            //   appName,
            //   style: GoogleFonts.roboto().copyWith(color: appColor.shade700),
            // ),
            elevation: 0,
            title: Row(
              children: [
                SizedBox(
                  width: size.width * 0.035,
                ),
                Image.asset(
                  'assets/images/applogo.png',
                  height: 50,
                ),
              ],
            ),

            actions: [
              IconButton(
                onPressed: () {
                  pushPage(context, const ProfilePage());
                },
                icon: FirebaseAuth.instance.currentUser == null
                    ? const Icon(Icons.account_circle)
                    : CircleAvatar(
                        backgroundImage:
                            FirebaseAuth.instance.currentUser == null
                                ? null
                                : CachedNetworkImageProvider(FirebaseAuth
                                    .instance.currentUser!.photoURL
                                    .toString()),
                      ),
              ),
              IconButton(
                  onPressed: () {
                    pushPage(context, const NotificationPage());
                  },
                  icon: const Icon(Icons.notifications_on)),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              pushPage(
                  context,
                  const SearchProductPage(
                    isMic: false,
                  ));
            },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 54,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(blurRadius: 40, color: appColor.withOpacity(0.3)),
                  ]),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: appColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      pushPage(
                          context,
                          const SearchProductPage(
                            isMic: true,
                          ));
                    },
                    icon: const Icon(
                      CupertinoIcons.mic,
                    ),
                  ),
                  const Icon(
                    CupertinoIcons.search,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const CategorySection(),
          const SizedBox(
            height: 10,
          ),
          GridLayoutCard(
            title: 'For farmers',
            query: productsRef,
            type: 'product',
          ),
          GridLayoutCard(
            title: 'Top products',
            query: productsRef,
            type: 'product',
          ),
          GridLayoutCard(
            title: 'Services',
            type: 'service',
            //TODO services
            query: productsRef,
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
          mini: true,
          backgroundColor: Colors.white,
          onPressed: () {
            if (FirebaseAuth.instance.currentUser == null) {
              pushPage(context, const LoginPage(nextPage: MainPage()));
              return;
            }
            pushPage(context, const CustomerSupportPage(isTab: false));
          },
          child: const Icon(
            Icons.support_agent_outlined,
            color: appColor,
          )),
    );
  }
}

class CategorySection extends StatefulWidget {
  const CategorySection({
    Key? key,
  }) : super(key: key);

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  List labels = [
    'All',
    'Ghee',
    'Honey',
    'Snacks',
    'Spicy',
    'Oil',
  ];
  List KAlabels = [
    'kannada',
    'Ghee',
    'Honey',
    'Snacks',
    'Spicy',
    'Oil',
  ];
  int categoryIndex = 0;

  var categoryQuery = productsRef.get();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: labels.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  if (index == 0) {
                    categoryQuery = productsRef.get();
                  } else {
                    categoryQuery = productsRef
                        .where('category', arrayContains: labels[index])
                        .get();
                  }
                  setState(() {
                    categoryIndex = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Chip(
                      backgroundColor: categoryIndex == index ? appColor : null,
                      label: Text(
                        labels[index],
                        style: TextStyle(
                          color: categoryIndex == index ? Colors.white : null,
                        ),
                      )),
                ),
              );
            },
          ),
        ),
        FutureBuilder(
          future: categoryQuery,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: size.height * 0.23,
                child: ListView.builder(
                  itemCount: 3,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Skeleton(
                        heigth: size.height * 0.13,
                        width: size.width * 0.3,
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
            } else if (snapshot.data!.docs.isEmpty) {
              return SizedBox(
                  height: size.height * 0.23,
                  child: const Center(child: Text('No products found!')));
            }
            return SizedBox(
              height: size.height * 0.23,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot productSnap = snapshot.data!.docs[index];
                  return GestureDetector(
                    onTap: () {
                      pushPage(context,
                          ProductDetailsPage(productId: productSnap.id));
                    },
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Hero(
                            tag: productSnap['image'],
                            child: CachedNetworkImage(
                              height: size.height * 0.13,
                              imageUrl: productSnap['image'],
                            ),
                          ),
                          const Spacer(),
                          Text(productSnap['name']),
                          Text(productSnap['subtitle']),
                          const SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: [
                              Text(
                                '₹' + productSnap['price'].toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '₹' + productSnap['mrp'].toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 3),
                                decoration: BoxDecoration(
                                    color: appColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  (productSnap['mrp'] -
                                              (productSnap['mrp'] *
                                                  productSnap['price'] /
                                                  100))
                                          .ceil()
                                          .toString() +
                                      '%',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 10,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class GridLayoutCard extends StatelessWidget {
  const GridLayoutCard({
    Key? key,
    required this.title,
    required this.query,
    required this.type,
  }) : super(key: key);

  final String title;
  final Query query;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: appColor.shade800),
              ),
              const Divider(),
              FutureBuilder(
                //TODO change to category ref
                future: query.get(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return GridView.builder(
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4),
                        itemCount: 8,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext ctx, index) {
                          return Column(
                            children: const [
                              Skeleton(
                                heigth: 30,
                                width: 30,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Skeleton(
                                heigth: 5,
                                width: 10,
                              ),
                            ],
                          );
                        });
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong!'));
                  } else if (snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No products found!'));
                  }
                  return GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4),
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext ctx, index) {
                        DocumentSnapshot productSnap =
                            snapshot.data!.docs[index];
                        return GestureDetector(
                          onLongPress: () {
                            speech(
                              productSnap['name'],
                            );
                          },
                          onTap: () {
                            if (type == 'product') {
                              pushPage(
                                  context,
                                  ProductDetailsPage(
                                      productId: productSnap.id));
                            } else if (type == 'service') {
                              //TODO service page
                              pushPage(
                                  context,
                                  ProductDetailsPage(
                                      productId: productSnap.id));
                            }
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    productSnap['image']),
                                radius: 30,
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                productSnap['name'],
                                style: Theme.of(context).textTheme.caption,
                              )
                            ],
                          ),
                        );
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
