import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/consts/app_colors.dart';
import 'package:trendency/consts/route_consts.dart';
import 'package:trendency/providers/auth_provider.dart';
import 'package:trendency/providers/user_provider.dart';
import 'package:trendency/utils/keep_alive.dart';
import 'package:trendency/utils/paged_post_list_view.dart';
import 'package:trendency/utils/trendency_snackbar.dart';
import 'package:trendency/widgets/trendency_app_bar.dart';
import 'package:trendency/widgets/trendency_spinner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 0;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const TrendencyAppBar(
          isDismissable: false,
          color: Colors.transparent,
          title: Icon(FontAwesomeIcons.addressBook),
          height: 30,
        ),
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: SizedBox(
          height: 50,
          child: BottomNavigationBar(
              selectedFontSize: 0,
              unselectedFontSize: 0,
              elevation: 3,
              items: [
                BottomNavigationBarItem(
                  label: "",
                  icon: SizedBox(
                    width: 30,
                    height: 30,
                    child: InkWell(
                      onTap: () => {
                        scrollController.animateTo(0,
                            duration: const Duration(milliseconds: 900),
                            curve: Curves.easeIn)
                      },
                      child: SvgPicture.asset(
                        "assets/svgs/home.svg",
                      ),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  label: "",
                  icon: InkWell(
                    onTap: () =>
                        Routemaster.of(context).push(RouteConst.PROFILE),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          context.read<UserProvider>().userModel!.image_path!),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                    label: "",
                    icon: IconButton(
                      iconSize: 25,
                      icon: Consumer<AuthProvider>(
                        builder: (context, provider, child) {
                          if (provider.state == AuthState.failed) {
                            TrendencySnackbar.show(
                                title: "Logout has Failed",
                                content:
                                    "The username or password you have entered is incorrect!. Please try again",
                                isError: true);
                          } else if (provider.state == AuthState.loading) {
                            return const TrendencySpinner();
                          } else if (provider.state == AuthState.loggedOut) {
                            WidgetsBinding.instance!
                                .addPostFrameCallback((timeStamp) {
                              Routemaster.of(context).replace(RouteConst.LOGIN);
                            });
                          }
                          return const Icon(
                            FontAwesomeIcons.doorOpen,
                            color: AppColor.thirdColor,
                          );
                        },
                      ),
                      onPressed: () {
                        var notifer = context.read<AuthProvider>();
                        notifer.logoutUser();
                        if (notifer.state == AuthState.loggedOut) {
                          Routemaster.of(context).replace(RouteConst.LOGIN);
                        }
                      },
                    )),
              ]),
        ),
        body: KeepPageAlive(
            child: PagedArticleListView(scrollController: scrollController)));
  }
}
