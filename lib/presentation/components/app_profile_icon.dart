import 'package:flutter/material.dart';

class AppProfileIcon extends StatelessWidget {
  const AppProfileIcon({
    required this.imageUrl,
    super.key,
    required this.onClick,
  });
  final String imageUrl;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          height: 56,
          alignment: Alignment.center,
          width: 56,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(243, 244, 248, 100),
            shape: BoxShape.circle,
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, url, error) => const Center(
                    child: Icon(Icons.person, color: Colors.grey, size: 25),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
