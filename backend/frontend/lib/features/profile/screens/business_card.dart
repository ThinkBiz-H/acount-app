import 'dart:io';
import 'package:flutter/material.dart';

class BusinessCard extends StatelessWidget {
  final String businessName;
  final String phone;
  final String address;
  final File? logo;

  const BusinessCard({
    super.key,
    required this.businessName,
    required this.phone,
    required this.address,
    this.logo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0C2752), Color(0xFF1A3D8F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          /// TEXT INFO
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                phone,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),

              const SizedBox(height: 6),

              Text(
                phone,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),

              const SizedBox(height: 10),

              Text(
                address,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),

              const Spacer(),

              Text(
                businessName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          /// LOGO
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: const [
                  Icon(Icons.verified, color: Colors.green),
                  SizedBox(width: 6),
                  Text(
                    "Verified User",
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
