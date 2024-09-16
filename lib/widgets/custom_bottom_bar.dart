import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  CustomBottomNavigationBarState createState() =>
      CustomBottomNavigationBarState();
}

class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: [
          _buildNavItem(0, 'lib/assets/icons/wallet.svg', 'Carteira'),
          _buildNavItem(1, 'lib/assets/icons/chart.svg', 'Relatórios'),
          _buildNavItem(2, 'lib/assets/icons/more.svg', 'Mais'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String icon, String label) {
    bool isSelected = _selectedIndex == index;

    return isSelected
        ? Expanded(
            child: GestureDetector(
              onTap: () => _onItemTapped(index),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF24F07D),
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      icon,
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                          Color(0xFF000000), BlendMode.srcIn),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: () => _onItemTapped(index),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F1F),
                borderRadius: BorderRadius.circular(100),
              ),
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: SvgPicture.asset(
                icon,
                width: 20,
                height: 20,
                colorFilter:
                    const ColorFilter.mode(Color(0xFF7A7A7A), BlendMode.srcIn),
              ),
            ),
          );
  }
}
