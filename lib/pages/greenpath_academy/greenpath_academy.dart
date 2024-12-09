import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import Lottie
import 'package:webview_flutter/webview_flutter.dart';

class GreenPathAcademyPage extends StatelessWidget {
  const GreenPathAcademyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> maps = [
      {
        'title': 'World Forest Map',
        'url': 'https://www.globalforestwatch.org/map',
        'animation': 'assets/animations/forest.json'
      },
      {
        'title': 'NATURE MAP EXPLORER',
        'url': 'https://explorer.naturemap.earth/map',
        'animation': 'assets/animations/nature.json'
      },
      {
        'title': 'Ecosystem mapping',
        'url': 'https://strata.earthmap.org/',
        'animation': 'assets/animations/ecosystem.json'
      },
      {
        'title': 'Global Deforestation Rates',
        'url': 'https://www.globalforestwatch.org/dashboards/global',
        'animation': 'assets/animations/rates.json'
      },
      {
        'title': 'Weather Forecast Map',
        'url': 'https://waqi.info/forecast',
        'animation': 'assets/animations/forecast.json'
      },
      {
        'title': 'World Electricity Map',
        'url': 'https://app.electricitymaps.com',
        'animation': 'assets/animations/electricity.json'
      },
      {
        'title': 'Freshwater Ecosystems Explorer',
        'url': 'https://map.sdg661.app',
        'animation': 'assets/animations/freshwater.json'
      },
    ];

    final List<Map<String, String>> unresources = [
      {
        'title': 'UNEP Resources',
        'url': 'https://www.unep.org/resources',
        'animation': 'assets/animations/unep.json'
      },
      {
        'title': 'Sustainability Guide',
        'url': 'https://sustainabilityguide.eu/',
        'animation': 'assets/animations/guide.json'
      },
      {
        'title': 'UNEP World Conservation Monitoring',
        'url': 'https://www.unep-wcmc.org/en',
        'animation': 'assets/animations/monitor.json'
      },
      {
        'title': 'UNEP Knowledge on the Environment',
        'url': 'https://wesr.unep.org',
        'animation': 'assets/animations/knowledge.json'
      },
      {
        'title': 'UNEP Documents Repository',
        'url': 'https://wedocs.unep.org',
        'animation': 'assets/animations/repository.json'
      },
      {
        'title': 'UN Biodiversity Lab',
        'url': 'https://unbiodiversitylab.org/en',
        'animation': 'assets/animations/lab.json'
      },
    ];

    final List<Map<String, String>> database = [
      {
        'title': 'Biodiversity Database',
        'url': 'https://ibat-alliance.org',
        'animation': 'assets/animations/database.json'
      },
      {
        'title': 'WTO Environmental Database',
        'url': 'https://edb.wto.org/',
        'animation': 'assets/animations/wto.json'
      },
      {
        'title': 'Environment Research Databases',
        'url': 'https://www.ebsco.com/academic-libraries/subjects/environment',
        'animation': 'assets/animations/research.json'
      },
      {
        'title': 'OECD Environment',
        'url': 'https://data.oecd.org/environment.htm',
        'animation': 'assets/animations/oecd.json'
      },
    ];

    final List<Map<String, String>> courses = [
      {
        'title': 'Coursera Environmental Courses',
        'url': 'https://www.coursera.org/courses?query=environmental',
        'animation': 'assets/animations/coursera.json'
      },
      {
        'title': 'Udemy Environmental Management',
        'url': 'https://www.udemy.com/topic/environmental-management',
        'animation': 'assets/animations/udemy.json'
      },
      {
        'title': 'Harvard Environmental Science',
        'url': 'https://pll.harvard.edu/subject/environmental-science',
        'animation': 'assets/animations/harvard.json'
      },
      {
        'title': 'FutureLearn Nature Courses',
        'url':
            'https://www.futurelearn.com/subjects/nature-and-environment-courses',
        'animation': 'assets/animations/futurelearn.json'
      },
      {
        'title': 'UNCC Elearn',
        'url': 'https://unccelearn.org/courses/?language=en',
        'animation': 'assets/animations/iot.json'
      },
      {
        'title': 'UNCC Moodle Course',
        'url':
            'https://unccelearn.org/course/view.php?id=201&page=overview&utm_campaign=Newsletter%20Q4%202024%20-%20Moodle%20Users&utm_medium=email&utm_source=Mailjet',
        'animation': 'assets/animations/moodle.json'
      },
    ];

