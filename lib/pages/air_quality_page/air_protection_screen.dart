import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert'; // For jsonDecode
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:card_swiper/card_swiper.dart';
import 'package:url_launcher/url_launcher.dart';

class AirProtectionScreen extends StatefulWidget {
  const AirProtectionScreen({super.key});

  @override
  State<AirProtectionScreen> createState() => _AirProtectionScreenState();
}

class _AirProtectionScreenState extends State<AirProtectionScreen> {
  late VideoPlayerController _controller;
  String selectedCountry = 'United States'; // Default country for AQI
  late Future<Map<String, dynamic>> airQualityData;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/air_purifier.mp4')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      }).catchError((error) {
        // Handle any error while initializing the video
        print('Error initializing video: $error');
      });
    airQualityData = fetchAirQualityData(selectedCountry);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<Map<String, dynamic>> fetchAirQualityData(String country) async {
    final response = await http.get(Uri.parse(
        'https://api.waqi.info/feed/$country/?token=acb50fb2ea443d4bca2ea520b4323a81a70e9633'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['data'] is Map<String, dynamic>) {
        return data['data'];
      } else {
        throw Exception('Invalid data format');
      }
    } else {
      throw Exception('Failed to load air quality data');
    }
  }

  void updateCountry(String newCountry) {
    setState(() {
      selectedCountry = newCountry;
      airQualityData = fetchAirQualityData(newCountry);
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  Widget _buildStepCard(String title, String description, IconData icon) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _buildProductCard(String title, String description, String link) {
    return GestureDetector(
      onTap: () async {
        final Uri url = Uri.parse(link);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not launch $link';
        }
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade50, Colors.teal.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAQICell(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Air Protection'),
        backgroundColor: Colors.teal[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // AQI at the top
            FutureBuilder<Map<String, dynamic>>(
              future: airQualityData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Text('No data available or data is malformed');
                } else {
                  final data = snapshot.data!;
                  return Card(
                    elevation: 4,
                    color: Colors.blue[100],
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Air Quality: ${data['city']['name']}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('AQI: ${data['aqi'] ?? 'N/A'}'),
                          Text(
                              'Dominant Pollutant: ${data['dominentpol'] ?? 'N/A'}'),
                          Text(
                              'Temperature: ${data['iaqi']?['t']?['v'] ?? 'N/A'}°C'),
                          Text(
                              'Humidity: ${data['iaqi']?['h']?['v'] ?? 'N/A'}%'),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
            // Country Dropdown
            DropdownButton<String>(
              value: selectedCountry,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  updateCountry(newValue);
                }
              },
              items: <String>[
                'United States',
                'United Kingdom',
                'China',
                'Afghanistan',
                'India',
                'Australia',
                'Canada',
                'Germany',
                'France',
                'Italy',
                'Spain',
                'Japan',
                'Brazil',
                'Russia',
                'Mexico',
                'South Korea',
                'Argentina',
                'South Africa',
                'Turkey',
                'Egypt',
                'Saudi Arabia'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Air Quality Scale',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal[900],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'The AQI scale used for indexing the real-time pollution in the above map is based on the latest US EPA standard, using the Instant Cast reporting formula.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(color: Colors.teal, width: 1),
              children: [
                // Titles Row
                TableRow(
                  decoration: BoxDecoration(color: Colors.teal[100]),
                  children: [
                    _buildAQICell('AQI', Colors.teal),
                    _buildAQICell('Air Pollution Level', Colors.teal),
                    _buildAQICell('Health Implications', Colors.teal),
                    _buildAQICell(
                        'Cautionary Statement (for PM2.5)', Colors.teal),
                  ],
                ),
                // Data Rows
                TableRow(
                  decoration: BoxDecoration(color: Colors.green[100]),
                  children: [
                    _buildAQICell('0 - 50', Colors.green),
                    _buildAQICell('Good', Colors.green),
                    _buildAQICell(
                        'Air quality is considered satisfactory, and air pollution poses little or no risk',
                        Colors.green),
                    _buildAQICell('None', Colors.green),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(color: Colors.yellow[100]),
                  children: [
                    _buildAQICell('51 - 100', Colors.yellow),
                    _buildAQICell('Moderate', Colors.yellow),
                    _buildAQICell(
                        'Air quality is acceptable; however, for some pollutants there may be a moderate health concern for a very small number of people who are unusually sensitive to air pollution.',
                        Colors.yellow),
                    _buildAQICell(
                        'Active children and adults, and people with respiratory disease, such as asthma, should limit prolonged outdoor exertion.',
                        Colors.yellow),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(color: Colors.orange[100]),
                  children: [
                    _buildAQICell('101 - 150', Colors.orange),
                    _buildAQICell(
                        'Unhealthy for Sensitive Groups', Colors.orange),
                    _buildAQICell(
                        'Members of sensitive groups may experience health effects. The general public is not likely to be affected.',
                        Colors.orange),
                    _buildAQICell(
                        'Active children and adults, and people with respiratory disease, such as asthma, should limit prolonged outdoor exertion.',
                        Colors.orange),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(color: Colors.red[100]),
                  children: [
                    _buildAQICell('151 - 200', Colors.red),
                    _buildAQICell('Unhealthy', Colors.red),
                    _buildAQICell(
                        'Everyone may begin to experience health effects; members of sensitive groups may experience more serious health effects',
                        Colors.red),
                    _buildAQICell(
                        'Active children and adults, and people with respiratory disease, such as asthma, should avoid prolonged outdoor exertion; everyone else, especially children, should limit prolonged outdoor exertion.',
                        Colors.red),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(color: Colors.purple[100]),
                  children: [
                    _buildAQICell('201 - 300', Colors.purple),
                    _buildAQICell('Very Unhealthy', Colors.purple),
                    _buildAQICell(
                        'Health warnings of emergency conditions. The entire population is more likely to be affected.',
                        Colors.purple),
                    _buildAQICell(
                        'Active children and adults, and people with respiratory disease, such as asthma, should avoid all outdoor exertion; everyone else, especially children, should limit outdoor exertion.',
                        Colors.purple),
                  ],
                ),
                TableRow(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 129, 25, 17)),
                  children: [
                    _buildAQICell(
                        '300+', const Color.fromARGB(255, 122, 22, 14)),
                    _buildAQICell(
                        'Hazardous', const Color.fromARGB(255, 122, 22, 14)),
                    _buildAQICell(
                        'Health alert: everyone may experience more serious health effects',
                        const Color.fromARGB(255, 122, 22, 14)),
                    _buildAQICell(
                        'Active children and adults, and people with respiratory disease, such as asthma, should avoid all outdoor exertion; everyone else, especially children, should avoid outdoor exertion.',
                        const Color.fromARGB(255, 122, 22, 14)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Text(
              'Steps to Protect Yourself from Air Pollution',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0)),
            ),
            const SizedBox(height: 8),
            _buildStepCard(
                'Stay Indoors',
                'Avoid outdoor activities when pollution levels are high.',
                Icons.home),
            _buildStepCard(
                'Use Air Purifiers',
                'Air purifiers can significantly improve indoor air quality.',
                Icons.air),
            _buildStepCard(
                'Wear Masks',
                'Face masks can filter out harmful pollutants in the air.',
                Icons.masks),
            _buildStepCard(
                'Reduce Exposure',
                'Limit physical exertion outdoors during times of high pollution.',
                Icons.directions_walk),
            const SizedBox(height: 16),
            Text(
              'simple DIY air purifier',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[900]),
            ),
            const SizedBox(height: 8),
            _buildStepCard(
              "Step 1: Gather materials.",
              "You'll need a box fan, HEPA filter, duct tape, and scissors.",
              Icons.list_alt,
            ),
            _buildStepCard(
              "Step 2: Attach the filter.",
              "Fit the HEPA filter snugly to the intake side of the fan.",
              Icons.filter_alt,
            ),
            _buildStepCard(
              "Step 3: Secure with tape.",
              "Use duct tape to secure the filter around the edges.",
              Icons.attach_file,
            ),
            _buildStepCard(
              "Step 4: Test your purifier.",
              "Turn the fan on to ensure it's working correctly.",
              Icons.check_circle,
            ),

            _buildStepCard(
              "Step 5: Cut the filter to size.",
              "If needed, trim the HEPA filter to fit the fan.",
              Icons.cut,
            ),

            // Step 6
            _buildStepCard(
              "Step 6: Attach additional filters (optional).",
              "For extra filtration, you can stack filters for a better effect.",
              Icons.filter_alt_outlined,
            ),

            // Step 7
            _buildStepCard(
              "Step 7: Place the purifier in the right spot.",
              "Place your air purifier near sources of pollution, like windows.",
              Icons.place,
            ),

            // Step 8
            _buildStepCard(
              "Step 8: Monitor air quality.",
              "Track air quality using an app or monitor to check improvement.",
              Icons.assessment,
            ),

            // Step 9
            _buildStepCard(
              "Step 9: Clean the fan regularly.",
              "Dust and dirt may accumulate on the fan, affecting performance.",
              Icons.cleaning_services,
            ),

            // Step 10
            _buildStepCard(
              "Step 10: Replace the filter periodically.",
              "After some time, replace the HEPA filter for continued efficiency.",
              Icons.refresh,
            ),

            // Step 11
            _buildStepCard(
              "Step 11: Add essential oils (optional).",
              "You can add essential oils to your purifier to freshen the air.",
              Icons.local_florist,
            ),

            // Step 12
            _buildStepCard(
              "Step 12: Check for any malfunctions.",
              "Ensure your fan and filter are working optimally without noise.",
              Icons.warning,
            ),

            // Step 13
            _buildStepCard(
              "Step 13: Save energy.",
              "Turn off the fan when not needed to conserve electricity.",
              Icons.bolt,
            ),

            // Step 14
            _buildStepCard(
              "Step 14: Improve air circulation.",
              "Place the purifier where air can flow freely for better results.",
              Icons.air,
            ),

            // Step 15
            _buildStepCard(
              "Step 15: Test the air purifier in different settings.",
              "Try using your purifier in different rooms to test its effectiveness.",
              Icons.compare_arrows,
            ),

            // Step 16
            _buildStepCard(
              "Step 16: Share your success.",
              "Share your DIY air purifier with friends and family for awareness.",
              Icons.share,
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Air-Friendly Products',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 8),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildProductCard(
                      'Air Purifier',
                      'A compact device that cleans the air by removing particles and toxins, ideal for reducing indoor pollution.',
                      'https://www.amazon.com/air-purifiers/b?ie=UTF8&node=267554011',
                    ),
                    _buildProductCard(
                      'Snake Plant',
                      'A natural air purifier that absorbs toxins like CO2, benzene, and formaldehyde, making your indoor air cleaner.',
                      'https://www.amazon.com/snake-plant/s?k=snake+plant',
                    ),
                    _buildProductCard(
                      'Peace Lily',
                      'Known for improving indoor air quality by filtering toxins such as ammonia, benzene, and formaldehyde.',
                      'https://www.amazon.com/peace-lily/s?k=peace+lily',
                    ),
                    _buildProductCard(
                      'Air Quality Monitor',
                      'Helps track the levels of pollutants in the air, so you can take action to improve air quality when necessary.',
                      'https://www.amazon.com/air-quality-monitor/s?k=air+quality+monitor',
                    ),
                    _buildProductCard(
                      'HEPA Filter',
                      'High-efficiency particulate air filters that trap tiny particles in the air, including dust, smoke, and allergens.',
                      'https://www.amazon.com/hepa-air-purifiers/b?ie=UTF8&node=510192',
                    ),
                    _buildProductCard(
                      'Activated Charcoal Bags',
                      'Natural air purifiers that absorb odors and toxins from the air, ideal for small spaces like closets or cars.',
                      'https://www.amazon.com/Best-Sellers-Charcoal-Air-Purifying-Bags/zgbs/hpc/21579650011',
                    ),
                    _buildProductCard(
                      'Essential Oil Diffuser',
                      'Distributes essential oils that can help purify the air and add a pleasant scent, some oils also have air-cleaning properties.',
                      'https://www.amazon.com/essential-oil-diffuser/s?k=essential+oil+diffuser',
                    ),
                    _buildProductCard(
                      'Indoor Plants Bundle',
                      'A collection of air-purifying plants like Aloe Vera and Spider Plants, which help to filter toxins and improve air quality.',
                      'https://www.amazon.com/plant-bundle-live-indoor/s?k=plant+bundle+live+indoor',
                    ),
                    _buildProductCard(
                      'Smart Air Purifier',
                      'An advanced air purifier with smart features that can be controlled via your smartphone, providing constant air quality monitoring.',
                      'https://www.amazon.com/smart-air-purifier/s?k=smart+air+purifier',
                    ),
                    _buildProductCard(
                      'UV-C Air Sanitizer',
                      'Uses ultraviolet light to sanitize the air by killing germs and bacteria, improving the overall air quality in your home.',
                      'https://www.amazon.com/uv-c-air-sanitizer/s?k=uv+c+air+sanitizer',
                    ),
                  ],
                ),
              ],
            ),

            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Air Quality Information Video",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  AspectRatio(
                    aspectRatio: _controller.value.isInitialized
                        ? _controller.value.aspectRatio
                        : 16 / 9,
                    child: VideoPlayer(_controller),
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.teal,
                    ),
                    onPressed: _togglePlayPause,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: Swiper(
                      itemCount: 1, // Adjust based on the number of items
                      itemBuilder: (BuildContext context, int index) {
                        return // Replace this part with the image and custom onTap function
                            GestureDetector(
                          onTap: () async {
                            final Uri url =
                                Uri.parse('https://tree-nation.com');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url,
                                  mode: LaunchMode
                                      .inAppWebView); // Open inside the app
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Card(
                            color: Colors.teal[50],
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/tree_planting_icon.png',
                                    width: 50,
                                    height: 50,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Join the Tree Planting Community and Help Save Earth',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal[900],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
