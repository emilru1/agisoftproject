// ignore_for_file: unused_field
import 'package:group7/core/widgets/favourite_page.dart';
import 'package:group7/features/user/user_provider.dart';
import 'package:group7/features/current_aqi/current_aqi_screen.dart';
import 'package:group7/features/help/help_page.dart';
import 'package:provider/provider.dart';
import 'package:group7/features/current_aqi/aqi_provider.dart';
import 'package:flutter/material.dart';
import 'package:free_map/free_map.dart';
import 'package:group7/api-calls/http_requests.dart';
  final String activePage;

  const Navbar({super.key, this.activePage = ''});

  @override
  State<Navbar> createState() => _NavbarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _NavbarState extends State<Navbar> {
  FmData? _address;
  LatLng? _currentPos = LatLng(37.4165849896396, -122.08051867783071);

  final TextEditingController usernameController = TextEditingController();
  bool userCreated = false;
  bool _isOverlayVisible = false;

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  Future<void> openFavourites() async {
    final username = usernameController.text.trim();

    if (username.isEmpty) return;

    try {
      final exists = await ApiService.checkUserExists(username);
      if (!exists) {
        await ApiService.createUser(username);
      }
      if (!mounted) return;

      context.read<UserProvider>().setUsername(username);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FavouritesPage(username: username)),
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  void _onAddressSelected(FmData? data) {
    if (data == null) return;

    if (widget.activePage == 'learn') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CurrentAqiScreen(lat: data.lat, lon: data.lng),
        ),
      );
      Future.microtask(() {
        if (!mounted) return;
        setState(() {
          _address = data;
    } else {
      setState(() {
        _address = data;
      });

      context.read<AqiProvider>().fetchAqiForCoordinates(data.lat, data.lng);
    }
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: ConstrainedBox(
              minWidth: MediaQuery.of(context).size.width - 88,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  height: 40,
                  fit: BoxFit.contain,
                ),
                  children: [
                    _buildCleanNavItem("Home", "home", () {
                      if (widget.activePage != 'home') {
                        Navigator.pushReplacement(
                          MaterialPageRoute(
                    _buildCleanNavItem("Learn", "learn", () {
                        Navigator.pushReplacement(
                          context,
                        );
                      }
                    }),

                    const SizedBox(width: 24),
                    const SizedBox(width: 24),

                    _buildModernSearchField(),

                    const SizedBox(width: 16),
                    _buildModernUserControls(),
                ),
            ),
        ),
      ),
    );
  }

  Widget _buildCleanNavItem(String title, String pageKey, VoidCallback onTap) {
    bool isActive = widget.activePage == pageKey;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? AppTheme.black87 : AppTheme.grey500,
            fontSize: 16,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Search
  Widget _buildModernSearchField() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 600),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 40,
        child: FmSearchField(
          selectedValue: _address,
          onSelected: _onAddressSelected,
          searchParams: const FmSearchParams(),
          resultViewOptions: FmResultViewOptions(
            onOverlayVisible: (v) => setState(() => _isOverlayVisible = v),
          ),
          textFieldBuilder: (focus, controller, onChanged) {
            return TextFormField(
              focusNode: focus,
                filled: true,
                hintText: 'Search city...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.grey[400],
                  size: 20,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                suffixIcon: controller.text.trim().isEmpty || !focus.hasFocus
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        color: Colors.grey[500],
                        onPressed: controller.clear,
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Användarinmatning
  Widget _buildModernUserControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 120,
          height: 40,
          child: TextField(
            controller: usernameController,
            decoration: InputDecoration(
              hintText: "@username",
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              filled: true,
              fillColor: Colors.grey[50],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: openFavourites,
          icon: const Icon(
            Icons.favorite_border_rounded,
            size: 26,
          ), // Tunn ikon
          color: Colors.black87,
          tooltip: "Favourites",
        ),
      ],
    );
  }
}