    final List<Map<String, String>> practicalsolutions = [
      {
        'title': 'Practical Environmental Solutions',
        'url': 'https://practicalenvirosolutions.com/',
        'animation': 'assets/animations/practical.json'
      },
      {
        'title': 'Environmental Wellness Toolkit',
        'url':
            'https://www.nih.gov/health-information/environmental-wellness-toolkit',
        'animation': 'assets/animations/toolkit.json'
      },
      {
        'title': 'A Roadmap for Using Environmental Rights to Fight Pollution',
        'url':
            'https://www.wri.org/research/community-action-toolkit-roadmap-using-environmental-rights-fight-pollution',
        'animation': 'assets/animations/roadmap.json'
      },
      {
        'title': 'Toolkit on climate change and health',
        'url':
            'https://www.who.int/teams/environment-climate-change-and-health/climate-change-and-health/capacity-building/toolkit-on-climate-change-and-health',
        'animation': 'assets/animations/technology.json'
      },
    ];

    final List<Map<String, String>> sustainablecommunities = [
      {
        'title': 'Waste Management World',
        'url': 'https://waste-management-world.com',
        'animation': 'assets/animations/world.json'
      },
      {
        'title': 'The Future of Trees',
        'url': 'https://onetreeplanted.org/pages/individuals',
        'animation': 'assets/animations/future.json'
      },
      {
        'title': 'Actionable Recycling',
        'url': 'https://recyclingpartnership.org/',
        'animation': 'assets/animations/actionable.json'
      },
      {
        'title': 'Renewable Energy World',
        'url': 'https://www.renewableenergyworld.com/',
        'animation': 'assets/animations/renewable.json'
      },
      {
        'title': 'Habitats for hope',
        'url': 'https://www.birdlife.org/',
        'animation': 'assets/animations/hope.json'
      },
      {
        'title': 'Biodiversity',
        'url': 'https://iucn.org/',
        'animation': 'assets/animations/bio.json'
      },
      {
        'title': 'WRI',
        'url': 'https://www.wri.org/',
        'animation': 'assets/animations/wri.json'
      },
      {
        'title': 'Earth Watch',
        'url': 'https://earthwatch.org/',
        'animation': 'assets/animations/watch.json'
      },
      {
        'title': 'National Geographic',
        'url': 'https://www.nationalgeographic.org/society/',
        'animation': 'assets/animations/geographic.json'
      },
    ];

    final List<Map<String, String>> greenTechLinks = [
      {
        'title': 'What Is Green Technology?',
        'url': 'https://www.youtube.com/watch?v=TCtIRAFyTIY',
        'animation': 'assets/animations/tech.json'
      },
      {
        'title': 'The Future of Green Technology',
        'url': 'https://www.youtube.com/watch?v=6TmSqBz4esU',
        'animation': 'assets/animations/techno.json'
      },
      {
        'title': 'Connecting Green Tech with IoT',
        'url': 'https://www.youtube.com/watch?v=G4_Z6JZblTg',
        'animation': 'assets/animations/iot.json'
      },
      {
        'title': 'Green Technologies',
        'url': 'https://www.green-technology.org/',
        'animation': 'assets/animations/technology.json'
      },
      {
        'title': 'Green Technologies Guide',
        'url':
            'https://www.netguru.com/blog/what-is-greentech#:~:text=Green%20tech%20is%20the%20use,towards%20a%20more%20sustainable%20future.',
        'animation': 'assets/animations/guides.json'
      },
    ];

