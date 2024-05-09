import 'package:flutter/material.dart';

import '../../models/models.dart';

class MedicationCard extends StatelessWidget {
  final Medication medication;
  final Function()? onTap;
  const MedicationCard({
    super.key,
    required this.medication,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(medication.name),
                  const SizedBox(
                    width: 10,
                  ),
                  // Text(medication),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
