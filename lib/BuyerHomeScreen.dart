import 'package:flutter/material.dart';
import 'package:kissan_market_app/Theme/AppColors.dart';

class BuyerHomeScreen extends StatefulWidget{
 const BuyerHomeScreen({super.key});
 @override
 State<BuyerHomeScreen>createState()=>_BuyerHomeScreenState();
}
class _BuyerHomeScreenState extends State<BuyerHomeScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  AppColors.appBarColor,
        title: const Text("Buyer Home Screen"),
      ),
      body: Column(
        children: [
          Expanded(
          child: Container(
            child: GridView.count(
              padding: EdgeInsets.only(top: 10),
              shrinkWrap: true,
              mainAxisSpacing: 40,
              childAspectRatio: 1.5,
              crossAxisSpacing: 0,
              crossAxisCount: 2,
              children: [
                Column(
                  children: [
                    FloatingActionButton.large(
                      onPressed: (){},
                      heroTag:"Pulses" ,
                      tooltip: 'Pulses',
                      // shape: CircleBorder(),
                      child: const CircleAvatar(
                          radius: 50,
                         backgroundImage: AssetImage('assets/images/sack-rice-seed-with-white-rice-small-wooden-spoon-rice-plant.jpg'),
                             ),
                    ),// Change the image as
                        const Text('Pulses'),
                  ],
                ),
                Column(
                  children: [
                    FloatingActionButton.large(
                      onPressed: (){},
                      heroTag:"Wheat" ,
                      tooltip: 'Wheat',
                      // shape: CircleBorder(),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/wheat_grain_image.png'),
                      ),
                    ),// Change the image as
                    const Text('Wheat'),
                  ],
                ),
                Column(
                  children: [
                    FloatingActionButton.large(
                      onPressed: (){},
                      heroTag:"Rice" ,
                      tooltip: 'Rice',
                      // shape: CircleBorder(),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/pexels-polina-tankilevitch-4110260.jpg'),
                      ),
                    ),// Change the image as
                    const Text('Rice'),
                  ],
                ),
                Column(
                  children: [
                    FloatingActionButton.large(
                      onPressed: (){},
                      heroTag:"Paddy" ,
                      tooltip: 'Paddy',
                      // shape: CircleBorder(),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/rice-plant-green.jpg'),
                      ),
                    ),// Change the image as
                    const Text('Paddy'),
                  ],
                ),
              ],
            ),
          ),

          ),
          Expanded(
            child: Container(
              color: AppColors.primaryColor,
            ),

          ),
        ],
      ),
    );
  }
}
