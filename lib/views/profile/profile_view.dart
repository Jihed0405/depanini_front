import 'package:depanini_front/constants/color.dart';
import 'package:depanini_front/constants/size.dart';
import 'package:depanini_front/widgets/profile_account_info_tile.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
    var userData= (
  name:"Ben othmen",
  firstName:"Jihed",
  email:"jihed.benothmen@polytechnicien.tn",
  
);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: background,
      
      appBar: AppBar(
        elevation: 0,
        backgroundColor: background,
        leading: IconButton(
        icon:   const Icon(
          Icons.arrow_back_ios,
          color: fontDark,
          
        ),
        onPressed: (){
          
        },),
        actions: const [
          Image(image: AssetImage("assets/images/settings.png"))
        ],
      ),
      body:SingleChildScrollView(
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
                    "assets/person/avatar.jpg",
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
                        "${userData.firstName} ${userData.name}",
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
                      const Chip(
                        backgroundColor: primaryLight,
                        label: Text(
                          "Edit Profile",
                        ),
                        labelStyle: TextStyle(color: primaryGreen),
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
                const ProfileAccountInfoTile(
                    imageUrl: 'assets/images/location-1.png',
                    title: 'Adress',
                    subTitle: 'Rue ramla 5111 mahdia Tunisia'),
                const ProfileAccountInfoTile(
                    imageUrl: 'assets/images/wallet.png',
                    title: 'My Wallet',
                    subTitle: 'Manage your saved wallet'),
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
    ),);
  }
  }
