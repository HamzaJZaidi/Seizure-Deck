import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class AmbulanceServicesScreen extends StatefulWidget {
  const AmbulanceServicesScreen({super.key});

  @override
  _AmbulanceServicesScreenState createState() => _AmbulanceServicesScreenState();
}

class _AmbulanceServicesScreenState extends State<AmbulanceServicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> ambulanceServices = [];
  List<Map<String, String>> filteredAmbulanceServices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAmbulanceServices();
  }

  Future<void> fetchAmbulanceServices() async {
    final response = await http.get(Uri.parse('https://lightskyblue-lark-971495.hostingersite.com/ambulances_list.php'));
    
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        ambulanceServices = data.map<Map<String, String>>((item) {
          return {
            'Aid': item['Aid'],
            'name': item['name'],
            'number': item['contact_number'],
            'image': item['image_url'],
          };
        }).toList();
        filteredAmbulanceServices = ambulanceServices;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load ambulance services');
    }
  }

  void _filterAmbulances(String searchQuery) {
    setState(() {
      if (searchQuery.isEmpty) {
        filteredAmbulanceServices = ambulanceServices;
      } else {
        filteredAmbulanceServices = ambulanceServices.where((service) {
          final name = service['name']!.toLowerCase();
          final number = service['number']!;
          final query = searchQuery.toLowerCase();
          return name.contains(query) || number.contains(query);
        }).toList();
      }
    });
  }

  void _makePhoneCall(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambulance Services'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterAmbulances,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search for ambulance...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                
                // Displaying the number of matching results
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Ambulance matching searches ${filteredAmbulanceServices.length}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredAmbulanceServices.length,
                    itemBuilder: (context, index) {
                      final service = filteredAmbulanceServices[index];
                      return Column(
                        children: [
                          GestureDetector(
                            child: Container(  
                              child: ListTile(
                                leading: Image.network(
                                  service['image']!,
                                  width: 100,
                                  height: 50,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.broken_image, size: 40);
                                  },
                                ),
                                title: Text(service['name']!),
                                subtitle: Text(service['number']!),
                                trailing: IconButton(
                                  icon: const Icon(Icons.phone, color: Color.fromARGB(255, 219, 129, 235)),
                                  onPressed: () => _makePhoneCall('tel:${service['number']}'),
                                ),
                              ),
                            ),
                          ),
                          
                          // Adding a gray divider between the list items
                          Divider(
                            color: Colors.grey[300],
                            thickness: 1.0,
                            indent: 15,
                            endIndent: 15,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
