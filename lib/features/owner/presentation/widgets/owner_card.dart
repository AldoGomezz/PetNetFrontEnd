import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/owner/domain/domain.dart';
import 'package:pet_net_app/features/owner/presentation/presentation.dart';

class OwnerCard extends ConsumerWidget {
  final OwnerModel owner;
  const OwnerCard({super.key, required this.owner});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    String fullName = "${owner.firstName} ${owner.lastName}";
    return GestureDetector(
      onTap: () {
        ref.read(ownerGetProvider.notifier).setOwner(owner);
        context.push('/owner-info');
      },
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.tertiary,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Expanded(
              /* child: Image.network(
                owner.profilePhoto,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
              ), */
              child: Image.asset(
                'assets/profile.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              fullName,
              overflow: TextOverflow.ellipsis,
              style: getSubtitleBoldStyle(context).copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