    final List<Map<String, String>> globalEnvConfLinks = [
      {
        'title': 'UN Global Environmental Conferences',
        'url': 'https://www.un.org/en/conferences/environment',
        'animation': 'assets/animations/conferences.json'
      },
      {
        'title': 'Top 10: Sustainability Conferences',
        'url':
            'https://sustainabilitymag.com/top10/top-10-sustainability-conferences-around-the-world',
        'animation': 'assets/animations/global.json'
      },
      {
        'title': 'ICESA 2025 - 6th International Conference',
        'url': 'https://esaconference.com/',
        'animation': 'assets/animations/icesa.json'
      },
    ];

    final List<Map<String, String>> researchpapers = [
      {
        'title': 'ScienceDirect Environmental Research Papers',
        'url': 'https://www.sciencedirect.com/journal/environmental-research',
        'animation': 'assets/animations/papers.json'
      },
      {
        'title': 'International Journal of Environmental Research',
        'url': 'https://link.springer.com/journal/41742',
        'animation': 'assets/animations/journal.json'
      },
      {
        'title': 'The Open Environmental Research Journal',
        'url': 'https://openenvironmentalresearchjournal.com/',
        'animation': 'assets/animations/open.json'
      },
      {
        'title': 'UN Publications & data',
        'url': 'https://www.unep.org/publications-data',
        'animation': 'assets/animations/publications.json'
      },
    ];

    final List<Map<String, String>> scholarship = [
      {
        'title': 'United Nations Environmental Funding',
        'url':
            'https://www.unep.org/about-un-environment-programme/funding-and-partnerships/environment-fund',
        'animation': 'assets/animations/funding.json'
      },
      {
        'title': 'Exclusive Environmental Science Scholarships',
        'url':
            'https://bold.org/scholarships/by-major/environmental-science-scholarships/',
        'animation': 'assets/animations/exclusive.json'
      },
      {
        'title': 'Latest Environmental Grants',
        'url':
            'https://www.grantfinder.co.uk/funding-highlights/funds/environment/',
        'animation': 'assets/animations/future.json'
      },
      {
        'title': 'Future For Nature',
        'url': 'https://futurefornature.org/apply/',
        'animation': 'assets/animations/blogs.json'
      },
      {
        'title': 'Funding opportunities for nature restoration',
        'url': 'https://restor.eco/platform/funding-opportunities',
        'animation': 'assets/animations/forest.json'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Path Academy'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SectionWidget(
              sectionTitle: 'World Map',
              links: maps,
            ),
            SectionWidget(
              sectionTitle: 'United Nations Resources',
              links: unresources,
            ),
            SectionWidget(
              sectionTitle: 'Database',
              links: database,
            ),
            SectionWidget(
              sectionTitle: 'Courses',
              links: courses,
            ),
            SectionWidget(
              sectionTitle: 'Practical Solutions',
              links: practicalsolutions,
            ),
            SectionWidget(
              sectionTitle: 'Sustainable Communities & Companies',
              links: sustainablecommunities,
            ),
            SectionWidget(
              sectionTitle: 'Green Technologies',
              links: greenTechLinks,
            ),
            SectionWidget(
              sectionTitle: 'Global Environmental Conferences',
              links: globalEnvConfLinks,
            ),
            SectionWidget(
              sectionTitle: 'Research Papers',
              links: researchpapers,
            ),
            SectionWidget(
              sectionTitle: 'Scholarships and Grants',
              links: scholarship,
            ),
          ],
        ),
      ),
    );
  }
}

class SectionWidget extends StatelessWidget {
  final String sectionTitle;
  final List<Map<String, String>> links;

  const SectionWidget({
    super.key,
    required this.sectionTitle,
    required this.links,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            sectionTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: links.length,
          itemBuilder: (context, index) {
            final link = links[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewPage(
                      url: link['url']!,
                      title: link['title']!,
                    ),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        link['animation']!,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        link['title']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
      ],
    );
  }
}

class AnimatedBanner extends StatelessWidget {
  final String title;
  final String animationPath;

  const AnimatedBanner(
      {super.key, required this.title, required this.animationPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.green.withOpacity(0.6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Lottie.asset(
            animationPath,
            width: 300, // Adjust the width
            height: 200, // Adjust the height
            fit: BoxFit.contain,
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({super.key, required this.url, required this.title});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    _controller.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green[700],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
