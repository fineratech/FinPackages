// import 'package:flutter/material.dart';

// import 'vehicle_type.dart';

// class Filters extends StatelessWidget {
//   const Filters({super.key, required this.selectedFilters});

//   final FilterParams selectedFilters;

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       child: Container(
//         height: 350,
//         width: double.infinity,
//         color: Colors.white,
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Filter by Vehicle Type',
//                 style: Theme.of(context).textTheme.titleMedium),
//             const SizedBox(height: 10),
//             Wrap(
//               children: ItemType.values
//                   .map(
//                     (type) => Padding(
//                       padding: const EdgeInsets.all(5),
//                       child: StatefulBuilder(builder: (context, setState) {
//                         return FilterChip(
//                           selected: selectedFilters.vehicleTypes.contains(type),
//                           label: Text(type.name.toUpperCase()),
//                           onSelected: (_) {
//                             selectedFilters.vehicleTypes.contains(type)
//                                 ? selectedFilters.vehicleTypes.remove(type)
//                                 : selectedFilters.vehicleTypes.add(type);
//                             setState(() {});
//                           },
//                         );
//                       }),
//                     ),
//                   )
//                   .toList(),
//             ),
//             const SizedBox(height: 20),
//             Text('Filter by Vehicle Brand',
//                 style: Theme.of(context).textTheme.titleMedium),
//             const SizedBox(height: 10),
//             Wrap(
//               children: ["Toyota", "Honda", "Tesla"]
//                   .map(
//                     (brand) => Padding(
//                       padding: const EdgeInsets.all(5),
//                       child: StatefulBuilder(
//                         builder: (context, setState) {
//                           return FilterChip(
//                             selected:
//                                 selectedFilters.vehicleBrands.contains(brand),
//                             label: Text(brand),
//                             onSelected: (_) {
//                               selectedFilters.vehicleBrands.contains(brand)
//                                   ? selectedFilters.vehicleBrands.remove(brand)
//                                   : selectedFilters.vehicleBrands.add(brand);
//                               setState(() {});
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                   )
//                   .toList(),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(selectedFilters);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 6, 114, 202),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Text('Apply Filters'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FilterParams {
//   final List<ItemType> vehicleTypes;
//   final List<String> vehicleBrands;

//   FilterParams({required this.vehicleTypes, required this.vehicleBrands});

//   factory FilterParams.empty() {
//     return FilterParams(vehicleTypes: [], vehicleBrands: []);
//   }

//   FilterParams copyWith({
//     List<ItemType>? vehicleTypes,
//     List<String>? vehicleBrands,
//   }) {
//     return FilterParams(
//       vehicleTypes: vehicleTypes ?? this.vehicleTypes,
//       vehicleBrands: vehicleBrands ?? this.vehicleBrands,
//     );
//   }
// }
