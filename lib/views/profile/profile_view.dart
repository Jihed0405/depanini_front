import 'package:cached_network_image/cached_network_image.dart';
import 'package:depanini/constants/color.dart';
import 'package:depanini/constants/size.dart';
import 'package:depanini/controllers/profile_controller.dart';
import 'package:depanini/models/user.dart';
import 'package:shimmer/shimmer.dart';
import 'package:depanini/widgets/profile_account_info_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:depanini/provider/provider.dart';
class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final ProfileController _profileController = ProfileController();
  late Future<User> _userServiceFuture;

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    _userServiceFuture = Future.delayed(
        Duration(seconds: 2), () => _profileController.getUserById(ref.watch(userIdProvider)));
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: background,
      ),
      body: FutureBuilder<User>(
        future: _userServiceFuture,
        builder: (context, snapshot) {
          bool isLoading = snapshot.connectionState == ConnectionState.waiting;

          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Center(
                child: Text('Failed to load user. Please try again later.'),
              ),
            );
          } else {
            User? userData = snapshot.data;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        if (isLoading)
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(defaultRadius)),
                              child: Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        else
                          ClipRRect(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(defaultRadius)),
                            child: CachedNetworkImage(
                              imageUrl: userData!.photoUrl,
                              width: 100,
                              height: 100,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        const SizedBox(height: defaultSpacing / 2),
                        if (isLoading)
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Column(
                              children: [
                                Container(
                                  height: 20,
                                  width: 150,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: defaultSpacing / 2),
                                Container(
                                  height: 16,
                                  width: 250,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 2 * defaultSpacing / 3),
                              ],
                            ),
                          )
                        else
                          Column(
                            children: [
                              Text(
                                "${userData!.firstName} ${userData.lastName}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: fontHeading),
                              ),
                              const SizedBox(height: defaultSpacing / 2),
                              Text(
                                userData.email,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: fontSubHeading),
                              ),
                              const SizedBox(height: 2 * defaultSpacing / 3),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(defaultSpacing * 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "General",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: fontHeading),
                        ),
                        const SizedBox(height: defaultSpacing / 4),
                        ProfileAccountInfoTile(
                          imageUrl: 'assets/images/location-1.png',
                          title: 'Address',
                          subTitle: isLoading ? 'hello' : userData!.address,
                          load: isLoading,
                        ),
                        ProfileAccountInfoTile(
                          imageUrl: 'assets/images/info-circle.png',
                          title: 'Edit personal information',
                          subTitle: 'Manage your information',
                          load: false,
                        ),
                        const SizedBox(height: defaultSpacing),
                        Text(
                          "Account",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: fontHeading),
                        ),
                        const SizedBox(height: defaultSpacing),
                        ProfileAccountInfoTile(
                          imageUrl: 'assets/images/user-1.png',
                          title: 'My Account',
                          subTitle: '',
                          load: isLoading,
                        ),
                        const SizedBox(height: defaultSpacing),
                        ProfileAccountInfoTile(
                          imageUrl: 'assets/images/bell.png',
                          title: 'Notification',
                          subTitle: '',
                          load: isLoading,
                        ),
                        const SizedBox(height: defaultSpacing),
                        ProfileAccountInfoTile(
                          imageUrl: 'assets/images/lock-on.png',
                          title: 'Privacy',
                          subTitle: '',
                          load: isLoading,
                        ),
                        const SizedBox(height: defaultSpacing),
                        ProfileAccountInfoTile(
                          imageUrl: 'assets/images/info-circle.png',
                          title: 'About',
                          subTitle: '',
                          load: isLoading,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
