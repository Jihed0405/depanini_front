import 'package:depanini/constants/color.dart';
import 'package:depanini/controllers/service_provider_details_controller.dart';
import 'package:depanini/models/rating.dart';
import 'package:depanini/models/serviceProvider.dart';
import 'package:depanini/provider/provider.dart';
import 'package:depanini/services/ratingService.dart';
import 'package:depanini/widgets/reviewsContent.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../widgets/providerDetailCard.dart';

class ServiceProviderDetailsView extends ConsumerStatefulWidget {
  const ServiceProviderDetailsView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ServiceProviderDetailsViewState();
}

class _ServiceProviderDetailsViewState
    extends ConsumerState<ServiceProviderDetailsView> {
  final ServiceProviderDetailsController _controller =
      ServiceProviderDetailsController();

  late Future<ServiceProvider> _serviceProviderFuture;
  String _selectedMenu = 'About'; // Default selected menu
  final RatingService _ratingService = RatingService();
  late Future<List<Rating>> _ratingFuture;
  @override
  void initState() {
    super.initState();

    _serviceProviderFuture = Future.delayed(Duration(seconds: 2),
        () => _controller.getProvider(ref.read(serviceProviderIdProvider)));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '${ref.watch(serviceProviderNameProvider)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<ServiceProvider>(
                  future: _serviceProviderFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, left: 16.0),
                                child: Text(
                                  "Details",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 50), // Spacer
                              _buildContactIcons(null),
                            ],
                          ),
                          SizedBox(height: 180, child: detailsCardOnload()),
                          const SizedBox(height: 30),
                          _buildMenu(),
                          _buildContentOnLoad(),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 32.0),
                        child: Center(
                          child: Text(
                              'Failed to load Provider. Please try again later.'),
                        ),
                      );
                    } else {
                      final serviceProvider = snapshot.data;

                      if (serviceProvider == null) {
                        return Text(
                            "error in retrieving service provider détails ");
                      } else {
                        final _providerId = serviceProvider.id;
                        this._ratingFuture = Future.delayed(
                            Duration(seconds: 2),
                            () => _ratingService
                                .getRatingByProviderId(_providerId));
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 16.0),
                                  child: Text(
                                    "Details",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 50), // Spacer
                                _buildContactIcons(serviceProvider),
                              ],
                            ),
                            SizedBox(
                              height: 180,
                              child: ProviderDetailCard(
                                serviceProvider: serviceProvider,
                              ),
                            ),
                            const SizedBox(height: 30),
                            _buildMenu(),
                            _buildContent(serviceProvider),
                          ],
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMenuItem('About'),
        _buildMenuItem('Gallery'),
        _buildMenuItem('Reviews'),
      ],
    );
  }

  Widget _buildMenuItem(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMenu = title;
        });
      },
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: _selectedMenu == title ? selectedColor : Colors.black,
        ),
      ),
    );
  }

  Widget _buildContent(ServiceProvider serviceProvider) {
    switch (_selectedMenu) {
      case 'Gallery':
        return _buildGalleryContent(serviceProvider);
      case 'Reviews':
        return ReviewsContent(serviceProvider: serviceProvider);
      default:
        return _buildAboutContent(serviceProvider);
    }
  }

  Widget _buildContentOnLoad() {
    switch (_selectedMenu) {
      case 'Gallery':
        return _buildGalleryContentOnLoad();
      case 'Reviews':
        return _buildReviewsContentOnLoad();
      default:
        return _buildAboutContentOnLoad();
    }
  }

  Widget _buildAboutContent(ServiceProvider serviceProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Color(0xFFF5F5F5),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bio',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                serviceProvider.bio,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.work), // Icon for professional experience
                      SizedBox(width: 8),
                      Text(
                        'Professional Experience:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    '${serviceProvider.numberOfExperiences} years',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Services',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 80, // Adjust height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: serviceProvider.services.length,
                  itemBuilder: (context, index) {
                    final service = serviceProvider.services[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SizedBox(
                        width: 150, // Width of each card
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              service.imagePath,
                              height: 40,
                            ),
                            SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                service.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutContentOnLoad() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bio',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 20,
                  width: 150,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.work), // Icon for professional experience
                      SizedBox(width: 8),
                      Text(
                        'Professional Experience:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 20,
                      width: 60,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Services',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 80, // Adjust height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3, // Number of placeholders
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: SizedBox(
                          width: 100, // Width of each placeholder
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 8),
                              Container(
                                height: 16,
                                width: 60,
                                color: Colors.grey[300],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryContent(ServiceProvider serviceProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 200,
        color: Colors.grey[200],
        child: Center(
          child: Text('Gallery content goes here'),
        ),
      ),
    );
  }

  Widget _buildReviewsContent(ServiceProvider serviceProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Clients rate',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Text(
                      '4.5', // Example star rating
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < 4.5 ? Icons.star : Icons.star_border,
                          color: Color(0xFFebab01),
                        );
                      }),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '2 notes', // Example number of notes
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              _buildRatingRow('Quality of service'),
              SizedBox(height: 8),
              _buildRatingRow('Discipline Rating'),
              SizedBox(height: 8),
              _buildRatingRow('Fees of the service'),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Add your rating functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFebab01),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(
                    Icons.star,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Add Rate',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactIcons(ServiceProvider? serviceProvider) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              if (serviceProvider != null) {
                _controller.makePhoneCall(serviceProvider.phoneNumber, context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFebab01),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size(40, 40),
            ),
            child: Icon(
              Icons.call,
              size: 24,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              ref.read(bottomNavIndexProvider.notifier).add(2);
              // Add your message functionality here
              _controller.sendMessage(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFebab01),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size(40, 40),
            ),
            child: Icon(
              Icons.message,
              size: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 16,
        color: Colors.grey[300], // Gray color for loading placeholder
      ),
    );
  }

  Widget _buildGalleryContentOnLoad() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 200,
        color: Colors.grey[200],
        child: Center(
          child: Text('Gallery content goes here'),
        ),
      ),
    );
  }

  Widget _buildReviewsContentOnLoad() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 200,
        color: Colors.grey[200],
        child: Center(
          child: Text('Reviews content goes here'),
        ),
      ),
    );
  }
}

Widget _buildRatingRow(String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      Row(
        children: List.generate(5, (index) {
          return Icon(
            index < 4.5 ? Icons.star : Icons.star_border,
            color: Color(0xFFebab01),
          );
        }),
      ),
    ],
  );
}
