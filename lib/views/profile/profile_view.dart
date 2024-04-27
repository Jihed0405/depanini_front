import 'package:depanini_front/constants/color.dart';
import 'package:depanini_front/constants/size.dart';
import 'package:depanini_front/models/user.dart';
import 'package:depanini_front/services/userService.dart';
import 'package:depanini_front/widgets/profile_account_info_tile.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
     final UserService _userService = UserService();
  late Future<User> _userServiceFuture;
  @override
  Widget build(BuildContext context) {
     _userServiceFuture = _userService.getUserById(7);
    return Scaffold(
      
      backgroundColor: background,
      
      appBar: AppBar(
        elevation: 0,
        backgroundColor: background,
        
        
      ),
      body:
          FutureBuilder<User>( future: _userServiceFuture,
             builder: (context,snapshot){
               if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(
                    child: Text(
                        'Failed to load user . Please try again later.'),
                  );
                } else {final  userData= snapshot.data!;
  return SingleChildScrollView(
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Center(
                child: Column(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.all(Radius.circular(defaultRadius)),
                  child: Image.asset(
                    "${userData.photoUrl}",
                    width: 100,
                  ),
                ),
                const SizedBox(
                  height: defaultSpacing / 2,
                ),
                ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.zero),
                    child: Column(children: [
                      Text(
                        "${userData.firstName} ${userData.lastName}",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: fontHeading),
                      ),
                      const SizedBox(
                        height: defaultSpacing / 2,
                      ),
                      Text(
                        userData.email,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: fontSubHeading),
                      ),
                      const SizedBox(
                        height: 2 * defaultSpacing / 3,
                      ),
                     
                    ])),
              ],
            )),
          
          
          Padding(
            padding: const EdgeInsets.all(defaultSpacing*2),
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
                const SizedBox(
                  height: defaultSpacing / 4,
                ),
                 ProfileAccountInfoTile(
                    imageUrl: 'assets/images/location-1.png',
                    title: 'Adress',
                    subTitle: userData.address),
                const ProfileAccountInfoTile(
                    imageUrl: 'assets/images/info-circle.png',
                    title: 'Edit  personal information',
                    subTitle: 'Manage your information '),
                const SizedBox(
                  height: defaultSpacing,
                ),
                Text(
                  "Account",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: fontHeading),
                ),
                const SizedBox(
                  height: defaultSpacing,
                ),
                const ProfileAccountInfoTile(
                    imageUrl: 'assets/images/user-1.png',
                    title: 'My Account',
                    subTitle: ''),
                const SizedBox(
                  height: defaultSpacing,
                ),
                const ProfileAccountInfoTile(
                    imageUrl: 'assets/images/bell.png',
                    title: 'Notification',
                    subTitle: ''),
                const SizedBox(
                  height: defaultSpacing,
                ),
                const ProfileAccountInfoTile(
                    imageUrl: 'assets/images/lock-on.png',
                    title: 'Privacy',
                    subTitle: ''),
                const SizedBox(
                  height: defaultSpacing,
                ),
                const ProfileAccountInfoTile(
                    imageUrl: 'assets/images/info-circle.png',
                    title: 'About',
                    subTitle: ''),
              ],
            ),
          )
        ],
      ),
    );
  }}
  ),);
  
      
  }
  
}