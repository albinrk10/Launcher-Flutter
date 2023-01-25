import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BouncingScrollPhysics _bouncingScrollPhysics = BouncingScrollPhysics();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: PageView(
          children: <Widget>[
            Container(
              child: Center(
                child: Image.asset('assets/images/user.png'),
              ),
            ),
            FutureBuilder(
                future: DeviceApps.getInstalledApplications(
                  includeSystemApps: true,
                  onlyAppsWithLaunchIntent: true,
                  includeAppIcons: true,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<Application> allApps = snapshot.data!;

                    return GridView.count(
                      crossAxisCount: 3,
                      padding: const EdgeInsets.only(
                        top: 60.0,
                      ),
                      physics: _bouncingScrollPhysics,
                      children: List.generate(allApps.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            DeviceApps.openApp(allApps[index].packageName);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Image.memory(
                                    (allApps[index] as ApplicationWithIcon)
                                        .icon,
                                    width: 32),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  allApps[index].appName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
