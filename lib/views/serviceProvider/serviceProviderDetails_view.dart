import 'package:depanini_front/models/serviceProvider.dart';
import 'package:depanini_front/provider/provider.dart';
import 'package:depanini_front/services/serviceProvidersService.dart';
import 'package:depanini_front/widgets/ProviderDetailCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceProviderDetailsView extends ConsumerStatefulWidget {
  const ServiceProviderDetailsView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ServiceProviderDetailsViewState();
}

class _ServiceProviderDetailsViewState
    extends ConsumerState<ServiceProviderDetailsView> {
  final ServiceProvidersService _serviceProvidersService =
      ServiceProvidersService();
  late Future<ServiceProvider> _serviceProviderFuture;
  String _selectedMenu = 'About'; // Default selected menu

  @override
  void initState() {
    super.initState();
    _serviceProviderFuture =
        _serviceProvidersService.getProviderById(ref.read(serviceProviderIdProvider));
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
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
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
                      print("jihed phone is${serviceProvider?.phoneNumber}");
                      if (serviceProvider == null) {
                        return Text(
                            "No service providers for this service ");
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 16.0),
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
          color: _selectedMenu == title ? Colors.blue : Colors.black,
        ),
      ),
    );
  }

  Widget _buildContent(ServiceProvider serviceProvider) {
    switch (_selectedMenu) {
      case 'Gallery':
        return _buildGalleryContent();
      case 'Reviews':
        return _buildReviewsContent();
      default:
        return _buildAboutContent(serviceProvider);
    }
  }

  Widget _buildAboutContent(ServiceProvider serviceProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(serviceProvider.bio ?? 'No bio available'),
          const SizedBox(height: 10),
          Text(
            'Qualification',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryContent() {
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

  Widget _buildReviewsContent() {
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
Widget _buildContactIcons(ServiceProvider? serviceProvider) {
  return Padding(
    padding: const EdgeInsets.only(right: 16.0),
    child: Row(
      children: [
        ElevatedButton(
          onPressed: () {
             if (serviceProvider != null) {
              _makePhoneCall(serviceProvider.phoneNumber ?? '');} // Replace '1234567890' with the desired phone number
          },
          style: ElevatedButton.styleFrom(
            primary: Color(0xFFebab01),
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
            // Add your message functionality here
            print("message clicked");
          },
          style: ElevatedButton.styleFrom(
            primary: Color(0xFFebab01),
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

Future<void> _makePhoneCall(String phoneNumber) async {
  final Uri _url = Uri(scheme: 'tel', path: phoneNumber);
 if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

}
