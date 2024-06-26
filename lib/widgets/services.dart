import 'package:depanini/models/serviceEntity.dart';
import 'package:depanini/provider/provider.dart';
import 'package:depanini/services/serviceService.dart';
import 'package:depanini/widgets/serviceCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class Services extends ConsumerStatefulWidget {
  const Services({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ServicesState();
}

class _ServicesState extends ConsumerState<Services> {
  final ServiceService _serviceService = ServiceService();
  late Future<List<ServiceEntity>> _serviceFuture;

  @override
  void initState() {
    super.initState();
    _serviceFuture = Future.delayed(
        Duration(seconds: 2),
        () => _serviceService
            .getServicesByCategoryId(ref.read(categoryIdProvider)));
  }

  @override
  Widget build(BuildContext context) {
    print("helllooo ${ref.watch(categoryIdProvider)}");

    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 20,
                right: 30,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Explore Services",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder<List<ServiceEntity>>(
              future: _serviceFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: ServiceCardOnload(),
                      );
                    },
                    itemCount: 9,
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: Center(
                      child: Text(
                          'Failed to load Services. Please try again later.'),
                    ),
                  );
                } else {
                  final serviceList = snapshot.data!;
                  if (serviceList.isEmpty) {
                    return Text("No Service for this category  ");
                  } else {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.9,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: ServiceCard(service: serviceList[index]),
                        );
                      },
                      itemCount: serviceList.length,
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  ServiceCardOnload() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 80,
              width: 80,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 20,
              width: 100,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
