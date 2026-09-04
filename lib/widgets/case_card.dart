import 'package:flutter/material.dart';
import '../models/case.dart';

class CaseCard extends StatelessWidget {
  final Case caseItem;

  const CaseCard({super.key, required this.caseItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    caseItem.caseTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: caseItem.caseStatus == 'در جریان' 
                        ? Colors.green 
                        : caseItem.caseStatus == 'بسته شده'
                            ? Colors.red
                            : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    caseItem.caseStatus ?? 'نامشخص',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.numbers, size: 18, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  'شماره پرونده: ${caseItem.caseNumber}',
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 18, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  'دادستان: ${caseItem.prosecutorName ?? "نامشخص"}',
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (caseItem.caseType != null)
              Row(
                children: [
                  const Icon(Icons.category, size: 18, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(
                    'نوع پرونده: ${caseItem.caseType}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            if (caseItem.courtName != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.account_balance, size: 18, color: Colors.grey),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'دادگاه: ${caseItem.courtName}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
