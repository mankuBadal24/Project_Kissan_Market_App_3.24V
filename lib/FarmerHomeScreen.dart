import 'package:flutter/material.dart';
import 'package:kissan_market_app/AddCropScreen.dart';
import 'package:kissan_market_app/AppDrawerMenuScreen.dart';
import 'package:kissan_market_app/LoginScreen.dart';
import 'package:kissan_market_app/SaveUserData/SaveUserData.dart';
import 'package:kissan_market_app/ViewCropsScreen.dart';

import 'Theme/AppColors.dart';

class FarmerHomeScreen extends StatefulWidget{
  SaveUserData saveUserData=SaveUserData();
  FarmerHomeScreen({super.key,required this.saveUserData});
  @override
  State<FarmerHomeScreen> createState()=>_FarmerHomeScreenState();
  
}
class _FarmerHomeScreenState extends State<FarmerHomeScreen>{
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print(widget.saveUserData.getUserId());
  }


  Widget _buildDotIndicator(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (dotIndex) {
        bool isActive = (index % 2) == dotIndex;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: isActive ? 12: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryColor : AppColors.borderColor,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title:  const Text('FarmerHomeScreen',
        style: TextStyle(color: AppColors.secondaryColor),),
        backgroundColor: AppColors.primaryColor,
      ),

      drawer:const AppDrawerMenuScreen(),
      body: Column(
        children: [
          Expanded(
            child:PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton.large(
                            backgroundColor: AppColors.primaryColor,
                            heroTag: 'Add Crop',
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> AddCropScreen(saveUserData: widget.saveUserData,)));
                            },
                            tooltip: 'Add Crops',
                            shape:const CircleBorder(),
                            child:  const Icon(Icons.add_a_photo_outlined,color: AppColors.secondaryColor,),),
                        ),
                        const Text('Add Crops'),
                      ],
                    ),

                //     Column(
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: FloatingActionButton.large(
                //             onPressed: (){},
                //             backgroundColor: AppColors.primaryColor,
                //             heroTag: 'Update Crops',
                //             tooltip: 'Update Crops',
                //             shape: const CircleBorder(),
                //             child: const Icon(Icons.update,color: AppColors.secondaryColor,),),
                //         ),
                //         const Text('Update Crops'),
                //       ],
                //     ),
                //   ],
                // ),
                //
                // Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Column(
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: FloatingActionButton.large(
                //             backgroundColor: AppColors.primaryColor,
                //             onPressed: (){},
                //             heroTag:"Delete Crops" ,
                //             tooltip: 'Delete crops',
                //             shape: const CircleBorder(),
                //             child: const Icon(Icons.delete_outline,color: AppColors.secondaryColor,),),
                //         ),
                //         const Text('Delete Crops'),
                //       ],
                //     ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton.large(
                            backgroundColor: AppColors.primaryColor,
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewCropsScreen(saveUserData: widget.saveUserData,)));
                            },
                            heroTag: "View Added Crops",
                            tooltip: 'View Added crops',
                            shape: const CircleBorder(),
                            child: const Icon(Icons.remove_red_eye_outlined,color: AppColors.secondaryColor,),),
                        ),
                        const Text('View Added Crops')
                      ],
                    ),
                  ],
                ),

              ],
            ),

          ),
          // _buildDotIndicator(_currentIndex), // Call the function here

          Expanded(
              child: Container(
                child: const Column(
                  children: [
                    Divider(height: 1,color: AppColors.borderColor,)
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
  

  
}
